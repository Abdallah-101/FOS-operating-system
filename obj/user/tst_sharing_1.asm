
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 7b 15 00 00       	call   8015b1 <libmain>
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
  800067:	e8 37 43 00 00       	call   8043a3 <sys_calculate_free_frames>
  80006c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80006f:	e8 7a 43 00 00       	call   8043ee <sys_pf_calculate_allocated_pages>
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
  8000c2:	e8 8a 29 00 00       	call   802a51 <malloc>
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
  8000df:	e8 bf 42 00 00       	call   8043a3 <sys_calculate_free_frames>
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
  800125:	68 20 56 80 00       	push   $0x805620
  80012a:	6a 0c                	push   $0xc
  80012c:	e8 34 19 00 00       	call   801a65 <cprintf_colored>
  800131:	83 c4 20             	add    $0x20,%esp
	if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800134:	e8 b5 42 00 00       	call   8043ee <sys_pf_calculate_allocated_pages>
  800139:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80013c:	74 1c                	je     80015a <allocSpaceInPageAlloc+0x101>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"2 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  80013e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	ff 75 08             	pushl  0x8(%ebp)
  80014b:	68 9c 56 80 00       	push   $0x80569c
  800150:	6a 0c                	push   $0xc
  800152:	e8 0e 19 00 00       	call   801a65 <cprintf_colored>
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
  800174:	e8 2a 42 00 00       	call   8043a3 <sys_calculate_free_frames>
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
  8001b9:	e8 e5 41 00 00       	call   8043a3 <sys_calculate_free_frames>
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
  8001f8:	68 14 57 80 00       	push   $0x805714
  8001fd:	6a 0c                	push   $0xc
  8001ff:	e8 61 18 00 00       	call   801a65 <cprintf_colored>
  800204:	83 c4 20             	add    $0x20,%esp
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  800207:	e8 e2 41 00 00       	call   8043ee <sys_pf_calculate_allocated_pages>
  80020c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80020f:	74 23                	je     800234 <allocSpaceInPageAlloc+0x1db>
		{ correct = 0; correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"4 in alloc#%d: Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", index); }
  800211:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80021f:	83 ec 04             	sub    $0x4,%esp
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	68 a0 57 80 00       	push   $0x8057a0
  80022a:	6a 0c                	push   $0xc
  80022c:	e8 34 18 00 00       	call   801a65 <cprintf_colored>
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
  800270:	e8 f0 44 00 00       	call   804765 <sys_check_WS_list>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	83 f8 01             	cmp    $0x1,%eax
  80027b:	74 1c                	je     800299 <allocSpaceInPageAlloc+0x240>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"5 Wrong malloc in alloc#%d: page is not added to WS\n", index);}
  80027d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	ff 75 08             	pushl  0x8(%ebp)
  80028a:	68 18 58 80 00       	push   $0x805818
  80028f:	6a 0c                	push   $0xc
  800291:	e8 cf 17 00 00       	call   801a65 <cprintf_colored>
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
  8002ae:	e8 f0 40 00 00       	call   8043a3 <sys_calculate_free_frames>
  8002b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  8002b6:	e8 33 41 00 00       	call   8043ee <sys_pf_calculate_allocated_pages>
  8002bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	{
		free(ptr_allocations[index]);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 04 85 20 70 80 00 	mov    0x807020(,%eax,4),%eax
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	50                   	push   %eax
  8002cc:	e8 7e 2c 00 00       	call   802f4f <free>
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
  8002fc:	e8 ed 40 00 00       	call   8043ee <sys_pf_calculate_allocated_pages>
  800301:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800304:	74 1c                	je     800322 <freeSpaceInPageAlloc+0x81>
	{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"1 Wrong free in alloc#%d: Extra or less pages are removed from PageFile\n", index);}
  800306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80030d:	83 ec 04             	sub    $0x4,%esp
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	68 50 58 80 00       	push   $0x805850
  800318:	6a 0c                	push   $0xc
  80031a:	e8 46 17 00 00       	call   801a65 <cprintf_colored>
  80031f:	83 c4 10             	add    $0x10,%esp
	if ((sys_calculate_free_frames() - freeFrames) != expectedNumOfFrames)
  800322:	e8 7c 40 00 00       	call   8043a3 <sys_calculate_free_frames>
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
  800342:	68 9c 58 80 00       	push   $0x80589c
  800347:	6a 0c                	push   $0xc
  800349:	e8 17 17 00 00       	call   801a65 <cprintf_colored>
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
  8003a0:	e8 c0 43 00 00       	call   804765 <sys_check_WS_list>
  8003a5:	83 c4 10             	add    $0x10,%esp
  8003a8:	83 f8 01             	cmp    $0x1,%eax
  8003ab:	74 1c                	je     8003c9 <freeSpaceInPageAlloc+0x128>
		{ correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"3 Wrong free in alloc#%d: page is not removed from WS\n", index);}
  8003ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	ff 75 08             	pushl  0x8(%ebp)
  8003ba:	68 f8 58 80 00       	push   $0x8058f8
  8003bf:	6a 0c                	push   $0xc
  8003c1:	e8 9f 16 00 00       	call   801a65 <cprintf_colored>
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
  800416:	68 30 59 80 00       	push   $0x805930
  80041b:	6a 03                	push   $0x3
  80041d:	e8 43 16 00 00       	call   801a65 <cprintf_colored>
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
  8004df:	68 60 59 80 00       	push   $0x805960
  8004e4:	6a 0c                	push   $0xc
  8004e6:	e8 7a 15 00 00       	call   801a65 <cprintf_colored>
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
  8005b9:	68 60 59 80 00       	push   $0x805960
  8005be:	6a 0c                	push   $0xc
  8005c0:	e8 a0 14 00 00       	call   801a65 <cprintf_colored>
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
  800693:	68 60 59 80 00       	push   $0x805960
  800698:	6a 0c                	push   $0xc
  80069a:	e8 c6 13 00 00       	call   801a65 <cprintf_colored>
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
  80076d:	68 60 59 80 00       	push   $0x805960
  800772:	6a 0c                	push   $0xc
  800774:	e8 ec 12 00 00       	call   801a65 <cprintf_colored>
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
  800847:	68 60 59 80 00       	push   $0x805960
  80084c:	6a 0c                	push   $0xc
  80084e:	e8 12 12 00 00       	call   801a65 <cprintf_colored>
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
  800921:	68 60 59 80 00       	push   $0x805960
  800926:	6a 0c                	push   $0xc
  800928:	e8 38 11 00 00       	call   801a65 <cprintf_colored>
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
  800a16:	68 60 59 80 00       	push   $0x805960
  800a1b:	6a 0c                	push   $0xc
  800a1d:	e8 43 10 00 00       	call   801a65 <cprintf_colored>
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
  800b14:	68 60 59 80 00       	push   $0x805960
  800b19:	6a 0c                	push   $0xc
  800b1b:	e8 45 0f 00 00       	call   801a65 <cprintf_colored>
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
  800c12:	68 60 59 80 00       	push   $0x805960
  800c17:	6a 0c                	push   $0xc
  800c19:	e8 47 0e 00 00       	call   801a65 <cprintf_colored>
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
  800d10:	68 60 59 80 00       	push   $0x805960
  800d15:	6a 0c                	push   $0xc
  800d17:	e8 49 0d 00 00       	call   801a65 <cprintf_colored>
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
  800dfd:	68 60 59 80 00       	push   $0x805960
  800e02:	6a 0c                	push   $0xc
  800e04:	e8 5c 0c 00 00       	call   801a65 <cprintf_colored>
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
  800eea:	68 60 59 80 00       	push   $0x805960
  800eef:	6a 0c                	push   $0xc
  800ef1:	e8 6f 0b 00 00       	call   801a65 <cprintf_colored>
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
  800fd7:	68 60 59 80 00       	push   $0x805960
  800fdc:	6a 0c                	push   $0xc
  800fde:	e8 82 0a 00 00       	call   801a65 <cprintf_colored>
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
  800ffa:	68 b2 59 80 00       	push   $0x8059b2
  800fff:	6a 03                	push   $0x3
  801001:	e8 5f 0a 00 00       	call   801a65 <cprintf_colored>
  801006:	83 c4 10             	add    $0x10,%esp
	{
		allocIndex = 13;
  801009:	c7 05 4c f2 81 00 0d 	movl   $0xd,0x81f24c
  801010:	00 00 00 
		expectedVA = 0;
  801013:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		freeFrames = (int)sys_calculate_free_frames() ;
  80101a:	e8 84 33 00 00       	call   8043a3 <sys_calculate_free_frames>
  80101f:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		usedDiskPages = (int)sys_pf_calculate_allocated_pages() ;
  801025:	e8 c4 33 00 00       	call   8043ee <sys_pf_calculate_allocated_pages>
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
  801055:	e8 f7 19 00 00       	call   802a51 <malloc>
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
  801084:	68 d0 59 80 00       	push   $0x8059d0
  801089:	6a 0c                	push   $0xc
  80108b:	e8 d5 09 00 00       	call   801a65 <cprintf_colored>
  801090:	83 c4 10             	add    $0x10,%esp
		if (((int)sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.2 Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)\n", allocIndex); }
  801093:	e8 56 33 00 00       	call   8043ee <sys_pf_calculate_allocated_pages>
  801098:	3b 85 0c ff ff ff    	cmp    -0xf4(%ebp),%eax
  80109e:	74 1f                	je     8010bf <initial_page_allocations+0xcf1>
  8010a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010a7:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	50                   	push   %eax
  8010b0:	68 0c 5a 80 00       	push   $0x805a0c
  8010b5:	6a 0c                	push   $0xc
  8010b7:	e8 a9 09 00 00       	call   801a65 <cprintf_colored>
  8010bc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - (int)sys_calculate_free_frames()) != 0) { correct = 0; cprintf_colored(TEXT_TESTERR_CLR,"%~%d.3 Wrong allocation: pages are not loaded successfully into memory\n", allocIndex); }
  8010bf:	e8 df 32 00 00       	call   8043a3 <sys_calculate_free_frames>
  8010c4:	3b 85 10 ff ff ff    	cmp    -0xf0(%ebp),%eax
  8010ca:	74 1f                	je     8010eb <initial_page_allocations+0xd1d>
  8010cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010d3:	a1 4c f2 81 00       	mov    0x81f24c,%eax
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	50                   	push   %eax
  8010dc:	68 7c 5a 80 00       	push   $0x805a7c
  8010e1:	6a 0c                	push   $0xc
  8010e3:	e8 7d 09 00 00       	call   801a65 <cprintf_colored>
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
  801102:	56                   	push   %esi
  801103:	53                   	push   %ebx
  801104:	83 ec 30             	sub    $0x30,%esp
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE THAT SOME
	 * PAGES ARE ALLOCATED IN KERNEL BLOCK ALLOCATOR OR USER
	 * BLOCK ALLOCATOR DUE TO DIFFERENT MANAGEMENT OF USER HEAP
	 *********************************************************/

	cprintf_colored(TEXT_yellow, "%~************************************************\n");
  801107:	83 ec 08             	sub    $0x8,%esp
  80110a:	68 c4 5a 80 00       	push   $0x805ac4
  80110f:	6a 0e                	push   $0xe
  801111:	e8 4f 09 00 00       	call   801a65 <cprintf_colored>
  801116:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  801119:	83 ec 08             	sub    $0x8,%esp
  80111c:	68 f8 5a 80 00       	push   $0x805af8
  801121:	6a 0e                	push   $0xe
  801123:	e8 3d 09 00 00       	call   801a65 <cprintf_colored>
  801128:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_yellow, "%~************************************************\n\n\n");
  80112b:	83 ec 08             	sub    $0x8,%esp
  80112e:	68 54 5b 80 00       	push   $0x805b54
  801133:	6a 0e                	push   $0xe
  801135:	e8 2b 09 00 00       	call   801a65 <cprintf_colored>
  80113a:	83 c4 10             	add    $0x10,%esp

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80113d:	a1 00 72 80 00       	mov    0x807200,%eax
  801142:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
  801148:	a1 00 72 80 00       	mov    0x807200,%eax
  80114d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  801153:	39 c2                	cmp    %eax,%edx
  801155:	72 14                	jb     80116b <_main+0x6c>
			panic("Please increase the WS size");
  801157:	83 ec 04             	sub    $0x4,%esp
  80115a:	68 8a 5b 80 00       	push   $0x805b8a
  80115f:	6a 18                	push   $0x18
  801161:	68 a6 5b 80 00       	push   $0x805ba6
  801166:	e8 ff 05 00 00       	call   80176a <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	int eval = 0;
  80116b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  801172:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 *x, *y, *z ;
	uint32 expected ;
	uint32 pagealloc_start = ACTUAL_PAGE_ALLOC_START; //UHS + 32MB + 4KB
  801179:	c7 45 e8 00 10 00 82 	movl   $0x82001000,-0x18(%ebp)
	int freeFrames, usedDiskPages ;

	cprintf_colored(TEXT_cyan, "\n%~STEP A: checking the creation of shared variables... [60%]\n");
  801180:	83 ec 08             	sub    $0x8,%esp
  801183:	68 bc 5b 80 00       	push   $0x805bbc
  801188:	6a 03                	push   $0x3
  80118a:	e8 d6 08 00 00       	call   801a65 <cprintf_colored>
  80118f:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  801192:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  801199:	e8 05 32 00 00       	call   8043a3 <sys_calculate_free_frames>
  80119e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8011a1:	e8 48 32 00 00       	call   8043ee <sys_pf_calculate_allocated_pages>
  8011a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8011a9:	83 ec 04             	sub    $0x4,%esp
  8011ac:	6a 01                	push   $0x1
  8011ae:	68 00 10 00 00       	push   $0x1000
  8011b3:	68 fb 5b 80 00       	push   $0x805bfb
  8011b8:	e8 22 25 00 00       	call   8036df <smalloc>
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)pagealloc_start)
  8011c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011c6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  8011c9:	74 19                	je     8011e4 <_main+0xe5>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~1 Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8011cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011d2:	83 ec 08             	sub    $0x8,%esp
  8011d5:	68 00 5c 80 00       	push   $0x805c00
  8011da:	6a 0c                	push   $0xc
  8011dc:	e8 84 08 00 00       	call   801a65 <cprintf_colored>
  8011e1:	83 c4 10             	add    $0x10,%esp
		expected = 1+1 ; /*1page +1table*/
  8011e4:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
		int diff = (freeFrames - sys_calculate_free_frames());
  8011eb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8011ee:	e8 b0 31 00 00       	call   8043a3 <sys_calculate_free_frames>
  8011f3:	29 c3                	sub    %eax,%ebx
  8011f5:	89 d8                	mov    %ebx,%eax
  8011f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expected + 1 /*KH Block Alloc: 1 page for Share object*/ + 2 /*UH Block Alloc: max of 1 page & 1 table*/))
  8011fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011fd:	83 c0 03             	add    $0x3,%eax
  801200:	89 c2                	mov    %eax,%edx
  801202:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801205:	83 ec 04             	sub    $0x4,%esp
  801208:	52                   	push   %edx
  801209:	50                   	push   %eax
  80120a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80120d:	e8 26 ee ff ff       	call   800038 <inRange>
  801212:	83 c4 10             	add    $0x10,%esp
  801215:	85 c0                	test   %eax,%eax
  801217:	75 30                	jne    801249 <_main+0x14a>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~1 Wrong allocation (actual=%d, expected=[%d, %d]): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected, expected +1 +2);}
  801219:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801220:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801223:	8d 58 03             	lea    0x3(%eax),%ebx
  801226:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801229:	e8 75 31 00 00       	call   8043a3 <sys_calculate_free_frames>
  80122e:	29 c6                	sub    %eax,%esi
  801230:	89 f0                	mov    %esi,%eax
  801232:	83 ec 0c             	sub    $0xc,%esp
  801235:	53                   	push   %ebx
  801236:	ff 75 d8             	pushl  -0x28(%ebp)
  801239:	50                   	push   %eax
  80123a:	68 70 5c 80 00       	push   $0x805c70
  80123f:	6a 0c                	push   $0xc
  801241:	e8 1f 08 00 00       	call   801a65 <cprintf_colored>
  801246:	83 c4 20             	add    $0x20,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  801249:	e8 a0 31 00 00       	call   8043ee <sys_pf_calculate_allocated_pages>
  80124e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801251:	74 19                	je     80126c <_main+0x16d>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~1 Wrong page file allocation: ");}
  801253:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80125a:	83 ec 08             	sub    $0x8,%esp
  80125d:	68 14 5d 80 00       	push   $0x805d14
  801262:	6a 0c                	push   $0xc
  801264:	e8 fc 07 00 00       	call   801a65 <cprintf_colored>
  801269:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80126c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801270:	74 04                	je     801276 <_main+0x177>
  801272:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  801276:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80127d:	e8 21 31 00 00       	call   8043a3 <sys_calculate_free_frames>
  801282:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  801285:	e8 64 31 00 00       	call   8043ee <sys_pf_calculate_allocated_pages>
  80128a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  80128d:	83 ec 04             	sub    $0x4,%esp
  801290:	6a 01                	push   $0x1
  801292:	68 04 10 00 00       	push   $0x1004
  801297:	68 35 5d 80 00       	push   $0x805d35
  80129c:	e8 3e 24 00 00       	call   8036df <smalloc>
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (z != (uint32*)(pagealloc_start + 1 * PAGE_SIZE))
  8012a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012aa:	05 00 10 00 00       	add    $0x1000,%eax
  8012af:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8012b2:	74 19                	je     8012cd <_main+0x1ce>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~2 Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  8012b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012bb:	83 ec 08             	sub    $0x8,%esp
  8012be:	68 38 5d 80 00       	push   $0x805d38
  8012c3:	6a 0c                	push   $0xc
  8012c5:	e8 9b 07 00 00       	call   801a65 <cprintf_colored>
  8012ca:	83 c4 10             	add    $0x10,%esp
		expected = 2 ; /*2 pages*/
  8012cd:	c7 45 d8 02 00 00 00 	movl   $0x2,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8012d4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8012d7:	e8 c7 30 00 00       	call   8043a3 <sys_calculate_free_frames>
  8012dc:	29 c3                	sub    %eax,%ebx
  8012de:	89 d8                	mov    %ebx,%eax
  8012e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  8012e3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8012e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012e9:	83 ec 04             	sub    $0x4,%esp
  8012ec:	52                   	push   %edx
  8012ed:	50                   	push   %eax
  8012ee:	ff 75 d4             	pushl  -0x2c(%ebp)
  8012f1:	e8 42 ed ff ff       	call   800038 <inRange>
  8012f6:	83 c4 10             	add    $0x10,%esp
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	75 26                	jne    801323 <_main+0x224>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~2 Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8012fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801304:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  801307:	e8 97 30 00 00       	call   8043a3 <sys_calculate_free_frames>
  80130c:	29 c3                	sub    %eax,%ebx
  80130e:	89 d8                	mov    %ebx,%eax
  801310:	ff 75 d8             	pushl  -0x28(%ebp)
  801313:	50                   	push   %eax
  801314:	68 a8 5d 80 00       	push   $0x805da8
  801319:	6a 0c                	push   $0xc
  80131b:	e8 45 07 00 00       	call   801a65 <cprintf_colored>
  801320:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  801323:	e8 c6 30 00 00       	call   8043ee <sys_pf_calculate_allocated_pages>
  801328:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80132b:	74 19                	je     801346 <_main+0x247>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~2 Wrong page file allocation: ");}
  80132d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801334:	83 ec 08             	sub    $0x8,%esp
  801337:	68 44 5e 80 00       	push   $0x805e44
  80133c:	6a 0c                	push   $0xc
  80133e:	e8 22 07 00 00       	call   801a65 <cprintf_colored>
  801343:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  801346:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80134a:	74 04                	je     801350 <_main+0x251>
  80134c:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)

		is_correct = 1;
  801350:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  801357:	e8 47 30 00 00       	call   8043a3 <sys_calculate_free_frames>
  80135c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80135f:	e8 8a 30 00 00       	call   8043ee <sys_pf_calculate_allocated_pages>
  801364:	89 45 e0             	mov    %eax,-0x20(%ebp)
		y = smalloc("y", 4, 1);
  801367:	83 ec 04             	sub    $0x4,%esp
  80136a:	6a 01                	push   $0x1
  80136c:	6a 04                	push   $0x4
  80136e:	68 65 5e 80 00       	push   $0x805e65
  801373:	e8 67 23 00 00       	call   8036df <smalloc>
  801378:	83 c4 10             	add    $0x10,%esp
  80137b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (y != (uint32*)(pagealloc_start + 3 * PAGE_SIZE))
  80137e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801381:	05 00 30 00 00       	add    $0x3000,%eax
  801386:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  801389:	74 19                	je     8013a4 <_main+0x2a5>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~3 Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");}
  80138b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801392:	83 ec 08             	sub    $0x8,%esp
  801395:	68 68 5e 80 00       	push   $0x805e68
  80139a:	6a 0c                	push   $0xc
  80139c:	e8 c4 06 00 00       	call   801a65 <cprintf_colored>
  8013a1:	83 c4 10             	add    $0x10,%esp
		expected = 1 ; /*1 page*/
  8013a4:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
		diff = (freeFrames - sys_calculate_free_frames());
  8013ab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8013ae:	e8 f0 2f 00 00       	call   8043a3 <sys_calculate_free_frames>
  8013b3:	29 c3                	sub    %eax,%ebx
  8013b5:	89 d8                	mov    %ebx,%eax
  8013b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		if (!inRange(diff, expected, expected)) //no extra is expected since there'll be free blocks in Block Allo since last allocation
  8013ba:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8013bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013c0:	83 ec 04             	sub    $0x4,%esp
  8013c3:	52                   	push   %edx
  8013c4:	50                   	push   %eax
  8013c5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8013c8:	e8 6b ec ff ff       	call   800038 <inRange>
  8013cd:	83 c4 10             	add    $0x10,%esp
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	75 26                	jne    8013fa <_main+0x2fb>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~3 Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);}
  8013d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013db:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8013de:	e8 c0 2f 00 00       	call   8043a3 <sys_calculate_free_frames>
  8013e3:	29 c3                	sub    %eax,%ebx
  8013e5:	89 d8                	mov    %ebx,%eax
  8013e7:	ff 75 d8             	pushl  -0x28(%ebp)
  8013ea:	50                   	push   %eax
  8013eb:	68 d8 5e 80 00       	push   $0x805ed8
  8013f0:	6a 0c                	push   $0xc
  8013f2:	e8 6e 06 00 00       	call   801a65 <cprintf_colored>
  8013f7:	83 c4 10             	add    $0x10,%esp
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  8013fa:	e8 ef 2f 00 00       	call   8043ee <sys_pf_calculate_allocated_pages>
  8013ff:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801402:	74 19                	je     80141d <_main+0x31e>
		{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~3 Wrong page file allocation: ");}
  801404:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80140b:	83 ec 08             	sub    $0x8,%esp
  80140e:	68 74 5f 80 00       	push   $0x805f74
  801413:	6a 0c                	push   $0xc
  801415:	e8 4b 06 00 00       	call   801a65 <cprintf_colored>
  80141a:	83 c4 10             	add    $0x10,%esp
		if (is_correct) eval += 20 ;
  80141d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801421:	74 04                	je     801427 <_main+0x328>
  801423:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
	}

	is_correct = 1;
  801427:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	cprintf_colored(TEXT_cyan, "\n%~STEP B: checking reading & writing... [40%]\n");
  80142e:	83 ec 08             	sub    $0x8,%esp
  801431:	68 98 5f 80 00       	push   $0x805f98
  801436:	6a 03                	push   $0x3
  801438:	e8 28 06 00 00       	call   801a65 <cprintf_colored>
  80143d:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  801440:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  801447:	eb 2d                	jmp    801476 <_main+0x377>
		{
			x[i] = -1;
  801449:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80144c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801453:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801456:	01 d0                	add    %edx,%eax
  801458:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  80145e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801461:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801468:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80146b:	01 d0                	add    %edx,%eax
  80146d:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

	is_correct = 1;
	cprintf_colored(TEXT_cyan, "\n%~STEP B: checking reading & writing... [40%]\n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  801473:	ff 45 ec             	incl   -0x14(%ebp)
  801476:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  80147d:	7e ca                	jle    801449 <_main+0x34a>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80147f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  801486:	eb 18                	jmp    8014a0 <_main+0x3a1>
		{
			z[i] = -1;
  801488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80148b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801492:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801495:	01 d0                	add    %edx,%eax
  801497:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  80149d:	ff 45 ec             	incl   -0x14(%ebp)
  8014a0:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  8014a7:	7e df                	jle    801488 <_main+0x389>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  8014a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	83 f8 ff             	cmp    $0xffffffff,%eax
  8014b1:	74 19                	je     8014cc <_main+0x3cd>
  8014b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014ba:	83 ec 08             	sub    $0x8,%esp
  8014bd:	68 c8 5f 80 00       	push   $0x805fc8
  8014c2:	6a 0c                	push   $0xc
  8014c4:	e8 9c 05 00 00       	call   801a65 <cprintf_colored>
  8014c9:	83 c4 10             	add    $0x10,%esp
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  8014cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014cf:	05 fc 0f 00 00       	add    $0xffc,%eax
  8014d4:	8b 00                	mov    (%eax),%eax
  8014d6:	83 f8 ff             	cmp    $0xffffffff,%eax
  8014d9:	74 19                	je     8014f4 <_main+0x3f5>
  8014db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014e2:	83 ec 08             	sub    $0x8,%esp
  8014e5:	68 c8 5f 80 00       	push   $0x805fc8
  8014ea:	6a 0c                	push   $0xc
  8014ec:	e8 74 05 00 00       	call   801a65 <cprintf_colored>
  8014f1:	83 c4 10             	add    $0x10,%esp

		if( y[0] !=  -1)  					{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  8014f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014f7:	8b 00                	mov    (%eax),%eax
  8014f9:	83 f8 ff             	cmp    $0xffffffff,%eax
  8014fc:	74 19                	je     801517 <_main+0x418>
  8014fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	68 c8 5f 80 00       	push   $0x805fc8
  80150d:	6a 0c                	push   $0xc
  80150f:	e8 51 05 00 00       	call   801a65 <cprintf_colored>
  801514:	83 c4 10             	add    $0x10,%esp
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  801517:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80151a:	05 fc 0f 00 00       	add    $0xffc,%eax
  80151f:	8b 00                	mov    (%eax),%eax
  801521:	83 f8 ff             	cmp    $0xffffffff,%eax
  801524:	74 19                	je     80153f <_main+0x440>
  801526:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80152d:	83 ec 08             	sub    $0x8,%esp
  801530:	68 c8 5f 80 00       	push   $0x805fc8
  801535:	6a 0c                	push   $0xc
  801537:	e8 29 05 00 00       	call   801a65 <cprintf_colored>
  80153c:	83 c4 10             	add    $0x10,%esp

		if( z[0] !=  -1)  					{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  80153f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801542:	8b 00                	mov    (%eax),%eax
  801544:	83 f8 ff             	cmp    $0xffffffff,%eax
  801547:	74 19                	je     801562 <_main+0x463>
  801549:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	68 c8 5f 80 00       	push   $0x805fc8
  801558:	6a 0c                	push   $0xc
  80155a:	e8 06 05 00 00       	call   801a65 <cprintf_colored>
  80155f:	83 c4 10             	add    $0x10,%esp
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	{is_correct = 0; cprintf_colored(TEXT_TESTERR_CLR, "%~Reading/Writing of shared object is failed");}
  801562:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801565:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  80156a:	8b 00                	mov    (%eax),%eax
  80156c:	83 f8 ff             	cmp    $0xffffffff,%eax
  80156f:	74 19                	je     80158a <_main+0x48b>
  801571:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801578:	83 ec 08             	sub    $0x8,%esp
  80157b:	68 c8 5f 80 00       	push   $0x805fc8
  801580:	6a 0c                	push   $0xc
  801582:	e8 de 04 00 00       	call   801a65 <cprintf_colored>
  801587:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  80158a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80158e:	74 04                	je     801594 <_main+0x495>
		eval += 40 ;
  801590:	83 45 f4 28          	addl   $0x28,-0xc(%ebp)
	cprintf_colored(TEXT_light_green, "%~\n%~Test of Shared Variables [Create] [1] completed. Eval = %d%%\n\n", eval);
  801594:	83 ec 04             	sub    $0x4,%esp
  801597:	ff 75 f4             	pushl  -0xc(%ebp)
  80159a:	68 f8 5f 80 00       	push   $0x805ff8
  80159f:	6a 0a                	push   $0xa
  8015a1:	e8 bf 04 00 00       	call   801a65 <cprintf_colored>
  8015a6:	83 c4 10             	add    $0x10,%esp

	return;
  8015a9:	90                   	nop
}
  8015aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ad:	5b                   	pop    %ebx
  8015ae:	5e                   	pop    %esi
  8015af:	5d                   	pop    %ebp
  8015b0:	c3                   	ret    

008015b1 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	57                   	push   %edi
  8015b5:	56                   	push   %esi
  8015b6:	53                   	push   %ebx
  8015b7:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8015ba:	e8 ad 2f 00 00       	call   80456c <sys_getenvindex>
  8015bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8015c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015c5:	89 d0                	mov    %edx,%eax
  8015c7:	c1 e0 02             	shl    $0x2,%eax
  8015ca:	01 d0                	add    %edx,%eax
  8015cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015d3:	01 d0                	add    %edx,%eax
  8015d5:	89 c2                	mov    %eax,%edx
  8015d7:	c1 e2 04             	shl    $0x4,%edx
  8015da:	29 c2                	sub    %eax,%edx
  8015dc:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8015e3:	89 c2                	mov    %eax,%edx
  8015e5:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8015eb:	a3 00 72 80 00       	mov    %eax,0x807200

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8015f0:	a1 00 72 80 00       	mov    0x807200,%eax
  8015f5:	8a 40 20             	mov    0x20(%eax),%al
  8015f8:	84 c0                	test   %al,%al
  8015fa:	74 0d                	je     801609 <libmain+0x58>
		binaryname = myEnv->prog_name;
  8015fc:	a1 00 72 80 00       	mov    0x807200,%eax
  801601:	83 c0 20             	add    $0x20,%eax
  801604:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801609:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80160d:	7e 0a                	jle    801619 <libmain+0x68>
		binaryname = argv[0];
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	8b 00                	mov    (%eax),%eax
  801614:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  801619:	83 ec 08             	sub    $0x8,%esp
  80161c:	ff 75 0c             	pushl  0xc(%ebp)
  80161f:	ff 75 08             	pushl  0x8(%ebp)
  801622:	e8 d8 fa ff ff       	call   8010ff <_main>
  801627:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80162a:	a1 00 70 80 00       	mov    0x807000,%eax
  80162f:	85 c0                	test   %eax,%eax
  801631:	0f 84 01 01 00 00    	je     801738 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  801637:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80163d:	bb 34 61 80 00       	mov    $0x806134,%ebx
  801642:	ba 0e 00 00 00       	mov    $0xe,%edx
  801647:	89 c7                	mov    %eax,%edi
  801649:	89 de                	mov    %ebx,%esi
  80164b:	89 d1                	mov    %edx,%ecx
  80164d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80164f:	8d 55 8a             	lea    -0x76(%ebp),%edx
  801652:	b9 56 00 00 00       	mov    $0x56,%ecx
  801657:	b0 00                	mov    $0x0,%al
  801659:	89 d7                	mov    %edx,%edi
  80165b:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80165d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  801664:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801667:	83 ec 08             	sub    $0x8,%esp
  80166a:	50                   	push   %eax
  80166b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801671:	50                   	push   %eax
  801672:	e8 2b 31 00 00       	call   8047a2 <sys_utilities>
  801677:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80167a:	e8 74 2c 00 00       	call   8042f3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	68 54 60 80 00       	push   $0x806054
  801687:	e8 ac 03 00 00       	call   801a38 <cprintf>
  80168c:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80168f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801692:	85 c0                	test   %eax,%eax
  801694:	74 18                	je     8016ae <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  801696:	e8 25 31 00 00       	call   8047c0 <sys_get_optimal_num_faults>
  80169b:	83 ec 08             	sub    $0x8,%esp
  80169e:	50                   	push   %eax
  80169f:	68 7c 60 80 00       	push   $0x80607c
  8016a4:	e8 8f 03 00 00       	call   801a38 <cprintf>
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	eb 59                	jmp    801707 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8016ae:	a1 00 72 80 00       	mov    0x807200,%eax
  8016b3:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8016b9:	a1 00 72 80 00       	mov    0x807200,%eax
  8016be:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	52                   	push   %edx
  8016c8:	50                   	push   %eax
  8016c9:	68 a0 60 80 00       	push   $0x8060a0
  8016ce:	e8 65 03 00 00       	call   801a38 <cprintf>
  8016d3:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8016d6:	a1 00 72 80 00       	mov    0x807200,%eax
  8016db:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8016e1:	a1 00 72 80 00       	mov    0x807200,%eax
  8016e6:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8016ec:	a1 00 72 80 00       	mov    0x807200,%eax
  8016f1:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8016f7:	51                   	push   %ecx
  8016f8:	52                   	push   %edx
  8016f9:	50                   	push   %eax
  8016fa:	68 c8 60 80 00       	push   $0x8060c8
  8016ff:	e8 34 03 00 00       	call   801a38 <cprintf>
  801704:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801707:	a1 00 72 80 00       	mov    0x807200,%eax
  80170c:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  801712:	83 ec 08             	sub    $0x8,%esp
  801715:	50                   	push   %eax
  801716:	68 20 61 80 00       	push   $0x806120
  80171b:	e8 18 03 00 00       	call   801a38 <cprintf>
  801720:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801723:	83 ec 0c             	sub    $0xc,%esp
  801726:	68 54 60 80 00       	push   $0x806054
  80172b:	e8 08 03 00 00       	call   801a38 <cprintf>
  801730:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801733:	e8 d5 2b 00 00       	call   80430d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801738:	e8 1f 00 00 00       	call   80175c <exit>
}
  80173d:	90                   	nop
  80173e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801741:	5b                   	pop    %ebx
  801742:	5e                   	pop    %esi
  801743:	5f                   	pop    %edi
  801744:	5d                   	pop    %ebp
  801745:	c3                   	ret    

00801746 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80174c:	83 ec 0c             	sub    $0xc,%esp
  80174f:	6a 00                	push   $0x0
  801751:	e8 e2 2d 00 00       	call   804538 <sys_destroy_env>
  801756:	83 c4 10             	add    $0x10,%esp
}
  801759:	90                   	nop
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <exit>:

void
exit(void)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801762:	e8 37 2e 00 00       	call   80459e <sys_exit_env>
}
  801767:	90                   	nop
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801770:	8d 45 10             	lea    0x10(%ebp),%eax
  801773:	83 c0 04             	add    $0x4,%eax
  801776:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801779:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  80177e:	85 c0                	test   %eax,%eax
  801780:	74 16                	je     801798 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801782:	a1 f8 f2 81 00       	mov    0x81f2f8,%eax
  801787:	83 ec 08             	sub    $0x8,%esp
  80178a:	50                   	push   %eax
  80178b:	68 98 61 80 00       	push   $0x806198
  801790:	e8 a3 02 00 00       	call   801a38 <cprintf>
  801795:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  801798:	a1 04 70 80 00       	mov    0x807004,%eax
  80179d:	83 ec 0c             	sub    $0xc,%esp
  8017a0:	ff 75 0c             	pushl  0xc(%ebp)
  8017a3:	ff 75 08             	pushl  0x8(%ebp)
  8017a6:	50                   	push   %eax
  8017a7:	68 a0 61 80 00       	push   $0x8061a0
  8017ac:	6a 74                	push   $0x74
  8017ae:	e8 b2 02 00 00       	call   801a65 <cprintf_colored>
  8017b3:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8017b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b9:	83 ec 08             	sub    $0x8,%esp
  8017bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8017bf:	50                   	push   %eax
  8017c0:	e8 04 02 00 00       	call   8019c9 <vcprintf>
  8017c5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8017c8:	83 ec 08             	sub    $0x8,%esp
  8017cb:	6a 00                	push   $0x0
  8017cd:	68 c8 61 80 00       	push   $0x8061c8
  8017d2:	e8 f2 01 00 00       	call   8019c9 <vcprintf>
  8017d7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8017da:	e8 7d ff ff ff       	call   80175c <exit>

	// should not return here
	while (1) ;
  8017df:	eb fe                	jmp    8017df <_panic+0x75>

008017e1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8017e7:	a1 00 72 80 00       	mov    0x807200,%eax
  8017ec:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8017f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f5:	39 c2                	cmp    %eax,%edx
  8017f7:	74 14                	je     80180d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	68 cc 61 80 00       	push   $0x8061cc
  801801:	6a 26                	push   $0x26
  801803:	68 18 62 80 00       	push   $0x806218
  801808:	e8 5d ff ff ff       	call   80176a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80180d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801814:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80181b:	e9 c5 00 00 00       	jmp    8018e5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801823:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	01 d0                	add    %edx,%eax
  80182f:	8b 00                	mov    (%eax),%eax
  801831:	85 c0                	test   %eax,%eax
  801833:	75 08                	jne    80183d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801835:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801838:	e9 a5 00 00 00       	jmp    8018e2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80183d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801844:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80184b:	eb 69                	jmp    8018b6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80184d:	a1 00 72 80 00       	mov    0x807200,%eax
  801852:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  801858:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80185b:	89 d0                	mov    %edx,%eax
  80185d:	01 c0                	add    %eax,%eax
  80185f:	01 d0                	add    %edx,%eax
  801861:	c1 e0 03             	shl    $0x3,%eax
  801864:	01 c8                	add    %ecx,%eax
  801866:	8a 40 04             	mov    0x4(%eax),%al
  801869:	84 c0                	test   %al,%al
  80186b:	75 46                	jne    8018b3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80186d:	a1 00 72 80 00       	mov    0x807200,%eax
  801872:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  801878:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80187b:	89 d0                	mov    %edx,%eax
  80187d:	01 c0                	add    %eax,%eax
  80187f:	01 d0                	add    %edx,%eax
  801881:	c1 e0 03             	shl    $0x3,%eax
  801884:	01 c8                	add    %ecx,%eax
  801886:	8b 00                	mov    (%eax),%eax
  801888:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80188b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80188e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801893:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801898:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	01 c8                	add    %ecx,%eax
  8018a4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018a6:	39 c2                	cmp    %eax,%edx
  8018a8:	75 09                	jne    8018b3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8018aa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018b1:	eb 15                	jmp    8018c8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018b3:	ff 45 e8             	incl   -0x18(%ebp)
  8018b6:	a1 00 72 80 00       	mov    0x807200,%eax
  8018bb:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8018c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018c4:	39 c2                	cmp    %eax,%edx
  8018c6:	77 85                	ja     80184d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8018c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018cc:	75 14                	jne    8018e2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	68 24 62 80 00       	push   $0x806224
  8018d6:	6a 3a                	push   $0x3a
  8018d8:	68 18 62 80 00       	push   $0x806218
  8018dd:	e8 88 fe ff ff       	call   80176a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8018e2:	ff 45 f0             	incl   -0x10(%ebp)
  8018e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8018eb:	0f 8c 2f ff ff ff    	jl     801820 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8018f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018f8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8018ff:	eb 26                	jmp    801927 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801901:	a1 00 72 80 00       	mov    0x807200,%eax
  801906:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80190c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80190f:	89 d0                	mov    %edx,%eax
  801911:	01 c0                	add    %eax,%eax
  801913:	01 d0                	add    %edx,%eax
  801915:	c1 e0 03             	shl    $0x3,%eax
  801918:	01 c8                	add    %ecx,%eax
  80191a:	8a 40 04             	mov    0x4(%eax),%al
  80191d:	3c 01                	cmp    $0x1,%al
  80191f:	75 03                	jne    801924 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801921:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801924:	ff 45 e0             	incl   -0x20(%ebp)
  801927:	a1 00 72 80 00       	mov    0x807200,%eax
  80192c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801932:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801935:	39 c2                	cmp    %eax,%edx
  801937:	77 c8                	ja     801901 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80193f:	74 14                	je     801955 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801941:	83 ec 04             	sub    $0x4,%esp
  801944:	68 78 62 80 00       	push   $0x806278
  801949:	6a 44                	push   $0x44
  80194b:	68 18 62 80 00       	push   $0x806218
  801950:	e8 15 fe ff ff       	call   80176a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801955:	90                   	nop
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	53                   	push   %ebx
  80195c:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  80195f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801962:	8b 00                	mov    (%eax),%eax
  801964:	8d 48 01             	lea    0x1(%eax),%ecx
  801967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196a:	89 0a                	mov    %ecx,(%edx)
  80196c:	8b 55 08             	mov    0x8(%ebp),%edx
  80196f:	88 d1                	mov    %dl,%cl
  801971:	8b 55 0c             	mov    0xc(%ebp),%edx
  801974:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801978:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197b:	8b 00                	mov    (%eax),%eax
  80197d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801982:	75 30                	jne    8019b4 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  801984:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  80198a:	a0 24 72 80 00       	mov    0x807224,%al
  80198f:	0f b6 c0             	movzbl %al,%eax
  801992:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801995:	8b 09                	mov    (%ecx),%ecx
  801997:	89 cb                	mov    %ecx,%ebx
  801999:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80199c:	83 c1 08             	add    $0x8,%ecx
  80199f:	52                   	push   %edx
  8019a0:	50                   	push   %eax
  8019a1:	53                   	push   %ebx
  8019a2:	51                   	push   %ecx
  8019a3:	e8 07 29 00 00       	call   8042af <sys_cputs>
  8019a8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8019ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8019b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b7:	8b 40 04             	mov    0x4(%eax),%eax
  8019ba:	8d 50 01             	lea    0x1(%eax),%edx
  8019bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8019c3:	90                   	nop
  8019c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
  8019cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8019d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019d9:	00 00 00 
	b.cnt = 0;
  8019dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8019e3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8019e6:	ff 75 0c             	pushl  0xc(%ebp)
  8019e9:	ff 75 08             	pushl  0x8(%ebp)
  8019ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8019f2:	50                   	push   %eax
  8019f3:	68 58 19 80 00       	push   $0x801958
  8019f8:	e8 5a 02 00 00       	call   801c57 <vprintfmt>
  8019fd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801a00:	8b 15 fc f2 81 00    	mov    0x81f2fc,%edx
  801a06:	a0 24 72 80 00       	mov    0x807224,%al
  801a0b:	0f b6 c0             	movzbl %al,%eax
  801a0e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  801a14:	52                   	push   %edx
  801a15:	50                   	push   %eax
  801a16:	51                   	push   %ecx
  801a17:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a1d:	83 c0 08             	add    $0x8,%eax
  801a20:	50                   	push   %eax
  801a21:	e8 89 28 00 00       	call   8042af <sys_cputs>
  801a26:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801a29:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
	return b.cnt;
  801a30:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
  801a3b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801a3e:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	va_start(ap, fmt);
  801a45:	8d 45 0c             	lea    0xc(%ebp),%eax
  801a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	83 ec 08             	sub    $0x8,%esp
  801a51:	ff 75 f4             	pushl  -0xc(%ebp)
  801a54:	50                   	push   %eax
  801a55:	e8 6f ff ff ff       	call   8019c9 <vcprintf>
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801a6b:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
	curTextClr = (textClr << 8) ; //set text color by the given value
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	c1 e0 08             	shl    $0x8,%eax
  801a78:	a3 fc f2 81 00       	mov    %eax,0x81f2fc
	va_start(ap, fmt);
  801a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  801a80:	83 c0 04             	add    $0x4,%eax
  801a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a89:	83 ec 08             	sub    $0x8,%esp
  801a8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a8f:	50                   	push   %eax
  801a90:	e8 34 ff ff ff       	call   8019c9 <vcprintf>
  801a95:	83 c4 10             	add    $0x10,%esp
  801a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  801a9b:	c7 05 fc f2 81 00 00 	movl   $0x700,0x81f2fc
  801aa2:	07 00 00 

	return cnt;
  801aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801ab0:	e8 3e 28 00 00       	call   8042f3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801ab5:	8d 45 0c             	lea    0xc(%ebp),%eax
  801ab8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac4:	50                   	push   %eax
  801ac5:	e8 ff fe ff ff       	call   8019c9 <vcprintf>
  801aca:	83 c4 10             	add    $0x10,%esp
  801acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801ad0:	e8 38 28 00 00       	call   80430d <sys_unlock_cons>
	return cnt;
  801ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	53                   	push   %ebx
  801ade:	83 ec 14             	sub    $0x14,%esp
  801ae1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  801aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801aed:	8b 45 18             	mov    0x18(%ebp),%eax
  801af0:	ba 00 00 00 00       	mov    $0x0,%edx
  801af5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801af8:	77 55                	ja     801b4f <printnum+0x75>
  801afa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801afd:	72 05                	jb     801b04 <printnum+0x2a>
  801aff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b02:	77 4b                	ja     801b4f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801b04:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801b07:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801b0a:	8b 45 18             	mov    0x18(%ebp),%eax
  801b0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b12:	52                   	push   %edx
  801b13:	50                   	push   %eax
  801b14:	ff 75 f4             	pushl  -0xc(%ebp)
  801b17:	ff 75 f0             	pushl  -0x10(%ebp)
  801b1a:	e8 81 38 00 00       	call   8053a0 <__udivdi3>
  801b1f:	83 c4 10             	add    $0x10,%esp
  801b22:	83 ec 04             	sub    $0x4,%esp
  801b25:	ff 75 20             	pushl  0x20(%ebp)
  801b28:	53                   	push   %ebx
  801b29:	ff 75 18             	pushl  0x18(%ebp)
  801b2c:	52                   	push   %edx
  801b2d:	50                   	push   %eax
  801b2e:	ff 75 0c             	pushl  0xc(%ebp)
  801b31:	ff 75 08             	pushl  0x8(%ebp)
  801b34:	e8 a1 ff ff ff       	call   801ada <printnum>
  801b39:	83 c4 20             	add    $0x20,%esp
  801b3c:	eb 1a                	jmp    801b58 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801b3e:	83 ec 08             	sub    $0x8,%esp
  801b41:	ff 75 0c             	pushl  0xc(%ebp)
  801b44:	ff 75 20             	pushl  0x20(%ebp)
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	ff d0                	call   *%eax
  801b4c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801b4f:	ff 4d 1c             	decl   0x1c(%ebp)
  801b52:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801b56:	7f e6                	jg     801b3e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801b58:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801b5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b66:	53                   	push   %ebx
  801b67:	51                   	push   %ecx
  801b68:	52                   	push   %edx
  801b69:	50                   	push   %eax
  801b6a:	e8 41 39 00 00       	call   8054b0 <__umoddi3>
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	05 f4 64 80 00       	add    $0x8064f4,%eax
  801b77:	8a 00                	mov    (%eax),%al
  801b79:	0f be c0             	movsbl %al,%eax
  801b7c:	83 ec 08             	sub    $0x8,%esp
  801b7f:	ff 75 0c             	pushl  0xc(%ebp)
  801b82:	50                   	push   %eax
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	ff d0                	call   *%eax
  801b88:	83 c4 10             	add    $0x10,%esp
}
  801b8b:	90                   	nop
  801b8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801b94:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801b98:	7e 1c                	jle    801bb6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	8b 00                	mov    (%eax),%eax
  801b9f:	8d 50 08             	lea    0x8(%eax),%edx
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	89 10                	mov    %edx,(%eax)
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	8b 00                	mov    (%eax),%eax
  801bac:	83 e8 08             	sub    $0x8,%eax
  801baf:	8b 50 04             	mov    0x4(%eax),%edx
  801bb2:	8b 00                	mov    (%eax),%eax
  801bb4:	eb 40                	jmp    801bf6 <getuint+0x65>
	else if (lflag)
  801bb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bba:	74 1e                	je     801bda <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	8b 00                	mov    (%eax),%eax
  801bc1:	8d 50 04             	lea    0x4(%eax),%edx
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	89 10                	mov    %edx,(%eax)
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	8b 00                	mov    (%eax),%eax
  801bce:	83 e8 04             	sub    $0x4,%eax
  801bd1:	8b 00                	mov    (%eax),%eax
  801bd3:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd8:	eb 1c                	jmp    801bf6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	8b 00                	mov    (%eax),%eax
  801bdf:	8d 50 04             	lea    0x4(%eax),%edx
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	89 10                	mov    %edx,(%eax)
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	8b 00                	mov    (%eax),%eax
  801bec:	83 e8 04             	sub    $0x4,%eax
  801bef:	8b 00                	mov    (%eax),%eax
  801bf1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801bf6:	5d                   	pop    %ebp
  801bf7:	c3                   	ret    

00801bf8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801bfb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801bff:	7e 1c                	jle    801c1d <getint+0x25>
		return va_arg(*ap, long long);
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	8b 00                	mov    (%eax),%eax
  801c06:	8d 50 08             	lea    0x8(%eax),%edx
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	89 10                	mov    %edx,(%eax)
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	8b 00                	mov    (%eax),%eax
  801c13:	83 e8 08             	sub    $0x8,%eax
  801c16:	8b 50 04             	mov    0x4(%eax),%edx
  801c19:	8b 00                	mov    (%eax),%eax
  801c1b:	eb 38                	jmp    801c55 <getint+0x5d>
	else if (lflag)
  801c1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c21:	74 1a                	je     801c3d <getint+0x45>
		return va_arg(*ap, long);
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	8b 00                	mov    (%eax),%eax
  801c28:	8d 50 04             	lea    0x4(%eax),%edx
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	89 10                	mov    %edx,(%eax)
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	8b 00                	mov    (%eax),%eax
  801c35:	83 e8 04             	sub    $0x4,%eax
  801c38:	8b 00                	mov    (%eax),%eax
  801c3a:	99                   	cltd   
  801c3b:	eb 18                	jmp    801c55 <getint+0x5d>
	else
		return va_arg(*ap, int);
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	8b 00                	mov    (%eax),%eax
  801c42:	8d 50 04             	lea    0x4(%eax),%edx
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	89 10                	mov    %edx,(%eax)
  801c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4d:	8b 00                	mov    (%eax),%eax
  801c4f:	83 e8 04             	sub    $0x4,%eax
  801c52:	8b 00                	mov    (%eax),%eax
  801c54:	99                   	cltd   
}
  801c55:	5d                   	pop    %ebp
  801c56:	c3                   	ret    

00801c57 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	56                   	push   %esi
  801c5b:	53                   	push   %ebx
  801c5c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801c5f:	eb 17                	jmp    801c78 <vprintfmt+0x21>
			if (ch == '\0')
  801c61:	85 db                	test   %ebx,%ebx
  801c63:	0f 84 c1 03 00 00    	je     80202a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801c69:	83 ec 08             	sub    $0x8,%esp
  801c6c:	ff 75 0c             	pushl  0xc(%ebp)
  801c6f:	53                   	push   %ebx
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	ff d0                	call   *%eax
  801c75:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801c78:	8b 45 10             	mov    0x10(%ebp),%eax
  801c7b:	8d 50 01             	lea    0x1(%eax),%edx
  801c7e:	89 55 10             	mov    %edx,0x10(%ebp)
  801c81:	8a 00                	mov    (%eax),%al
  801c83:	0f b6 d8             	movzbl %al,%ebx
  801c86:	83 fb 25             	cmp    $0x25,%ebx
  801c89:	75 d6                	jne    801c61 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801c8b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801c8f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801c96:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801c9d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801ca4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801cab:	8b 45 10             	mov    0x10(%ebp),%eax
  801cae:	8d 50 01             	lea    0x1(%eax),%edx
  801cb1:	89 55 10             	mov    %edx,0x10(%ebp)
  801cb4:	8a 00                	mov    (%eax),%al
  801cb6:	0f b6 d8             	movzbl %al,%ebx
  801cb9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801cbc:	83 f8 5b             	cmp    $0x5b,%eax
  801cbf:	0f 87 3d 03 00 00    	ja     802002 <vprintfmt+0x3ab>
  801cc5:	8b 04 85 18 65 80 00 	mov    0x806518(,%eax,4),%eax
  801ccc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801cce:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801cd2:	eb d7                	jmp    801cab <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801cd4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801cd8:	eb d1                	jmp    801cab <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801cda:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801ce1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ce4:	89 d0                	mov    %edx,%eax
  801ce6:	c1 e0 02             	shl    $0x2,%eax
  801ce9:	01 d0                	add    %edx,%eax
  801ceb:	01 c0                	add    %eax,%eax
  801ced:	01 d8                	add    %ebx,%eax
  801cef:	83 e8 30             	sub    $0x30,%eax
  801cf2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801cf5:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf8:	8a 00                	mov    (%eax),%al
  801cfa:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801cfd:	83 fb 2f             	cmp    $0x2f,%ebx
  801d00:	7e 3e                	jle    801d40 <vprintfmt+0xe9>
  801d02:	83 fb 39             	cmp    $0x39,%ebx
  801d05:	7f 39                	jg     801d40 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801d07:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801d0a:	eb d5                	jmp    801ce1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801d0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0f:	83 c0 04             	add    $0x4,%eax
  801d12:	89 45 14             	mov    %eax,0x14(%ebp)
  801d15:	8b 45 14             	mov    0x14(%ebp),%eax
  801d18:	83 e8 04             	sub    $0x4,%eax
  801d1b:	8b 00                	mov    (%eax),%eax
  801d1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801d20:	eb 1f                	jmp    801d41 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801d22:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d26:	79 83                	jns    801cab <vprintfmt+0x54>
				width = 0;
  801d28:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801d2f:	e9 77 ff ff ff       	jmp    801cab <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801d34:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801d3b:	e9 6b ff ff ff       	jmp    801cab <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801d40:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801d41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d45:	0f 89 60 ff ff ff    	jns    801cab <vprintfmt+0x54>
				width = precision, precision = -1;
  801d4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d51:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801d58:	e9 4e ff ff ff       	jmp    801cab <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801d5d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801d60:	e9 46 ff ff ff       	jmp    801cab <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801d65:	8b 45 14             	mov    0x14(%ebp),%eax
  801d68:	83 c0 04             	add    $0x4,%eax
  801d6b:	89 45 14             	mov    %eax,0x14(%ebp)
  801d6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801d71:	83 e8 04             	sub    $0x4,%eax
  801d74:	8b 00                	mov    (%eax),%eax
  801d76:	83 ec 08             	sub    $0x8,%esp
  801d79:	ff 75 0c             	pushl  0xc(%ebp)
  801d7c:	50                   	push   %eax
  801d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d80:	ff d0                	call   *%eax
  801d82:	83 c4 10             	add    $0x10,%esp
			break;
  801d85:	e9 9b 02 00 00       	jmp    802025 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801d8a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8d:	83 c0 04             	add    $0x4,%eax
  801d90:	89 45 14             	mov    %eax,0x14(%ebp)
  801d93:	8b 45 14             	mov    0x14(%ebp),%eax
  801d96:	83 e8 04             	sub    $0x4,%eax
  801d99:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801d9b:	85 db                	test   %ebx,%ebx
  801d9d:	79 02                	jns    801da1 <vprintfmt+0x14a>
				err = -err;
  801d9f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801da1:	83 fb 64             	cmp    $0x64,%ebx
  801da4:	7f 0b                	jg     801db1 <vprintfmt+0x15a>
  801da6:	8b 34 9d 60 63 80 00 	mov    0x806360(,%ebx,4),%esi
  801dad:	85 f6                	test   %esi,%esi
  801daf:	75 19                	jne    801dca <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801db1:	53                   	push   %ebx
  801db2:	68 05 65 80 00       	push   $0x806505
  801db7:	ff 75 0c             	pushl  0xc(%ebp)
  801dba:	ff 75 08             	pushl  0x8(%ebp)
  801dbd:	e8 70 02 00 00       	call   802032 <printfmt>
  801dc2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801dc5:	e9 5b 02 00 00       	jmp    802025 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801dca:	56                   	push   %esi
  801dcb:	68 0e 65 80 00       	push   $0x80650e
  801dd0:	ff 75 0c             	pushl  0xc(%ebp)
  801dd3:	ff 75 08             	pushl  0x8(%ebp)
  801dd6:	e8 57 02 00 00       	call   802032 <printfmt>
  801ddb:	83 c4 10             	add    $0x10,%esp
			break;
  801dde:	e9 42 02 00 00       	jmp    802025 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801de3:	8b 45 14             	mov    0x14(%ebp),%eax
  801de6:	83 c0 04             	add    $0x4,%eax
  801de9:	89 45 14             	mov    %eax,0x14(%ebp)
  801dec:	8b 45 14             	mov    0x14(%ebp),%eax
  801def:	83 e8 04             	sub    $0x4,%eax
  801df2:	8b 30                	mov    (%eax),%esi
  801df4:	85 f6                	test   %esi,%esi
  801df6:	75 05                	jne    801dfd <vprintfmt+0x1a6>
				p = "(null)";
  801df8:	be 11 65 80 00       	mov    $0x806511,%esi
			if (width > 0 && padc != '-')
  801dfd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e01:	7e 6d                	jle    801e70 <vprintfmt+0x219>
  801e03:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801e07:	74 67                	je     801e70 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801e09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e0c:	83 ec 08             	sub    $0x8,%esp
  801e0f:	50                   	push   %eax
  801e10:	56                   	push   %esi
  801e11:	e8 1e 03 00 00       	call   802134 <strnlen>
  801e16:	83 c4 10             	add    $0x10,%esp
  801e19:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801e1c:	eb 16                	jmp    801e34 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801e1e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801e22:	83 ec 08             	sub    $0x8,%esp
  801e25:	ff 75 0c             	pushl  0xc(%ebp)
  801e28:	50                   	push   %eax
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	ff d0                	call   *%eax
  801e2e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801e31:	ff 4d e4             	decl   -0x1c(%ebp)
  801e34:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e38:	7f e4                	jg     801e1e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801e3a:	eb 34                	jmp    801e70 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801e3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e40:	74 1c                	je     801e5e <vprintfmt+0x207>
  801e42:	83 fb 1f             	cmp    $0x1f,%ebx
  801e45:	7e 05                	jle    801e4c <vprintfmt+0x1f5>
  801e47:	83 fb 7e             	cmp    $0x7e,%ebx
  801e4a:	7e 12                	jle    801e5e <vprintfmt+0x207>
					putch('?', putdat);
  801e4c:	83 ec 08             	sub    $0x8,%esp
  801e4f:	ff 75 0c             	pushl  0xc(%ebp)
  801e52:	6a 3f                	push   $0x3f
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	ff d0                	call   *%eax
  801e59:	83 c4 10             	add    $0x10,%esp
  801e5c:	eb 0f                	jmp    801e6d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801e5e:	83 ec 08             	sub    $0x8,%esp
  801e61:	ff 75 0c             	pushl  0xc(%ebp)
  801e64:	53                   	push   %ebx
  801e65:	8b 45 08             	mov    0x8(%ebp),%eax
  801e68:	ff d0                	call   *%eax
  801e6a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801e6d:	ff 4d e4             	decl   -0x1c(%ebp)
  801e70:	89 f0                	mov    %esi,%eax
  801e72:	8d 70 01             	lea    0x1(%eax),%esi
  801e75:	8a 00                	mov    (%eax),%al
  801e77:	0f be d8             	movsbl %al,%ebx
  801e7a:	85 db                	test   %ebx,%ebx
  801e7c:	74 24                	je     801ea2 <vprintfmt+0x24b>
  801e7e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e82:	78 b8                	js     801e3c <vprintfmt+0x1e5>
  801e84:	ff 4d e0             	decl   -0x20(%ebp)
  801e87:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e8b:	79 af                	jns    801e3c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801e8d:	eb 13                	jmp    801ea2 <vprintfmt+0x24b>
				putch(' ', putdat);
  801e8f:	83 ec 08             	sub    $0x8,%esp
  801e92:	ff 75 0c             	pushl  0xc(%ebp)
  801e95:	6a 20                	push   $0x20
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	ff d0                	call   *%eax
  801e9c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801e9f:	ff 4d e4             	decl   -0x1c(%ebp)
  801ea2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ea6:	7f e7                	jg     801e8f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801ea8:	e9 78 01 00 00       	jmp    802025 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801ead:	83 ec 08             	sub    $0x8,%esp
  801eb0:	ff 75 e8             	pushl  -0x18(%ebp)
  801eb3:	8d 45 14             	lea    0x14(%ebp),%eax
  801eb6:	50                   	push   %eax
  801eb7:	e8 3c fd ff ff       	call   801bf8 <getint>
  801ebc:	83 c4 10             	add    $0x10,%esp
  801ebf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ec2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ecb:	85 d2                	test   %edx,%edx
  801ecd:	79 23                	jns    801ef2 <vprintfmt+0x29b>
				putch('-', putdat);
  801ecf:	83 ec 08             	sub    $0x8,%esp
  801ed2:	ff 75 0c             	pushl  0xc(%ebp)
  801ed5:	6a 2d                	push   $0x2d
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	ff d0                	call   *%eax
  801edc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee5:	f7 d8                	neg    %eax
  801ee7:	83 d2 00             	adc    $0x0,%edx
  801eea:	f7 da                	neg    %edx
  801eec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801eef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801ef2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801ef9:	e9 bc 00 00 00       	jmp    801fba <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801efe:	83 ec 08             	sub    $0x8,%esp
  801f01:	ff 75 e8             	pushl  -0x18(%ebp)
  801f04:	8d 45 14             	lea    0x14(%ebp),%eax
  801f07:	50                   	push   %eax
  801f08:	e8 84 fc ff ff       	call   801b91 <getuint>
  801f0d:	83 c4 10             	add    $0x10,%esp
  801f10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f13:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801f16:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801f1d:	e9 98 00 00 00       	jmp    801fba <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801f22:	83 ec 08             	sub    $0x8,%esp
  801f25:	ff 75 0c             	pushl  0xc(%ebp)
  801f28:	6a 58                	push   $0x58
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	ff d0                	call   *%eax
  801f2f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801f32:	83 ec 08             	sub    $0x8,%esp
  801f35:	ff 75 0c             	pushl  0xc(%ebp)
  801f38:	6a 58                	push   $0x58
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	ff d0                	call   *%eax
  801f3f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801f42:	83 ec 08             	sub    $0x8,%esp
  801f45:	ff 75 0c             	pushl  0xc(%ebp)
  801f48:	6a 58                	push   $0x58
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	ff d0                	call   *%eax
  801f4f:	83 c4 10             	add    $0x10,%esp
			break;
  801f52:	e9 ce 00 00 00       	jmp    802025 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801f57:	83 ec 08             	sub    $0x8,%esp
  801f5a:	ff 75 0c             	pushl  0xc(%ebp)
  801f5d:	6a 30                	push   $0x30
  801f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f62:	ff d0                	call   *%eax
  801f64:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801f67:	83 ec 08             	sub    $0x8,%esp
  801f6a:	ff 75 0c             	pushl  0xc(%ebp)
  801f6d:	6a 78                	push   $0x78
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	ff d0                	call   *%eax
  801f74:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801f77:	8b 45 14             	mov    0x14(%ebp),%eax
  801f7a:	83 c0 04             	add    $0x4,%eax
  801f7d:	89 45 14             	mov    %eax,0x14(%ebp)
  801f80:	8b 45 14             	mov    0x14(%ebp),%eax
  801f83:	83 e8 04             	sub    $0x4,%eax
  801f86:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801f88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801f92:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801f99:	eb 1f                	jmp    801fba <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801f9b:	83 ec 08             	sub    $0x8,%esp
  801f9e:	ff 75 e8             	pushl  -0x18(%ebp)
  801fa1:	8d 45 14             	lea    0x14(%ebp),%eax
  801fa4:	50                   	push   %eax
  801fa5:	e8 e7 fb ff ff       	call   801b91 <getuint>
  801faa:	83 c4 10             	add    $0x10,%esp
  801fad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fb0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801fb3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801fba:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801fbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc1:	83 ec 04             	sub    $0x4,%esp
  801fc4:	52                   	push   %edx
  801fc5:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fc8:	50                   	push   %eax
  801fc9:	ff 75 f4             	pushl  -0xc(%ebp)
  801fcc:	ff 75 f0             	pushl  -0x10(%ebp)
  801fcf:	ff 75 0c             	pushl  0xc(%ebp)
  801fd2:	ff 75 08             	pushl  0x8(%ebp)
  801fd5:	e8 00 fb ff ff       	call   801ada <printnum>
  801fda:	83 c4 20             	add    $0x20,%esp
			break;
  801fdd:	eb 46                	jmp    802025 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801fdf:	83 ec 08             	sub    $0x8,%esp
  801fe2:	ff 75 0c             	pushl  0xc(%ebp)
  801fe5:	53                   	push   %ebx
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	ff d0                	call   *%eax
  801feb:	83 c4 10             	add    $0x10,%esp
			break;
  801fee:	eb 35                	jmp    802025 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801ff0:	c6 05 24 72 80 00 00 	movb   $0x0,0x807224
			break;
  801ff7:	eb 2c                	jmp    802025 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801ff9:	c6 05 24 72 80 00 01 	movb   $0x1,0x807224
			break;
  802000:	eb 23                	jmp    802025 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  802002:	83 ec 08             	sub    $0x8,%esp
  802005:	ff 75 0c             	pushl  0xc(%ebp)
  802008:	6a 25                	push   $0x25
  80200a:	8b 45 08             	mov    0x8(%ebp),%eax
  80200d:	ff d0                	call   *%eax
  80200f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  802012:	ff 4d 10             	decl   0x10(%ebp)
  802015:	eb 03                	jmp    80201a <vprintfmt+0x3c3>
  802017:	ff 4d 10             	decl   0x10(%ebp)
  80201a:	8b 45 10             	mov    0x10(%ebp),%eax
  80201d:	48                   	dec    %eax
  80201e:	8a 00                	mov    (%eax),%al
  802020:	3c 25                	cmp    $0x25,%al
  802022:	75 f3                	jne    802017 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  802024:	90                   	nop
		}
	}
  802025:	e9 35 fc ff ff       	jmp    801c5f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80202a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80202b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80202e:	5b                   	pop    %ebx
  80202f:	5e                   	pop    %esi
  802030:	5d                   	pop    %ebp
  802031:	c3                   	ret    

00802032 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802038:	8d 45 10             	lea    0x10(%ebp),%eax
  80203b:	83 c0 04             	add    $0x4,%eax
  80203e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  802041:	8b 45 10             	mov    0x10(%ebp),%eax
  802044:	ff 75 f4             	pushl  -0xc(%ebp)
  802047:	50                   	push   %eax
  802048:	ff 75 0c             	pushl  0xc(%ebp)
  80204b:	ff 75 08             	pushl  0x8(%ebp)
  80204e:	e8 04 fc ff ff       	call   801c57 <vprintfmt>
  802053:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  802056:	90                   	nop
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80205c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205f:	8b 40 08             	mov    0x8(%eax),%eax
  802062:	8d 50 01             	lea    0x1(%eax),%edx
  802065:	8b 45 0c             	mov    0xc(%ebp),%eax
  802068:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80206b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206e:	8b 10                	mov    (%eax),%edx
  802070:	8b 45 0c             	mov    0xc(%ebp),%eax
  802073:	8b 40 04             	mov    0x4(%eax),%eax
  802076:	39 c2                	cmp    %eax,%edx
  802078:	73 12                	jae    80208c <sprintputch+0x33>
		*b->buf++ = ch;
  80207a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207d:	8b 00                	mov    (%eax),%eax
  80207f:	8d 48 01             	lea    0x1(%eax),%ecx
  802082:	8b 55 0c             	mov    0xc(%ebp),%edx
  802085:	89 0a                	mov    %ecx,(%edx)
  802087:	8b 55 08             	mov    0x8(%ebp),%edx
  80208a:	88 10                	mov    %dl,(%eax)
}
  80208c:	90                   	nop
  80208d:	5d                   	pop    %ebp
  80208e:	c3                   	ret    

0080208f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
  802092:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80209b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209e:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	01 d0                	add    %edx,%eax
  8020a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8020b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b4:	74 06                	je     8020bc <vsnprintf+0x2d>
  8020b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020ba:	7f 07                	jg     8020c3 <vsnprintf+0x34>
		return -E_INVAL;
  8020bc:	b8 03 00 00 00       	mov    $0x3,%eax
  8020c1:	eb 20                	jmp    8020e3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8020c3:	ff 75 14             	pushl  0x14(%ebp)
  8020c6:	ff 75 10             	pushl  0x10(%ebp)
  8020c9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8020cc:	50                   	push   %eax
  8020cd:	68 59 20 80 00       	push   $0x802059
  8020d2:	e8 80 fb ff ff       	call   801c57 <vprintfmt>
  8020d7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8020da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020dd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8020eb:	8d 45 10             	lea    0x10(%ebp),%eax
  8020ee:	83 c0 04             	add    $0x4,%eax
  8020f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8020f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8020fa:	50                   	push   %eax
  8020fb:	ff 75 0c             	pushl  0xc(%ebp)
  8020fe:	ff 75 08             	pushl  0x8(%ebp)
  802101:	e8 89 ff ff ff       	call   80208f <vsnprintf>
  802106:	83 c4 10             	add    $0x10,%esp
  802109:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80210c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802117:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80211e:	eb 06                	jmp    802126 <strlen+0x15>
		n++;
  802120:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802123:	ff 45 08             	incl   0x8(%ebp)
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	8a 00                	mov    (%eax),%al
  80212b:	84 c0                	test   %al,%al
  80212d:	75 f1                	jne    802120 <strlen+0xf>
		n++;
	return n;
  80212f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80213a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802141:	eb 09                	jmp    80214c <strnlen+0x18>
		n++;
  802143:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802146:	ff 45 08             	incl   0x8(%ebp)
  802149:	ff 4d 0c             	decl   0xc(%ebp)
  80214c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802150:	74 09                	je     80215b <strnlen+0x27>
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	8a 00                	mov    (%eax),%al
  802157:	84 c0                	test   %al,%al
  802159:	75 e8                	jne    802143 <strnlen+0xf>
		n++;
	return n;
  80215b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80216c:	90                   	nop
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	8d 50 01             	lea    0x1(%eax),%edx
  802173:	89 55 08             	mov    %edx,0x8(%ebp)
  802176:	8b 55 0c             	mov    0xc(%ebp),%edx
  802179:	8d 4a 01             	lea    0x1(%edx),%ecx
  80217c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80217f:	8a 12                	mov    (%edx),%dl
  802181:	88 10                	mov    %dl,(%eax)
  802183:	8a 00                	mov    (%eax),%al
  802185:	84 c0                	test   %al,%al
  802187:	75 e4                	jne    80216d <strcpy+0xd>
		/* do nothing */;
	return ret;
  802189:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80219a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021a1:	eb 1f                	jmp    8021c2 <strncpy+0x34>
		*dst++ = *src;
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8d 50 01             	lea    0x1(%eax),%edx
  8021a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8021ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021af:	8a 12                	mov    (%edx),%dl
  8021b1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8021b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b6:	8a 00                	mov    (%eax),%al
  8021b8:	84 c0                	test   %al,%al
  8021ba:	74 03                	je     8021bf <strncpy+0x31>
			src++;
  8021bc:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8021bf:	ff 45 fc             	incl   -0x4(%ebp)
  8021c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021c8:	72 d9                	jb     8021a3 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8021ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8021db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021df:	74 30                	je     802211 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8021e1:	eb 16                	jmp    8021f9 <strlcpy+0x2a>
			*dst++ = *src++;
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	8d 50 01             	lea    0x1(%eax),%edx
  8021e9:	89 55 08             	mov    %edx,0x8(%ebp)
  8021ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ef:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021f2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8021f5:	8a 12                	mov    (%edx),%dl
  8021f7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8021f9:	ff 4d 10             	decl   0x10(%ebp)
  8021fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802200:	74 09                	je     80220b <strlcpy+0x3c>
  802202:	8b 45 0c             	mov    0xc(%ebp),%eax
  802205:	8a 00                	mov    (%eax),%al
  802207:	84 c0                	test   %al,%al
  802209:	75 d8                	jne    8021e3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  802211:	8b 55 08             	mov    0x8(%ebp),%edx
  802214:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802217:	29 c2                	sub    %eax,%edx
  802219:	89 d0                	mov    %edx,%eax
}
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    

0080221d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802220:	eb 06                	jmp    802228 <strcmp+0xb>
		p++, q++;
  802222:	ff 45 08             	incl   0x8(%ebp)
  802225:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	8a 00                	mov    (%eax),%al
  80222d:	84 c0                	test   %al,%al
  80222f:	74 0e                	je     80223f <strcmp+0x22>
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	8a 10                	mov    (%eax),%dl
  802236:	8b 45 0c             	mov    0xc(%ebp),%eax
  802239:	8a 00                	mov    (%eax),%al
  80223b:	38 c2                	cmp    %al,%dl
  80223d:	74 e3                	je     802222 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	8a 00                	mov    (%eax),%al
  802244:	0f b6 d0             	movzbl %al,%edx
  802247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224a:	8a 00                	mov    (%eax),%al
  80224c:	0f b6 c0             	movzbl %al,%eax
  80224f:	29 c2                	sub    %eax,%edx
  802251:	89 d0                	mov    %edx,%eax
}
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    

00802255 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802258:	eb 09                	jmp    802263 <strncmp+0xe>
		n--, p++, q++;
  80225a:	ff 4d 10             	decl   0x10(%ebp)
  80225d:	ff 45 08             	incl   0x8(%ebp)
  802260:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802263:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802267:	74 17                	je     802280 <strncmp+0x2b>
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	8a 00                	mov    (%eax),%al
  80226e:	84 c0                	test   %al,%al
  802270:	74 0e                	je     802280 <strncmp+0x2b>
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	8a 10                	mov    (%eax),%dl
  802277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227a:	8a 00                	mov    (%eax),%al
  80227c:	38 c2                	cmp    %al,%dl
  80227e:	74 da                	je     80225a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802280:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802284:	75 07                	jne    80228d <strncmp+0x38>
		return 0;
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
  80228b:	eb 14                	jmp    8022a1 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	8a 00                	mov    (%eax),%al
  802292:	0f b6 d0             	movzbl %al,%edx
  802295:	8b 45 0c             	mov    0xc(%ebp),%eax
  802298:	8a 00                	mov    (%eax),%al
  80229a:	0f b6 c0             	movzbl %al,%eax
  80229d:	29 c2                	sub    %eax,%edx
  80229f:	89 d0                	mov    %edx,%eax
}
  8022a1:	5d                   	pop    %ebp
  8022a2:	c3                   	ret    

008022a3 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8022a3:	55                   	push   %ebp
  8022a4:	89 e5                	mov    %esp,%ebp
  8022a6:	83 ec 04             	sub    $0x4,%esp
  8022a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8022af:	eb 12                	jmp    8022c3 <strchr+0x20>
		if (*s == c)
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	8a 00                	mov    (%eax),%al
  8022b6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8022b9:	75 05                	jne    8022c0 <strchr+0x1d>
			return (char *) s;
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	eb 11                	jmp    8022d1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8022c0:	ff 45 08             	incl   0x8(%ebp)
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	8a 00                	mov    (%eax),%al
  8022c8:	84 c0                	test   %al,%al
  8022ca:	75 e5                	jne    8022b1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8022cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    

008022d3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	83 ec 04             	sub    $0x4,%esp
  8022d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8022df:	eb 0d                	jmp    8022ee <strfind+0x1b>
		if (*s == c)
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	8a 00                	mov    (%eax),%al
  8022e6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8022e9:	74 0e                	je     8022f9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8022eb:	ff 45 08             	incl   0x8(%ebp)
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	8a 00                	mov    (%eax),%al
  8022f3:	84 c0                	test   %al,%al
  8022f5:	75 ea                	jne    8022e1 <strfind+0xe>
  8022f7:	eb 01                	jmp    8022fa <strfind+0x27>
		if (*s == c)
			break;
  8022f9:	90                   	nop
	return (char *) s;
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  80230b:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  80230f:	76 63                	jbe    802374 <memset+0x75>
		uint64 data_block = c;
  802311:	8b 45 0c             	mov    0xc(%ebp),%eax
  802314:	99                   	cltd   
  802315:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802318:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  80231b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802321:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  802325:	c1 e0 08             	shl    $0x8,%eax
  802328:	09 45 f0             	or     %eax,-0x10(%ebp)
  80232b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80232e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802334:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  802338:	c1 e0 10             	shl    $0x10,%eax
  80233b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80233e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  802341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802344:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802347:	89 c2                	mov    %eax,%edx
  802349:	b8 00 00 00 00       	mov    $0x0,%eax
  80234e:	09 45 f0             	or     %eax,-0x10(%ebp)
  802351:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  802354:	eb 18                	jmp    80236e <memset+0x6f>
			*p64++ = data_block, n -= 8;
  802356:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802359:	8d 41 08             	lea    0x8(%ecx),%eax
  80235c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80235f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802362:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802365:	89 01                	mov    %eax,(%ecx)
  802367:	89 51 04             	mov    %edx,0x4(%ecx)
  80236a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80236e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  802372:	77 e2                	ja     802356 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  802374:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802378:	74 23                	je     80239d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80237a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80237d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  802380:	eb 0e                	jmp    802390 <memset+0x91>
			*p8++ = (uint8)c;
  802382:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802385:	8d 50 01             	lea    0x1(%eax),%edx
  802388:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80238b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  802390:	8b 45 10             	mov    0x10(%ebp),%eax
  802393:	8d 50 ff             	lea    -0x1(%eax),%edx
  802396:	89 55 10             	mov    %edx,0x10(%ebp)
  802399:	85 c0                	test   %eax,%eax
  80239b:	75 e5                	jne    802382 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
  8023a5:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  8023a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  8023b4:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8023b8:	76 24                	jbe    8023de <memcpy+0x3c>
		while(n >= 8){
  8023ba:	eb 1c                	jmp    8023d8 <memcpy+0x36>
			*d64 = *s64;
  8023bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023bf:	8b 50 04             	mov    0x4(%eax),%edx
  8023c2:	8b 00                	mov    (%eax),%eax
  8023c4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8023c7:	89 01                	mov    %eax,(%ecx)
  8023c9:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8023cc:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8023d0:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8023d4:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8023d8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8023dc:	77 de                	ja     8023bc <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8023de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023e2:	74 31                	je     802415 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8023e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8023ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8023f0:	eb 16                	jmp    802408 <memcpy+0x66>
			*d8++ = *s8++;
  8023f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f5:	8d 50 01             	lea    0x1(%eax),%edx
  8023f8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8023fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  802401:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802404:	8a 12                	mov    (%edx),%dl
  802406:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802408:	8b 45 10             	mov    0x10(%ebp),%eax
  80240b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80240e:	89 55 10             	mov    %edx,0x10(%ebp)
  802411:	85 c0                	test   %eax,%eax
  802413:	75 dd                	jne    8023f2 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802420:	8b 45 0c             	mov    0xc(%ebp),%eax
  802423:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80242c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80242f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802432:	73 50                	jae    802484 <memmove+0x6a>
  802434:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802437:	8b 45 10             	mov    0x10(%ebp),%eax
  80243a:	01 d0                	add    %edx,%eax
  80243c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80243f:	76 43                	jbe    802484 <memmove+0x6a>
		s += n;
  802441:	8b 45 10             	mov    0x10(%ebp),%eax
  802444:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802447:	8b 45 10             	mov    0x10(%ebp),%eax
  80244a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80244d:	eb 10                	jmp    80245f <memmove+0x45>
			*--d = *--s;
  80244f:	ff 4d f8             	decl   -0x8(%ebp)
  802452:	ff 4d fc             	decl   -0x4(%ebp)
  802455:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802458:	8a 10                	mov    (%eax),%dl
  80245a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80245d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80245f:	8b 45 10             	mov    0x10(%ebp),%eax
  802462:	8d 50 ff             	lea    -0x1(%eax),%edx
  802465:	89 55 10             	mov    %edx,0x10(%ebp)
  802468:	85 c0                	test   %eax,%eax
  80246a:	75 e3                	jne    80244f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80246c:	eb 23                	jmp    802491 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80246e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802471:	8d 50 01             	lea    0x1(%eax),%edx
  802474:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802477:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80247a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80247d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802480:	8a 12                	mov    (%edx),%dl
  802482:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802484:	8b 45 10             	mov    0x10(%ebp),%eax
  802487:	8d 50 ff             	lea    -0x1(%eax),%edx
  80248a:	89 55 10             	mov    %edx,0x10(%ebp)
  80248d:	85 c0                	test   %eax,%eax
  80248f:	75 dd                	jne    80246e <memmove+0x54>
			*d++ = *s++;

	return dst;
  802491:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80249c:	8b 45 08             	mov    0x8(%ebp),%eax
  80249f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8024a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8024a8:	eb 2a                	jmp    8024d4 <memcmp+0x3e>
		if (*s1 != *s2)
  8024aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024ad:	8a 10                	mov    (%eax),%dl
  8024af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024b2:	8a 00                	mov    (%eax),%al
  8024b4:	38 c2                	cmp    %al,%dl
  8024b6:	74 16                	je     8024ce <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8024b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024bb:	8a 00                	mov    (%eax),%al
  8024bd:	0f b6 d0             	movzbl %al,%edx
  8024c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024c3:	8a 00                	mov    (%eax),%al
  8024c5:	0f b6 c0             	movzbl %al,%eax
  8024c8:	29 c2                	sub    %eax,%edx
  8024ca:	89 d0                	mov    %edx,%eax
  8024cc:	eb 18                	jmp    8024e6 <memcmp+0x50>
		s1++, s2++;
  8024ce:	ff 45 fc             	incl   -0x4(%ebp)
  8024d1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8024d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8024da:	89 55 10             	mov    %edx,0x10(%ebp)
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	75 c9                	jne    8024aa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e6:	c9                   	leave  
  8024e7:	c3                   	ret    

008024e8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8024e8:	55                   	push   %ebp
  8024e9:	89 e5                	mov    %esp,%ebp
  8024eb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8024ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f4:	01 d0                	add    %edx,%eax
  8024f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8024f9:	eb 15                	jmp    802510 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8024fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fe:	8a 00                	mov    (%eax),%al
  802500:	0f b6 d0             	movzbl %al,%edx
  802503:	8b 45 0c             	mov    0xc(%ebp),%eax
  802506:	0f b6 c0             	movzbl %al,%eax
  802509:	39 c2                	cmp    %eax,%edx
  80250b:	74 0d                	je     80251a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80250d:	ff 45 08             	incl   0x8(%ebp)
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802516:	72 e3                	jb     8024fb <memfind+0x13>
  802518:	eb 01                	jmp    80251b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80251a:	90                   	nop
	return (void *) s;
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80251e:	c9                   	leave  
  80251f:	c3                   	ret    

00802520 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
  802523:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802526:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80252d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802534:	eb 03                	jmp    802539 <strtol+0x19>
		s++;
  802536:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802539:	8b 45 08             	mov    0x8(%ebp),%eax
  80253c:	8a 00                	mov    (%eax),%al
  80253e:	3c 20                	cmp    $0x20,%al
  802540:	74 f4                	je     802536 <strtol+0x16>
  802542:	8b 45 08             	mov    0x8(%ebp),%eax
  802545:	8a 00                	mov    (%eax),%al
  802547:	3c 09                	cmp    $0x9,%al
  802549:	74 eb                	je     802536 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	8a 00                	mov    (%eax),%al
  802550:	3c 2b                	cmp    $0x2b,%al
  802552:	75 05                	jne    802559 <strtol+0x39>
		s++;
  802554:	ff 45 08             	incl   0x8(%ebp)
  802557:	eb 13                	jmp    80256c <strtol+0x4c>
	else if (*s == '-')
  802559:	8b 45 08             	mov    0x8(%ebp),%eax
  80255c:	8a 00                	mov    (%eax),%al
  80255e:	3c 2d                	cmp    $0x2d,%al
  802560:	75 0a                	jne    80256c <strtol+0x4c>
		s++, neg = 1;
  802562:	ff 45 08             	incl   0x8(%ebp)
  802565:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80256c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802570:	74 06                	je     802578 <strtol+0x58>
  802572:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802576:	75 20                	jne    802598 <strtol+0x78>
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	8a 00                	mov    (%eax),%al
  80257d:	3c 30                	cmp    $0x30,%al
  80257f:	75 17                	jne    802598 <strtol+0x78>
  802581:	8b 45 08             	mov    0x8(%ebp),%eax
  802584:	40                   	inc    %eax
  802585:	8a 00                	mov    (%eax),%al
  802587:	3c 78                	cmp    $0x78,%al
  802589:	75 0d                	jne    802598 <strtol+0x78>
		s += 2, base = 16;
  80258b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80258f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802596:	eb 28                	jmp    8025c0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802598:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80259c:	75 15                	jne    8025b3 <strtol+0x93>
  80259e:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a1:	8a 00                	mov    (%eax),%al
  8025a3:	3c 30                	cmp    $0x30,%al
  8025a5:	75 0c                	jne    8025b3 <strtol+0x93>
		s++, base = 8;
  8025a7:	ff 45 08             	incl   0x8(%ebp)
  8025aa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8025b1:	eb 0d                	jmp    8025c0 <strtol+0xa0>
	else if (base == 0)
  8025b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025b7:	75 07                	jne    8025c0 <strtol+0xa0>
		base = 10;
  8025b9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8025c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c3:	8a 00                	mov    (%eax),%al
  8025c5:	3c 2f                	cmp    $0x2f,%al
  8025c7:	7e 19                	jle    8025e2 <strtol+0xc2>
  8025c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cc:	8a 00                	mov    (%eax),%al
  8025ce:	3c 39                	cmp    $0x39,%al
  8025d0:	7f 10                	jg     8025e2 <strtol+0xc2>
			dig = *s - '0';
  8025d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d5:	8a 00                	mov    (%eax),%al
  8025d7:	0f be c0             	movsbl %al,%eax
  8025da:	83 e8 30             	sub    $0x30,%eax
  8025dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e0:	eb 42                	jmp    802624 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8025e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e5:	8a 00                	mov    (%eax),%al
  8025e7:	3c 60                	cmp    $0x60,%al
  8025e9:	7e 19                	jle    802604 <strtol+0xe4>
  8025eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ee:	8a 00                	mov    (%eax),%al
  8025f0:	3c 7a                	cmp    $0x7a,%al
  8025f2:	7f 10                	jg     802604 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	8a 00                	mov    (%eax),%al
  8025f9:	0f be c0             	movsbl %al,%eax
  8025fc:	83 e8 57             	sub    $0x57,%eax
  8025ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802602:	eb 20                	jmp    802624 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802604:	8b 45 08             	mov    0x8(%ebp),%eax
  802607:	8a 00                	mov    (%eax),%al
  802609:	3c 40                	cmp    $0x40,%al
  80260b:	7e 39                	jle    802646 <strtol+0x126>
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	8a 00                	mov    (%eax),%al
  802612:	3c 5a                	cmp    $0x5a,%al
  802614:	7f 30                	jg     802646 <strtol+0x126>
			dig = *s - 'A' + 10;
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	8a 00                	mov    (%eax),%al
  80261b:	0f be c0             	movsbl %al,%eax
  80261e:	83 e8 37             	sub    $0x37,%eax
  802621:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	3b 45 10             	cmp    0x10(%ebp),%eax
  80262a:	7d 19                	jge    802645 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80262c:	ff 45 08             	incl   0x8(%ebp)
  80262f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802632:	0f af 45 10          	imul   0x10(%ebp),%eax
  802636:	89 c2                	mov    %eax,%edx
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	01 d0                	add    %edx,%eax
  80263d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802640:	e9 7b ff ff ff       	jmp    8025c0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802645:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802646:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80264a:	74 08                	je     802654 <strtol+0x134>
		*endptr = (char *) s;
  80264c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80264f:	8b 55 08             	mov    0x8(%ebp),%edx
  802652:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802654:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802658:	74 07                	je     802661 <strtol+0x141>
  80265a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80265d:	f7 d8                	neg    %eax
  80265f:	eb 03                	jmp    802664 <strtol+0x144>
  802661:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <ltostr>:

void
ltostr(long value, char *str)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80266c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802673:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80267a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80267e:	79 13                	jns    802693 <ltostr+0x2d>
	{
		neg = 1;
  802680:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80268a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80268d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802690:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802693:	8b 45 08             	mov    0x8(%ebp),%eax
  802696:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80269b:	99                   	cltd   
  80269c:	f7 f9                	idiv   %ecx
  80269e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8026a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026a4:	8d 50 01             	lea    0x1(%eax),%edx
  8026a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8026aa:	89 c2                	mov    %eax,%edx
  8026ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026af:	01 d0                	add    %edx,%eax
  8026b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b4:	83 c2 30             	add    $0x30,%edx
  8026b7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8026b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8026c1:	f7 e9                	imul   %ecx
  8026c3:	c1 fa 02             	sar    $0x2,%edx
  8026c6:	89 c8                	mov    %ecx,%eax
  8026c8:	c1 f8 1f             	sar    $0x1f,%eax
  8026cb:	29 c2                	sub    %eax,%edx
  8026cd:	89 d0                	mov    %edx,%eax
  8026cf:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8026d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026d6:	75 bb                	jne    802693 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8026d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8026df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026e2:	48                   	dec    %eax
  8026e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8026e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8026ea:	74 3d                	je     802729 <ltostr+0xc3>
		start = 1 ;
  8026ec:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8026f3:	eb 34                	jmp    802729 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8026f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026fb:	01 d0                	add    %edx,%eax
  8026fd:	8a 00                	mov    (%eax),%al
  8026ff:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802702:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802705:	8b 45 0c             	mov    0xc(%ebp),%eax
  802708:	01 c2                	add    %eax,%edx
  80270a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80270d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802710:	01 c8                	add    %ecx,%eax
  802712:	8a 00                	mov    (%eax),%al
  802714:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802716:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802719:	8b 45 0c             	mov    0xc(%ebp),%eax
  80271c:	01 c2                	add    %eax,%edx
  80271e:	8a 45 eb             	mov    -0x15(%ebp),%al
  802721:	88 02                	mov    %al,(%edx)
		start++ ;
  802723:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802726:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80272f:	7c c4                	jl     8026f5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802731:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802734:	8b 45 0c             	mov    0xc(%ebp),%eax
  802737:	01 d0                	add    %edx,%eax
  802739:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80273c:	90                   	nop
  80273d:	c9                   	leave  
  80273e:	c3                   	ret    

0080273f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80273f:	55                   	push   %ebp
  802740:	89 e5                	mov    %esp,%ebp
  802742:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802745:	ff 75 08             	pushl  0x8(%ebp)
  802748:	e8 c4 f9 ff ff       	call   802111 <strlen>
  80274d:	83 c4 04             	add    $0x4,%esp
  802750:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802753:	ff 75 0c             	pushl  0xc(%ebp)
  802756:	e8 b6 f9 ff ff       	call   802111 <strlen>
  80275b:	83 c4 04             	add    $0x4,%esp
  80275e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802761:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80276f:	eb 17                	jmp    802788 <strcconcat+0x49>
		final[s] = str1[s] ;
  802771:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802774:	8b 45 10             	mov    0x10(%ebp),%eax
  802777:	01 c2                	add    %eax,%edx
  802779:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80277c:	8b 45 08             	mov    0x8(%ebp),%eax
  80277f:	01 c8                	add    %ecx,%eax
  802781:	8a 00                	mov    (%eax),%al
  802783:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802785:	ff 45 fc             	incl   -0x4(%ebp)
  802788:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80278b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80278e:	7c e1                	jl     802771 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  802790:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802797:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80279e:	eb 1f                	jmp    8027bf <strcconcat+0x80>
		final[s++] = str2[i] ;
  8027a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027a3:	8d 50 01             	lea    0x1(%eax),%edx
  8027a6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8027a9:	89 c2                	mov    %eax,%edx
  8027ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8027ae:	01 c2                	add    %eax,%edx
  8027b0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8027b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b6:	01 c8                	add    %ecx,%eax
  8027b8:	8a 00                	mov    (%eax),%al
  8027ba:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8027bc:	ff 45 f8             	incl   -0x8(%ebp)
  8027bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8027c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027c5:	7c d9                	jl     8027a0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8027c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8027ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8027cd:	01 d0                	add    %edx,%eax
  8027cf:	c6 00 00             	movb   $0x0,(%eax)
}
  8027d2:	90                   	nop
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    

008027d5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8027d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8027db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8027e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8027e4:	8b 00                	mov    (%eax),%eax
  8027e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8027ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8027f0:	01 d0                	add    %edx,%eax
  8027f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8027f8:	eb 0c                	jmp    802806 <strsplit+0x31>
			*string++ = 0;
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	8d 50 01             	lea    0x1(%eax),%edx
  802800:	89 55 08             	mov    %edx,0x8(%ebp)
  802803:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	8a 00                	mov    (%eax),%al
  80280b:	84 c0                	test   %al,%al
  80280d:	74 18                	je     802827 <strsplit+0x52>
  80280f:	8b 45 08             	mov    0x8(%ebp),%eax
  802812:	8a 00                	mov    (%eax),%al
  802814:	0f be c0             	movsbl %al,%eax
  802817:	50                   	push   %eax
  802818:	ff 75 0c             	pushl  0xc(%ebp)
  80281b:	e8 83 fa ff ff       	call   8022a3 <strchr>
  802820:	83 c4 08             	add    $0x8,%esp
  802823:	85 c0                	test   %eax,%eax
  802825:	75 d3                	jne    8027fa <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802827:	8b 45 08             	mov    0x8(%ebp),%eax
  80282a:	8a 00                	mov    (%eax),%al
  80282c:	84 c0                	test   %al,%al
  80282e:	74 5a                	je     80288a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802830:	8b 45 14             	mov    0x14(%ebp),%eax
  802833:	8b 00                	mov    (%eax),%eax
  802835:	83 f8 0f             	cmp    $0xf,%eax
  802838:	75 07                	jne    802841 <strsplit+0x6c>
		{
			return 0;
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	eb 66                	jmp    8028a7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802841:	8b 45 14             	mov    0x14(%ebp),%eax
  802844:	8b 00                	mov    (%eax),%eax
  802846:	8d 48 01             	lea    0x1(%eax),%ecx
  802849:	8b 55 14             	mov    0x14(%ebp),%edx
  80284c:	89 0a                	mov    %ecx,(%edx)
  80284e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802855:	8b 45 10             	mov    0x10(%ebp),%eax
  802858:	01 c2                	add    %eax,%edx
  80285a:	8b 45 08             	mov    0x8(%ebp),%eax
  80285d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80285f:	eb 03                	jmp    802864 <strsplit+0x8f>
			string++;
  802861:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	8a 00                	mov    (%eax),%al
  802869:	84 c0                	test   %al,%al
  80286b:	74 8b                	je     8027f8 <strsplit+0x23>
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	8a 00                	mov    (%eax),%al
  802872:	0f be c0             	movsbl %al,%eax
  802875:	50                   	push   %eax
  802876:	ff 75 0c             	pushl  0xc(%ebp)
  802879:	e8 25 fa ff ff       	call   8022a3 <strchr>
  80287e:	83 c4 08             	add    $0x8,%esp
  802881:	85 c0                	test   %eax,%eax
  802883:	74 dc                	je     802861 <strsplit+0x8c>
			string++;
	}
  802885:	e9 6e ff ff ff       	jmp    8027f8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80288a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80288b:	8b 45 14             	mov    0x14(%ebp),%eax
  80288e:	8b 00                	mov    (%eax),%eax
  802890:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802897:	8b 45 10             	mov    0x10(%ebp),%eax
  80289a:	01 d0                	add    %edx,%eax
  80289c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8028a2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8028a7:	c9                   	leave  
  8028a8:	c3                   	ret    

008028a9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8028a9:	55                   	push   %ebp
  8028aa:	89 e5                	mov    %esp,%ebp
  8028ac:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8028af:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8028b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8028bc:	eb 4a                	jmp    802908 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8028be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	01 c2                	add    %eax,%edx
  8028c6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8028c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028cc:	01 c8                	add    %ecx,%eax
  8028ce:	8a 00                	mov    (%eax),%al
  8028d0:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8028d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028d8:	01 d0                	add    %edx,%eax
  8028da:	8a 00                	mov    (%eax),%al
  8028dc:	3c 40                	cmp    $0x40,%al
  8028de:	7e 25                	jle    802905 <str2lower+0x5c>
  8028e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028e6:	01 d0                	add    %edx,%eax
  8028e8:	8a 00                	mov    (%eax),%al
  8028ea:	3c 5a                	cmp    $0x5a,%al
  8028ec:	7f 17                	jg     802905 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  8028ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	01 d0                	add    %edx,%eax
  8028f6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8028f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028fc:	01 ca                	add    %ecx,%edx
  8028fe:	8a 12                	mov    (%edx),%dl
  802900:	83 c2 20             	add    $0x20,%edx
  802903:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802905:	ff 45 fc             	incl   -0x4(%ebp)
  802908:	ff 75 0c             	pushl  0xc(%ebp)
  80290b:	e8 01 f8 ff ff       	call   802111 <strlen>
  802910:	83 c4 04             	add    $0x4,%esp
  802913:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802916:	7f a6                	jg     8028be <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802918:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80291b:	c9                   	leave  
  80291c:	c3                   	ret    

0080291d <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80291d:	55                   	push   %ebp
  80291e:	89 e5                	mov    %esp,%ebp
  802920:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802923:	a1 08 70 80 00       	mov    0x807008,%eax
  802928:	85 c0                	test   %eax,%eax
  80292a:	0f 84 95 00 00 00    	je     8029c5 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  802930:	83 ec 08             	sub    $0x8,%esp
  802933:	68 00 00 00 82       	push   $0x82000000
  802938:	68 00 00 00 80       	push   $0x80000000
  80293d:	e8 59 1f 00 00       	call   80489b <initialize_dynamic_allocator>
  802942:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802945:	e8 93 1d 00 00       	call   8046dd <sys_get_uheap_strategy>
  80294a:	a3 44 f2 81 00       	mov    %eax,0x81f244
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80294f:	a1 20 72 80 00       	mov    0x807220,%eax
  802954:	05 00 10 00 00       	add    $0x1000,%eax
  802959:	a3 f0 f2 81 00       	mov    %eax,0x81f2f0
		uheapPageAllocBreak = uheapPageAllocStart;
  80295e:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802963:	a3 50 f2 81 00       	mov    %eax,0x81f250
		init_uspinlock(&ulock,"malloc",1);
  802968:	83 ec 04             	sub    $0x4,%esp
  80296b:	6a 01                	push   $0x1
  80296d:	68 88 66 80 00       	push   $0x806688
  802972:	68 20 f3 81 00       	push   $0x81f320
  802977:	e8 1a 29 00 00       	call   805296 <init_uspinlock>
  80297c:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  80297f:	c7 05 00 f3 81 00 00 	movl   $0x0,0x81f300
  802986:	00 00 00 
  802989:	c7 05 04 f3 81 00 00 	movl   $0x0,0x81f304
  802990:	00 00 00 
  802993:	c7 05 0c f3 81 00 00 	movl   $0x0,0x81f30c
  80299a:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  80299d:	c7 05 10 f3 81 00 00 	movl   $0x0,0x81f310
  8029a4:	00 00 00 
  8029a7:	c7 05 14 f3 81 00 00 	movl   $0x0,0x81f314
  8029ae:	00 00 00 
  8029b1:	c7 05 1c f3 81 00 00 	movl   $0x0,0x81f31c
  8029b8:	00 00 00 
		__firstTimeFlag = 0;
  8029bb:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  8029c2:	00 00 00 
	}
}
  8029c5:	90                   	nop
  8029c6:	c9                   	leave  
  8029c7:	c3                   	ret    

008029c8 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
  8029cb:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8029ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8029dc:	83 ec 08             	sub    $0x8,%esp
  8029df:	68 06 04 00 00       	push   $0x406
  8029e4:	50                   	push   %eax
  8029e5:	e8 3d 19 00 00       	call   804327 <__sys_allocate_page>
  8029ea:	83 c4 10             	add    $0x10,%esp
  8029ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  8029f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f4:	79 14                	jns    802a0a <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  8029f6:	83 ec 04             	sub    $0x4,%esp
  8029f9:	68 90 66 80 00       	push   $0x806690
  8029fe:	6a 2d                	push   $0x2d
  802a00:	68 cc 66 80 00       	push   $0x8066cc
  802a05:	e8 60 ed ff ff       	call   80176a <_panic>
	return 0;
  802a0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a0f:	c9                   	leave  
  802a10:	c3                   	ret    

00802a11 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  802a11:	55                   	push   %ebp
  802a12:	89 e5                	mov    %esp,%ebp
  802a14:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802a25:	83 ec 0c             	sub    $0xc,%esp
  802a28:	50                   	push   %eax
  802a29:	e8 40 19 00 00       	call   80436e <__sys_unmap_frame>
  802a2e:	83 c4 10             	add    $0x10,%esp
  802a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802a34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a38:	79 14                	jns    802a4e <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802a3a:	83 ec 04             	sub    $0x4,%esp
  802a3d:	68 d8 66 80 00       	push   $0x8066d8
  802a42:	6a 38                	push   $0x38
  802a44:	68 cc 66 80 00       	push   $0x8066cc
  802a49:	e8 1c ed ff ff       	call   80176a <_panic>
}
  802a4e:	90                   	nop
  802a4f:	c9                   	leave  
  802a50:	c3                   	ret    

00802a51 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  802a51:	55                   	push   %ebp
  802a52:	89 e5                	mov    %esp,%ebp
  802a54:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802a57:	e8 c1 fe ff ff       	call   80291d <uheap_init>
	if (size == 0) return NULL ;
  802a5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a60:	75 0a                	jne    802a6c <malloc+0x1b>
  802a62:	b8 00 00 00 00       	mov    $0x0,%eax
  802a67:	e9 e1 04 00 00       	jmp    802f4d <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  802a6c:	83 ec 0c             	sub    $0xc,%esp
  802a6f:	68 20 f3 81 00       	push   $0x81f320
  802a74:	e8 6c 28 00 00       	call   8052e5 <acquire_uspinlock>
  802a79:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  802a7c:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  802a83:	77 23                	ja     802aa8 <malloc+0x57>
		release_uspinlock(&ulock);
  802a85:	83 ec 0c             	sub    $0xc,%esp
  802a88:	68 20 f3 81 00       	push   $0x81f320
  802a8d:	e8 ab 28 00 00       	call   80533d <release_uspinlock>
  802a92:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  802a95:	83 ec 0c             	sub    $0xc,%esp
  802a98:	ff 75 08             	pushl  0x8(%ebp)
  802a9b:	e8 dd 1f 00 00       	call   804a7d <alloc_block>
  802aa0:	83 c4 10             	add    $0x10,%esp
  802aa3:	e9 a5 04 00 00       	jmp    802f4d <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802aa8:	83 ec 0c             	sub    $0xc,%esp
  802aab:	6a 10                	push   $0x10
  802aad:	e8 cb 1f 00 00       	call   804a7d <alloc_block>
  802ab2:	83 c4 10             	add    $0x10,%esp
  802ab5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  802ab8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802abc:	75 0a                	jne    802ac8 <malloc+0x77>
			return NULL;
  802abe:	b8 00 00 00 00       	mov    $0x0,%eax
  802ac3:	e9 85 04 00 00       	jmp    802f4d <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  802ac8:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802acf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad5:	01 d0                	add    %edx,%eax
  802ad7:	48                   	dec    %eax
  802ad8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802adb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ade:	ba 00 00 00 00       	mov    $0x0,%edx
  802ae3:	f7 75 e8             	divl   -0x18(%ebp)
  802ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae9:	29 d0                	sub    %edx,%eax
  802aeb:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802aee:	a1 04 f3 81 00       	mov    0x81f304,%eax
  802af3:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802af6:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802afb:	85 c0                	test   %eax,%eax
  802afd:	74 0f                	je     802b0e <malloc+0xbd>
  802aff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b02:	8b 40 04             	mov    0x4(%eax),%eax
  802b05:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b08:	0f 83 ea 00 00 00    	jae    802bf8 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  802b0e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802b13:	2b 45 08             	sub    0x8(%ebp),%eax
  802b16:	89 c2                	mov    %eax,%edx
  802b18:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802b1d:	39 c2                	cmp    %eax,%edx
  802b1f:	0f 86 b9 00 00 00    	jbe    802bde <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  802b25:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802b2a:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  802b2d:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  802b33:	8b 45 08             	mov    0x8(%ebp),%eax
  802b36:	01 d0                	add    %edx,%eax
  802b38:	a3 50 f2 81 00       	mov    %eax,0x81f250
					allocblock->startva = requestedblockva;
  802b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b40:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802b43:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b48:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4b:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802b4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b52:	75 14                	jne    802b68 <malloc+0x117>
  802b54:	83 ec 04             	sub    $0x4,%esp
  802b57:	68 18 67 80 00       	push   $0x806718
  802b5c:	6a 60                	push   $0x60
  802b5e:	68 cc 66 80 00       	push   $0x8066cc
  802b63:	e8 02 ec ff ff       	call   80176a <_panic>
  802b68:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b71:	89 50 0c             	mov    %edx,0xc(%eax)
  802b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b77:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7a:	85 c0                	test   %eax,%eax
  802b7c:	74 0d                	je     802b8b <malloc+0x13a>
  802b7e:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802b83:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b86:	89 50 08             	mov    %edx,0x8(%eax)
  802b89:	eb 08                	jmp    802b93 <malloc+0x142>
  802b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8e:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b96:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ba5:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802baa:	40                   	inc    %eax
  802bab:	a3 1c f3 81 00       	mov    %eax,0x81f31c


					sys_allocate_user_mem(allocblock->startva ,size);
  802bb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb3:	8b 00                	mov    (%eax),%eax
  802bb5:	83 ec 08             	sub    $0x8,%esp
  802bb8:	ff 75 08             	pushl  0x8(%ebp)
  802bbb:	50                   	push   %eax
  802bbc:	e8 34 1c 00 00       	call   8047f5 <sys_allocate_user_mem>
  802bc1:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  802bc4:	83 ec 0c             	sub    $0xc,%esp
  802bc7:	68 20 f3 81 00       	push   $0x81f320
  802bcc:	e8 6c 27 00 00       	call   80533d <release_uspinlock>
  802bd1:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd7:	8b 00                	mov    (%eax),%eax
  802bd9:	e9 6f 03 00 00       	jmp    802f4d <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  802bde:	83 ec 0c             	sub    $0xc,%esp
  802be1:	68 20 f3 81 00       	push   $0x81f320
  802be6:	e8 52 27 00 00       	call   80533d <release_uspinlock>
  802beb:	83 c4 10             	add    $0x10,%esp
					return NULL;
  802bee:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf3:	e9 55 03 00 00       	jmp    802f4d <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802bf8:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  802c00:	e9 39 03 00 00       	jmp    802f3e <malloc+0x4ed>
			if(size<currentfreeelement->size){
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 40 04             	mov    0x4(%eax),%eax
  802c0b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c0e:	0f 86 e7 01 00 00    	jbe    802dfb <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  802c14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c17:	8b 10                	mov    (%eax),%edx
  802c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1c:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  802c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c21:	8b 55 08             	mov    0x8(%ebp),%edx
  802c24:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802c27:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c2b:	75 14                	jne    802c41 <malloc+0x1f0>
  802c2d:	83 ec 04             	sub    $0x4,%esp
  802c30:	68 18 67 80 00       	push   $0x806718
  802c35:	6a 72                	push   $0x72
  802c37:	68 cc 66 80 00       	push   $0x8066cc
  802c3c:	e8 29 eb ff ff       	call   80176a <_panic>
  802c41:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802c47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4a:	89 50 0c             	mov    %edx,0xc(%eax)
  802c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c50:	8b 40 0c             	mov    0xc(%eax),%eax
  802c53:	85 c0                	test   %eax,%eax
  802c55:	74 0d                	je     802c64 <malloc+0x213>
  802c57:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802c5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c5f:	89 50 08             	mov    %edx,0x8(%eax)
  802c62:	eb 08                	jmp    802c6c <malloc+0x21b>
  802c64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c67:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6f:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c77:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c7e:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802c83:	40                   	inc    %eax
  802c84:	a3 1c f3 81 00       	mov    %eax,0x81f31c
                lastfreeelement->startva += size;
  802c89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c8c:	8b 10                	mov    (%eax),%edx
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	01 c2                	add    %eax,%edx
  802c93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c96:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  802c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9b:	8b 40 04             	mov    0x4(%eax),%eax
  802c9e:	2b 45 08             	sub    0x8(%ebp),%eax
  802ca1:	89 c2                	mov    %eax,%edx
  802ca3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca6:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802ca9:	a1 00 f3 81 00       	mov    0x81f300,%eax
  802cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  802cb1:	e9 0d 01 00 00       	jmp    802dc3 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  802cb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb9:	8b 50 04             	mov    0x4(%eax),%edx
  802cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbf:	8b 40 04             	mov    0x4(%eax),%eax
  802cc2:	39 c2                	cmp    %eax,%edx
  802cc4:	0f 83 f0 00 00 00    	jae    802dba <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802cca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802cce:	75 14                	jne    802ce4 <malloc+0x293>
  802cd0:	83 ec 04             	sub    $0x4,%esp
  802cd3:	68 3b 67 80 00       	push   $0x80673b
  802cd8:	6a 7a                	push   $0x7a
  802cda:	68 cc 66 80 00       	push   $0x8066cc
  802cdf:	e8 86 ea ff ff       	call   80176a <_panic>
  802ce4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ce7:	8b 40 08             	mov    0x8(%eax),%eax
  802cea:	85 c0                	test   %eax,%eax
  802cec:	74 11                	je     802cff <malloc+0x2ae>
  802cee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf1:	8b 40 08             	mov    0x8(%eax),%eax
  802cf4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cf7:	8b 52 0c             	mov    0xc(%edx),%edx
  802cfa:	89 50 0c             	mov    %edx,0xc(%eax)
  802cfd:	eb 0b                	jmp    802d0a <malloc+0x2b9>
  802cff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d02:	8b 40 0c             	mov    0xc(%eax),%eax
  802d05:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802d0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d10:	85 c0                	test   %eax,%eax
  802d12:	74 11                	je     802d25 <malloc+0x2d4>
  802d14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d17:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d1d:	8b 52 08             	mov    0x8(%edx),%edx
  802d20:	89 50 08             	mov    %edx,0x8(%eax)
  802d23:	eb 0b                	jmp    802d30 <malloc+0x2df>
  802d25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d28:	8b 40 08             	mov    0x8(%eax),%eax
  802d2b:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802d30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d33:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d3d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d44:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802d49:	48                   	dec    %eax
  802d4a:	a3 0c f3 81 00       	mov    %eax,0x81f30c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802d4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d53:	74 06                	je     802d5b <malloc+0x30a>
  802d55:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d59:	75 14                	jne    802d6f <malloc+0x31e>
  802d5b:	83 ec 04             	sub    $0x4,%esp
  802d5e:	68 5c 67 80 00       	push   $0x80675c
  802d63:	6a 7b                	push   $0x7b
  802d65:	68 cc 66 80 00       	push   $0x8066cc
  802d6a:	e8 fb e9 ff ff       	call   80176a <_panic>
  802d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d72:	8b 50 0c             	mov    0xc(%eax),%edx
  802d75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d78:	89 50 0c             	mov    %edx,0xc(%eax)
  802d7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d81:	89 50 08             	mov    %edx,0x8(%eax)
  802d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d87:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	74 0e                	je     802d9c <malloc+0x34b>
  802d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d91:	8b 40 0c             	mov    0xc(%eax),%eax
  802d94:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d97:	89 50 08             	mov    %edx,0x8(%eax)
  802d9a:	eb 08                	jmp    802da4 <malloc+0x353>
  802d9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d9f:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802daa:	89 50 0c             	mov    %edx,0xc(%eax)
  802dad:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802db2:	40                   	inc    %eax
  802db3:	a3 0c f3 81 00       	mov    %eax,0x81f30c
                		break;
  802db8:	eb 13                	jmp    802dcd <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  802dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbd:	8b 40 08             	mov    0x8(%eax),%eax
  802dc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  802dc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc7:	0f 85 e9 fe ff ff    	jne    802cb6 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  802dcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd0:	8b 00                	mov    (%eax),%eax
  802dd2:	83 ec 08             	sub    $0x8,%esp
  802dd5:	ff 75 08             	pushl  0x8(%ebp)
  802dd8:	50                   	push   %eax
  802dd9:	e8 17 1a 00 00       	call   8047f5 <sys_allocate_user_mem>
  802dde:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  802de1:	83 ec 0c             	sub    $0xc,%esp
  802de4:	68 20 f3 81 00       	push   $0x81f320
  802de9:	e8 4f 25 00 00       	call   80533d <release_uspinlock>
  802dee:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  802df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df4:	8b 00                	mov    (%eax),%eax
  802df6:	e9 52 01 00 00       	jmp    802f4d <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	8b 40 04             	mov    0x4(%eax),%eax
  802e01:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e04:	0f 85 2b 01 00 00    	jne    802f35 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 10                	mov    (%eax),%edx
  802e0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e12:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  802e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e17:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1a:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802e1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e21:	75 17                	jne    802e3a <malloc+0x3e9>
  802e23:	83 ec 04             	sub    $0x4,%esp
  802e26:	68 18 67 80 00       	push   $0x806718
  802e2b:	68 89 00 00 00       	push   $0x89
  802e30:	68 cc 66 80 00       	push   $0x8066cc
  802e35:	e8 30 e9 ff ff       	call   80176a <_panic>
  802e3a:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  802e40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e43:	89 50 0c             	mov    %edx,0xc(%eax)
  802e46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e49:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	74 0d                	je     802e5d <malloc+0x40c>
  802e50:	a1 14 f3 81 00       	mov    0x81f314,%eax
  802e55:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e58:	89 50 08             	mov    %edx,0x8(%eax)
  802e5b:	eb 08                	jmp    802e65 <malloc+0x414>
  802e5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e60:	a3 10 f3 81 00       	mov    %eax,0x81f310
  802e65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e68:	a3 14 f3 81 00       	mov    %eax,0x81f314
  802e6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e70:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e77:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  802e7c:	40                   	inc    %eax
  802e7d:	a3 1c f3 81 00       	mov    %eax,0x81f31c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  802e82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e86:	75 17                	jne    802e9f <malloc+0x44e>
  802e88:	83 ec 04             	sub    $0x4,%esp
  802e8b:	68 3b 67 80 00       	push   $0x80673b
  802e90:	68 8a 00 00 00       	push   $0x8a
  802e95:	68 cc 66 80 00       	push   $0x8066cc
  802e9a:	e8 cb e8 ff ff       	call   80176a <_panic>
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 40 08             	mov    0x8(%eax),%eax
  802ea5:	85 c0                	test   %eax,%eax
  802ea7:	74 11                	je     802eba <malloc+0x469>
  802ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eac:	8b 40 08             	mov    0x8(%eax),%eax
  802eaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb2:	8b 52 0c             	mov    0xc(%edx),%edx
  802eb5:	89 50 0c             	mov    %edx,0xc(%eax)
  802eb8:	eb 0b                	jmp    802ec5 <malloc+0x474>
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec0:	a3 04 f3 81 00       	mov    %eax,0x81f304
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecb:	85 c0                	test   %eax,%eax
  802ecd:	74 11                	je     802ee0 <malloc+0x48f>
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed8:	8b 52 08             	mov    0x8(%edx),%edx
  802edb:	89 50 08             	mov    %edx,0x8(%eax)
  802ede:	eb 0b                	jmp    802eeb <malloc+0x49a>
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	8b 40 08             	mov    0x8(%eax),%eax
  802ee6:	a3 00 f3 81 00       	mov    %eax,0x81f300
  802eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802eff:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  802f04:	48                   	dec    %eax
  802f05:	a3 0c f3 81 00       	mov    %eax,0x81f30c
				sys_allocate_user_mem(allocblock->startva ,size);
  802f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0d:	8b 00                	mov    (%eax),%eax
  802f0f:	83 ec 08             	sub    $0x8,%esp
  802f12:	ff 75 08             	pushl  0x8(%ebp)
  802f15:	50                   	push   %eax
  802f16:	e8 da 18 00 00       	call   8047f5 <sys_allocate_user_mem>
  802f1b:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  802f1e:	83 ec 0c             	sub    $0xc,%esp
  802f21:	68 20 f3 81 00       	push   $0x81f320
  802f26:	e8 12 24 00 00       	call   80533d <release_uspinlock>
  802f2b:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  802f2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f31:	8b 00                	mov    (%eax),%eax
  802f33:	eb 18                	jmp    802f4d <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	8b 40 08             	mov    0x8(%eax),%eax
  802f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  802f3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f42:	0f 85 bd fc ff ff    	jne    802c05 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  802f48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f4d:	c9                   	leave  
  802f4e:	c3                   	ret    

00802f4f <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802f4f:	55                   	push   %ebp
  802f50:	89 e5                	mov    %esp,%ebp
  802f52:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802f5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802f63:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  802f66:	e8 b2 f9 ff ff       	call   80291d <uheap_init>
		acquire_uspinlock(&ulock);
  802f6b:	83 ec 0c             	sub    $0xc,%esp
  802f6e:	68 20 f3 81 00       	push   $0x81f320
  802f73:	e8 6d 23 00 00       	call   8052e5 <acquire_uspinlock>
  802f78:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  802f7b:	a1 f0 f2 81 00       	mov    0x81f2f0,%eax
  802f80:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802f83:	73 23                	jae    802fa8 <free+0x59>
			free_block(virtual_address);
  802f85:	83 ec 0c             	sub    $0xc,%esp
  802f88:	ff 75 08             	pushl  0x8(%ebp)
  802f8b:	e8 89 1f 00 00       	call   804f19 <free_block>
  802f90:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  802f93:	83 ec 0c             	sub    $0xc,%esp
  802f96:	68 20 f3 81 00       	push   $0x81f320
  802f9b:	e8 9d 23 00 00       	call   80533d <release_uspinlock>
  802fa0:	83 c4 10             	add    $0x10,%esp
			return;
  802fa3:	e9 35 07 00 00       	jmp    8036dd <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  802fa8:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802fad:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802fb0:	72 30                	jb     802fe2 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  802fb2:	a1 50 f2 81 00       	mov    0x81f250,%eax
  802fb7:	83 ec 04             	sub    $0x4,%esp
  802fba:	50                   	push   %eax
  802fbb:	ff 75 d8             	pushl  -0x28(%ebp)
  802fbe:	68 91 67 80 00       	push   $0x806791
  802fc3:	e8 70 ea ff ff       	call   801a38 <cprintf>
  802fc8:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  802fcb:	83 ec 04             	sub    $0x4,%esp
  802fce:	68 99 67 80 00       	push   $0x806799
  802fd3:	68 a7 00 00 00       	push   $0xa7
  802fd8:	68 cc 66 80 00       	push   $0x8066cc
  802fdd:	e8 88 e7 ff ff       	call   80176a <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802fe2:	83 ec 0c             	sub    $0xc,%esp
  802fe5:	6a 10                	push   $0x10
  802fe7:	e8 91 1a 00 00       	call   804a7d <alloc_block>
  802fec:	83 c4 10             	add    $0x10,%esp
  802fef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  802ff2:	83 ec 0c             	sub    $0xc,%esp
  802ff5:	6a 10                	push   $0x10
  802ff7:	e8 81 1a 00 00       	call   804a7d <alloc_block>
  802ffc:	83 c4 10             	add    $0x10,%esp
  802fff:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  803002:	a1 10 f3 81 00       	mov    0x81f310,%eax
  803007:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  80300a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  803011:	eb 1c                	jmp    80302f <free+0xe0>

			if (VA ==ToBefreed->startva ){
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80301b:	75 09                	jne    803026 <free+0xd7>
				foundVA = 1;
  80301d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  803024:	eb 0f                	jmp    803035 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  803026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803029:	8b 40 08             	mov    0x8(%eax),%eax
  80302c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  80302f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803033:	75 de                	jne    803013 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  803035:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803039:	75 17                	jne    803052 <free+0x103>
				panic("INVALID ADDRESS!");
  80303b:	83 ec 04             	sub    $0x4,%esp
  80303e:	68 b6 67 80 00       	push   $0x8067b6
  803043:	68 be 00 00 00       	push   $0xbe
  803048:	68 cc 66 80 00       	push   $0x8066cc
  80304d:	e8 18 e7 ff ff       	call   80176a <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  803052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803055:	8b 10                	mov    (%eax),%edx
  803057:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80305a:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 50 04             	mov    0x4(%eax),%edx
  803062:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803065:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  803068:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80306c:	75 17                	jne    803085 <free+0x136>
  80306e:	83 ec 04             	sub    $0x4,%esp
  803071:	68 3b 67 80 00       	push   $0x80673b
  803076:	68 c8 00 00 00       	push   $0xc8
  80307b:	68 cc 66 80 00       	push   $0x8066cc
  803080:	e8 e5 e6 ff ff       	call   80176a <_panic>
  803085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803088:	8b 40 08             	mov    0x8(%eax),%eax
  80308b:	85 c0                	test   %eax,%eax
  80308d:	74 11                	je     8030a0 <free+0x151>
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 40 08             	mov    0x8(%eax),%eax
  803095:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803098:	8b 52 0c             	mov    0xc(%edx),%edx
  80309b:	89 50 0c             	mov    %edx,0xc(%eax)
  80309e:	eb 0b                	jmp    8030ab <free+0x15c>
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a6:	a3 14 f3 81 00       	mov    %eax,0x81f314
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b1:	85 c0                	test   %eax,%eax
  8030b3:	74 11                	je     8030c6 <free+0x177>
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030be:	8b 52 08             	mov    0x8(%edx),%edx
  8030c1:	89 50 08             	mov    %edx,0x8(%eax)
  8030c4:	eb 0b                	jmp    8030d1 <free+0x182>
  8030c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c9:	8b 40 08             	mov    0x8(%eax),%eax
  8030cc:	a3 10 f3 81 00       	mov    %eax,0x81f310
  8030d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8030e5:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  8030ea:	48                   	dec    %eax
  8030eb:	a3 1c f3 81 00       	mov    %eax,0x81f31c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  8030f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f3:	8b 50 04             	mov    0x4(%eax),%edx
  8030f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	83 ec 08             	sub    $0x8,%esp
  8030fe:	52                   	push   %edx
  8030ff:	50                   	push   %eax
  803100:	e8 d4 16 00 00       	call   8047d9 <sys_free_user_mem>
  803105:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  803108:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80310d:	85 c0                	test   %eax,%eax
  80310f:	75 7a                	jne    80318b <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  803111:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803115:	75 17                	jne    80312e <free+0x1df>
  803117:	83 ec 04             	sub    $0x4,%esp
  80311a:	68 c8 67 80 00       	push   $0x8067c8
  80311f:	68 d0 00 00 00       	push   $0xd0
  803124:	68 cc 66 80 00       	push   $0x8066cc
  803129:	e8 3c e6 ff ff       	call   80176a <_panic>
  80312e:	8b 15 00 f3 81 00    	mov    0x81f300,%edx
  803134:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803137:	89 50 08             	mov    %edx,0x8(%eax)
  80313a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80313d:	8b 40 08             	mov    0x8(%eax),%eax
  803140:	85 c0                	test   %eax,%eax
  803142:	74 0d                	je     803151 <free+0x202>
  803144:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803149:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80314c:	89 50 0c             	mov    %edx,0xc(%eax)
  80314f:	eb 08                	jmp    803159 <free+0x20a>
  803151:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803154:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803159:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80315c:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803161:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803164:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80316b:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803170:	40                   	inc    %eax
  803171:	a3 0c f3 81 00       	mov    %eax,0x81f30c
			release_uspinlock(&ulock);
  803176:	83 ec 0c             	sub    $0xc,%esp
  803179:	68 20 f3 81 00       	push   $0x81f320
  80317e:	e8 ba 21 00 00       	call   80533d <release_uspinlock>
  803183:	83 c4 10             	add    $0x10,%esp
			return;
  803186:	e9 52 05 00 00       	jmp    8036dd <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  80318b:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803190:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  803193:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  80319a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  8031a1:	e9 d2 00 00 00       	jmp    803278 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  8031a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a9:	8b 10                	mov    (%eax),%edx
  8031ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ae:	8b 40 04             	mov    0x4(%eax),%eax
  8031b1:	01 c2                	add    %eax,%edx
  8031b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031b6:	8b 00                	mov    (%eax),%eax
  8031b8:	39 c2                	cmp    %eax,%edx
  8031ba:	0f 85 af 00 00 00    	jne    80326f <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  8031c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031c3:	8b 10                	mov    (%eax),%edx
  8031c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031c8:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  8031ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031cd:	8b 50 04             	mov    0x4(%eax),%edx
  8031d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031d3:	8b 40 04             	mov    0x4(%eax),%eax
  8031d6:	01 c2                	add    %eax,%edx
  8031d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031db:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  8031de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031e2:	75 17                	jne    8031fb <free+0x2ac>
  8031e4:	83 ec 04             	sub    $0x4,%esp
  8031e7:	68 3b 67 80 00       	push   $0x80673b
  8031ec:	68 df 00 00 00       	push   $0xdf
  8031f1:	68 cc 66 80 00       	push   $0x8066cc
  8031f6:	e8 6f e5 ff ff       	call   80176a <_panic>
  8031fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fe:	8b 40 08             	mov    0x8(%eax),%eax
  803201:	85 c0                	test   %eax,%eax
  803203:	74 11                	je     803216 <free+0x2c7>
  803205:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803208:	8b 40 08             	mov    0x8(%eax),%eax
  80320b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80320e:	8b 52 0c             	mov    0xc(%edx),%edx
  803211:	89 50 0c             	mov    %edx,0xc(%eax)
  803214:	eb 0b                	jmp    803221 <free+0x2d2>
  803216:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803219:	8b 40 0c             	mov    0xc(%eax),%eax
  80321c:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803221:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803224:	8b 40 0c             	mov    0xc(%eax),%eax
  803227:	85 c0                	test   %eax,%eax
  803229:	74 11                	je     80323c <free+0x2ed>
  80322b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80322e:	8b 40 0c             	mov    0xc(%eax),%eax
  803231:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803234:	8b 52 08             	mov    0x8(%edx),%edx
  803237:	89 50 08             	mov    %edx,0x8(%eax)
  80323a:	eb 0b                	jmp    803247 <free+0x2f8>
  80323c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323f:	8b 40 08             	mov    0x8(%eax),%eax
  803242:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803247:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803251:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803254:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80325b:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803260:	48                   	dec    %eax
  803261:	a3 0c f3 81 00       	mov    %eax,0x81f30c
				mergeprev = 1;
  803266:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  80326d:	eb 13                	jmp    803282 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  80326f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803272:	8b 40 08             	mov    0x8(%eax),%eax
  803275:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  803278:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80327c:	0f 85 24 ff ff ff    	jne    8031a6 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  803282:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803285:	8b 10                	mov    (%eax),%edx
  803287:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80328a:	8b 40 04             	mov    0x4(%eax),%eax
  80328d:	01 c2                	add    %eax,%edx
  80328f:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803294:	39 c2                	cmp    %eax,%edx
  803296:	75 44                	jne    8032dc <free+0x38d>

			if(mergeprev){
  803298:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80329c:	74 1f                	je     8032bd <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  80329e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8032a1:	8b 00                	mov    (%eax),%eax
  8032a3:	a3 50 f2 81 00       	mov    %eax,0x81f250
				release_uspinlock(&ulock);
  8032a8:	83 ec 0c             	sub    $0xc,%esp
  8032ab:	68 20 f3 81 00       	push   $0x81f320
  8032b0:	e8 88 20 00 00       	call   80533d <release_uspinlock>
  8032b5:	83 c4 10             	add    $0x10,%esp
				return;
  8032b8:	e9 20 04 00 00       	jmp    8036dd <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  8032bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	a3 50 f2 81 00       	mov    %eax,0x81f250
				release_uspinlock(&ulock);
  8032c7:	83 ec 0c             	sub    $0xc,%esp
  8032ca:	68 20 f3 81 00       	push   $0x81f320
  8032cf:	e8 69 20 00 00       	call   80533d <release_uspinlock>
  8032d4:	83 c4 10             	add    $0x10,%esp
				return;
  8032d7:	e9 01 04 00 00       	jmp    8036dd <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  8032dc:	a1 00 f3 81 00       	mov    0x81f300,%eax
  8032e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  8032e4:	e9 7d 01 00 00       	jmp    803466 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  8032e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032ec:	8b 10                	mov    (%eax),%edx
  8032ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032f1:	8b 40 04             	mov    0x4(%eax),%eax
  8032f4:	01 c2                	add    %eax,%edx
  8032f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f9:	8b 00                	mov    (%eax),%eax
  8032fb:	39 c2                	cmp    %eax,%edx
  8032fd:	0f 85 5a 01 00 00    	jne    80345d <free+0x50e>
				if (mergeprev){
  803303:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803307:	0f 84 a1 00 00 00    	je     8033ae <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  80330d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803310:	8b 50 04             	mov    0x4(%eax),%edx
  803313:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803316:	8b 40 04             	mov    0x4(%eax),%eax
  803319:	01 c2                	add    %eax,%edx
  80331b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80331e:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  803321:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803325:	75 17                	jne    80333e <free+0x3ef>
  803327:	83 ec 04             	sub    $0x4,%esp
  80332a:	68 3b 67 80 00       	push   $0x80673b
  80332f:	68 0a 01 00 00       	push   $0x10a
  803334:	68 cc 66 80 00       	push   $0x8066cc
  803339:	e8 2c e4 ff ff       	call   80176a <_panic>
  80333e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803341:	8b 40 08             	mov    0x8(%eax),%eax
  803344:	85 c0                	test   %eax,%eax
  803346:	74 11                	je     803359 <free+0x40a>
  803348:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334b:	8b 40 08             	mov    0x8(%eax),%eax
  80334e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803351:	8b 52 0c             	mov    0xc(%edx),%edx
  803354:	89 50 0c             	mov    %edx,0xc(%eax)
  803357:	eb 0b                	jmp    803364 <free+0x415>
  803359:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335c:	8b 40 0c             	mov    0xc(%eax),%eax
  80335f:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803364:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803367:	8b 40 0c             	mov    0xc(%eax),%eax
  80336a:	85 c0                	test   %eax,%eax
  80336c:	74 11                	je     80337f <free+0x430>
  80336e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803371:	8b 40 0c             	mov    0xc(%eax),%eax
  803374:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803377:	8b 52 08             	mov    0x8(%edx),%edx
  80337a:	89 50 08             	mov    %edx,0x8(%eax)
  80337d:	eb 0b                	jmp    80338a <free+0x43b>
  80337f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803382:	8b 40 08             	mov    0x8(%eax),%eax
  803385:	a3 00 f3 81 00       	mov    %eax,0x81f300
  80338a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803394:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803397:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80339e:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8033a3:	48                   	dec    %eax
  8033a4:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					break;
  8033a9:	e9 c2 00 00 00       	jmp    803470 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  8033ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033b1:	8b 10                	mov    (%eax),%edx
  8033b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033b6:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  8033b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8033bb:	8b 50 04             	mov    0x4(%eax),%edx
  8033be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c1:	8b 40 04             	mov    0x4(%eax),%eax
  8033c4:	01 c2                	add    %eax,%edx
  8033c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8033c9:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8033cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033d0:	75 17                	jne    8033e9 <free+0x49a>
  8033d2:	83 ec 04             	sub    $0x4,%esp
  8033d5:	68 3b 67 80 00       	push   $0x80673b
  8033da:	68 10 01 00 00       	push   $0x110
  8033df:	68 cc 66 80 00       	push   $0x8066cc
  8033e4:	e8 81 e3 ff ff       	call   80176a <_panic>
  8033e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ec:	8b 40 08             	mov    0x8(%eax),%eax
  8033ef:	85 c0                	test   %eax,%eax
  8033f1:	74 11                	je     803404 <free+0x4b5>
  8033f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f6:	8b 40 08             	mov    0x8(%eax),%eax
  8033f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033fc:	8b 52 0c             	mov    0xc(%edx),%edx
  8033ff:	89 50 0c             	mov    %edx,0xc(%eax)
  803402:	eb 0b                	jmp    80340f <free+0x4c0>
  803404:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803407:	8b 40 0c             	mov    0xc(%eax),%eax
  80340a:	a3 04 f3 81 00       	mov    %eax,0x81f304
  80340f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803412:	8b 40 0c             	mov    0xc(%eax),%eax
  803415:	85 c0                	test   %eax,%eax
  803417:	74 11                	je     80342a <free+0x4db>
  803419:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80341c:	8b 40 0c             	mov    0xc(%eax),%eax
  80341f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803422:	8b 52 08             	mov    0x8(%edx),%edx
  803425:	89 50 08             	mov    %edx,0x8(%eax)
  803428:	eb 0b                	jmp    803435 <free+0x4e6>
  80342a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342d:	8b 40 08             	mov    0x8(%eax),%eax
  803430:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803435:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803438:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80343f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803442:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803449:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80344e:	48                   	dec    %eax
  80344f:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					mergenext = 1;
  803454:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  80345b:	eb 13                	jmp    803470 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  80345d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803460:	8b 40 08             	mov    0x8(%eax),%eax
  803463:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  803466:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80346a:	0f 85 79 fe ff ff    	jne    8032e9 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  803470:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803475:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  803478:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80347c:	0f 85 ad 00 00 00    	jne    80352f <free+0x5e0>
  803482:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803486:	0f 84 c3 01 00 00    	je     80364f <free+0x700>
				while(currentfree != NULL){
  80348c:	e9 9e 00 00 00       	jmp    80352f <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  803491:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803494:	8b 50 04             	mov    0x4(%eax),%edx
  803497:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349a:	8b 40 04             	mov    0x4(%eax),%eax
  80349d:	39 c2                	cmp    %eax,%edx
  80349f:	0f 83 81 00 00 00    	jae    803526 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  8034a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8034a9:	74 06                	je     8034b1 <free+0x562>
  8034ab:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8034af:	75 17                	jne    8034c8 <free+0x579>
  8034b1:	83 ec 04             	sub    $0x4,%esp
  8034b4:	68 5c 67 80 00       	push   $0x80675c
  8034b9:	68 23 01 00 00       	push   $0x123
  8034be:	68 cc 66 80 00       	push   $0x8066cc
  8034c3:	e8 a2 e2 ff ff       	call   80176a <_panic>
  8034c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034cb:	8b 50 0c             	mov    0xc(%eax),%edx
  8034ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034d1:	89 50 0c             	mov    %edx,0xc(%eax)
  8034d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034da:	89 50 08             	mov    %edx,0x8(%eax)
  8034dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e3:	85 c0                	test   %eax,%eax
  8034e5:	74 0e                	je     8034f5 <free+0x5a6>
  8034e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ed:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8034f0:	89 50 08             	mov    %edx,0x8(%eax)
  8034f3:	eb 08                	jmp    8034fd <free+0x5ae>
  8034f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8034f8:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8034fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803500:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803503:	89 50 0c             	mov    %edx,0xc(%eax)
  803506:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80350b:	40                   	inc    %eax
  80350c:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							release_uspinlock(&ulock);
  803511:	83 ec 0c             	sub    $0xc,%esp
  803514:	68 20 f3 81 00       	push   $0x81f320
  803519:	e8 1f 1e 00 00       	call   80533d <release_uspinlock>
  80351e:	83 c4 10             	add    $0x10,%esp
							return;
  803521:	e9 b7 01 00 00       	jmp    8036dd <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  803526:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803529:	8b 40 08             	mov    0x8(%eax),%eax
  80352c:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  80352f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803533:	0f 85 58 ff ff ff    	jne    803491 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  803539:	83 ec 0c             	sub    $0xc,%esp
  80353c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80353f:	e8 d5 19 00 00       	call   804f19 <free_block>
  803544:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  803547:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80354b:	75 17                	jne    803564 <free+0x615>
  80354d:	83 ec 04             	sub    $0x4,%esp
  803550:	68 18 67 80 00       	push   $0x806718
  803555:	68 2a 01 00 00       	push   $0x12a
  80355a:	68 cc 66 80 00       	push   $0x8066cc
  80355f:	e8 06 e2 ff ff       	call   80176a <_panic>
  803564:	8b 15 04 f3 81 00    	mov    0x81f304,%edx
  80356a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80356d:	89 50 0c             	mov    %edx,0xc(%eax)
  803570:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803573:	8b 40 0c             	mov    0xc(%eax),%eax
  803576:	85 c0                	test   %eax,%eax
  803578:	74 0d                	je     803587 <free+0x638>
  80357a:	a1 04 f3 81 00       	mov    0x81f304,%eax
  80357f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803582:	89 50 08             	mov    %edx,0x8(%eax)
  803585:	eb 08                	jmp    80358f <free+0x640>
  803587:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80358a:	a3 00 f3 81 00       	mov    %eax,0x81f300
  80358f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803592:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803597:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80359a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8035a1:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8035a6:	40                   	inc    %eax
  8035a7:	a3 0c f3 81 00       	mov    %eax,0x81f30c
  8035ac:	e9 1b 01 00 00       	jmp    8036cc <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  8035b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b4:	8b 50 04             	mov    0x4(%eax),%edx
  8035b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ba:	8b 40 04             	mov    0x4(%eax),%eax
  8035bd:	39 c2                	cmp    %eax,%edx
  8035bf:	0f 83 81 00 00 00    	jae    803646 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  8035c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8035c9:	74 06                	je     8035d1 <free+0x682>
  8035cb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8035cf:	75 17                	jne    8035e8 <free+0x699>
  8035d1:	83 ec 04             	sub    $0x4,%esp
  8035d4:	68 5c 67 80 00       	push   $0x80675c
  8035d9:	68 30 01 00 00       	push   $0x130
  8035de:	68 cc 66 80 00       	push   $0x8066cc
  8035e3:	e8 82 e1 ff ff       	call   80176a <_panic>
  8035e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035eb:	8b 50 0c             	mov    0xc(%eax),%edx
  8035ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f1:	89 50 0c             	mov    %edx,0xc(%eax)
  8035f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035fa:	89 50 08             	mov    %edx,0x8(%eax)
  8035fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803600:	8b 40 0c             	mov    0xc(%eax),%eax
  803603:	85 c0                	test   %eax,%eax
  803605:	74 0e                	je     803615 <free+0x6c6>
  803607:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80360a:	8b 40 0c             	mov    0xc(%eax),%eax
  80360d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803610:	89 50 08             	mov    %edx,0x8(%eax)
  803613:	eb 08                	jmp    80361d <free+0x6ce>
  803615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803618:	a3 00 f3 81 00       	mov    %eax,0x81f300
  80361d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803620:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803623:	89 50 0c             	mov    %edx,0xc(%eax)
  803626:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  80362b:	40                   	inc    %eax
  80362c:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							release_uspinlock(&ulock);
  803631:	83 ec 0c             	sub    $0xc,%esp
  803634:	68 20 f3 81 00       	push   $0x81f320
  803639:	e8 ff 1c 00 00       	call   80533d <release_uspinlock>
  80363e:	83 c4 10             	add    $0x10,%esp
							return;
  803641:	e9 97 00 00 00       	jmp    8036dd <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  803646:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803649:	8b 40 08             	mov    0x8(%eax),%eax
  80364c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  80364f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803653:	0f 85 58 ff ff ff    	jne    8035b1 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  803659:	83 ec 0c             	sub    $0xc,%esp
  80365c:	ff 75 d0             	pushl  -0x30(%ebp)
  80365f:	e8 b5 18 00 00       	call   804f19 <free_block>
  803664:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  803667:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80366b:	75 17                	jne    803684 <free+0x735>
  80366d:	83 ec 04             	sub    $0x4,%esp
  803670:	68 18 67 80 00       	push   $0x806718
  803675:	68 37 01 00 00       	push   $0x137
  80367a:	68 cc 66 80 00       	push   $0x8066cc
  80367f:	e8 e6 e0 ff ff       	call   80176a <_panic>
  803684:	8b 15 04 f3 81 00    	mov    0x81f304,%edx
  80368a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80368d:	89 50 0c             	mov    %edx,0xc(%eax)
  803690:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803693:	8b 40 0c             	mov    0xc(%eax),%eax
  803696:	85 c0                	test   %eax,%eax
  803698:	74 0d                	je     8036a7 <free+0x758>
  80369a:	a1 04 f3 81 00       	mov    0x81f304,%eax
  80369f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8036a2:	89 50 08             	mov    %edx,0x8(%eax)
  8036a5:	eb 08                	jmp    8036af <free+0x760>
  8036a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036aa:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8036af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036b2:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8036b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8036ba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8036c1:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8036c6:	40                   	inc    %eax
  8036c7:	a3 0c f3 81 00       	mov    %eax,0x81f30c
			}
		release_uspinlock(&ulock);
  8036cc:	83 ec 0c             	sub    $0xc,%esp
  8036cf:	68 20 f3 81 00       	push   $0x81f320
  8036d4:	e8 64 1c 00 00       	call   80533d <release_uspinlock>
  8036d9:	83 c4 10             	add    $0x10,%esp
		return;
  8036dc:	90                   	nop
}
  8036dd:	c9                   	leave  
  8036de:	c3                   	ret    

008036df <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8036df:	55                   	push   %ebp
  8036e0:	89 e5                	mov    %esp,%ebp
  8036e2:	83 ec 48             	sub    $0x48,%esp
  8036e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8036e8:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8036eb:	e8 2d f2 ff ff       	call   80291d <uheap_init>
	if (size == 0) return NULL;
  8036f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8036f4:	75 0a                	jne    803700 <smalloc+0x21>
  8036f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8036fb:	e9 84 05 00 00       	jmp    803c84 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  803700:	83 ec 0c             	sub    $0xc,%esp
  803703:	68 20 f3 81 00       	push   $0x81f320
  803708:	e8 d8 1b 00 00       	call   8052e5 <acquire_uspinlock>
  80370d:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  803710:	83 ec 0c             	sub    $0xc,%esp
  803713:	6a 10                	push   $0x10
  803715:	e8 63 13 00 00       	call   804a7d <alloc_block>
  80371a:	83 c4 10             	add    $0x10,%esp
  80371d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  803720:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803724:	75 0a                	jne    803730 <smalloc+0x51>
				return NULL;
  803726:	b8 00 00 00 00       	mov    $0x0,%eax
  80372b:	e9 54 05 00 00       	jmp    803c84 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  803730:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  803737:	8b 55 0c             	mov    0xc(%ebp),%edx
  80373a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80373d:	01 d0                	add    %edx,%eax
  80373f:	48                   	dec    %eax
  803740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803746:	ba 00 00 00 00       	mov    $0x0,%edx
  80374b:	f7 75 e8             	divl   -0x18(%ebp)
  80374e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803751:	29 d0                	sub    %edx,%eax
  803753:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  803756:	a1 04 f3 81 00       	mov    0x81f304,%eax
  80375b:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80375e:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803763:	85 c0                	test   %eax,%eax
  803765:	74 0f                	je     803776 <smalloc+0x97>
  803767:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80376a:	8b 40 04             	mov    0x4(%eax),%eax
  80376d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803770:	0f 83 25 01 00 00    	jae    80389b <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  803776:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80377b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80377e:	89 c2                	mov    %eax,%edx
  803780:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803785:	39 c2                	cmp    %eax,%edx
  803787:	0f 82 f4 00 00 00    	jb     803881 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  80378d:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803792:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  803795:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  80379b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80379e:	01 d0                	add    %edx,%eax
  8037a0:	a3 50 f2 81 00       	mov    %eax,0x81f250
						allocblock->startva = requestedblockva;
  8037a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8037ab:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8037ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8037b3:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8037b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037ba:	75 17                	jne    8037d3 <smalloc+0xf4>
  8037bc:	83 ec 04             	sub    $0x4,%esp
  8037bf:	68 18 67 80 00       	push   $0x806718
  8037c4:	68 57 01 00 00       	push   $0x157
  8037c9:	68 cc 66 80 00       	push   $0x8066cc
  8037ce:	e8 97 df ff ff       	call   80176a <_panic>
  8037d3:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  8037d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037dc:	89 50 0c             	mov    %edx,0xc(%eax)
  8037df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8037e5:	85 c0                	test   %eax,%eax
  8037e7:	74 0d                	je     8037f6 <smalloc+0x117>
  8037e9:	a1 14 f3 81 00       	mov    0x81f314,%eax
  8037ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8037f1:	89 50 08             	mov    %edx,0x8(%eax)
  8037f4:	eb 08                	jmp    8037fe <smalloc+0x11f>
  8037f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f9:	a3 10 f3 81 00       	mov    %eax,0x81f310
  8037fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803801:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803806:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803809:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803810:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803815:	40                   	inc    %eax
  803816:	a3 1c f3 81 00       	mov    %eax,0x81f31c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80381b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80381e:	8b 00                	mov    (%eax),%eax
  803820:	89 c2                	mov    %eax,%edx
  803822:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803826:	52                   	push   %edx
  803827:	50                   	push   %eax
  803828:	ff 75 0c             	pushl  0xc(%ebp)
  80382b:	ff 75 08             	pushl  0x8(%ebp)
  80382e:	e8 48 0c 00 00       	call   80447b <sys_create_shared_object>
  803833:	83 c4 10             	add    $0x10,%esp
  803836:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  803839:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80383d:	79 28                	jns    803867 <smalloc+0x188>
							free_block(allocblock);
  80383f:	83 ec 0c             	sub    $0xc,%esp
  803842:	ff 75 ec             	pushl  -0x14(%ebp)
  803845:	e8 cf 16 00 00       	call   804f19 <free_block>
  80384a:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  80384d:	83 ec 0c             	sub    $0xc,%esp
  803850:	68 20 f3 81 00       	push   $0x81f320
  803855:	e8 e3 1a 00 00       	call   80533d <release_uspinlock>
  80385a:	83 c4 10             	add    $0x10,%esp
							return NULL;
  80385d:	b8 00 00 00 00       	mov    $0x0,%eax
  803862:	e9 1d 04 00 00       	jmp    803c84 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  803867:	83 ec 0c             	sub    $0xc,%esp
  80386a:	68 20 f3 81 00       	push   $0x81f320
  80386f:	e8 c9 1a 00 00       	call   80533d <release_uspinlock>
  803874:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  803877:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80387a:	8b 00                	mov    (%eax),%eax
  80387c:	e9 03 04 00 00       	jmp    803c84 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  803881:	83 ec 0c             	sub    $0xc,%esp
  803884:	68 20 f3 81 00       	push   $0x81f320
  803889:	e8 af 1a 00 00       	call   80533d <release_uspinlock>
  80388e:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803891:	b8 00 00 00 00       	mov    $0x0,%eax
  803896:	e9 e9 03 00 00       	jmp    803c84 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  80389b:	a1 00 f3 81 00       	mov    0x81f300,%eax
  8038a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8038a3:	e9 af 03 00 00       	jmp    803c57 <smalloc+0x578>
				if(size<currentfreeelement->size){
  8038a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038ab:	8b 40 04             	mov    0x4(%eax),%eax
  8038ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8038b1:	0f 86 28 02 00 00    	jbe    803adf <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  8038b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038ba:	8b 10                	mov    (%eax),%edx
  8038bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038bf:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  8038c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038c7:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8038ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038ce:	75 17                	jne    8038e7 <smalloc+0x208>
  8038d0:	83 ec 04             	sub    $0x4,%esp
  8038d3:	68 18 67 80 00       	push   $0x806718
  8038d8:	68 6f 01 00 00       	push   $0x16f
  8038dd:	68 cc 66 80 00       	push   $0x8066cc
  8038e2:	e8 83 de ff ff       	call   80176a <_panic>
  8038e7:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  8038ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038f0:	89 50 0c             	mov    %edx,0xc(%eax)
  8038f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8038f9:	85 c0                	test   %eax,%eax
  8038fb:	74 0d                	je     80390a <smalloc+0x22b>
  8038fd:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803902:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803905:	89 50 08             	mov    %edx,0x8(%eax)
  803908:	eb 08                	jmp    803912 <smalloc+0x233>
  80390a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80390d:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803912:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803915:	a3 14 f3 81 00       	mov    %eax,0x81f314
  80391a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80391d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803924:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803929:	40                   	inc    %eax
  80392a:	a3 1c f3 81 00       	mov    %eax,0x81f31c
	                lastfreeelement->startva += size;
  80392f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803932:	8b 10                	mov    (%eax),%edx
  803934:	8b 45 0c             	mov    0xc(%ebp),%eax
  803937:	01 c2                	add    %eax,%edx
  803939:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80393c:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  80393e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803941:	8b 40 04             	mov    0x4(%eax),%eax
  803944:	2b 45 0c             	sub    0xc(%ebp),%eax
  803947:	89 c2                	mov    %eax,%edx
  803949:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80394c:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  80394f:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803954:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  803957:	e9 13 01 00 00       	jmp    803a6f <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  80395c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80395f:	8b 50 04             	mov    0x4(%eax),%edx
  803962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803965:	8b 40 04             	mov    0x4(%eax),%eax
  803968:	39 c2                	cmp    %eax,%edx
  80396a:	0f 83 f6 00 00 00    	jae    803a66 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  803970:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803974:	75 17                	jne    80398d <smalloc+0x2ae>
  803976:	83 ec 04             	sub    $0x4,%esp
  803979:	68 3b 67 80 00       	push   $0x80673b
  80397e:	68 77 01 00 00       	push   $0x177
  803983:	68 cc 66 80 00       	push   $0x8066cc
  803988:	e8 dd dd ff ff       	call   80176a <_panic>
  80398d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803990:	8b 40 08             	mov    0x8(%eax),%eax
  803993:	85 c0                	test   %eax,%eax
  803995:	74 11                	je     8039a8 <smalloc+0x2c9>
  803997:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80399a:	8b 40 08             	mov    0x8(%eax),%eax
  80399d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039a0:	8b 52 0c             	mov    0xc(%edx),%edx
  8039a3:	89 50 0c             	mov    %edx,0xc(%eax)
  8039a6:	eb 0b                	jmp    8039b3 <smalloc+0x2d4>
  8039a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8039ae:	a3 04 f3 81 00       	mov    %eax,0x81f304
  8039b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8039b9:	85 c0                	test   %eax,%eax
  8039bb:	74 11                	je     8039ce <smalloc+0x2ef>
  8039bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8039c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039c6:	8b 52 08             	mov    0x8(%edx),%edx
  8039c9:	89 50 08             	mov    %edx,0x8(%eax)
  8039cc:	eb 0b                	jmp    8039d9 <smalloc+0x2fa>
  8039ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039d1:	8b 40 08             	mov    0x8(%eax),%eax
  8039d4:	a3 00 f3 81 00       	mov    %eax,0x81f300
  8039d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8039e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039e6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8039ed:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8039f2:	48                   	dec    %eax
  8039f3:	a3 0c f3 81 00       	mov    %eax,0x81f30c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  8039f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039fc:	74 06                	je     803a04 <smalloc+0x325>
  8039fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803a02:	75 17                	jne    803a1b <smalloc+0x33c>
  803a04:	83 ec 04             	sub    $0x4,%esp
  803a07:	68 5c 67 80 00       	push   $0x80675c
  803a0c:	68 78 01 00 00       	push   $0x178
  803a11:	68 cc 66 80 00       	push   $0x8066cc
  803a16:	e8 4f dd ff ff       	call   80176a <_panic>
  803a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a1e:	8b 50 0c             	mov    0xc(%eax),%edx
  803a21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a24:	89 50 0c             	mov    %edx,0xc(%eax)
  803a27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a2d:	89 50 08             	mov    %edx,0x8(%eax)
  803a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a33:	8b 40 0c             	mov    0xc(%eax),%eax
  803a36:	85 c0                	test   %eax,%eax
  803a38:	74 0e                	je     803a48 <smalloc+0x369>
  803a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a3d:	8b 40 0c             	mov    0xc(%eax),%eax
  803a40:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a43:	89 50 08             	mov    %edx,0x8(%eax)
  803a46:	eb 08                	jmp    803a50 <smalloc+0x371>
  803a48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a4b:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a53:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a56:	89 50 0c             	mov    %edx,0xc(%eax)
  803a59:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803a5e:	40                   	inc    %eax
  803a5f:	a3 0c f3 81 00       	mov    %eax,0x81f30c
	                		break;
  803a64:	eb 13                	jmp    803a79 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  803a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a69:	8b 40 08             	mov    0x8(%eax),%eax
  803a6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  803a6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803a73:	0f 85 e3 fe ff ff    	jne    80395c <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  803a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a7c:	8b 00                	mov    (%eax),%eax
  803a7e:	89 c2                	mov    %eax,%edx
  803a80:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803a84:	52                   	push   %edx
  803a85:	50                   	push   %eax
  803a86:	ff 75 0c             	pushl  0xc(%ebp)
  803a89:	ff 75 08             	pushl  0x8(%ebp)
  803a8c:	e8 ea 09 00 00       	call   80447b <sys_create_shared_object>
  803a91:	83 c4 10             	add    $0x10,%esp
  803a94:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  803a97:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803a9b:	79 28                	jns    803ac5 <smalloc+0x3e6>
	                	free_block(allocblock);
  803a9d:	83 ec 0c             	sub    $0xc,%esp
  803aa0:	ff 75 ec             	pushl  -0x14(%ebp)
  803aa3:	e8 71 14 00 00       	call   804f19 <free_block>
  803aa8:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  803aab:	83 ec 0c             	sub    $0xc,%esp
  803aae:	68 20 f3 81 00       	push   $0x81f320
  803ab3:	e8 85 18 00 00       	call   80533d <release_uspinlock>
  803ab8:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  803abb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ac0:	e9 bf 01 00 00       	jmp    803c84 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  803ac5:	83 ec 0c             	sub    $0xc,%esp
  803ac8:	68 20 f3 81 00       	push   $0x81f320
  803acd:	e8 6b 18 00 00       	call   80533d <release_uspinlock>
  803ad2:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  803ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ad8:	8b 00                	mov    (%eax),%eax
  803ada:	e9 a5 01 00 00       	jmp    803c84 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  803adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ae2:	8b 40 04             	mov    0x4(%eax),%eax
  803ae5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ae8:	0f 85 60 01 00 00    	jne    803c4e <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  803aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af1:	8b 10                	mov    (%eax),%edx
  803af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803af6:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  803afe:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803b01:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b05:	75 17                	jne    803b1e <smalloc+0x43f>
  803b07:	83 ec 04             	sub    $0x4,%esp
  803b0a:	68 18 67 80 00       	push   $0x806718
  803b0f:	68 8c 01 00 00       	push   $0x18c
  803b14:	68 cc 66 80 00       	push   $0x8066cc
  803b19:	e8 4c dc ff ff       	call   80176a <_panic>
  803b1e:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b27:	89 50 0c             	mov    %edx,0xc(%eax)
  803b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b2d:	8b 40 0c             	mov    0xc(%eax),%eax
  803b30:	85 c0                	test   %eax,%eax
  803b32:	74 0d                	je     803b41 <smalloc+0x462>
  803b34:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803b39:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803b3c:	89 50 08             	mov    %edx,0x8(%eax)
  803b3f:	eb 08                	jmp    803b49 <smalloc+0x46a>
  803b41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b44:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b4c:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b54:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803b5b:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803b60:	40                   	inc    %eax
  803b61:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803b66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b6a:	75 17                	jne    803b83 <smalloc+0x4a4>
  803b6c:	83 ec 04             	sub    $0x4,%esp
  803b6f:	68 3b 67 80 00       	push   $0x80673b
  803b74:	68 8d 01 00 00       	push   $0x18d
  803b79:	68 cc 66 80 00       	push   $0x8066cc
  803b7e:	e8 e7 db ff ff       	call   80176a <_panic>
  803b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b86:	8b 40 08             	mov    0x8(%eax),%eax
  803b89:	85 c0                	test   %eax,%eax
  803b8b:	74 11                	je     803b9e <smalloc+0x4bf>
  803b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b90:	8b 40 08             	mov    0x8(%eax),%eax
  803b93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b96:	8b 52 0c             	mov    0xc(%edx),%edx
  803b99:	89 50 0c             	mov    %edx,0xc(%eax)
  803b9c:	eb 0b                	jmp    803ba9 <smalloc+0x4ca>
  803b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ba1:	8b 40 0c             	mov    0xc(%eax),%eax
  803ba4:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bac:	8b 40 0c             	mov    0xc(%eax),%eax
  803baf:	85 c0                	test   %eax,%eax
  803bb1:	74 11                	je     803bc4 <smalloc+0x4e5>
  803bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bb6:	8b 40 0c             	mov    0xc(%eax),%eax
  803bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bbc:	8b 52 08             	mov    0x8(%edx),%edx
  803bbf:	89 50 08             	mov    %edx,0x8(%eax)
  803bc2:	eb 0b                	jmp    803bcf <smalloc+0x4f0>
  803bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc7:	8b 40 08             	mov    0x8(%eax),%eax
  803bca:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803be3:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803be8:	48                   	dec    %eax
  803be9:	a3 0c f3 81 00       	mov    %eax,0x81f30c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  803bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bf1:	8b 00                	mov    (%eax),%eax
  803bf3:	89 c2                	mov    %eax,%edx
  803bf5:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803bf9:	52                   	push   %edx
  803bfa:	50                   	push   %eax
  803bfb:	ff 75 0c             	pushl  0xc(%ebp)
  803bfe:	ff 75 08             	pushl  0x8(%ebp)
  803c01:	e8 75 08 00 00       	call   80447b <sys_create_shared_object>
  803c06:	83 c4 10             	add    $0x10,%esp
  803c09:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  803c0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803c10:	79 25                	jns    803c37 <smalloc+0x558>
						free_block(allocblock);
  803c12:	83 ec 0c             	sub    $0xc,%esp
  803c15:	ff 75 ec             	pushl  -0x14(%ebp)
  803c18:	e8 fc 12 00 00       	call   804f19 <free_block>
  803c1d:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803c20:	83 ec 0c             	sub    $0xc,%esp
  803c23:	68 20 f3 81 00       	push   $0x81f320
  803c28:	e8 10 17 00 00       	call   80533d <release_uspinlock>
  803c2d:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803c30:	b8 00 00 00 00       	mov    $0x0,%eax
  803c35:	eb 4d                	jmp    803c84 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  803c37:	83 ec 0c             	sub    $0xc,%esp
  803c3a:	68 20 f3 81 00       	push   $0x81f320
  803c3f:	e8 f9 16 00 00       	call   80533d <release_uspinlock>
  803c44:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803c47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c4a:	8b 00                	mov    (%eax),%eax
  803c4c:	eb 36                	jmp    803c84 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c51:	8b 40 08             	mov    0x8(%eax),%eax
  803c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  803c57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c5b:	0f 85 47 fc ff ff    	jne    8038a8 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  803c61:	83 ec 0c             	sub    $0xc,%esp
  803c64:	ff 75 ec             	pushl  -0x14(%ebp)
  803c67:	e8 ad 12 00 00       	call   804f19 <free_block>
  803c6c:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803c6f:	83 ec 0c             	sub    $0xc,%esp
  803c72:	68 20 f3 81 00       	push   $0x81f320
  803c77:	e8 c1 16 00 00       	call   80533d <release_uspinlock>
  803c7c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803c84:	c9                   	leave  
  803c85:	c3                   	ret    

00803c86 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  803c86:	55                   	push   %ebp
  803c87:	89 e5                	mov    %esp,%ebp
  803c89:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  803c8c:	e8 8c ec ff ff       	call   80291d <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  803c91:	83 ec 0c             	sub    $0xc,%esp
  803c94:	68 20 f3 81 00       	push   $0x81f320
  803c99:	e8 47 16 00 00       	call   8052e5 <acquire_uspinlock>
  803c9e:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  803ca1:	83 ec 08             	sub    $0x8,%esp
  803ca4:	ff 75 0c             	pushl  0xc(%ebp)
  803ca7:	ff 75 08             	pushl  0x8(%ebp)
  803caa:	e8 f6 07 00 00       	call   8044a5 <sys_size_of_shared_object>
  803caf:	83 c4 10             	add    $0x10,%esp
  803cb2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  803cb5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803cb9:	79 1a                	jns    803cd5 <sget+0x4f>
			release_uspinlock(&ulock);
  803cbb:	83 ec 0c             	sub    $0xc,%esp
  803cbe:	68 20 f3 81 00       	push   $0x81f320
  803cc3:	e8 75 16 00 00       	call   80533d <release_uspinlock>
  803cc8:	83 c4 10             	add    $0x10,%esp
			return NULL;
  803ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  803cd0:	e9 6e 05 00 00       	jmp    804243 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  803cd5:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  803cdc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ce2:	01 d0                	add    %edx,%eax
  803ce4:	48                   	dec    %eax
  803ce5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803ce8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  803cf0:	f7 75 e8             	divl   -0x18(%ebp)
  803cf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803cf6:	29 d0                	sub    %edx,%eax
  803cf8:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  803cfb:	83 ec 0c             	sub    $0xc,%esp
  803cfe:	6a 10                	push   $0x10
  803d00:	e8 78 0d 00 00       	call   804a7d <alloc_block>
  803d05:	83 c4 10             	add    $0x10,%esp
  803d08:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  803d0b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803d0f:	75 0a                	jne    803d1b <sget+0x95>
			return NULL;
  803d11:	b8 00 00 00 00       	mov    $0x0,%eax
  803d16:	e9 28 05 00 00       	jmp    804243 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  803d1b:	a1 04 f3 81 00       	mov    0x81f304,%eax
  803d20:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  803d23:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803d28:	85 c0                	test   %eax,%eax
  803d2a:	74 11                	je     803d3d <sget+0xb7>
  803d2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803d2f:	8b 50 04             	mov    0x4(%eax),%edx
  803d32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d35:	39 c2                	cmp    %eax,%edx
  803d37:	0f 83 21 01 00 00    	jae    803e5e <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  803d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d40:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  803d45:	29 c2                	sub    %eax,%edx
  803d47:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803d4c:	39 c2                	cmp    %eax,%edx
  803d4e:	0f 82 f0 00 00 00    	jb     803e44 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  803d54:	a1 50 f2 81 00       	mov    0x81f250,%eax
  803d59:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  803d5c:	8b 15 50 f2 81 00    	mov    0x81f250,%edx
  803d62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803d65:	01 d0                	add    %edx,%eax
  803d67:	a3 50 f2 81 00       	mov    %eax,0x81f250
						allocblock->startva = requestedblockva;
  803d6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d6f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803d72:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  803d74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803d77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d7a:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  803d7d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803d81:	75 17                	jne    803d9a <sget+0x114>
  803d83:	83 ec 04             	sub    $0x4,%esp
  803d86:	68 18 67 80 00       	push   $0x806718
  803d8b:	68 c8 01 00 00       	push   $0x1c8
  803d90:	68 cc 66 80 00       	push   $0x8066cc
  803d95:	e8 d0 d9 ff ff       	call   80176a <_panic>
  803d9a:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803da0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803da3:	89 50 0c             	mov    %edx,0xc(%eax)
  803da6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803da9:	8b 40 0c             	mov    0xc(%eax),%eax
  803dac:	85 c0                	test   %eax,%eax
  803dae:	74 0d                	je     803dbd <sget+0x137>
  803db0:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803db5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803db8:	89 50 08             	mov    %edx,0x8(%eax)
  803dbb:	eb 08                	jmp    803dc5 <sget+0x13f>
  803dbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dc0:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803dc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dc8:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803dcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dd0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803dd7:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803ddc:	40                   	inc    %eax
  803ddd:	a3 1c f3 81 00       	mov    %eax,0x81f31c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803de2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803de5:	8b 00                	mov    (%eax),%eax
  803de7:	83 ec 04             	sub    $0x4,%esp
  803dea:	50                   	push   %eax
  803deb:	ff 75 0c             	pushl  0xc(%ebp)
  803dee:	ff 75 08             	pushl  0x8(%ebp)
  803df1:	e8 cc 06 00 00       	call   8044c2 <sys_get_shared_object>
  803df6:	83 c4 10             	add    $0x10,%esp
  803df9:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  803dfc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803e00:	79 28                	jns    803e2a <sget+0x1a4>
							free_block(allocblock);
  803e02:	83 ec 0c             	sub    $0xc,%esp
  803e05:	ff 75 e0             	pushl  -0x20(%ebp)
  803e08:	e8 0c 11 00 00       	call   804f19 <free_block>
  803e0d:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  803e10:	83 ec 0c             	sub    $0xc,%esp
  803e13:	68 20 f3 81 00       	push   $0x81f320
  803e18:	e8 20 15 00 00       	call   80533d <release_uspinlock>
  803e1d:	83 c4 10             	add    $0x10,%esp
							return NULL;
  803e20:	b8 00 00 00 00       	mov    $0x0,%eax
  803e25:	e9 19 04 00 00       	jmp    804243 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  803e2a:	83 ec 0c             	sub    $0xc,%esp
  803e2d:	68 20 f3 81 00       	push   $0x81f320
  803e32:	e8 06 15 00 00       	call   80533d <release_uspinlock>
  803e37:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  803e3a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e3d:	8b 00                	mov    (%eax),%eax
  803e3f:	e9 ff 03 00 00       	jmp    804243 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  803e44:	83 ec 0c             	sub    $0xc,%esp
  803e47:	68 20 f3 81 00       	push   $0x81f320
  803e4c:	e8 ec 14 00 00       	call   80533d <release_uspinlock>
  803e51:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803e54:	b8 00 00 00 00       	mov    $0x0,%eax
  803e59:	e9 e5 03 00 00       	jmp    804243 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  803e5e:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803e63:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  803e66:	e9 ab 03 00 00       	jmp    804216 <sget+0x590>
				if(size<currentfreeelement->size){
  803e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e6e:	8b 50 04             	mov    0x4(%eax),%edx
  803e71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803e74:	39 c2                	cmp    %eax,%edx
  803e76:	0f 86 24 02 00 00    	jbe    8040a0 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  803e7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e7f:	8b 10                	mov    (%eax),%edx
  803e81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e84:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803e86:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803e89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e8c:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  803e8f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803e93:	75 17                	jne    803eac <sget+0x226>
  803e95:	83 ec 04             	sub    $0x4,%esp
  803e98:	68 18 67 80 00       	push   $0x806718
  803e9d:	68 e0 01 00 00       	push   $0x1e0
  803ea2:	68 cc 66 80 00       	push   $0x8066cc
  803ea7:	e8 be d8 ff ff       	call   80176a <_panic>
  803eac:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  803eb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803eb5:	89 50 0c             	mov    %edx,0xc(%eax)
  803eb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ebb:	8b 40 0c             	mov    0xc(%eax),%eax
  803ebe:	85 c0                	test   %eax,%eax
  803ec0:	74 0d                	je     803ecf <sget+0x249>
  803ec2:	a1 14 f3 81 00       	mov    0x81f314,%eax
  803ec7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803eca:	89 50 08             	mov    %edx,0x8(%eax)
  803ecd:	eb 08                	jmp    803ed7 <sget+0x251>
  803ecf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ed2:	a3 10 f3 81 00       	mov    %eax,0x81f310
  803ed7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803eda:	a3 14 f3 81 00       	mov    %eax,0x81f314
  803edf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ee2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803ee9:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  803eee:	40                   	inc    %eax
  803eef:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					lastfreeelement->startva += size;
  803ef4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ef7:	8b 10                	mov    (%eax),%edx
  803ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803efc:	01 c2                	add    %eax,%edx
  803efe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f01:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  803f03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f06:	8b 50 04             	mov    0x4(%eax),%edx
  803f09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803f0c:	29 c2                	sub    %eax,%edx
  803f0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f11:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  803f14:	a1 00 f3 81 00       	mov    0x81f300,%eax
  803f19:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  803f1c:	e9 13 01 00 00       	jmp    804034 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  803f21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f24:	8b 50 04             	mov    0x4(%eax),%edx
  803f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f2a:	8b 40 04             	mov    0x4(%eax),%eax
  803f2d:	39 c2                	cmp    %eax,%edx
  803f2f:	0f 83 f6 00 00 00    	jae    80402b <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  803f35:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803f39:	75 17                	jne    803f52 <sget+0x2cc>
  803f3b:	83 ec 04             	sub    $0x4,%esp
  803f3e:	68 3b 67 80 00       	push   $0x80673b
  803f43:	68 e8 01 00 00       	push   $0x1e8
  803f48:	68 cc 66 80 00       	push   $0x8066cc
  803f4d:	e8 18 d8 ff ff       	call   80176a <_panic>
  803f52:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f55:	8b 40 08             	mov    0x8(%eax),%eax
  803f58:	85 c0                	test   %eax,%eax
  803f5a:	74 11                	je     803f6d <sget+0x2e7>
  803f5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f5f:	8b 40 08             	mov    0x8(%eax),%eax
  803f62:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f65:	8b 52 0c             	mov    0xc(%edx),%edx
  803f68:	89 50 0c             	mov    %edx,0xc(%eax)
  803f6b:	eb 0b                	jmp    803f78 <sget+0x2f2>
  803f6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f70:	8b 40 0c             	mov    0xc(%eax),%eax
  803f73:	a3 04 f3 81 00       	mov    %eax,0x81f304
  803f78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f7b:	8b 40 0c             	mov    0xc(%eax),%eax
  803f7e:	85 c0                	test   %eax,%eax
  803f80:	74 11                	je     803f93 <sget+0x30d>
  803f82:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f85:	8b 40 0c             	mov    0xc(%eax),%eax
  803f88:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803f8b:	8b 52 08             	mov    0x8(%edx),%edx
  803f8e:	89 50 08             	mov    %edx,0x8(%eax)
  803f91:	eb 0b                	jmp    803f9e <sget+0x318>
  803f93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803f96:	8b 40 08             	mov    0x8(%eax),%eax
  803f99:	a3 00 f3 81 00       	mov    %eax,0x81f300
  803f9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fa1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803fa8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803fb2:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  803fb7:	48                   	dec    %eax
  803fb8:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803fbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803fc1:	74 06                	je     803fc9 <sget+0x343>
  803fc3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803fc7:	75 17                	jne    803fe0 <sget+0x35a>
  803fc9:	83 ec 04             	sub    $0x4,%esp
  803fcc:	68 5c 67 80 00       	push   $0x80675c
  803fd1:	68 e9 01 00 00       	push   $0x1e9
  803fd6:	68 cc 66 80 00       	push   $0x8066cc
  803fdb:	e8 8a d7 ff ff       	call   80176a <_panic>
  803fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fe3:	8b 50 0c             	mov    0xc(%eax),%edx
  803fe6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fe9:	89 50 0c             	mov    %edx,0xc(%eax)
  803fec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803fef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ff2:	89 50 08             	mov    %edx,0x8(%eax)
  803ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff8:	8b 40 0c             	mov    0xc(%eax),%eax
  803ffb:	85 c0                	test   %eax,%eax
  803ffd:	74 0e                	je     80400d <sget+0x387>
  803fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804002:	8b 40 0c             	mov    0xc(%eax),%eax
  804005:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804008:	89 50 08             	mov    %edx,0x8(%eax)
  80400b:	eb 08                	jmp    804015 <sget+0x38f>
  80400d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804010:	a3 00 f3 81 00       	mov    %eax,0x81f300
  804015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804018:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80401b:	89 50 0c             	mov    %edx,0xc(%eax)
  80401e:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  804023:	40                   	inc    %eax
  804024:	a3 0c f3 81 00       	mov    %eax,0x81f30c
							break;
  804029:	eb 13                	jmp    80403e <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  80402b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80402e:	8b 40 08             	mov    0x8(%eax),%eax
  804031:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  804034:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804038:	0f 85 e3 fe ff ff    	jne    803f21 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  80403e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804041:	8b 00                	mov    (%eax),%eax
  804043:	83 ec 04             	sub    $0x4,%esp
  804046:	50                   	push   %eax
  804047:	ff 75 0c             	pushl  0xc(%ebp)
  80404a:	ff 75 08             	pushl  0x8(%ebp)
  80404d:	e8 70 04 00 00       	call   8044c2 <sys_get_shared_object>
  804052:	83 c4 10             	add    $0x10,%esp
  804055:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  804058:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80405c:	79 28                	jns    804086 <sget+0x400>
						free_block(allocblock);
  80405e:	83 ec 0c             	sub    $0xc,%esp
  804061:	ff 75 e0             	pushl  -0x20(%ebp)
  804064:	e8 b0 0e 00 00       	call   804f19 <free_block>
  804069:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  80406c:	83 ec 0c             	sub    $0xc,%esp
  80406f:	68 20 f3 81 00       	push   $0x81f320
  804074:	e8 c4 12 00 00       	call   80533d <release_uspinlock>
  804079:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80407c:	b8 00 00 00 00       	mov    $0x0,%eax
  804081:	e9 bd 01 00 00       	jmp    804243 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  804086:	83 ec 0c             	sub    $0xc,%esp
  804089:	68 20 f3 81 00       	push   $0x81f320
  80408e:	e8 aa 12 00 00       	call   80533d <release_uspinlock>
  804093:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  804096:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804099:	8b 00                	mov    (%eax),%eax
  80409b:	e9 a3 01 00 00       	jmp    804243 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  8040a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040a3:	8b 50 04             	mov    0x4(%eax),%edx
  8040a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8040a9:	39 c2                	cmp    %eax,%edx
  8040ab:	0f 85 5c 01 00 00    	jne    80420d <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  8040b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040b4:	8b 10                	mov    (%eax),%edx
  8040b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040b9:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  8040bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8040be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040c1:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  8040c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8040c8:	75 17                	jne    8040e1 <sget+0x45b>
  8040ca:	83 ec 04             	sub    $0x4,%esp
  8040cd:	68 18 67 80 00       	push   $0x806718
  8040d2:	68 fe 01 00 00       	push   $0x1fe
  8040d7:	68 cc 66 80 00       	push   $0x8066cc
  8040dc:	e8 89 d6 ff ff       	call   80176a <_panic>
  8040e1:	8b 15 14 f3 81 00    	mov    0x81f314,%edx
  8040e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040ea:	89 50 0c             	mov    %edx,0xc(%eax)
  8040ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8040f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8040f3:	85 c0                	test   %eax,%eax
  8040f5:	74 0d                	je     804104 <sget+0x47e>
  8040f7:	a1 14 f3 81 00       	mov    0x81f314,%eax
  8040fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8040ff:	89 50 08             	mov    %edx,0x8(%eax)
  804102:	eb 08                	jmp    80410c <sget+0x486>
  804104:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804107:	a3 10 f3 81 00       	mov    %eax,0x81f310
  80410c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80410f:	a3 14 f3 81 00       	mov    %eax,0x81f314
  804114:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804117:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80411e:	a1 1c f3 81 00       	mov    0x81f31c,%eax
  804123:	40                   	inc    %eax
  804124:	a3 1c f3 81 00       	mov    %eax,0x81f31c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  804129:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80412d:	75 17                	jne    804146 <sget+0x4c0>
  80412f:	83 ec 04             	sub    $0x4,%esp
  804132:	68 3b 67 80 00       	push   $0x80673b
  804137:	68 ff 01 00 00       	push   $0x1ff
  80413c:	68 cc 66 80 00       	push   $0x8066cc
  804141:	e8 24 d6 ff ff       	call   80176a <_panic>
  804146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804149:	8b 40 08             	mov    0x8(%eax),%eax
  80414c:	85 c0                	test   %eax,%eax
  80414e:	74 11                	je     804161 <sget+0x4db>
  804150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804153:	8b 40 08             	mov    0x8(%eax),%eax
  804156:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804159:	8b 52 0c             	mov    0xc(%edx),%edx
  80415c:	89 50 0c             	mov    %edx,0xc(%eax)
  80415f:	eb 0b                	jmp    80416c <sget+0x4e6>
  804161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804164:	8b 40 0c             	mov    0xc(%eax),%eax
  804167:	a3 04 f3 81 00       	mov    %eax,0x81f304
  80416c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80416f:	8b 40 0c             	mov    0xc(%eax),%eax
  804172:	85 c0                	test   %eax,%eax
  804174:	74 11                	je     804187 <sget+0x501>
  804176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804179:	8b 40 0c             	mov    0xc(%eax),%eax
  80417c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80417f:	8b 52 08             	mov    0x8(%edx),%edx
  804182:	89 50 08             	mov    %edx,0x8(%eax)
  804185:	eb 0b                	jmp    804192 <sget+0x50c>
  804187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80418a:	8b 40 08             	mov    0x8(%eax),%eax
  80418d:	a3 00 f3 81 00       	mov    %eax,0x81f300
  804192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804195:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80419c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80419f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8041a6:	a1 0c f3 81 00       	mov    0x81f30c,%eax
  8041ab:	48                   	dec    %eax
  8041ac:	a3 0c f3 81 00       	mov    %eax,0x81f30c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  8041b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041b4:	8b 00                	mov    (%eax),%eax
  8041b6:	83 ec 04             	sub    $0x4,%esp
  8041b9:	50                   	push   %eax
  8041ba:	ff 75 0c             	pushl  0xc(%ebp)
  8041bd:	ff 75 08             	pushl  0x8(%ebp)
  8041c0:	e8 fd 02 00 00       	call   8044c2 <sys_get_shared_object>
  8041c5:	83 c4 10             	add    $0x10,%esp
  8041c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  8041cb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8041cf:	79 25                	jns    8041f6 <sget+0x570>
						free_block(allocblock);
  8041d1:	83 ec 0c             	sub    $0xc,%esp
  8041d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8041d7:	e8 3d 0d 00 00       	call   804f19 <free_block>
  8041dc:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8041df:	83 ec 0c             	sub    $0xc,%esp
  8041e2:	68 20 f3 81 00       	push   $0x81f320
  8041e7:	e8 51 11 00 00       	call   80533d <release_uspinlock>
  8041ec:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8041ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8041f4:	eb 4d                	jmp    804243 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  8041f6:	83 ec 0c             	sub    $0xc,%esp
  8041f9:	68 20 f3 81 00       	push   $0x81f320
  8041fe:	e8 3a 11 00 00       	call   80533d <release_uspinlock>
  804203:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  804206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804209:	8b 00                	mov    (%eax),%eax
  80420b:	eb 36                	jmp    804243 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  80420d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804210:	8b 40 08             	mov    0x8(%eax),%eax
  804213:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  804216:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80421a:	0f 85 4b fc ff ff    	jne    803e6b <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  804220:	83 ec 0c             	sub    $0xc,%esp
  804223:	ff 75 e0             	pushl  -0x20(%ebp)
  804226:	e8 ee 0c 00 00       	call   804f19 <free_block>
  80422b:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  80422e:	83 ec 0c             	sub    $0xc,%esp
  804231:	68 20 f3 81 00       	push   $0x81f320
  804236:	e8 02 11 00 00       	call   80533d <release_uspinlock>
  80423b:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80423e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  804243:	c9                   	leave  
  804244:	c3                   	ret    

00804245 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  804245:	55                   	push   %ebp
  804246:	89 e5                	mov    %esp,%ebp
  804248:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80424b:	e8 cd e6 ff ff       	call   80291d <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  804250:	83 ec 04             	sub    $0x4,%esp
  804253:	68 ec 67 80 00       	push   $0x8067ec
  804258:	68 2d 02 00 00       	push   $0x22d
  80425d:	68 cc 66 80 00       	push   $0x8066cc
  804262:	e8 03 d5 ff ff       	call   80176a <_panic>

00804267 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  804267:	55                   	push   %ebp
  804268:	89 e5                	mov    %esp,%ebp
  80426a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80426d:	83 ec 04             	sub    $0x4,%esp
  804270:	68 14 68 80 00       	push   $0x806814
  804275:	68 40 02 00 00       	push   $0x240
  80427a:	68 cc 66 80 00       	push   $0x8066cc
  80427f:	e8 e6 d4 ff ff       	call   80176a <_panic>

00804284 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  804284:	55                   	push   %ebp
  804285:	89 e5                	mov    %esp,%ebp
  804287:	57                   	push   %edi
  804288:	56                   	push   %esi
  804289:	53                   	push   %ebx
  80428a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80428d:	8b 45 08             	mov    0x8(%ebp),%eax
  804290:	8b 55 0c             	mov    0xc(%ebp),%edx
  804293:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804296:	8b 5d 14             	mov    0x14(%ebp),%ebx
  804299:	8b 7d 18             	mov    0x18(%ebp),%edi
  80429c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80429f:	cd 30                	int    $0x30
  8042a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  8042a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8042a7:	83 c4 10             	add    $0x10,%esp
  8042aa:	5b                   	pop    %ebx
  8042ab:	5e                   	pop    %esi
  8042ac:	5f                   	pop    %edi
  8042ad:	5d                   	pop    %ebp
  8042ae:	c3                   	ret    

008042af <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  8042af:	55                   	push   %ebp
  8042b0:	89 e5                	mov    %esp,%ebp
  8042b2:	83 ec 04             	sub    $0x4,%esp
  8042b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8042b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  8042bb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8042be:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8042c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8042c5:	6a 00                	push   $0x0
  8042c7:	51                   	push   %ecx
  8042c8:	52                   	push   %edx
  8042c9:	ff 75 0c             	pushl  0xc(%ebp)
  8042cc:	50                   	push   %eax
  8042cd:	6a 00                	push   $0x0
  8042cf:	e8 b0 ff ff ff       	call   804284 <syscall>
  8042d4:	83 c4 18             	add    $0x18,%esp
}
  8042d7:	90                   	nop
  8042d8:	c9                   	leave  
  8042d9:	c3                   	ret    

008042da <sys_cgetc>:

int
sys_cgetc(void)
{
  8042da:	55                   	push   %ebp
  8042db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8042dd:	6a 00                	push   $0x0
  8042df:	6a 00                	push   $0x0
  8042e1:	6a 00                	push   $0x0
  8042e3:	6a 00                	push   $0x0
  8042e5:	6a 00                	push   $0x0
  8042e7:	6a 02                	push   $0x2
  8042e9:	e8 96 ff ff ff       	call   804284 <syscall>
  8042ee:	83 c4 18             	add    $0x18,%esp
}
  8042f1:	c9                   	leave  
  8042f2:	c3                   	ret    

008042f3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8042f3:	55                   	push   %ebp
  8042f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8042f6:	6a 00                	push   $0x0
  8042f8:	6a 00                	push   $0x0
  8042fa:	6a 00                	push   $0x0
  8042fc:	6a 00                	push   $0x0
  8042fe:	6a 00                	push   $0x0
  804300:	6a 03                	push   $0x3
  804302:	e8 7d ff ff ff       	call   804284 <syscall>
  804307:	83 c4 18             	add    $0x18,%esp
}
  80430a:	90                   	nop
  80430b:	c9                   	leave  
  80430c:	c3                   	ret    

0080430d <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  80430d:	55                   	push   %ebp
  80430e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  804310:	6a 00                	push   $0x0
  804312:	6a 00                	push   $0x0
  804314:	6a 00                	push   $0x0
  804316:	6a 00                	push   $0x0
  804318:	6a 00                	push   $0x0
  80431a:	6a 04                	push   $0x4
  80431c:	e8 63 ff ff ff       	call   804284 <syscall>
  804321:	83 c4 18             	add    $0x18,%esp
}
  804324:	90                   	nop
  804325:	c9                   	leave  
  804326:	c3                   	ret    

00804327 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  804327:	55                   	push   %ebp
  804328:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80432a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80432d:	8b 45 08             	mov    0x8(%ebp),%eax
  804330:	6a 00                	push   $0x0
  804332:	6a 00                	push   $0x0
  804334:	6a 00                	push   $0x0
  804336:	52                   	push   %edx
  804337:	50                   	push   %eax
  804338:	6a 08                	push   $0x8
  80433a:	e8 45 ff ff ff       	call   804284 <syscall>
  80433f:	83 c4 18             	add    $0x18,%esp
}
  804342:	c9                   	leave  
  804343:	c3                   	ret    

00804344 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  804344:	55                   	push   %ebp
  804345:	89 e5                	mov    %esp,%ebp
  804347:	56                   	push   %esi
  804348:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  804349:	8b 75 18             	mov    0x18(%ebp),%esi
  80434c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80434f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  804352:	8b 55 0c             	mov    0xc(%ebp),%edx
  804355:	8b 45 08             	mov    0x8(%ebp),%eax
  804358:	56                   	push   %esi
  804359:	53                   	push   %ebx
  80435a:	51                   	push   %ecx
  80435b:	52                   	push   %edx
  80435c:	50                   	push   %eax
  80435d:	6a 09                	push   $0x9
  80435f:	e8 20 ff ff ff       	call   804284 <syscall>
  804364:	83 c4 18             	add    $0x18,%esp
}
  804367:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80436a:	5b                   	pop    %ebx
  80436b:	5e                   	pop    %esi
  80436c:	5d                   	pop    %ebp
  80436d:	c3                   	ret    

0080436e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80436e:	55                   	push   %ebp
  80436f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  804371:	6a 00                	push   $0x0
  804373:	6a 00                	push   $0x0
  804375:	6a 00                	push   $0x0
  804377:	6a 00                	push   $0x0
  804379:	ff 75 08             	pushl  0x8(%ebp)
  80437c:	6a 0a                	push   $0xa
  80437e:	e8 01 ff ff ff       	call   804284 <syscall>
  804383:	83 c4 18             	add    $0x18,%esp
}
  804386:	c9                   	leave  
  804387:	c3                   	ret    

00804388 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  804388:	55                   	push   %ebp
  804389:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80438b:	6a 00                	push   $0x0
  80438d:	6a 00                	push   $0x0
  80438f:	6a 00                	push   $0x0
  804391:	ff 75 0c             	pushl  0xc(%ebp)
  804394:	ff 75 08             	pushl  0x8(%ebp)
  804397:	6a 0b                	push   $0xb
  804399:	e8 e6 fe ff ff       	call   804284 <syscall>
  80439e:	83 c4 18             	add    $0x18,%esp
}
  8043a1:	c9                   	leave  
  8043a2:	c3                   	ret    

008043a3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8043a3:	55                   	push   %ebp
  8043a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8043a6:	6a 00                	push   $0x0
  8043a8:	6a 00                	push   $0x0
  8043aa:	6a 00                	push   $0x0
  8043ac:	6a 00                	push   $0x0
  8043ae:	6a 00                	push   $0x0
  8043b0:	6a 0c                	push   $0xc
  8043b2:	e8 cd fe ff ff       	call   804284 <syscall>
  8043b7:	83 c4 18             	add    $0x18,%esp
}
  8043ba:	c9                   	leave  
  8043bb:	c3                   	ret    

008043bc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8043bc:	55                   	push   %ebp
  8043bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8043bf:	6a 00                	push   $0x0
  8043c1:	6a 00                	push   $0x0
  8043c3:	6a 00                	push   $0x0
  8043c5:	6a 00                	push   $0x0
  8043c7:	6a 00                	push   $0x0
  8043c9:	6a 0d                	push   $0xd
  8043cb:	e8 b4 fe ff ff       	call   804284 <syscall>
  8043d0:	83 c4 18             	add    $0x18,%esp
}
  8043d3:	c9                   	leave  
  8043d4:	c3                   	ret    

008043d5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8043d5:	55                   	push   %ebp
  8043d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8043d8:	6a 00                	push   $0x0
  8043da:	6a 00                	push   $0x0
  8043dc:	6a 00                	push   $0x0
  8043de:	6a 00                	push   $0x0
  8043e0:	6a 00                	push   $0x0
  8043e2:	6a 0e                	push   $0xe
  8043e4:	e8 9b fe ff ff       	call   804284 <syscall>
  8043e9:	83 c4 18             	add    $0x18,%esp
}
  8043ec:	c9                   	leave  
  8043ed:	c3                   	ret    

008043ee <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8043ee:	55                   	push   %ebp
  8043ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8043f1:	6a 00                	push   $0x0
  8043f3:	6a 00                	push   $0x0
  8043f5:	6a 00                	push   $0x0
  8043f7:	6a 00                	push   $0x0
  8043f9:	6a 00                	push   $0x0
  8043fb:	6a 0f                	push   $0xf
  8043fd:	e8 82 fe ff ff       	call   804284 <syscall>
  804402:	83 c4 18             	add    $0x18,%esp
}
  804405:	c9                   	leave  
  804406:	c3                   	ret    

00804407 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  804407:	55                   	push   %ebp
  804408:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80440a:	6a 00                	push   $0x0
  80440c:	6a 00                	push   $0x0
  80440e:	6a 00                	push   $0x0
  804410:	6a 00                	push   $0x0
  804412:	ff 75 08             	pushl  0x8(%ebp)
  804415:	6a 10                	push   $0x10
  804417:	e8 68 fe ff ff       	call   804284 <syscall>
  80441c:	83 c4 18             	add    $0x18,%esp
}
  80441f:	c9                   	leave  
  804420:	c3                   	ret    

00804421 <sys_scarce_memory>:

void sys_scarce_memory()
{
  804421:	55                   	push   %ebp
  804422:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  804424:	6a 00                	push   $0x0
  804426:	6a 00                	push   $0x0
  804428:	6a 00                	push   $0x0
  80442a:	6a 00                	push   $0x0
  80442c:	6a 00                	push   $0x0
  80442e:	6a 11                	push   $0x11
  804430:	e8 4f fe ff ff       	call   804284 <syscall>
  804435:	83 c4 18             	add    $0x18,%esp
}
  804438:	90                   	nop
  804439:	c9                   	leave  
  80443a:	c3                   	ret    

0080443b <sys_cputc>:

void
sys_cputc(const char c)
{
  80443b:	55                   	push   %ebp
  80443c:	89 e5                	mov    %esp,%ebp
  80443e:	83 ec 04             	sub    $0x4,%esp
  804441:	8b 45 08             	mov    0x8(%ebp),%eax
  804444:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  804447:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80444b:	6a 00                	push   $0x0
  80444d:	6a 00                	push   $0x0
  80444f:	6a 00                	push   $0x0
  804451:	6a 00                	push   $0x0
  804453:	50                   	push   %eax
  804454:	6a 01                	push   $0x1
  804456:	e8 29 fe ff ff       	call   804284 <syscall>
  80445b:	83 c4 18             	add    $0x18,%esp
}
  80445e:	90                   	nop
  80445f:	c9                   	leave  
  804460:	c3                   	ret    

00804461 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  804461:	55                   	push   %ebp
  804462:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  804464:	6a 00                	push   $0x0
  804466:	6a 00                	push   $0x0
  804468:	6a 00                	push   $0x0
  80446a:	6a 00                	push   $0x0
  80446c:	6a 00                	push   $0x0
  80446e:	6a 14                	push   $0x14
  804470:	e8 0f fe ff ff       	call   804284 <syscall>
  804475:	83 c4 18             	add    $0x18,%esp
}
  804478:	90                   	nop
  804479:	c9                   	leave  
  80447a:	c3                   	ret    

0080447b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80447b:	55                   	push   %ebp
  80447c:	89 e5                	mov    %esp,%ebp
  80447e:	83 ec 04             	sub    $0x4,%esp
  804481:	8b 45 10             	mov    0x10(%ebp),%eax
  804484:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  804487:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80448a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80448e:	8b 45 08             	mov    0x8(%ebp),%eax
  804491:	6a 00                	push   $0x0
  804493:	51                   	push   %ecx
  804494:	52                   	push   %edx
  804495:	ff 75 0c             	pushl  0xc(%ebp)
  804498:	50                   	push   %eax
  804499:	6a 15                	push   $0x15
  80449b:	e8 e4 fd ff ff       	call   804284 <syscall>
  8044a0:	83 c4 18             	add    $0x18,%esp
}
  8044a3:	c9                   	leave  
  8044a4:	c3                   	ret    

008044a5 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8044a5:	55                   	push   %ebp
  8044a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8044a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8044ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8044ae:	6a 00                	push   $0x0
  8044b0:	6a 00                	push   $0x0
  8044b2:	6a 00                	push   $0x0
  8044b4:	52                   	push   %edx
  8044b5:	50                   	push   %eax
  8044b6:	6a 16                	push   $0x16
  8044b8:	e8 c7 fd ff ff       	call   804284 <syscall>
  8044bd:	83 c4 18             	add    $0x18,%esp
}
  8044c0:	c9                   	leave  
  8044c1:	c3                   	ret    

008044c2 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8044c2:	55                   	push   %ebp
  8044c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8044c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8044c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8044cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8044ce:	6a 00                	push   $0x0
  8044d0:	6a 00                	push   $0x0
  8044d2:	51                   	push   %ecx
  8044d3:	52                   	push   %edx
  8044d4:	50                   	push   %eax
  8044d5:	6a 17                	push   $0x17
  8044d7:	e8 a8 fd ff ff       	call   804284 <syscall>
  8044dc:	83 c4 18             	add    $0x18,%esp
}
  8044df:	c9                   	leave  
  8044e0:	c3                   	ret    

008044e1 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8044e1:	55                   	push   %ebp
  8044e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8044e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8044e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8044ea:	6a 00                	push   $0x0
  8044ec:	6a 00                	push   $0x0
  8044ee:	6a 00                	push   $0x0
  8044f0:	52                   	push   %edx
  8044f1:	50                   	push   %eax
  8044f2:	6a 18                	push   $0x18
  8044f4:	e8 8b fd ff ff       	call   804284 <syscall>
  8044f9:	83 c4 18             	add    $0x18,%esp
}
  8044fc:	c9                   	leave  
  8044fd:	c3                   	ret    

008044fe <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8044fe:	55                   	push   %ebp
  8044ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  804501:	8b 45 08             	mov    0x8(%ebp),%eax
  804504:	6a 00                	push   $0x0
  804506:	ff 75 14             	pushl  0x14(%ebp)
  804509:	ff 75 10             	pushl  0x10(%ebp)
  80450c:	ff 75 0c             	pushl  0xc(%ebp)
  80450f:	50                   	push   %eax
  804510:	6a 19                	push   $0x19
  804512:	e8 6d fd ff ff       	call   804284 <syscall>
  804517:	83 c4 18             	add    $0x18,%esp
}
  80451a:	c9                   	leave  
  80451b:	c3                   	ret    

0080451c <sys_run_env>:

void sys_run_env(int32 envId)
{
  80451c:	55                   	push   %ebp
  80451d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80451f:	8b 45 08             	mov    0x8(%ebp),%eax
  804522:	6a 00                	push   $0x0
  804524:	6a 00                	push   $0x0
  804526:	6a 00                	push   $0x0
  804528:	6a 00                	push   $0x0
  80452a:	50                   	push   %eax
  80452b:	6a 1a                	push   $0x1a
  80452d:	e8 52 fd ff ff       	call   804284 <syscall>
  804532:	83 c4 18             	add    $0x18,%esp
}
  804535:	90                   	nop
  804536:	c9                   	leave  
  804537:	c3                   	ret    

00804538 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  804538:	55                   	push   %ebp
  804539:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80453b:	8b 45 08             	mov    0x8(%ebp),%eax
  80453e:	6a 00                	push   $0x0
  804540:	6a 00                	push   $0x0
  804542:	6a 00                	push   $0x0
  804544:	6a 00                	push   $0x0
  804546:	50                   	push   %eax
  804547:	6a 1b                	push   $0x1b
  804549:	e8 36 fd ff ff       	call   804284 <syscall>
  80454e:	83 c4 18             	add    $0x18,%esp
}
  804551:	c9                   	leave  
  804552:	c3                   	ret    

00804553 <sys_getenvid>:

int32 sys_getenvid(void)
{
  804553:	55                   	push   %ebp
  804554:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  804556:	6a 00                	push   $0x0
  804558:	6a 00                	push   $0x0
  80455a:	6a 00                	push   $0x0
  80455c:	6a 00                	push   $0x0
  80455e:	6a 00                	push   $0x0
  804560:	6a 05                	push   $0x5
  804562:	e8 1d fd ff ff       	call   804284 <syscall>
  804567:	83 c4 18             	add    $0x18,%esp
}
  80456a:	c9                   	leave  
  80456b:	c3                   	ret    

0080456c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80456c:	55                   	push   %ebp
  80456d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80456f:	6a 00                	push   $0x0
  804571:	6a 00                	push   $0x0
  804573:	6a 00                	push   $0x0
  804575:	6a 00                	push   $0x0
  804577:	6a 00                	push   $0x0
  804579:	6a 06                	push   $0x6
  80457b:	e8 04 fd ff ff       	call   804284 <syscall>
  804580:	83 c4 18             	add    $0x18,%esp
}
  804583:	c9                   	leave  
  804584:	c3                   	ret    

00804585 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  804585:	55                   	push   %ebp
  804586:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  804588:	6a 00                	push   $0x0
  80458a:	6a 00                	push   $0x0
  80458c:	6a 00                	push   $0x0
  80458e:	6a 00                	push   $0x0
  804590:	6a 00                	push   $0x0
  804592:	6a 07                	push   $0x7
  804594:	e8 eb fc ff ff       	call   804284 <syscall>
  804599:	83 c4 18             	add    $0x18,%esp
}
  80459c:	c9                   	leave  
  80459d:	c3                   	ret    

0080459e <sys_exit_env>:


void sys_exit_env(void)
{
  80459e:	55                   	push   %ebp
  80459f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8045a1:	6a 00                	push   $0x0
  8045a3:	6a 00                	push   $0x0
  8045a5:	6a 00                	push   $0x0
  8045a7:	6a 00                	push   $0x0
  8045a9:	6a 00                	push   $0x0
  8045ab:	6a 1c                	push   $0x1c
  8045ad:	e8 d2 fc ff ff       	call   804284 <syscall>
  8045b2:	83 c4 18             	add    $0x18,%esp
}
  8045b5:	90                   	nop
  8045b6:	c9                   	leave  
  8045b7:	c3                   	ret    

008045b8 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8045b8:	55                   	push   %ebp
  8045b9:	89 e5                	mov    %esp,%ebp
  8045bb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8045be:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8045c1:	8d 50 04             	lea    0x4(%eax),%edx
  8045c4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8045c7:	6a 00                	push   $0x0
  8045c9:	6a 00                	push   $0x0
  8045cb:	6a 00                	push   $0x0
  8045cd:	52                   	push   %edx
  8045ce:	50                   	push   %eax
  8045cf:	6a 1d                	push   $0x1d
  8045d1:	e8 ae fc ff ff       	call   804284 <syscall>
  8045d6:	83 c4 18             	add    $0x18,%esp
	return result;
  8045d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8045dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8045df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8045e2:	89 01                	mov    %eax,(%ecx)
  8045e4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8045e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8045ea:	c9                   	leave  
  8045eb:	c2 04 00             	ret    $0x4

008045ee <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8045ee:	55                   	push   %ebp
  8045ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8045f1:	6a 00                	push   $0x0
  8045f3:	6a 00                	push   $0x0
  8045f5:	ff 75 10             	pushl  0x10(%ebp)
  8045f8:	ff 75 0c             	pushl  0xc(%ebp)
  8045fb:	ff 75 08             	pushl  0x8(%ebp)
  8045fe:	6a 13                	push   $0x13
  804600:	e8 7f fc ff ff       	call   804284 <syscall>
  804605:	83 c4 18             	add    $0x18,%esp
	return ;
  804608:	90                   	nop
}
  804609:	c9                   	leave  
  80460a:	c3                   	ret    

0080460b <sys_rcr2>:
uint32 sys_rcr2()
{
  80460b:	55                   	push   %ebp
  80460c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80460e:	6a 00                	push   $0x0
  804610:	6a 00                	push   $0x0
  804612:	6a 00                	push   $0x0
  804614:	6a 00                	push   $0x0
  804616:	6a 00                	push   $0x0
  804618:	6a 1e                	push   $0x1e
  80461a:	e8 65 fc ff ff       	call   804284 <syscall>
  80461f:	83 c4 18             	add    $0x18,%esp
}
  804622:	c9                   	leave  
  804623:	c3                   	ret    

00804624 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  804624:	55                   	push   %ebp
  804625:	89 e5                	mov    %esp,%ebp
  804627:	83 ec 04             	sub    $0x4,%esp
  80462a:	8b 45 08             	mov    0x8(%ebp),%eax
  80462d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  804630:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  804634:	6a 00                	push   $0x0
  804636:	6a 00                	push   $0x0
  804638:	6a 00                	push   $0x0
  80463a:	6a 00                	push   $0x0
  80463c:	50                   	push   %eax
  80463d:	6a 1f                	push   $0x1f
  80463f:	e8 40 fc ff ff       	call   804284 <syscall>
  804644:	83 c4 18             	add    $0x18,%esp
	return ;
  804647:	90                   	nop
}
  804648:	c9                   	leave  
  804649:	c3                   	ret    

0080464a <rsttst>:
void rsttst()
{
  80464a:	55                   	push   %ebp
  80464b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80464d:	6a 00                	push   $0x0
  80464f:	6a 00                	push   $0x0
  804651:	6a 00                	push   $0x0
  804653:	6a 00                	push   $0x0
  804655:	6a 00                	push   $0x0
  804657:	6a 21                	push   $0x21
  804659:	e8 26 fc ff ff       	call   804284 <syscall>
  80465e:	83 c4 18             	add    $0x18,%esp
	return ;
  804661:	90                   	nop
}
  804662:	c9                   	leave  
  804663:	c3                   	ret    

00804664 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  804664:	55                   	push   %ebp
  804665:	89 e5                	mov    %esp,%ebp
  804667:	83 ec 04             	sub    $0x4,%esp
  80466a:	8b 45 14             	mov    0x14(%ebp),%eax
  80466d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  804670:	8b 55 18             	mov    0x18(%ebp),%edx
  804673:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  804677:	52                   	push   %edx
  804678:	50                   	push   %eax
  804679:	ff 75 10             	pushl  0x10(%ebp)
  80467c:	ff 75 0c             	pushl  0xc(%ebp)
  80467f:	ff 75 08             	pushl  0x8(%ebp)
  804682:	6a 20                	push   $0x20
  804684:	e8 fb fb ff ff       	call   804284 <syscall>
  804689:	83 c4 18             	add    $0x18,%esp
	return ;
  80468c:	90                   	nop
}
  80468d:	c9                   	leave  
  80468e:	c3                   	ret    

0080468f <chktst>:
void chktst(uint32 n)
{
  80468f:	55                   	push   %ebp
  804690:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  804692:	6a 00                	push   $0x0
  804694:	6a 00                	push   $0x0
  804696:	6a 00                	push   $0x0
  804698:	6a 00                	push   $0x0
  80469a:	ff 75 08             	pushl  0x8(%ebp)
  80469d:	6a 22                	push   $0x22
  80469f:	e8 e0 fb ff ff       	call   804284 <syscall>
  8046a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8046a7:	90                   	nop
}
  8046a8:	c9                   	leave  
  8046a9:	c3                   	ret    

008046aa <inctst>:

void inctst()
{
  8046aa:	55                   	push   %ebp
  8046ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8046ad:	6a 00                	push   $0x0
  8046af:	6a 00                	push   $0x0
  8046b1:	6a 00                	push   $0x0
  8046b3:	6a 00                	push   $0x0
  8046b5:	6a 00                	push   $0x0
  8046b7:	6a 23                	push   $0x23
  8046b9:	e8 c6 fb ff ff       	call   804284 <syscall>
  8046be:	83 c4 18             	add    $0x18,%esp
	return ;
  8046c1:	90                   	nop
}
  8046c2:	c9                   	leave  
  8046c3:	c3                   	ret    

008046c4 <gettst>:
uint32 gettst()
{
  8046c4:	55                   	push   %ebp
  8046c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8046c7:	6a 00                	push   $0x0
  8046c9:	6a 00                	push   $0x0
  8046cb:	6a 00                	push   $0x0
  8046cd:	6a 00                	push   $0x0
  8046cf:	6a 00                	push   $0x0
  8046d1:	6a 24                	push   $0x24
  8046d3:	e8 ac fb ff ff       	call   804284 <syscall>
  8046d8:	83 c4 18             	add    $0x18,%esp
}
  8046db:	c9                   	leave  
  8046dc:	c3                   	ret    

008046dd <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8046dd:	55                   	push   %ebp
  8046de:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8046e0:	6a 00                	push   $0x0
  8046e2:	6a 00                	push   $0x0
  8046e4:	6a 00                	push   $0x0
  8046e6:	6a 00                	push   $0x0
  8046e8:	6a 00                	push   $0x0
  8046ea:	6a 25                	push   $0x25
  8046ec:	e8 93 fb ff ff       	call   804284 <syscall>
  8046f1:	83 c4 18             	add    $0x18,%esp
  8046f4:	a3 44 f2 81 00       	mov    %eax,0x81f244
	return uheapPlaceStrategy ;
  8046f9:	a1 44 f2 81 00       	mov    0x81f244,%eax
}
  8046fe:	c9                   	leave  
  8046ff:	c3                   	ret    

00804700 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  804700:	55                   	push   %ebp
  804701:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  804703:	8b 45 08             	mov    0x8(%ebp),%eax
  804706:	a3 44 f2 81 00       	mov    %eax,0x81f244
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80470b:	6a 00                	push   $0x0
  80470d:	6a 00                	push   $0x0
  80470f:	6a 00                	push   $0x0
  804711:	6a 00                	push   $0x0
  804713:	ff 75 08             	pushl  0x8(%ebp)
  804716:	6a 26                	push   $0x26
  804718:	e8 67 fb ff ff       	call   804284 <syscall>
  80471d:	83 c4 18             	add    $0x18,%esp
	return ;
  804720:	90                   	nop
}
  804721:	c9                   	leave  
  804722:	c3                   	ret    

00804723 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  804723:	55                   	push   %ebp
  804724:	89 e5                	mov    %esp,%ebp
  804726:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  804727:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80472a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80472d:	8b 55 0c             	mov    0xc(%ebp),%edx
  804730:	8b 45 08             	mov    0x8(%ebp),%eax
  804733:	6a 00                	push   $0x0
  804735:	53                   	push   %ebx
  804736:	51                   	push   %ecx
  804737:	52                   	push   %edx
  804738:	50                   	push   %eax
  804739:	6a 27                	push   $0x27
  80473b:	e8 44 fb ff ff       	call   804284 <syscall>
  804740:	83 c4 18             	add    $0x18,%esp
}
  804743:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  804746:	c9                   	leave  
  804747:	c3                   	ret    

00804748 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  804748:	55                   	push   %ebp
  804749:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80474b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80474e:	8b 45 08             	mov    0x8(%ebp),%eax
  804751:	6a 00                	push   $0x0
  804753:	6a 00                	push   $0x0
  804755:	6a 00                	push   $0x0
  804757:	52                   	push   %edx
  804758:	50                   	push   %eax
  804759:	6a 28                	push   $0x28
  80475b:	e8 24 fb ff ff       	call   804284 <syscall>
  804760:	83 c4 18             	add    $0x18,%esp
}
  804763:	c9                   	leave  
  804764:	c3                   	ret    

00804765 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  804765:	55                   	push   %ebp
  804766:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  804768:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80476b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80476e:	8b 45 08             	mov    0x8(%ebp),%eax
  804771:	6a 00                	push   $0x0
  804773:	51                   	push   %ecx
  804774:	ff 75 10             	pushl  0x10(%ebp)
  804777:	52                   	push   %edx
  804778:	50                   	push   %eax
  804779:	6a 29                	push   $0x29
  80477b:	e8 04 fb ff ff       	call   804284 <syscall>
  804780:	83 c4 18             	add    $0x18,%esp
}
  804783:	c9                   	leave  
  804784:	c3                   	ret    

00804785 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  804785:	55                   	push   %ebp
  804786:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  804788:	6a 00                	push   $0x0
  80478a:	6a 00                	push   $0x0
  80478c:	ff 75 10             	pushl  0x10(%ebp)
  80478f:	ff 75 0c             	pushl  0xc(%ebp)
  804792:	ff 75 08             	pushl  0x8(%ebp)
  804795:	6a 12                	push   $0x12
  804797:	e8 e8 fa ff ff       	call   804284 <syscall>
  80479c:	83 c4 18             	add    $0x18,%esp
	return ;
  80479f:	90                   	nop
}
  8047a0:	c9                   	leave  
  8047a1:	c3                   	ret    

008047a2 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8047a2:	55                   	push   %ebp
  8047a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8047a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8047a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8047ab:	6a 00                	push   $0x0
  8047ad:	6a 00                	push   $0x0
  8047af:	6a 00                	push   $0x0
  8047b1:	52                   	push   %edx
  8047b2:	50                   	push   %eax
  8047b3:	6a 2a                	push   $0x2a
  8047b5:	e8 ca fa ff ff       	call   804284 <syscall>
  8047ba:	83 c4 18             	add    $0x18,%esp
	return;
  8047bd:	90                   	nop
}
  8047be:	c9                   	leave  
  8047bf:	c3                   	ret    

008047c0 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8047c0:	55                   	push   %ebp
  8047c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8047c3:	6a 00                	push   $0x0
  8047c5:	6a 00                	push   $0x0
  8047c7:	6a 00                	push   $0x0
  8047c9:	6a 00                	push   $0x0
  8047cb:	6a 00                	push   $0x0
  8047cd:	6a 2b                	push   $0x2b
  8047cf:	e8 b0 fa ff ff       	call   804284 <syscall>
  8047d4:	83 c4 18             	add    $0x18,%esp
}
  8047d7:	c9                   	leave  
  8047d8:	c3                   	ret    

008047d9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8047d9:	55                   	push   %ebp
  8047da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8047dc:	6a 00                	push   $0x0
  8047de:	6a 00                	push   $0x0
  8047e0:	6a 00                	push   $0x0
  8047e2:	ff 75 0c             	pushl  0xc(%ebp)
  8047e5:	ff 75 08             	pushl  0x8(%ebp)
  8047e8:	6a 2d                	push   $0x2d
  8047ea:	e8 95 fa ff ff       	call   804284 <syscall>
  8047ef:	83 c4 18             	add    $0x18,%esp
	return;
  8047f2:	90                   	nop
}
  8047f3:	c9                   	leave  
  8047f4:	c3                   	ret    

008047f5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8047f5:	55                   	push   %ebp
  8047f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8047f8:	6a 00                	push   $0x0
  8047fa:	6a 00                	push   $0x0
  8047fc:	6a 00                	push   $0x0
  8047fe:	ff 75 0c             	pushl  0xc(%ebp)
  804801:	ff 75 08             	pushl  0x8(%ebp)
  804804:	6a 2c                	push   $0x2c
  804806:	e8 79 fa ff ff       	call   804284 <syscall>
  80480b:	83 c4 18             	add    $0x18,%esp
	return ;
  80480e:	90                   	nop
}
  80480f:	c9                   	leave  
  804810:	c3                   	ret    

00804811 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  804811:	55                   	push   %ebp
  804812:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  804814:	8b 55 0c             	mov    0xc(%ebp),%edx
  804817:	8b 45 08             	mov    0x8(%ebp),%eax
  80481a:	6a 00                	push   $0x0
  80481c:	6a 00                	push   $0x0
  80481e:	6a 00                	push   $0x0
  804820:	52                   	push   %edx
  804821:	50                   	push   %eax
  804822:	6a 2e                	push   $0x2e
  804824:	e8 5b fa ff ff       	call   804284 <syscall>
  804829:	83 c4 18             	add    $0x18,%esp
	    return;
  80482c:	90                   	nop
}
  80482d:	c9                   	leave  
  80482e:	c3                   	ret    

0080482f <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80482f:	55                   	push   %ebp
  804830:	89 e5                	mov    %esp,%ebp
  804832:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  804835:	8b 45 08             	mov    0x8(%ebp),%eax
  804838:	ba 40 72 80 00       	mov    $0x807240,%edx
  80483d:	29 d0                	sub    %edx,%eax
  80483f:	c1 f8 02             	sar    $0x2,%eax
  804842:	89 c2                	mov    %eax,%edx
  804844:	89 d0                	mov    %edx,%eax
  804846:	c1 e0 02             	shl    $0x2,%eax
  804849:	01 d0                	add    %edx,%eax
  80484b:	c1 e0 02             	shl    $0x2,%eax
  80484e:	01 d0                	add    %edx,%eax
  804850:	c1 e0 02             	shl    $0x2,%eax
  804853:	01 d0                	add    %edx,%eax
  804855:	89 c1                	mov    %eax,%ecx
  804857:	c1 e1 08             	shl    $0x8,%ecx
  80485a:	01 c8                	add    %ecx,%eax
  80485c:	89 c1                	mov    %eax,%ecx
  80485e:	c1 e1 10             	shl    $0x10,%ecx
  804861:	01 c8                	add    %ecx,%eax
  804863:	01 c0                	add    %eax,%eax
  804865:	01 d0                	add    %edx,%eax
  804867:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  80486a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80486d:	c1 e0 0c             	shl    $0xc,%eax
  804870:	89 c2                	mov    %eax,%edx
  804872:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804877:	01 d0                	add    %edx,%eax
}
  804879:	c9                   	leave  
  80487a:	c3                   	ret    

0080487b <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  80487b:	55                   	push   %ebp
  80487c:	89 e5                	mov    %esp,%ebp
  80487e:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  804881:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  804888:	eb 06                	jmp    804890 <log2+0x15>
			n >>=1;
  80488a:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  80488d:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  804890:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  804894:	77 f4                	ja     80488a <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  804896:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  804899:	c9                   	leave  
  80489a:	c3                   	ret    

0080489b <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  80489b:	55                   	push   %ebp
  80489c:	89 e5                	mov    %esp,%ebp
  80489e:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8048a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8048a4:	05 00 00 00 02       	add    $0x2000000,%eax
  8048a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8048ac:	73 16                	jae    8048c4 <initialize_dynamic_allocator+0x29>
  8048ae:	68 38 68 80 00       	push   $0x806838
  8048b3:	68 5e 68 80 00       	push   $0x80685e
  8048b8:	6a 2d                	push   $0x2d
  8048ba:	68 73 68 80 00       	push   $0x806873
  8048bf:	e8 a6 ce ff ff       	call   80176a <_panic>
		is_initialized = 1;
  8048c4:	c7 05 04 72 80 00 01 	movl   $0x1,0x807204
  8048cb:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  8048ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8048d1:	a3 48 f2 81 00       	mov    %eax,0x81f248
	dynAllocEnd= daEnd;
  8048d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8048d9:	a3 20 72 80 00       	mov    %eax,0x807220
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  8048de:	8b 15 20 72 80 00    	mov    0x807220,%edx
  8048e4:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8048e9:	29 c2                	sub    %eax,%edx
  8048eb:	89 d0                	mov    %edx,%eax
  8048ed:	c1 e8 0c             	shr    $0xc,%eax
  8048f0:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  8048f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8048fa:	eb 2f                	jmp    80492b <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  8048fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8048ff:	89 d0                	mov    %edx,%eax
  804901:	01 c0                	add    %eax,%eax
  804903:	01 d0                	add    %edx,%eax
  804905:	c1 e0 02             	shl    $0x2,%eax
  804908:	05 48 72 80 00       	add    $0x807248,%eax
  80490d:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  804912:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804915:	89 d0                	mov    %edx,%eax
  804917:	01 c0                	add    %eax,%eax
  804919:	01 d0                	add    %edx,%eax
  80491b:	c1 e0 02             	shl    $0x2,%eax
  80491e:	05 4a 72 80 00       	add    $0x80724a,%eax
  804923:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  804928:	ff 45 f4             	incl   -0xc(%ebp)
  80492b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80492e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  804931:	7c c9                	jl     8048fc <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  804933:	c7 05 28 72 80 00 00 	movl   $0x0,0x807228
  80493a:	00 00 00 
  80493d:	c7 05 2c 72 80 00 00 	movl   $0x0,0x80722c
  804944:	00 00 00 
  804947:	c7 05 34 72 80 00 00 	movl   $0x0,0x807234
  80494e:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  804951:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804958:	e9 9c 00 00 00       	jmp    8049f9 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80495d:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  804963:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804966:	89 c8                	mov    %ecx,%eax
  804968:	01 c0                	add    %eax,%eax
  80496a:	01 c8                	add    %ecx,%eax
  80496c:	c1 e0 02             	shl    $0x2,%eax
  80496f:	05 44 72 80 00       	add    $0x807244,%eax
  804974:	89 10                	mov    %edx,(%eax)
  804976:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804979:	89 d0                	mov    %edx,%eax
  80497b:	01 c0                	add    %eax,%eax
  80497d:	01 d0                	add    %edx,%eax
  80497f:	c1 e0 02             	shl    $0x2,%eax
  804982:	05 44 72 80 00       	add    $0x807244,%eax
  804987:	8b 00                	mov    (%eax),%eax
  804989:	85 c0                	test   %eax,%eax
  80498b:	74 1b                	je     8049a8 <initialize_dynamic_allocator+0x10d>
  80498d:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  804993:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804996:	89 c8                	mov    %ecx,%eax
  804998:	01 c0                	add    %eax,%eax
  80499a:	01 c8                	add    %ecx,%eax
  80499c:	c1 e0 02             	shl    $0x2,%eax
  80499f:	05 40 72 80 00       	add    $0x807240,%eax
  8049a4:	89 02                	mov    %eax,(%edx)
  8049a6:	eb 16                	jmp    8049be <initialize_dynamic_allocator+0x123>
  8049a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8049ab:	89 d0                	mov    %edx,%eax
  8049ad:	01 c0                	add    %eax,%eax
  8049af:	01 d0                	add    %edx,%eax
  8049b1:	c1 e0 02             	shl    $0x2,%eax
  8049b4:	05 40 72 80 00       	add    $0x807240,%eax
  8049b9:	a3 28 72 80 00       	mov    %eax,0x807228
  8049be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8049c1:	89 d0                	mov    %edx,%eax
  8049c3:	01 c0                	add    %eax,%eax
  8049c5:	01 d0                	add    %edx,%eax
  8049c7:	c1 e0 02             	shl    $0x2,%eax
  8049ca:	05 40 72 80 00       	add    $0x807240,%eax
  8049cf:	a3 2c 72 80 00       	mov    %eax,0x80722c
  8049d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8049d7:	89 d0                	mov    %edx,%eax
  8049d9:	01 c0                	add    %eax,%eax
  8049db:	01 d0                	add    %edx,%eax
  8049dd:	c1 e0 02             	shl    $0x2,%eax
  8049e0:	05 40 72 80 00       	add    $0x807240,%eax
  8049e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8049eb:	a1 34 72 80 00       	mov    0x807234,%eax
  8049f0:	40                   	inc    %eax
  8049f1:	a3 34 72 80 00       	mov    %eax,0x807234
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  8049f6:	ff 45 f0             	incl   -0x10(%ebp)
  8049f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049fc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8049ff:	0f 8c 58 ff ff ff    	jl     80495d <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  804a05:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  804a0c:	eb 36                	jmp    804a44 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  804a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804a11:	c1 e0 04             	shl    $0x4,%eax
  804a14:	05 60 f2 81 00       	add    $0x81f260,%eax
  804a19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804a22:	c1 e0 04             	shl    $0x4,%eax
  804a25:	05 64 f2 81 00       	add    $0x81f264,%eax
  804a2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804a30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804a33:	c1 e0 04             	shl    $0x4,%eax
  804a36:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804a3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  804a41:	ff 45 ec             	incl   -0x14(%ebp)
  804a44:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804a48:	7e c4                	jle    804a0e <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  804a4a:	90                   	nop
  804a4b:	c9                   	leave  
  804a4c:	c3                   	ret    

00804a4d <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  804a4d:	55                   	push   %ebp
  804a4e:	89 e5                	mov    %esp,%ebp
  804a50:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804a53:	8b 55 08             	mov    0x8(%ebp),%edx
  804a56:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804a5b:	29 c2                	sub    %eax,%edx
  804a5d:	89 d0                	mov    %edx,%eax
  804a5f:	c1 e8 0c             	shr    $0xc,%eax
  804a62:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  804a65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804a68:	89 d0                	mov    %edx,%eax
  804a6a:	01 c0                	add    %eax,%eax
  804a6c:	01 d0                	add    %edx,%eax
  804a6e:	c1 e0 02             	shl    $0x2,%eax
  804a71:	05 48 72 80 00       	add    $0x807248,%eax
  804a76:	8b 00                	mov    (%eax),%eax
  804a78:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  804a7b:	c9                   	leave  
  804a7c:	c3                   	ret    

00804a7d <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  804a7d:	55                   	push   %ebp
  804a7e:	89 e5                	mov    %esp,%ebp
  804a80:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  804a83:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  804a8a:	76 16                	jbe    804aa2 <alloc_block+0x25>
  804a8c:	68 8c 68 80 00       	push   $0x80688c
  804a91:	68 5e 68 80 00       	push   $0x80685e
  804a96:	6a 6c                	push   $0x6c
  804a98:	68 73 68 80 00       	push   $0x806873
  804a9d:	e8 c8 cc ff ff       	call   80176a <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  804aa2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804aa6:	75 0a                	jne    804ab2 <alloc_block+0x35>
		return NULL;
  804aa8:	b8 00 00 00 00       	mov    $0x0,%eax
  804aad:	e9 65 04 00 00       	jmp    804f17 <alloc_block+0x49a>
	}
	else if(size<=8){
  804ab2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  804ab6:	77 09                	ja     804ac1 <alloc_block+0x44>
		size=8;
  804ab8:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  804abf:	eb 1f                	jmp    804ae0 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  804ac1:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  804ac8:	eb 08                	jmp    804ad2 <alloc_block+0x55>
			reqsize*=2;
  804aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804acd:	01 c0                	add    %eax,%eax
  804acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  804ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804ad5:	3b 45 08             	cmp    0x8(%ebp),%eax
  804ad8:	72 f0                	jb     804aca <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  804ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804add:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  804ae0:	83 ec 0c             	sub    $0xc,%esp
  804ae3:	ff 75 08             	pushl  0x8(%ebp)
  804ae6:	e8 90 fd ff ff       	call   80487b <log2>
  804aeb:	83 c4 10             	add    $0x10,%esp
  804aee:	83 e8 03             	sub    $0x3,%eax
  804af1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  804af4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804af7:	c1 e0 04             	shl    $0x4,%eax
  804afa:	05 60 f2 81 00       	add    $0x81f260,%eax
  804aff:	8b 00                	mov    (%eax),%eax
  804b01:	85 c0                	test   %eax,%eax
  804b03:	0f 84 fb 00 00 00    	je     804c04 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  804b09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804b0c:	c1 e0 04             	shl    $0x4,%eax
  804b0f:	05 60 f2 81 00       	add    $0x81f260,%eax
  804b14:	8b 00                	mov    (%eax),%eax
  804b16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  804b19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804b1d:	75 17                	jne    804b36 <alloc_block+0xb9>
  804b1f:	83 ec 04             	sub    $0x4,%esp
  804b22:	68 ad 68 80 00       	push   $0x8068ad
  804b27:	68 86 00 00 00       	push   $0x86
  804b2c:	68 73 68 80 00       	push   $0x806873
  804b31:	e8 34 cc ff ff       	call   80176a <_panic>
  804b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b39:	8b 00                	mov    (%eax),%eax
  804b3b:	85 c0                	test   %eax,%eax
  804b3d:	74 10                	je     804b4f <alloc_block+0xd2>
  804b3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b42:	8b 00                	mov    (%eax),%eax
  804b44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804b47:	8b 52 04             	mov    0x4(%edx),%edx
  804b4a:	89 50 04             	mov    %edx,0x4(%eax)
  804b4d:	eb 14                	jmp    804b63 <alloc_block+0xe6>
  804b4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b52:	8b 40 04             	mov    0x4(%eax),%eax
  804b55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804b58:	c1 e2 04             	shl    $0x4,%edx
  804b5b:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804b61:	89 02                	mov    %eax,(%edx)
  804b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b66:	8b 40 04             	mov    0x4(%eax),%eax
  804b69:	85 c0                	test   %eax,%eax
  804b6b:	74 0f                	je     804b7c <alloc_block+0xff>
  804b6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b70:	8b 40 04             	mov    0x4(%eax),%eax
  804b73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804b76:	8b 12                	mov    (%edx),%edx
  804b78:	89 10                	mov    %edx,(%eax)
  804b7a:	eb 13                	jmp    804b8f <alloc_block+0x112>
  804b7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b7f:	8b 00                	mov    (%eax),%eax
  804b81:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804b84:	c1 e2 04             	shl    $0x4,%edx
  804b87:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804b8d:	89 02                	mov    %eax,(%edx)
  804b8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804b98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804b9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804ba2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804ba5:	c1 e0 04             	shl    $0x4,%eax
  804ba8:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804bad:	8b 00                	mov    (%eax),%eax
  804baf:	8d 50 ff             	lea    -0x1(%eax),%edx
  804bb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804bb5:	c1 e0 04             	shl    $0x4,%eax
  804bb8:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804bbd:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804bbf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804bc2:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804bc7:	29 c2                	sub    %eax,%edx
  804bc9:	89 d0                	mov    %edx,%eax
  804bcb:	c1 e8 0c             	shr    $0xc,%eax
  804bce:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  804bd1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804bd4:	89 d0                	mov    %edx,%eax
  804bd6:	01 c0                	add    %eax,%eax
  804bd8:	01 d0                	add    %edx,%eax
  804bda:	c1 e0 02             	shl    $0x2,%eax
  804bdd:	05 4a 72 80 00       	add    $0x80724a,%eax
  804be2:	66 8b 00             	mov    (%eax),%ax
  804be5:	8d 50 ff             	lea    -0x1(%eax),%edx
  804be8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  804beb:	89 c8                	mov    %ecx,%eax
  804bed:	01 c0                	add    %eax,%eax
  804bef:	01 c8                	add    %ecx,%eax
  804bf1:	c1 e0 02             	shl    $0x2,%eax
  804bf4:	05 4a 72 80 00       	add    $0x80724a,%eax
  804bf9:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  804bfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bff:	e9 13 03 00 00       	jmp    804f17 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  804c04:	a1 28 72 80 00       	mov    0x807228,%eax
  804c09:	85 c0                	test   %eax,%eax
  804c0b:	0f 84 c9 01 00 00    	je     804dda <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  804c11:	a1 28 72 80 00       	mov    0x807228,%eax
  804c16:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  804c19:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  804c1d:	75 17                	jne    804c36 <alloc_block+0x1b9>
  804c1f:	83 ec 04             	sub    $0x4,%esp
  804c22:	68 ad 68 80 00       	push   $0x8068ad
  804c27:	68 8f 00 00 00       	push   $0x8f
  804c2c:	68 73 68 80 00       	push   $0x806873
  804c31:	e8 34 cb ff ff       	call   80176a <_panic>
  804c36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804c39:	8b 00                	mov    (%eax),%eax
  804c3b:	85 c0                	test   %eax,%eax
  804c3d:	74 10                	je     804c4f <alloc_block+0x1d2>
  804c3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804c42:	8b 00                	mov    (%eax),%eax
  804c44:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804c47:	8b 52 04             	mov    0x4(%edx),%edx
  804c4a:	89 50 04             	mov    %edx,0x4(%eax)
  804c4d:	eb 0b                	jmp    804c5a <alloc_block+0x1dd>
  804c4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804c52:	8b 40 04             	mov    0x4(%eax),%eax
  804c55:	a3 2c 72 80 00       	mov    %eax,0x80722c
  804c5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804c5d:	8b 40 04             	mov    0x4(%eax),%eax
  804c60:	85 c0                	test   %eax,%eax
  804c62:	74 0f                	je     804c73 <alloc_block+0x1f6>
  804c64:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804c67:	8b 40 04             	mov    0x4(%eax),%eax
  804c6a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804c6d:	8b 12                	mov    (%edx),%edx
  804c6f:	89 10                	mov    %edx,(%eax)
  804c71:	eb 0a                	jmp    804c7d <alloc_block+0x200>
  804c73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804c76:	8b 00                	mov    (%eax),%eax
  804c78:	a3 28 72 80 00       	mov    %eax,0x807228
  804c7d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804c80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804c86:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804c89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804c90:	a1 34 72 80 00       	mov    0x807234,%eax
  804c95:	48                   	dec    %eax
  804c96:	a3 34 72 80 00       	mov    %eax,0x807234
		uint32 page_va = to_page_va(page_info);
  804c9b:	83 ec 0c             	sub    $0xc,%esp
  804c9e:	ff 75 dc             	pushl  -0x24(%ebp)
  804ca1:	e8 89 fb ff ff       	call   80482f <to_page_va>
  804ca6:	83 c4 10             	add    $0x10,%esp
  804ca9:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  804cac:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804cb1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804cb4:	29 c2                	sub    %eax,%edx
  804cb6:	89 d0                	mov    %edx,%eax
  804cb8:	c1 e8 0c             	shr    $0xc,%eax
  804cbb:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  804cbe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804cc1:	83 ec 0c             	sub    $0xc,%esp
  804cc4:	50                   	push   %eax
  804cc5:	e8 fe dc ff ff       	call   8029c8 <get_page>
  804cca:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  804ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  804cd0:	89 c2                	mov    %eax,%edx
  804cd2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804cd5:	89 c8                	mov    %ecx,%eax
  804cd7:	01 c0                	add    %eax,%eax
  804cd9:	01 c8                	add    %ecx,%eax
  804cdb:	c1 e0 02             	shl    $0x2,%eax
  804cde:	05 48 72 80 00       	add    $0x807248,%eax
  804ce3:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  804ce6:	b8 00 10 00 00       	mov    $0x1000,%eax
  804ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  804cf0:	f7 75 08             	divl   0x8(%ebp)
  804cf3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  804cf6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804cf9:	8d 50 ff             	lea    -0x1(%eax),%edx
  804cfc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  804cff:	89 c8                	mov    %ecx,%eax
  804d01:	01 c0                	add    %eax,%eax
  804d03:	01 c8                	add    %ecx,%eax
  804d05:	c1 e0 02             	shl    $0x2,%eax
  804d08:	05 4a 72 80 00       	add    $0x80724a,%eax
  804d0d:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  804d10:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  804d17:	e9 aa 00 00 00       	jmp    804dc6 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  804d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804d1f:	0f af 45 08          	imul   0x8(%ebp),%eax
  804d23:	89 c2                	mov    %eax,%edx
  804d25:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804d28:	01 d0                	add    %edx,%eax
  804d2a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  804d2d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  804d31:	75 17                	jne    804d4a <alloc_block+0x2cd>
  804d33:	83 ec 04             	sub    $0x4,%esp
  804d36:	68 cc 68 80 00       	push   $0x8068cc
  804d3b:	68 9d 00 00 00       	push   $0x9d
  804d40:	68 73 68 80 00       	push   $0x806873
  804d45:	e8 20 ca ff ff       	call   80176a <_panic>
  804d4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804d4d:	c1 e0 04             	shl    $0x4,%eax
  804d50:	05 64 f2 81 00       	add    $0x81f264,%eax
  804d55:	8b 10                	mov    (%eax),%edx
  804d57:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804d5a:	89 50 04             	mov    %edx,0x4(%eax)
  804d5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804d60:	8b 40 04             	mov    0x4(%eax),%eax
  804d63:	85 c0                	test   %eax,%eax
  804d65:	74 14                	je     804d7b <alloc_block+0x2fe>
  804d67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804d6a:	c1 e0 04             	shl    $0x4,%eax
  804d6d:	05 64 f2 81 00       	add    $0x81f264,%eax
  804d72:	8b 00                	mov    (%eax),%eax
  804d74:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804d77:	89 10                	mov    %edx,(%eax)
  804d79:	eb 11                	jmp    804d8c <alloc_block+0x30f>
  804d7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804d7e:	c1 e0 04             	shl    $0x4,%eax
  804d81:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  804d87:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804d8a:	89 02                	mov    %eax,(%edx)
  804d8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804d8f:	c1 e0 04             	shl    $0x4,%eax
  804d92:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  804d98:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804d9b:	89 02                	mov    %eax,(%edx)
  804d9d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804da0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804da6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804da9:	c1 e0 04             	shl    $0x4,%eax
  804dac:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804db1:	8b 00                	mov    (%eax),%eax
  804db3:	8d 50 01             	lea    0x1(%eax),%edx
  804db6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804db9:	c1 e0 04             	shl    $0x4,%eax
  804dbc:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804dc1:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  804dc3:	ff 45 f0             	incl   -0x10(%ebp)
  804dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804dc9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  804dcc:	0f 8c 4a ff ff ff    	jl     804d1c <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  804dd2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804dd5:	e9 3d 01 00 00       	jmp    804f17 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804dda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804ddd:	40                   	inc    %eax
  804dde:	89 45 ec             	mov    %eax,-0x14(%ebp)
  804de1:	e9 10 01 00 00       	jmp    804ef6 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  804de6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804de9:	c1 e0 04             	shl    $0x4,%eax
  804dec:	05 60 f2 81 00       	add    $0x81f260,%eax
  804df1:	8b 00                	mov    (%eax),%eax
  804df3:	85 c0                	test   %eax,%eax
  804df5:	0f 84 f8 00 00 00    	je     804ef3 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  804dfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804dfe:	c1 e0 04             	shl    $0x4,%eax
  804e01:	05 60 f2 81 00       	add    $0x81f260,%eax
  804e06:	8b 00                	mov    (%eax),%eax
  804e08:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  804e0b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  804e0f:	75 17                	jne    804e28 <alloc_block+0x3ab>
  804e11:	83 ec 04             	sub    $0x4,%esp
  804e14:	68 ad 68 80 00       	push   $0x8068ad
  804e19:	68 a8 00 00 00       	push   $0xa8
  804e1e:	68 73 68 80 00       	push   $0x806873
  804e23:	e8 42 c9 ff ff       	call   80176a <_panic>
  804e28:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804e2b:	8b 00                	mov    (%eax),%eax
  804e2d:	85 c0                	test   %eax,%eax
  804e2f:	74 10                	je     804e41 <alloc_block+0x3c4>
  804e31:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804e34:	8b 00                	mov    (%eax),%eax
  804e36:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804e39:	8b 52 04             	mov    0x4(%edx),%edx
  804e3c:	89 50 04             	mov    %edx,0x4(%eax)
  804e3f:	eb 14                	jmp    804e55 <alloc_block+0x3d8>
  804e41:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804e44:	8b 40 04             	mov    0x4(%eax),%eax
  804e47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804e4a:	c1 e2 04             	shl    $0x4,%edx
  804e4d:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  804e53:	89 02                	mov    %eax,(%edx)
  804e55:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804e58:	8b 40 04             	mov    0x4(%eax),%eax
  804e5b:	85 c0                	test   %eax,%eax
  804e5d:	74 0f                	je     804e6e <alloc_block+0x3f1>
  804e5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804e62:	8b 40 04             	mov    0x4(%eax),%eax
  804e65:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804e68:	8b 12                	mov    (%edx),%edx
  804e6a:	89 10                	mov    %edx,(%eax)
  804e6c:	eb 13                	jmp    804e81 <alloc_block+0x404>
  804e6e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804e71:	8b 00                	mov    (%eax),%eax
  804e73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804e76:	c1 e2 04             	shl    $0x4,%edx
  804e79:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  804e7f:	89 02                	mov    %eax,(%edx)
  804e81:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804e84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804e8a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804e8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804e94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804e97:	c1 e0 04             	shl    $0x4,%eax
  804e9a:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804e9f:	8b 00                	mov    (%eax),%eax
  804ea1:	8d 50 ff             	lea    -0x1(%eax),%edx
  804ea4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804ea7:	c1 e0 04             	shl    $0x4,%eax
  804eaa:	05 6c f2 81 00       	add    $0x81f26c,%eax
  804eaf:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804eb1:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804eb4:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804eb9:	29 c2                	sub    %eax,%edx
  804ebb:	89 d0                	mov    %edx,%eax
  804ebd:	c1 e8 0c             	shr    $0xc,%eax
  804ec0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  804ec3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  804ec6:	89 d0                	mov    %edx,%eax
  804ec8:	01 c0                	add    %eax,%eax
  804eca:	01 d0                	add    %edx,%eax
  804ecc:	c1 e0 02             	shl    $0x2,%eax
  804ecf:	05 4a 72 80 00       	add    $0x80724a,%eax
  804ed4:	66 8b 00             	mov    (%eax),%ax
  804ed7:	8d 50 ff             	lea    -0x1(%eax),%edx
  804eda:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  804edd:	89 c8                	mov    %ecx,%eax
  804edf:	01 c0                	add    %eax,%eax
  804ee1:	01 c8                	add    %ecx,%eax
  804ee3:	c1 e0 02             	shl    $0x2,%eax
  804ee6:	05 4a 72 80 00       	add    $0x80724a,%eax
  804eeb:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  804eee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804ef1:	eb 24                	jmp    804f17 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804ef3:	ff 45 ec             	incl   -0x14(%ebp)
  804ef6:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804efa:	0f 8e e6 fe ff ff    	jle    804de6 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  804f00:	83 ec 04             	sub    $0x4,%esp
  804f03:	68 ef 68 80 00       	push   $0x8068ef
  804f08:	68 b1 00 00 00       	push   $0xb1
  804f0d:	68 73 68 80 00       	push   $0x806873
  804f12:	e8 53 c8 ff ff       	call   80176a <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  804f17:	c9                   	leave  
  804f18:	c3                   	ret    

00804f19 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804f19:	55                   	push   %ebp
  804f1a:	89 e5                	mov    %esp,%ebp
  804f1c:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  804f22:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804f27:	39 c2                	cmp    %eax,%edx
  804f29:	72 0c                	jb     804f37 <free_block+0x1e>
  804f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  804f2e:	a1 20 72 80 00       	mov    0x807220,%eax
  804f33:	39 c2                	cmp    %eax,%edx
  804f35:	72 19                	jb     804f50 <free_block+0x37>
  804f37:	68 0c 69 80 00       	push   $0x80690c
  804f3c:	68 5e 68 80 00       	push   $0x80685e
  804f41:	68 c3 00 00 00       	push   $0xc3
  804f46:	68 73 68 80 00       	push   $0x806873
  804f4b:	e8 1a c8 ff ff       	call   80176a <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804f50:	8b 55 08             	mov    0x8(%ebp),%edx
  804f53:	a1 48 f2 81 00       	mov    0x81f248,%eax
  804f58:	29 c2                	sub    %eax,%edx
  804f5a:	89 d0                	mov    %edx,%eax
  804f5c:	c1 e8 0c             	shr    $0xc,%eax
  804f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  804f62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804f65:	89 d0                	mov    %edx,%eax
  804f67:	01 c0                	add    %eax,%eax
  804f69:	01 d0                	add    %edx,%eax
  804f6b:	c1 e0 02             	shl    $0x2,%eax
  804f6e:	05 48 72 80 00       	add    $0x807248,%eax
  804f73:	8b 00                	mov    (%eax),%eax
  804f75:	0f b7 c0             	movzwl %ax,%eax
  804f78:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  804f7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804f7f:	75 17                	jne    804f98 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  804f81:	83 ec 04             	sub    $0x4,%esp
  804f84:	68 44 69 80 00       	push   $0x806944
  804f89:	68 cf 00 00 00       	push   $0xcf
  804f8e:	68 73 68 80 00       	push   $0x806873
  804f93:	e8 d2 c7 ff ff       	call   80176a <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  804f98:	83 ec 0c             	sub    $0xc,%esp
  804f9b:	ff 75 ec             	pushl  -0x14(%ebp)
  804f9e:	e8 d8 f8 ff ff       	call   80487b <log2>
  804fa3:	83 c4 10             	add    $0x10,%esp
  804fa6:	83 e8 03             	sub    $0x3,%eax
  804fa9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  804fac:	8b 45 08             	mov    0x8(%ebp),%eax
  804faf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  804fb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804fb6:	75 17                	jne    804fcf <free_block+0xb6>
  804fb8:	83 ec 04             	sub    $0x4,%esp
  804fbb:	68 cc 68 80 00       	push   $0x8068cc
  804fc0:	68 d5 00 00 00       	push   $0xd5
  804fc5:	68 73 68 80 00       	push   $0x806873
  804fca:	e8 9b c7 ff ff       	call   80176a <_panic>
  804fcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804fd2:	c1 e0 04             	shl    $0x4,%eax
  804fd5:	05 64 f2 81 00       	add    $0x81f264,%eax
  804fda:	8b 10                	mov    (%eax),%edx
  804fdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804fdf:	89 50 04             	mov    %edx,0x4(%eax)
  804fe2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804fe5:	8b 40 04             	mov    0x4(%eax),%eax
  804fe8:	85 c0                	test   %eax,%eax
  804fea:	74 14                	je     805000 <free_block+0xe7>
  804fec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804fef:	c1 e0 04             	shl    $0x4,%eax
  804ff2:	05 64 f2 81 00       	add    $0x81f264,%eax
  804ff7:	8b 00                	mov    (%eax),%eax
  804ff9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804ffc:	89 10                	mov    %edx,(%eax)
  804ffe:	eb 11                	jmp    805011 <free_block+0xf8>
  805000:	8b 45 e8             	mov    -0x18(%ebp),%eax
  805003:	c1 e0 04             	shl    $0x4,%eax
  805006:	8d 90 60 f2 81 00    	lea    0x81f260(%eax),%edx
  80500c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80500f:	89 02                	mov    %eax,(%edx)
  805011:	8b 45 e8             	mov    -0x18(%ebp),%eax
  805014:	c1 e0 04             	shl    $0x4,%eax
  805017:	8d 90 64 f2 81 00    	lea    0x81f264(%eax),%edx
  80501d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  805020:	89 02                	mov    %eax,(%edx)
  805022:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  805025:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80502b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80502e:	c1 e0 04             	shl    $0x4,%eax
  805031:	05 6c f2 81 00       	add    $0x81f26c,%eax
  805036:	8b 00                	mov    (%eax),%eax
  805038:	8d 50 01             	lea    0x1(%eax),%edx
  80503b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80503e:	c1 e0 04             	shl    $0x4,%eax
  805041:	05 6c f2 81 00       	add    $0x81f26c,%eax
  805046:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  805048:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80504b:	89 d0                	mov    %edx,%eax
  80504d:	01 c0                	add    %eax,%eax
  80504f:	01 d0                	add    %edx,%eax
  805051:	c1 e0 02             	shl    $0x2,%eax
  805054:	05 4a 72 80 00       	add    $0x80724a,%eax
  805059:	66 8b 00             	mov    (%eax),%ax
  80505c:	8d 50 01             	lea    0x1(%eax),%edx
  80505f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  805062:	89 c8                	mov    %ecx,%eax
  805064:	01 c0                	add    %eax,%eax
  805066:	01 c8                	add    %ecx,%eax
  805068:	c1 e0 02             	shl    $0x2,%eax
  80506b:	05 4a 72 80 00       	add    $0x80724a,%eax
  805070:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  805073:	b8 00 10 00 00       	mov    $0x1000,%eax
  805078:	ba 00 00 00 00       	mov    $0x0,%edx
  80507d:	f7 75 ec             	divl   -0x14(%ebp)
  805080:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  805083:	8b 55 f0             	mov    -0x10(%ebp),%edx
  805086:	89 d0                	mov    %edx,%eax
  805088:	01 c0                	add    %eax,%eax
  80508a:	01 d0                	add    %edx,%eax
  80508c:	c1 e0 02             	shl    $0x2,%eax
  80508f:	05 4a 72 80 00       	add    $0x80724a,%eax
  805094:	66 8b 00             	mov    (%eax),%ax
  805097:	0f b7 c0             	movzwl %ax,%eax
  80509a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80509d:	0f 85 d3 01 00 00    	jne    805276 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  8050a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8050a6:	c1 e0 04             	shl    $0x4,%eax
  8050a9:	05 60 f2 81 00       	add    $0x81f260,%eax
  8050ae:	8b 00                	mov    (%eax),%eax
  8050b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  8050b3:	e9 f1 00 00 00       	jmp    8051a9 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  8050b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8050bb:	8b 00                	mov    (%eax),%eax
  8050bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  8050c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8050c3:	c1 e0 0c             	shl    $0xc,%eax
  8050c6:	89 c2                	mov    %eax,%edx
  8050c8:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8050cd:	01 d0                	add    %edx,%eax
  8050cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  8050d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8050d5:	40                   	inc    %eax
  8050d6:	c1 e0 0c             	shl    $0xc,%eax
  8050d9:	89 c2                	mov    %eax,%edx
  8050db:	a1 48 f2 81 00       	mov    0x81f248,%eax
  8050e0:	01 d0                	add    %edx,%eax
  8050e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  8050e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8050e8:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8050eb:	0f 82 b8 00 00 00    	jb     8051a9 <free_block+0x290>
  8050f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8050f4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8050f7:	0f 83 ac 00 00 00    	jae    8051a9 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  8050fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  805101:	75 17                	jne    80511a <free_block+0x201>
  805103:	83 ec 04             	sub    $0x4,%esp
  805106:	68 ad 68 80 00       	push   $0x8068ad
  80510b:	68 e2 00 00 00       	push   $0xe2
  805110:	68 73 68 80 00       	push   $0x806873
  805115:	e8 50 c6 ff ff       	call   80176a <_panic>
  80511a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80511d:	8b 00                	mov    (%eax),%eax
  80511f:	85 c0                	test   %eax,%eax
  805121:	74 10                	je     805133 <free_block+0x21a>
  805123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805126:	8b 00                	mov    (%eax),%eax
  805128:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80512b:	8b 52 04             	mov    0x4(%edx),%edx
  80512e:	89 50 04             	mov    %edx,0x4(%eax)
  805131:	eb 14                	jmp    805147 <free_block+0x22e>
  805133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805136:	8b 40 04             	mov    0x4(%eax),%eax
  805139:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80513c:	c1 e2 04             	shl    $0x4,%edx
  80513f:	81 c2 64 f2 81 00    	add    $0x81f264,%edx
  805145:	89 02                	mov    %eax,(%edx)
  805147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80514a:	8b 40 04             	mov    0x4(%eax),%eax
  80514d:	85 c0                	test   %eax,%eax
  80514f:	74 0f                	je     805160 <free_block+0x247>
  805151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805154:	8b 40 04             	mov    0x4(%eax),%eax
  805157:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80515a:	8b 12                	mov    (%edx),%edx
  80515c:	89 10                	mov    %edx,(%eax)
  80515e:	eb 13                	jmp    805173 <free_block+0x25a>
  805160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805163:	8b 00                	mov    (%eax),%eax
  805165:	8b 55 e8             	mov    -0x18(%ebp),%edx
  805168:	c1 e2 04             	shl    $0x4,%edx
  80516b:	81 c2 60 f2 81 00    	add    $0x81f260,%edx
  805171:	89 02                	mov    %eax,(%edx)
  805173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  805176:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80517c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80517f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  805186:	8b 45 e8             	mov    -0x18(%ebp),%eax
  805189:	c1 e0 04             	shl    $0x4,%eax
  80518c:	05 6c f2 81 00       	add    $0x81f26c,%eax
  805191:	8b 00                	mov    (%eax),%eax
  805193:	8d 50 ff             	lea    -0x1(%eax),%edx
  805196:	8b 45 e8             	mov    -0x18(%ebp),%eax
  805199:	c1 e0 04             	shl    $0x4,%eax
  80519c:	05 6c f2 81 00       	add    $0x81f26c,%eax
  8051a1:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  8051a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8051a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  8051a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8051ad:	0f 85 05 ff ff ff    	jne    8050b8 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  8051b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8051b6:	89 d0                	mov    %edx,%eax
  8051b8:	01 c0                	add    %eax,%eax
  8051ba:	01 d0                	add    %edx,%eax
  8051bc:	c1 e0 02             	shl    $0x2,%eax
  8051bf:	05 48 72 80 00       	add    $0x807248,%eax
  8051c4:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  8051c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8051cc:	89 d0                	mov    %edx,%eax
  8051ce:	01 c0                	add    %eax,%eax
  8051d0:	01 d0                	add    %edx,%eax
  8051d2:	c1 e0 02             	shl    $0x2,%eax
  8051d5:	05 4a 72 80 00       	add    $0x80724a,%eax
  8051da:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  8051df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8051e2:	89 d0                	mov    %edx,%eax
  8051e4:	01 c0                	add    %eax,%eax
  8051e6:	01 d0                	add    %edx,%eax
  8051e8:	c1 e0 02             	shl    $0x2,%eax
  8051eb:	05 40 72 80 00       	add    $0x807240,%eax
  8051f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  8051f3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8051f7:	75 17                	jne    805210 <free_block+0x2f7>
  8051f9:	83 ec 04             	sub    $0x4,%esp
  8051fc:	68 cc 68 80 00       	push   $0x8068cc
  805201:	68 eb 00 00 00       	push   $0xeb
  805206:	68 73 68 80 00       	push   $0x806873
  80520b:	e8 5a c5 ff ff       	call   80176a <_panic>
  805210:	8b 15 2c 72 80 00    	mov    0x80722c,%edx
  805216:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805219:	89 50 04             	mov    %edx,0x4(%eax)
  80521c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80521f:	8b 40 04             	mov    0x4(%eax),%eax
  805222:	85 c0                	test   %eax,%eax
  805224:	74 0c                	je     805232 <free_block+0x319>
  805226:	a1 2c 72 80 00       	mov    0x80722c,%eax
  80522b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80522e:	89 10                	mov    %edx,(%eax)
  805230:	eb 08                	jmp    80523a <free_block+0x321>
  805232:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805235:	a3 28 72 80 00       	mov    %eax,0x807228
  80523a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80523d:	a3 2c 72 80 00       	mov    %eax,0x80722c
  805242:	8b 45 d0             	mov    -0x30(%ebp),%eax
  805245:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80524b:	a1 34 72 80 00       	mov    0x807234,%eax
  805250:	40                   	inc    %eax
  805251:	a3 34 72 80 00       	mov    %eax,0x807234
		uint32 page_va = to_page_va(page_info);
  805256:	83 ec 0c             	sub    $0xc,%esp
  805259:	ff 75 d0             	pushl  -0x30(%ebp)
  80525c:	e8 ce f5 ff ff       	call   80482f <to_page_va>
  805261:	83 c4 10             	add    $0x10,%esp
  805264:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  805267:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80526a:	83 ec 0c             	sub    $0xc,%esp
  80526d:	50                   	push   %eax
  80526e:	e8 9e d7 ff ff       	call   802a11 <return_page>
  805273:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  805276:	90                   	nop
  805277:	c9                   	leave  
  805278:	c3                   	ret    

00805279 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  805279:	55                   	push   %ebp
  80527a:	89 e5                	mov    %esp,%ebp
  80527c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80527f:	83 ec 04             	sub    $0x4,%esp
  805282:	68 6c 69 80 00       	push   $0x80696c
  805287:	68 01 01 00 00       	push   $0x101
  80528c:	68 73 68 80 00       	push   $0x806873
  805291:	e8 d4 c4 ff ff       	call   80176a <_panic>

00805296 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  805296:	55                   	push   %ebp
  805297:	89 e5                	mov    %esp,%ebp
  805299:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  80529c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8052a0:	74 1c                	je     8052be <init_uspinlock+0x28>
  8052a2:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  8052a6:	74 16                	je     8052be <init_uspinlock+0x28>
  8052a8:	68 90 69 80 00       	push   $0x806990
  8052ad:	68 af 69 80 00       	push   $0x8069af
  8052b2:	6a 10                	push   $0x10
  8052b4:	68 c4 69 80 00       	push   $0x8069c4
  8052b9:	e8 ac c4 ff ff       	call   80176a <_panic>
	strcpy(lk->name, name);
  8052be:	8b 45 08             	mov    0x8(%ebp),%eax
  8052c1:	83 c0 04             	add    $0x4,%eax
  8052c4:	83 ec 08             	sub    $0x8,%esp
  8052c7:	ff 75 0c             	pushl  0xc(%ebp)
  8052ca:	50                   	push   %eax
  8052cb:	e8 90 ce ff ff       	call   802160 <strcpy>
  8052d0:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  8052d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8052d8:	2b 45 10             	sub    0x10(%ebp),%eax
  8052db:	89 c2                	mov    %eax,%edx
  8052dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8052e0:	89 10                	mov    %edx,(%eax)
}
  8052e2:	90                   	nop
  8052e3:	c9                   	leave  
  8052e4:	c3                   	ret    

008052e5 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  8052e5:	55                   	push   %ebp
  8052e6:	89 e5                	mov    %esp,%ebp
  8052e8:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  8052eb:	90                   	nop
  8052ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8052ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8052f2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  8052f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8052fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8052ff:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  805302:	f0 87 02             	lock xchg %eax,(%edx)
  805305:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  805308:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80530b:	85 c0                	test   %eax,%eax
  80530d:	75 dd                	jne    8052ec <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80530f:	8b 45 08             	mov    0x8(%ebp),%eax
  805312:	8d 48 04             	lea    0x4(%eax),%ecx
  805315:	a1 00 72 80 00       	mov    0x807200,%eax
  80531a:	8d 50 20             	lea    0x20(%eax),%edx
  80531d:	a1 00 72 80 00       	mov    0x807200,%eax
  805322:	8b 40 10             	mov    0x10(%eax),%eax
  805325:	51                   	push   %ecx
  805326:	52                   	push   %edx
  805327:	50                   	push   %eax
  805328:	68 d4 69 80 00       	push   $0x8069d4
  80532d:	e8 06 c7 ff ff       	call   801a38 <cprintf>
  805332:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  805335:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  80533a:	90                   	nop
  80533b:	c9                   	leave  
  80533c:	c3                   	ret    

0080533d <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  80533d:	55                   	push   %ebp
  80533e:	89 e5                	mov    %esp,%ebp
  805340:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  805343:	8b 45 08             	mov    0x8(%ebp),%eax
  805346:	8b 00                	mov    (%eax),%eax
  805348:	85 c0                	test   %eax,%eax
  80534a:	75 18                	jne    805364 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  80534c:	8b 45 08             	mov    0x8(%ebp),%eax
  80534f:	83 c0 04             	add    $0x4,%eax
  805352:	50                   	push   %eax
  805353:	68 f8 69 80 00       	push   $0x8069f8
  805358:	6a 2b                	push   $0x2b
  80535a:	68 c4 69 80 00       	push   $0x8069c4
  80535f:	e8 06 c4 ff ff       	call   80176a <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  805364:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  805369:	8b 45 08             	mov    0x8(%ebp),%eax
  80536c:	8b 55 08             	mov    0x8(%ebp),%edx
  80536f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  805375:	8b 45 08             	mov    0x8(%ebp),%eax
  805378:	8d 48 04             	lea    0x4(%eax),%ecx
  80537b:	a1 00 72 80 00       	mov    0x807200,%eax
  805380:	8d 50 20             	lea    0x20(%eax),%edx
  805383:	a1 00 72 80 00       	mov    0x807200,%eax
  805388:	8b 40 10             	mov    0x10(%eax),%eax
  80538b:	51                   	push   %ecx
  80538c:	52                   	push   %edx
  80538d:	50                   	push   %eax
  80538e:	68 18 6a 80 00       	push   $0x806a18
  805393:	e8 a0 c6 ff ff       	call   801a38 <cprintf>
  805398:	83 c4 10             	add    $0x10,%esp
}
  80539b:	90                   	nop
  80539c:	c9                   	leave  
  80539d:	c3                   	ret    
  80539e:	66 90                	xchg   %ax,%ax

008053a0 <__udivdi3>:
  8053a0:	55                   	push   %ebp
  8053a1:	57                   	push   %edi
  8053a2:	56                   	push   %esi
  8053a3:	53                   	push   %ebx
  8053a4:	83 ec 1c             	sub    $0x1c,%esp
  8053a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8053ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8053af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8053b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8053b7:	89 ca                	mov    %ecx,%edx
  8053b9:	89 f8                	mov    %edi,%eax
  8053bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8053bf:	85 f6                	test   %esi,%esi
  8053c1:	75 2d                	jne    8053f0 <__udivdi3+0x50>
  8053c3:	39 cf                	cmp    %ecx,%edi
  8053c5:	77 65                	ja     80542c <__udivdi3+0x8c>
  8053c7:	89 fd                	mov    %edi,%ebp
  8053c9:	85 ff                	test   %edi,%edi
  8053cb:	75 0b                	jne    8053d8 <__udivdi3+0x38>
  8053cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8053d2:	31 d2                	xor    %edx,%edx
  8053d4:	f7 f7                	div    %edi
  8053d6:	89 c5                	mov    %eax,%ebp
  8053d8:	31 d2                	xor    %edx,%edx
  8053da:	89 c8                	mov    %ecx,%eax
  8053dc:	f7 f5                	div    %ebp
  8053de:	89 c1                	mov    %eax,%ecx
  8053e0:	89 d8                	mov    %ebx,%eax
  8053e2:	f7 f5                	div    %ebp
  8053e4:	89 cf                	mov    %ecx,%edi
  8053e6:	89 fa                	mov    %edi,%edx
  8053e8:	83 c4 1c             	add    $0x1c,%esp
  8053eb:	5b                   	pop    %ebx
  8053ec:	5e                   	pop    %esi
  8053ed:	5f                   	pop    %edi
  8053ee:	5d                   	pop    %ebp
  8053ef:	c3                   	ret    
  8053f0:	39 ce                	cmp    %ecx,%esi
  8053f2:	77 28                	ja     80541c <__udivdi3+0x7c>
  8053f4:	0f bd fe             	bsr    %esi,%edi
  8053f7:	83 f7 1f             	xor    $0x1f,%edi
  8053fa:	75 40                	jne    80543c <__udivdi3+0x9c>
  8053fc:	39 ce                	cmp    %ecx,%esi
  8053fe:	72 0a                	jb     80540a <__udivdi3+0x6a>
  805400:	3b 44 24 08          	cmp    0x8(%esp),%eax
  805404:	0f 87 9e 00 00 00    	ja     8054a8 <__udivdi3+0x108>
  80540a:	b8 01 00 00 00       	mov    $0x1,%eax
  80540f:	89 fa                	mov    %edi,%edx
  805411:	83 c4 1c             	add    $0x1c,%esp
  805414:	5b                   	pop    %ebx
  805415:	5e                   	pop    %esi
  805416:	5f                   	pop    %edi
  805417:	5d                   	pop    %ebp
  805418:	c3                   	ret    
  805419:	8d 76 00             	lea    0x0(%esi),%esi
  80541c:	31 ff                	xor    %edi,%edi
  80541e:	31 c0                	xor    %eax,%eax
  805420:	89 fa                	mov    %edi,%edx
  805422:	83 c4 1c             	add    $0x1c,%esp
  805425:	5b                   	pop    %ebx
  805426:	5e                   	pop    %esi
  805427:	5f                   	pop    %edi
  805428:	5d                   	pop    %ebp
  805429:	c3                   	ret    
  80542a:	66 90                	xchg   %ax,%ax
  80542c:	89 d8                	mov    %ebx,%eax
  80542e:	f7 f7                	div    %edi
  805430:	31 ff                	xor    %edi,%edi
  805432:	89 fa                	mov    %edi,%edx
  805434:	83 c4 1c             	add    $0x1c,%esp
  805437:	5b                   	pop    %ebx
  805438:	5e                   	pop    %esi
  805439:	5f                   	pop    %edi
  80543a:	5d                   	pop    %ebp
  80543b:	c3                   	ret    
  80543c:	bd 20 00 00 00       	mov    $0x20,%ebp
  805441:	89 eb                	mov    %ebp,%ebx
  805443:	29 fb                	sub    %edi,%ebx
  805445:	89 f9                	mov    %edi,%ecx
  805447:	d3 e6                	shl    %cl,%esi
  805449:	89 c5                	mov    %eax,%ebp
  80544b:	88 d9                	mov    %bl,%cl
  80544d:	d3 ed                	shr    %cl,%ebp
  80544f:	89 e9                	mov    %ebp,%ecx
  805451:	09 f1                	or     %esi,%ecx
  805453:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  805457:	89 f9                	mov    %edi,%ecx
  805459:	d3 e0                	shl    %cl,%eax
  80545b:	89 c5                	mov    %eax,%ebp
  80545d:	89 d6                	mov    %edx,%esi
  80545f:	88 d9                	mov    %bl,%cl
  805461:	d3 ee                	shr    %cl,%esi
  805463:	89 f9                	mov    %edi,%ecx
  805465:	d3 e2                	shl    %cl,%edx
  805467:	8b 44 24 08          	mov    0x8(%esp),%eax
  80546b:	88 d9                	mov    %bl,%cl
  80546d:	d3 e8                	shr    %cl,%eax
  80546f:	09 c2                	or     %eax,%edx
  805471:	89 d0                	mov    %edx,%eax
  805473:	89 f2                	mov    %esi,%edx
  805475:	f7 74 24 0c          	divl   0xc(%esp)
  805479:	89 d6                	mov    %edx,%esi
  80547b:	89 c3                	mov    %eax,%ebx
  80547d:	f7 e5                	mul    %ebp
  80547f:	39 d6                	cmp    %edx,%esi
  805481:	72 19                	jb     80549c <__udivdi3+0xfc>
  805483:	74 0b                	je     805490 <__udivdi3+0xf0>
  805485:	89 d8                	mov    %ebx,%eax
  805487:	31 ff                	xor    %edi,%edi
  805489:	e9 58 ff ff ff       	jmp    8053e6 <__udivdi3+0x46>
  80548e:	66 90                	xchg   %ax,%ax
  805490:	8b 54 24 08          	mov    0x8(%esp),%edx
  805494:	89 f9                	mov    %edi,%ecx
  805496:	d3 e2                	shl    %cl,%edx
  805498:	39 c2                	cmp    %eax,%edx
  80549a:	73 e9                	jae    805485 <__udivdi3+0xe5>
  80549c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80549f:	31 ff                	xor    %edi,%edi
  8054a1:	e9 40 ff ff ff       	jmp    8053e6 <__udivdi3+0x46>
  8054a6:	66 90                	xchg   %ax,%ax
  8054a8:	31 c0                	xor    %eax,%eax
  8054aa:	e9 37 ff ff ff       	jmp    8053e6 <__udivdi3+0x46>
  8054af:	90                   	nop

008054b0 <__umoddi3>:
  8054b0:	55                   	push   %ebp
  8054b1:	57                   	push   %edi
  8054b2:	56                   	push   %esi
  8054b3:	53                   	push   %ebx
  8054b4:	83 ec 1c             	sub    $0x1c,%esp
  8054b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8054bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8054bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8054c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8054c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8054cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8054cf:	89 f3                	mov    %esi,%ebx
  8054d1:	89 fa                	mov    %edi,%edx
  8054d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8054d7:	89 34 24             	mov    %esi,(%esp)
  8054da:	85 c0                	test   %eax,%eax
  8054dc:	75 1a                	jne    8054f8 <__umoddi3+0x48>
  8054de:	39 f7                	cmp    %esi,%edi
  8054e0:	0f 86 a2 00 00 00    	jbe    805588 <__umoddi3+0xd8>
  8054e6:	89 c8                	mov    %ecx,%eax
  8054e8:	89 f2                	mov    %esi,%edx
  8054ea:	f7 f7                	div    %edi
  8054ec:	89 d0                	mov    %edx,%eax
  8054ee:	31 d2                	xor    %edx,%edx
  8054f0:	83 c4 1c             	add    $0x1c,%esp
  8054f3:	5b                   	pop    %ebx
  8054f4:	5e                   	pop    %esi
  8054f5:	5f                   	pop    %edi
  8054f6:	5d                   	pop    %ebp
  8054f7:	c3                   	ret    
  8054f8:	39 f0                	cmp    %esi,%eax
  8054fa:	0f 87 ac 00 00 00    	ja     8055ac <__umoddi3+0xfc>
  805500:	0f bd e8             	bsr    %eax,%ebp
  805503:	83 f5 1f             	xor    $0x1f,%ebp
  805506:	0f 84 ac 00 00 00    	je     8055b8 <__umoddi3+0x108>
  80550c:	bf 20 00 00 00       	mov    $0x20,%edi
  805511:	29 ef                	sub    %ebp,%edi
  805513:	89 fe                	mov    %edi,%esi
  805515:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  805519:	89 e9                	mov    %ebp,%ecx
  80551b:	d3 e0                	shl    %cl,%eax
  80551d:	89 d7                	mov    %edx,%edi
  80551f:	89 f1                	mov    %esi,%ecx
  805521:	d3 ef                	shr    %cl,%edi
  805523:	09 c7                	or     %eax,%edi
  805525:	89 e9                	mov    %ebp,%ecx
  805527:	d3 e2                	shl    %cl,%edx
  805529:	89 14 24             	mov    %edx,(%esp)
  80552c:	89 d8                	mov    %ebx,%eax
  80552e:	d3 e0                	shl    %cl,%eax
  805530:	89 c2                	mov    %eax,%edx
  805532:	8b 44 24 08          	mov    0x8(%esp),%eax
  805536:	d3 e0                	shl    %cl,%eax
  805538:	89 44 24 04          	mov    %eax,0x4(%esp)
  80553c:	8b 44 24 08          	mov    0x8(%esp),%eax
  805540:	89 f1                	mov    %esi,%ecx
  805542:	d3 e8                	shr    %cl,%eax
  805544:	09 d0                	or     %edx,%eax
  805546:	d3 eb                	shr    %cl,%ebx
  805548:	89 da                	mov    %ebx,%edx
  80554a:	f7 f7                	div    %edi
  80554c:	89 d3                	mov    %edx,%ebx
  80554e:	f7 24 24             	mull   (%esp)
  805551:	89 c6                	mov    %eax,%esi
  805553:	89 d1                	mov    %edx,%ecx
  805555:	39 d3                	cmp    %edx,%ebx
  805557:	0f 82 87 00 00 00    	jb     8055e4 <__umoddi3+0x134>
  80555d:	0f 84 91 00 00 00    	je     8055f4 <__umoddi3+0x144>
  805563:	8b 54 24 04          	mov    0x4(%esp),%edx
  805567:	29 f2                	sub    %esi,%edx
  805569:	19 cb                	sbb    %ecx,%ebx
  80556b:	89 d8                	mov    %ebx,%eax
  80556d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  805571:	d3 e0                	shl    %cl,%eax
  805573:	89 e9                	mov    %ebp,%ecx
  805575:	d3 ea                	shr    %cl,%edx
  805577:	09 d0                	or     %edx,%eax
  805579:	89 e9                	mov    %ebp,%ecx
  80557b:	d3 eb                	shr    %cl,%ebx
  80557d:	89 da                	mov    %ebx,%edx
  80557f:	83 c4 1c             	add    $0x1c,%esp
  805582:	5b                   	pop    %ebx
  805583:	5e                   	pop    %esi
  805584:	5f                   	pop    %edi
  805585:	5d                   	pop    %ebp
  805586:	c3                   	ret    
  805587:	90                   	nop
  805588:	89 fd                	mov    %edi,%ebp
  80558a:	85 ff                	test   %edi,%edi
  80558c:	75 0b                	jne    805599 <__umoddi3+0xe9>
  80558e:	b8 01 00 00 00       	mov    $0x1,%eax
  805593:	31 d2                	xor    %edx,%edx
  805595:	f7 f7                	div    %edi
  805597:	89 c5                	mov    %eax,%ebp
  805599:	89 f0                	mov    %esi,%eax
  80559b:	31 d2                	xor    %edx,%edx
  80559d:	f7 f5                	div    %ebp
  80559f:	89 c8                	mov    %ecx,%eax
  8055a1:	f7 f5                	div    %ebp
  8055a3:	89 d0                	mov    %edx,%eax
  8055a5:	e9 44 ff ff ff       	jmp    8054ee <__umoddi3+0x3e>
  8055aa:	66 90                	xchg   %ax,%ax
  8055ac:	89 c8                	mov    %ecx,%eax
  8055ae:	89 f2                	mov    %esi,%edx
  8055b0:	83 c4 1c             	add    $0x1c,%esp
  8055b3:	5b                   	pop    %ebx
  8055b4:	5e                   	pop    %esi
  8055b5:	5f                   	pop    %edi
  8055b6:	5d                   	pop    %ebp
  8055b7:	c3                   	ret    
  8055b8:	3b 04 24             	cmp    (%esp),%eax
  8055bb:	72 06                	jb     8055c3 <__umoddi3+0x113>
  8055bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8055c1:	77 0f                	ja     8055d2 <__umoddi3+0x122>
  8055c3:	89 f2                	mov    %esi,%edx
  8055c5:	29 f9                	sub    %edi,%ecx
  8055c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8055cb:	89 14 24             	mov    %edx,(%esp)
  8055ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8055d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8055d6:	8b 14 24             	mov    (%esp),%edx
  8055d9:	83 c4 1c             	add    $0x1c,%esp
  8055dc:	5b                   	pop    %ebx
  8055dd:	5e                   	pop    %esi
  8055de:	5f                   	pop    %edi
  8055df:	5d                   	pop    %ebp
  8055e0:	c3                   	ret    
  8055e1:	8d 76 00             	lea    0x0(%esi),%esi
  8055e4:	2b 04 24             	sub    (%esp),%eax
  8055e7:	19 fa                	sbb    %edi,%edx
  8055e9:	89 d1                	mov    %edx,%ecx
  8055eb:	89 c6                	mov    %eax,%esi
  8055ed:	e9 71 ff ff ff       	jmp    805563 <__umoddi3+0xb3>
  8055f2:	66 90                	xchg   %ax,%ax
  8055f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8055f8:	72 ea                	jb     8055e4 <__umoddi3+0x134>
  8055fa:	89 d9                	mov    %ebx,%ecx
  8055fc:	e9 62 ff ff ff       	jmp    805563 <__umoddi3+0xb3>
