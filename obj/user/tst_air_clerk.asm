
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 5b 07 00 00       	call   800791 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>

extern volatile bool printStats;
void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec dc 01 00 00    	sub    $0x1dc,%esp
	//disable the print of prog stats after finishing
	printStats = 0;
  800044:	c7 05 00 60 80 00 00 	movl   $0x0,0x806000
  80004b:	00 00 00 

	int parentenvID = sys_getparentenvid();
  80004e:	e8 12 37 00 00       	call   803765 <sys_getparentenvid>
  800053:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _isOpened[] = "isOpened";
  800056:	8d 45 ab             	lea    -0x55(%ebp),%eax
  800059:	bb 9f 49 80 00       	mov    $0x80499f,%ebx
  80005e:	ba 09 00 00 00       	mov    $0x9,%edx
  800063:	89 c7                	mov    %eax,%edi
  800065:	89 de                	mov    %ebx,%esi
  800067:	89 d1                	mov    %edx,%ecx
  800069:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _customers[] = "customers";
  80006b:	8d 45 a1             	lea    -0x5f(%ebp),%eax
  80006e:	bb a8 49 80 00       	mov    $0x8049a8,%ebx
  800073:	ba 0a 00 00 00       	mov    $0xa,%edx
  800078:	89 c7                	mov    %eax,%edi
  80007a:	89 de                	mov    %ebx,%esi
  80007c:	89 d1                	mov    %edx,%ecx
  80007e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800080:	8d 45 95             	lea    -0x6b(%ebp),%eax
  800083:	bb b2 49 80 00       	mov    $0x8049b2,%ebx
  800088:	ba 03 00 00 00       	mov    $0x3,%edx
  80008d:	89 c7                	mov    %eax,%edi
  80008f:	89 de                	mov    %ebx,%esi
  800091:	89 d1                	mov    %edx,%ecx
  800093:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800095:	8d 45 86             	lea    -0x7a(%ebp),%eax
  800098:	bb be 49 80 00       	mov    $0x8049be,%ebx
  80009d:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000a2:	89 c7                	mov    %eax,%edi
  8000a4:	89 de                	mov    %ebx,%esi
  8000a6:	89 d1                	mov    %edx,%ecx
  8000a8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000aa:	8d 85 77 ff ff ff    	lea    -0x89(%ebp),%eax
  8000b0:	bb cd 49 80 00       	mov    $0x8049cd,%ebx
  8000b5:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ba:	89 c7                	mov    %eax,%edi
  8000bc:	89 de                	mov    %ebx,%esi
  8000be:	89 d1                	mov    %edx,%ecx
  8000c0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000c2:	8d 85 62 ff ff ff    	lea    -0x9e(%ebp),%eax
  8000c8:	bb dc 49 80 00       	mov    $0x8049dc,%ebx
  8000cd:	ba 15 00 00 00       	mov    $0x15,%edx
  8000d2:	89 c7                	mov    %eax,%edi
  8000d4:	89 de                	mov    %ebx,%esi
  8000d6:	89 d1                	mov    %edx,%ecx
  8000d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000da:	8d 85 4d ff ff ff    	lea    -0xb3(%ebp),%eax
  8000e0:	bb f1 49 80 00       	mov    $0x8049f1,%ebx
  8000e5:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ea:	89 c7                	mov    %eax,%edi
  8000ec:	89 de                	mov    %ebx,%esi
  8000ee:	89 d1                	mov    %edx,%ecx
  8000f0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000f2:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8000f8:	bb 06 4a 80 00       	mov    $0x804a06,%ebx
  8000fd:	ba 11 00 00 00       	mov    $0x11,%edx
  800102:	89 c7                	mov    %eax,%edi
  800104:	89 de                	mov    %ebx,%esi
  800106:	89 d1                	mov    %edx,%ecx
  800108:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80010a:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  800110:	bb 17 4a 80 00       	mov    $0x804a17,%ebx
  800115:	ba 11 00 00 00       	mov    $0x11,%edx
  80011a:	89 c7                	mov    %eax,%edi
  80011c:	89 de                	mov    %ebx,%esi
  80011e:	89 d1                	mov    %edx,%ecx
  800120:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800122:	8d 85 1a ff ff ff    	lea    -0xe6(%ebp),%eax
  800128:	bb 28 4a 80 00       	mov    $0x804a28,%ebx
  80012d:	ba 11 00 00 00       	mov    $0x11,%edx
  800132:	89 c7                	mov    %eax,%edi
  800134:	89 de                	mov    %ebx,%esi
  800136:	89 d1                	mov    %edx,%ecx
  800138:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80013a:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800140:	bb 39 4a 80 00       	mov    $0x804a39,%ebx
  800145:	ba 09 00 00 00       	mov    $0x9,%edx
  80014a:	89 c7                	mov    %eax,%edi
  80014c:	89 de                	mov    %ebx,%esi
  80014e:	89 d1                	mov    %edx,%ecx
  800150:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800152:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  800158:	bb 42 4a 80 00       	mov    $0x804a42,%ebx
  80015d:	ba 0a 00 00 00       	mov    $0xa,%edx
  800162:	89 c7                	mov    %eax,%edi
  800164:	89 de                	mov    %ebx,%esi
  800166:	89 d1                	mov    %edx,%ecx
  800168:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80016a:	8d 85 fc fe ff ff    	lea    -0x104(%ebp),%eax
  800170:	bb 4c 4a 80 00       	mov    $0x804a4c,%ebx
  800175:	ba 0b 00 00 00       	mov    $0xb,%edx
  80017a:	89 c7                	mov    %eax,%edi
  80017c:	89 de                	mov    %ebx,%esi
  80017e:	89 d1                	mov    %edx,%ecx
  800180:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800182:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800188:	bb 57 4a 80 00       	mov    $0x804a57,%ebx
  80018d:	ba 03 00 00 00       	mov    $0x3,%edx
  800192:	89 c7                	mov    %eax,%edi
  800194:	89 de                	mov    %ebx,%esi
  800196:	89 d1                	mov    %edx,%ecx
  800198:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  80019a:	8d 85 e6 fe ff ff    	lea    -0x11a(%ebp),%eax
  8001a0:	bb 63 4a 80 00       	mov    $0x804a63,%ebx
  8001a5:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001aa:	89 c7                	mov    %eax,%edi
  8001ac:	89 de                	mov    %ebx,%esi
  8001ae:	89 d1                	mov    %edx,%ecx
  8001b0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001b2:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  8001b8:	bb 6d 4a 80 00       	mov    $0x804a6d,%ebx
  8001bd:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001c2:	89 c7                	mov    %eax,%edi
  8001c4:	89 de                	mov    %ebx,%esi
  8001c6:	89 d1                	mov    %edx,%ecx
  8001c8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001ca:	c7 85 d6 fe ff ff 63 	movl   $0x72656c63,-0x12a(%ebp)
  8001d1:	6c 65 72 
  8001d4:	66 c7 85 da fe ff ff 	movw   $0x6b,-0x126(%ebp)
  8001db:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001dd:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
  8001e3:	bb 77 4a 80 00       	mov    $0x804a77,%ebx
  8001e8:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001ed:	89 c7                	mov    %eax,%edi
  8001ef:	89 de                	mov    %ebx,%esi
  8001f1:	89 d1                	mov    %edx,%ecx
  8001f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001f5:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8001fb:	bb 85 4a 80 00       	mov    $0x804a85,%ebx
  800200:	ba 0f 00 00 00       	mov    $0xf,%edx
  800205:	89 c7                	mov    %eax,%edi
  800207:	89 de                	mov    %ebx,%esi
  800209:	89 d1                	mov    %edx,%ecx
  80020b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _clerkTerminated[] = "clerkTerminated";
  80020d:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800213:	bb 94 4a 80 00       	mov    $0x804a94,%ebx
  800218:	ba 04 00 00 00       	mov    $0x4,%edx
  80021d:	89 c7                	mov    %eax,%edi
  80021f:	89 de                	mov    %ebx,%esi
  800221:	89 d1                	mov    %edx,%ecx
  800223:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800225:	8d 85 a2 fe ff ff    	lea    -0x15e(%ebp),%eax
  80022b:	bb a4 4a 80 00       	mov    $0x804aa4,%ebx
  800230:	ba 07 00 00 00       	mov    $0x7,%edx
  800235:	89 c7                	mov    %eax,%edi
  800237:	89 de                	mov    %ebx,%esi
  800239:	89 d1                	mov    %edx,%ecx
  80023b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  80023d:	8d 85 9b fe ff ff    	lea    -0x165(%ebp),%eax
  800243:	bb ab 4a 80 00       	mov    $0x804aab,%ebx
  800248:	ba 07 00 00 00       	mov    $0x7,%edx
  80024d:	89 c7                	mov    %eax,%edi
  80024f:	89 de                	mov    %ebx,%esi
  800251:	89 d1                	mov    %edx,%ecx
  800253:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	8d 45 a1             	lea    -0x5f(%ebp),%eax
  80025b:	50                   	push   %eax
  80025c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025f:	e8 02 2c 00 00       	call   802e66 <sget>
  800264:	83 c4 10             	add    $0x10,%esp
  800267:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* isOpened = sget(parentenvID, _isOpened);
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	8d 45 ab             	lea    -0x55(%ebp),%eax
  800270:	50                   	push   %eax
  800271:	ff 75 e4             	pushl  -0x1c(%ebp)
  800274:	e8 ed 2b 00 00       	call   802e66 <sget>
  800279:	83 c4 10             	add    $0x10,%esp
  80027c:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	8d 45 86             	lea    -0x7a(%ebp),%eax
  800285:	50                   	push   %eax
  800286:	ff 75 e4             	pushl  -0x1c(%ebp)
  800289:	e8 d8 2b 00 00       	call   802e66 <sget>
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	8d 85 77 ff ff ff    	lea    -0x89(%ebp),%eax
  80029d:	50                   	push   %eax
  80029e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a1:	e8 c0 2b 00 00       	call   802e66 <sget>
  8002a6:	83 c4 10             	add    $0x10,%esp
  8002a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	8d 85 62 ff ff ff    	lea    -0x9e(%ebp),%eax
  8002b5:	50                   	push   %eax
  8002b6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b9:	e8 a8 2b 00 00       	call   802e66 <sget>
  8002be:	83 c4 10             	add    $0x10,%esp
  8002c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  8002c4:	83 ec 08             	sub    $0x8,%esp
  8002c7:	8d 85 4d ff ff ff    	lea    -0xb3(%ebp),%eax
  8002cd:	50                   	push   %eax
  8002ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002d1:	e8 90 2b 00 00       	call   802e66 <sget>
  8002d6:	83 c4 10             	add    $0x10,%esp
  8002d9:	89 45 cc             	mov    %eax,-0x34(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  8002dc:	83 ec 08             	sub    $0x8,%esp
  8002df:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
  8002e5:	50                   	push   %eax
  8002e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e9:	e8 78 2b 00 00       	call   802e66 <sget>
  8002ee:	83 c4 10             	add    $0x10,%esp
  8002f1:	89 45 c8             	mov    %eax,-0x38(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002f4:	83 ec 08             	sub    $0x8,%esp
  8002f7:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8002fd:	50                   	push   %eax
  8002fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800301:	e8 60 2b 00 00       	call   802e66 <sget>
  800306:	83 c4 10             	add    $0x10,%esp
  800309:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	8d 85 1a ff ff ff    	lea    -0xe6(%ebp),%eax
  800315:	50                   	push   %eax
  800316:	ff 75 e4             	pushl  -0x1c(%ebp)
  800319:	e8 48 2b 00 00       	call   802e66 <sget>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	89 45 c0             	mov    %eax,-0x40(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  800324:	83 ec 08             	sub    $0x8,%esp
  800327:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80032d:	50                   	push   %eax
  80032e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800331:	e8 30 2b 00 00       	call   802e66 <sget>
  800336:	83 c4 10             	add    $0x10,%esp
  800339:	89 45 bc             	mov    %eax,-0x44(%ebp)
	//cprintf("address of queue_out = %d\n", queue_out);
	// *********************************************************************************

	struct semaphore cust_ready = get_semaphore(parentenvID, _cust_ready);
  80033c:	8d 85 94 fe ff ff    	lea    -0x16c(%ebp),%eax
  800342:	83 ec 04             	sub    $0x4,%esp
  800345:	8d 95 fc fe ff ff    	lea    -0x104(%ebp),%edx
  80034b:	52                   	push   %edx
  80034c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80034f:	50                   	push   %eax
  800350:	e8 3b 41 00 00       	call   804490 <get_semaphore>
  800355:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = get_semaphore(parentenvID, _custQueueCS);
  800358:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  80035e:	83 ec 04             	sub    $0x4,%esp
  800361:	8d 95 f0 fe ff ff    	lea    -0x110(%ebp),%edx
  800367:	52                   	push   %edx
  800368:	ff 75 e4             	pushl  -0x1c(%ebp)
  80036b:	50                   	push   %eax
  80036c:	e8 1f 41 00 00       	call   804490 <get_semaphore>
  800371:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
  800374:	8d 85 8c fe ff ff    	lea    -0x174(%ebp),%eax
  80037a:	83 ec 04             	sub    $0x4,%esp
  80037d:	8d 95 e6 fe ff ff    	lea    -0x11a(%ebp),%edx
  800383:	52                   	push   %edx
  800384:	ff 75 e4             	pushl  -0x1c(%ebp)
  800387:	50                   	push   %eax
  800388:	e8 03 41 00 00       	call   804490 <get_semaphore>
  80038d:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
  800390:	8d 85 88 fe ff ff    	lea    -0x178(%ebp),%eax
  800396:	83 ec 04             	sub    $0x4,%esp
  800399:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  80039f:	52                   	push   %edx
  8003a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	e8 e7 40 00 00       	call   804490 <get_semaphore>
  8003a9:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
  8003ac:	8d 85 84 fe ff ff    	lea    -0x17c(%ebp),%eax
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	8d 95 d6 fe ff ff    	lea    -0x12a(%ebp),%edx
  8003bb:	52                   	push   %edx
  8003bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003bf:	50                   	push   %eax
  8003c0:	e8 cb 40 00 00       	call   804490 <get_semaphore>
  8003c5:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerkTerminated = get_semaphore(parentenvID, _clerkTerminated);
  8003c8:	8d 85 80 fe ff ff    	lea    -0x180(%ebp),%eax
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	8d 95 a9 fe ff ff    	lea    -0x157(%ebp),%edx
  8003d7:	52                   	push   %edx
  8003d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003db:	50                   	push   %eax
  8003dc:	e8 af 40 00 00       	call   804490 <get_semaphore>
  8003e1:	83 c4 0c             	add    $0xc,%esp

	while(*isOpened)
  8003e4:	e9 71 03 00 00       	jmp    80075a <_main+0x722>
	{
		int custId;
		//wait for a customer
		wait_semaphore(cust_ready);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	ff b5 94 fe ff ff    	pushl  -0x16c(%ebp)
  8003f2:	e8 b3 40 00 00       	call   8044aa <wait_semaphore>
  8003f7:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		wait_semaphore(custQueueCS);
  8003fa:	83 ec 0c             	sub    $0xc,%esp
  8003fd:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800403:	e8 a2 40 00 00       	call   8044aa <wait_semaphore>
  800408:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  80040b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80040e:	8b 00                	mov    (%eax),%eax
  800410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800417:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80041a:	01 d0                	add    %edx,%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	89 45 b8             	mov    %eax,-0x48(%ebp)
			//there's no more customers for now...
			if (custId == -1)
  800421:	83 7d b8 ff          	cmpl   $0xffffffff,-0x48(%ebp)
  800425:	75 16                	jne    80043d <_main+0x405>
			{
				signal_semaphore(custQueueCS);
  800427:	83 ec 0c             	sub    $0xc,%esp
  80042a:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800430:	e8 8f 40 00 00       	call   8044c4 <signal_semaphore>
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	e9 1d 03 00 00       	jmp    80075a <_main+0x722>
				continue;
			}
			*queue_out = *queue_out +1;
  80043d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 50 01             	lea    0x1(%eax),%edx
  800445:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800448:	89 10                	mov    %edx,(%eax)
		}
		signal_semaphore(custQueueCS);
  80044a:	83 ec 0c             	sub    $0xc,%esp
  80044d:	ff b5 90 fe ff ff    	pushl  -0x170(%ebp)
  800453:	e8 6c 40 00 00       	call   8044c4 <signal_semaphore>
  800458:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  80045b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80045e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800465:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800468:	01 d0                	add    %edx,%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  80046f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800472:	83 f8 02             	cmp    $0x2,%eax
  800475:	0f 84 9d 00 00 00    	je     800518 <_main+0x4e0>
  80047b:	83 f8 03             	cmp    $0x3,%eax
  80047e:	0f 84 1f 01 00 00    	je     8005a3 <_main+0x56b>
  800484:	83 f8 01             	cmp    $0x1,%eax
  800487:	0f 85 17 02 00 00    	jne    8006a4 <_main+0x66c>
		{
		case 1:
		{
			//Check and update Flight1
			wait_semaphore(flight1CS);
  80048d:	83 ec 0c             	sub    $0xc,%esp
  800490:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  800496:	e8 0f 40 00 00       	call   8044aa <wait_semaphore>
  80049b:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  80049e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	85 c0                	test   %eax,%eax
  8004a5:	7e 48                	jle    8004ef <_main+0x4b7>
				{
					*flight1Counter = *flight1Counter - 1;
  8004a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004af:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b2:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8004b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8004ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004d9:	01 c2                	add    %eax,%edx
  8004db:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004de:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8004e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e3:	8b 00                	mov    (%eax),%eax
  8004e5:	8d 50 01             	lea    0x1(%eax),%edx
  8004e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004eb:	89 10                	mov    %edx,(%eax)
  8004ed:	eb 13                	jmp    800502 <_main+0x4ca>
				}
				else
				{
					cprintf("%~\nFlight#1 is FULL! Reservation request of customer#%d is rejected\n", custId);
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	ff 75 b8             	pushl  -0x48(%ebp)
  8004f5:	68 60 48 80 00       	push   $0x804860
  8004fa:	e8 19 07 00 00       	call   800c18 <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight1CS);
  800502:	83 ec 0c             	sub    $0xc,%esp
  800505:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  80050b:	e8 b4 3f 00 00       	call   8044c4 <signal_semaphore>
  800510:	83 c4 10             	add    $0x10,%esp
		}

		break;
  800513:	e9 a3 01 00 00       	jmp    8006bb <_main+0x683>
		case 2:
		{
			//Check and update Flight2
			wait_semaphore(flight2CS);
  800518:	83 ec 0c             	sub    $0xc,%esp
  80051b:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  800521:	e8 84 3f 00 00       	call   8044aa <wait_semaphore>
  800526:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800529:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	85 c0                	test   %eax,%eax
  800530:	7e 48                	jle    80057a <_main+0x542>
				{
					*flight2Counter = *flight2Counter - 1;
  800532:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800535:	8b 00                	mov    (%eax),%eax
  800537:	8d 50 ff             	lea    -0x1(%eax),%edx
  80053a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80053d:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  80053f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800542:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800549:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054c:	01 d0                	add    %edx,%eax
  80054e:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800555:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800561:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800564:	01 c2                	add    %eax,%edx
  800566:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800569:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80056b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	8d 50 01             	lea    0x1(%eax),%edx
  800573:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800576:	89 10                	mov    %edx,(%eax)
  800578:	eb 13                	jmp    80058d <_main+0x555>
				}
				else
				{
					cprintf("%~\nFlight#2 is FULL! Reservation request of customer#%d is rejected\n", custId);
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	ff 75 b8             	pushl  -0x48(%ebp)
  800580:	68 a8 48 80 00       	push   $0x8048a8
  800585:	e8 8e 06 00 00       	call   800c18 <cprintf>
  80058a:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight2CS);
  80058d:	83 ec 0c             	sub    $0xc,%esp
  800590:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  800596:	e8 29 3f 00 00       	call   8044c4 <signal_semaphore>
  80059b:	83 c4 10             	add    $0x10,%esp
		}
		break;
  80059e:	e9 18 01 00 00       	jmp    8006bb <_main+0x683>
		case 3:
		{
			//Check and update Both Flights
			wait_semaphore(flight1CS); wait_semaphore(flight2CS);
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  8005ac:	e8 f9 3e 00 00       	call   8044aa <wait_semaphore>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  8005bd:	e8 e8 3e 00 00       	call   8044aa <wait_semaphore>
  8005c2:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  8005c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	85 c0                	test   %eax,%eax
  8005cc:	0f 8e 9b 00 00 00    	jle    80066d <_main+0x635>
  8005d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005d5:	8b 00                	mov    (%eax),%eax
  8005d7:	85 c0                	test   %eax,%eax
  8005d9:	0f 8e 8e 00 00 00    	jle    80066d <_main+0x635>
				{
					*flight1Counter = *flight1Counter - 1;
  8005df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8005e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005ea:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8005ec:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8005ef:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f9:	01 d0                	add    %edx,%eax
  8005fb:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  800602:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800605:	8b 00                	mov    (%eax),%eax
  800607:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800611:	01 c2                	add    %eax,%edx
  800613:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800616:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  800618:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	8d 50 01             	lea    0x1(%eax),%edx
  800620:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800623:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  800625:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80062d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800630:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800632:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800635:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80063c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80063f:	01 d0                	add    %edx,%eax
  800641:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800648:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800654:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800657:	01 c2                	add    %eax,%edx
  800659:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80065c:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80065e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	8d 50 01             	lea    0x1(%eax),%edx
  800666:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800669:	89 10                	mov    %edx,(%eax)
  80066b:	eb 13                	jmp    800680 <_main+0x648>

				}
				else
				{
					cprintf("%~\nFlight#1 and/or Flight#2 is FULL! Reservation request of customer#%d is rejected\n", custId);
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	ff 75 b8             	pushl  -0x48(%ebp)
  800673:	68 f0 48 80 00       	push   $0x8048f0
  800678:	e8 9b 05 00 00       	call   800c18 <cprintf>
  80067d:	83 c4 10             	add    $0x10,%esp
				}
			}
			signal_semaphore(flight1CS); signal_semaphore(flight2CS);
  800680:	83 ec 0c             	sub    $0xc,%esp
  800683:	ff b5 8c fe ff ff    	pushl  -0x174(%ebp)
  800689:	e8 36 3e 00 00       	call   8044c4 <signal_semaphore>
  80068e:	83 c4 10             	add    $0x10,%esp
  800691:	83 ec 0c             	sub    $0xc,%esp
  800694:	ff b5 88 fe ff ff    	pushl  -0x178(%ebp)
  80069a:	e8 25 3e 00 00       	call   8044c4 <signal_semaphore>
  80069f:	83 c4 10             	add    $0x10,%esp
		}
		break;
  8006a2:	eb 17                	jmp    8006bb <_main+0x683>
		default:
			panic("customer must have flight type\n");
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	68 48 49 80 00       	push   $0x804948
  8006ac:	68 a4 00 00 00       	push   $0xa4
  8006b1:	68 68 49 80 00       	push   $0x804968
  8006b6:	e8 8f 02 00 00       	call   80094a <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  8006bb:	8d 85 62 fe ff ff    	lea    -0x19e(%ebp),%eax
  8006c1:	bb b2 4a 80 00       	mov    $0x804ab2,%ebx
  8006c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8006cb:	89 c7                	mov    %eax,%edi
  8006cd:	89 de                	mov    %ebx,%esi
  8006cf:	89 d1                	mov    %edx,%ecx
  8006d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8006d3:	8d 95 70 fe ff ff    	lea    -0x190(%ebp),%edx
  8006d9:	b9 04 00 00 00       	mov    $0x4,%ecx
  8006de:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e3:	89 d7                	mov    %edx,%edi
  8006e5:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	8d 85 5d fe ff ff    	lea    -0x1a3(%ebp),%eax
  8006f0:	50                   	push   %eax
  8006f1:	ff 75 b8             	pushl  -0x48(%ebp)
  8006f4:	e8 4d 11 00 00       	call   801846 <ltostr>
  8006f9:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8006fc:	83 ec 04             	sub    $0x4,%esp
  8006ff:	8d 85 26 fe ff ff    	lea    -0x1da(%ebp),%eax
  800705:	50                   	push   %eax
  800706:	8d 85 5d fe ff ff    	lea    -0x1a3(%ebp),%eax
  80070c:	50                   	push   %eax
  80070d:	8d 85 62 fe ff ff    	lea    -0x19e(%ebp),%eax
  800713:	50                   	push   %eax
  800714:	e8 06 12 00 00       	call   80191f <strcconcat>
  800719:	83 c4 10             	add    $0x10,%esp
		//sys_signalSemaphore(parentenvID, sname);
		struct semaphore cust_finished = get_semaphore(parentenvID, sname);
  80071c:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  800722:	83 ec 04             	sub    $0x4,%esp
  800725:	8d 95 26 fe ff ff    	lea    -0x1da(%ebp),%edx
  80072b:	52                   	push   %edx
  80072c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80072f:	50                   	push   %eax
  800730:	e8 5b 3d 00 00       	call   804490 <get_semaphore>
  800735:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(cust_finished);
  800738:	83 ec 0c             	sub    $0xc,%esp
  80073b:	ff b5 58 fe ff ff    	pushl  -0x1a8(%ebp)
  800741:	e8 7e 3d 00 00       	call   8044c4 <signal_semaphore>
  800746:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		signal_semaphore(clerk);
  800749:	83 ec 0c             	sub    $0xc,%esp
  80074c:	ff b5 84 fe ff ff    	pushl  -0x17c(%ebp)
  800752:	e8 6d 3d 00 00       	call   8044c4 <signal_semaphore>
  800757:	83 c4 10             	add    $0x10,%esp
	struct semaphore flight1CS = get_semaphore(parentenvID, _flight1CS);
	struct semaphore flight2CS = get_semaphore(parentenvID, _flight2CS);
	struct semaphore clerk = get_semaphore(parentenvID, _clerk);
	struct semaphore clerkTerminated = get_semaphore(parentenvID, _clerkTerminated);

	while(*isOpened)
  80075a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	0f 85 82 fc ff ff    	jne    8003e9 <_main+0x3b1>

		//signal the clerk
		signal_semaphore(clerk);
	}

	cprintf("\nclerk is finished...........\n");
  800767:	83 ec 0c             	sub    $0xc,%esp
  80076a:	68 80 49 80 00       	push   $0x804980
  80076f:	e8 a4 04 00 00       	call   800c18 <cprintf>
  800774:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(clerkTerminated);
  800777:	83 ec 0c             	sub    $0xc,%esp
  80077a:	ff b5 80 fe ff ff    	pushl  -0x180(%ebp)
  800780:	e8 3f 3d 00 00       	call   8044c4 <signal_semaphore>
  800785:	83 c4 10             	add    $0x10,%esp
}
  800788:	90                   	nop
  800789:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078c:	5b                   	pop    %ebx
  80078d:	5e                   	pop    %esi
  80078e:	5f                   	pop    %edi
  80078f:	5d                   	pop    %ebp
  800790:	c3                   	ret    

00800791 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	57                   	push   %edi
  800795:	56                   	push   %esi
  800796:	53                   	push   %ebx
  800797:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80079a:	e8 ad 2f 00 00       	call   80374c <sys_getenvindex>
  80079f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  8007a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007a5:	89 d0                	mov    %edx,%eax
  8007a7:	c1 e0 02             	shl    $0x2,%eax
  8007aa:	01 d0                	add    %edx,%eax
  8007ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007b3:	01 d0                	add    %edx,%eax
  8007b5:	89 c2                	mov    %eax,%edx
  8007b7:	c1 e2 04             	shl    $0x4,%edx
  8007ba:	29 c2                	sub    %eax,%edx
  8007bc:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  8007c3:	89 c2                	mov    %eax,%edx
  8007c5:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  8007cb:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007d0:	a1 20 60 80 00       	mov    0x806020,%eax
  8007d5:	8a 40 20             	mov    0x20(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	74 0d                	je     8007e9 <libmain+0x58>
		binaryname = myEnv->prog_name;
  8007dc:	a1 20 60 80 00       	mov    0x806020,%eax
  8007e1:	83 c0 20             	add    $0x20,%eax
  8007e4:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007ed:	7e 0a                	jle    8007f9 <libmain+0x68>
		binaryname = argv[0];
  8007ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  8007f9:	83 ec 08             	sub    $0x8,%esp
  8007fc:	ff 75 0c             	pushl  0xc(%ebp)
  8007ff:	ff 75 08             	pushl  0x8(%ebp)
  800802:	e8 31 f8 ff ff       	call   800038 <_main>
  800807:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80080a:	a1 00 60 80 00       	mov    0x806000,%eax
  80080f:	85 c0                	test   %eax,%eax
  800811:	0f 84 01 01 00 00    	je     800918 <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  800817:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  80081d:	bb c8 4b 80 00       	mov    $0x804bc8,%ebx
  800822:	ba 0e 00 00 00       	mov    $0xe,%edx
  800827:	89 c7                	mov    %eax,%edi
  800829:	89 de                	mov    %ebx,%esi
  80082b:	89 d1                	mov    %edx,%ecx
  80082d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80082f:	8d 55 8a             	lea    -0x76(%ebp),%edx
  800832:	b9 56 00 00 00       	mov    $0x56,%ecx
  800837:	b0 00                	mov    $0x0,%al
  800839:	89 d7                	mov    %edx,%edi
  80083b:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  80083d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  800844:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	50                   	push   %eax
  80084b:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800851:	50                   	push   %eax
  800852:	e8 2b 31 00 00       	call   803982 <sys_utilities>
  800857:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  80085a:	e8 74 2c 00 00       	call   8034d3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80085f:	83 ec 0c             	sub    $0xc,%esp
  800862:	68 e8 4a 80 00       	push   $0x804ae8
  800867:	e8 ac 03 00 00       	call   800c18 <cprintf>
  80086c:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  80086f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800872:	85 c0                	test   %eax,%eax
  800874:	74 18                	je     80088e <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  800876:	e8 25 31 00 00       	call   8039a0 <sys_get_optimal_num_faults>
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	50                   	push   %eax
  80087f:	68 10 4b 80 00       	push   $0x804b10
  800884:	e8 8f 03 00 00       	call   800c18 <cprintf>
  800889:	83 c4 10             	add    $0x10,%esp
  80088c:	eb 59                	jmp    8008e7 <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80088e:	a1 20 60 80 00       	mov    0x806020,%eax
  800893:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  800899:	a1 20 60 80 00       	mov    0x806020,%eax
  80089e:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8008a4:	83 ec 04             	sub    $0x4,%esp
  8008a7:	52                   	push   %edx
  8008a8:	50                   	push   %eax
  8008a9:	68 34 4b 80 00       	push   $0x804b34
  8008ae:	e8 65 03 00 00       	call   800c18 <cprintf>
  8008b3:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8008b6:	a1 20 60 80 00       	mov    0x806020,%eax
  8008bb:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8008c1:	a1 20 60 80 00       	mov    0x806020,%eax
  8008c6:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  8008cc:	a1 20 60 80 00       	mov    0x806020,%eax
  8008d1:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  8008d7:	51                   	push   %ecx
  8008d8:	52                   	push   %edx
  8008d9:	50                   	push   %eax
  8008da:	68 5c 4b 80 00       	push   $0x804b5c
  8008df:	e8 34 03 00 00       	call   800c18 <cprintf>
  8008e4:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008e7:	a1 20 60 80 00       	mov    0x806020,%eax
  8008ec:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	50                   	push   %eax
  8008f6:	68 b4 4b 80 00       	push   $0x804bb4
  8008fb:	e8 18 03 00 00       	call   800c18 <cprintf>
  800900:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800903:	83 ec 0c             	sub    $0xc,%esp
  800906:	68 e8 4a 80 00       	push   $0x804ae8
  80090b:	e8 08 03 00 00       	call   800c18 <cprintf>
  800910:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800913:	e8 d5 2b 00 00       	call   8034ed <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800918:	e8 1f 00 00 00       	call   80093c <exit>
}
  80091d:	90                   	nop
  80091e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800921:	5b                   	pop    %ebx
  800922:	5e                   	pop    %esi
  800923:	5f                   	pop    %edi
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    

00800926 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80092c:	83 ec 0c             	sub    $0xc,%esp
  80092f:	6a 00                	push   $0x0
  800931:	e8 e2 2d 00 00       	call   803718 <sys_destroy_env>
  800936:	83 c4 10             	add    $0x10,%esp
}
  800939:	90                   	nop
  80093a:	c9                   	leave  
  80093b:	c3                   	ret    

0080093c <exit>:

void
exit(void)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800942:	e8 37 2e 00 00       	call   80377e <sys_exit_env>
}
  800947:	90                   	nop
  800948:	c9                   	leave  
  800949:	c3                   	ret    

0080094a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800950:	8d 45 10             	lea    0x10(%ebp),%eax
  800953:	83 c0 04             	add    $0x4,%eax
  800956:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800959:	a1 18 e1 81 00       	mov    0x81e118,%eax
  80095e:	85 c0                	test   %eax,%eax
  800960:	74 16                	je     800978 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800962:	a1 18 e1 81 00       	mov    0x81e118,%eax
  800967:	83 ec 08             	sub    $0x8,%esp
  80096a:	50                   	push   %eax
  80096b:	68 2c 4c 80 00       	push   $0x804c2c
  800970:	e8 a3 02 00 00       	call   800c18 <cprintf>
  800975:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  800978:	a1 04 60 80 00       	mov    0x806004,%eax
  80097d:	83 ec 0c             	sub    $0xc,%esp
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	ff 75 08             	pushl  0x8(%ebp)
  800986:	50                   	push   %eax
  800987:	68 34 4c 80 00       	push   $0x804c34
  80098c:	6a 74                	push   $0x74
  80098e:	e8 b2 02 00 00       	call   800c45 <cprintf_colored>
  800993:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  800996:	8b 45 10             	mov    0x10(%ebp),%eax
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 f4             	pushl  -0xc(%ebp)
  80099f:	50                   	push   %eax
  8009a0:	e8 04 02 00 00       	call   800ba9 <vcprintf>
  8009a5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	6a 00                	push   $0x0
  8009ad:	68 5c 4c 80 00       	push   $0x804c5c
  8009b2:	e8 f2 01 00 00       	call   800ba9 <vcprintf>
  8009b7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8009ba:	e8 7d ff ff ff       	call   80093c <exit>

	// should not return here
	while (1) ;
  8009bf:	eb fe                	jmp    8009bf <_panic+0x75>

008009c1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8009c7:	a1 20 60 80 00       	mov    0x806020,%eax
  8009cc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	39 c2                	cmp    %eax,%edx
  8009d7:	74 14                	je     8009ed <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8009d9:	83 ec 04             	sub    $0x4,%esp
  8009dc:	68 60 4c 80 00       	push   $0x804c60
  8009e1:	6a 26                	push   $0x26
  8009e3:	68 ac 4c 80 00       	push   $0x804cac
  8009e8:	e8 5d ff ff ff       	call   80094a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009fb:	e9 c5 00 00 00       	jmp    800ac5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a03:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	01 d0                	add    %edx,%eax
  800a0f:	8b 00                	mov    (%eax),%eax
  800a11:	85 c0                	test   %eax,%eax
  800a13:	75 08                	jne    800a1d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800a15:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a18:	e9 a5 00 00 00       	jmp    800ac2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800a1d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a24:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a2b:	eb 69                	jmp    800a96 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a2d:	a1 20 60 80 00       	mov    0x806020,%eax
  800a32:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800a38:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a3b:	89 d0                	mov    %edx,%eax
  800a3d:	01 c0                	add    %eax,%eax
  800a3f:	01 d0                	add    %edx,%eax
  800a41:	c1 e0 03             	shl    $0x3,%eax
  800a44:	01 c8                	add    %ecx,%eax
  800a46:	8a 40 04             	mov    0x4(%eax),%al
  800a49:	84 c0                	test   %al,%al
  800a4b:	75 46                	jne    800a93 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a4d:	a1 20 60 80 00       	mov    0x806020,%eax
  800a52:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800a58:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a5b:	89 d0                	mov    %edx,%eax
  800a5d:	01 c0                	add    %eax,%eax
  800a5f:	01 d0                	add    %edx,%eax
  800a61:	c1 e0 03             	shl    $0x3,%eax
  800a64:	01 c8                	add    %ecx,%eax
  800a66:	8b 00                	mov    (%eax),%eax
  800a68:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a6b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a6e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a73:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a78:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	01 c8                	add    %ecx,%eax
  800a84:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a86:	39 c2                	cmp    %eax,%edx
  800a88:	75 09                	jne    800a93 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800a8a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a91:	eb 15                	jmp    800aa8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a93:	ff 45 e8             	incl   -0x18(%ebp)
  800a96:	a1 20 60 80 00       	mov    0x806020,%eax
  800a9b:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800aa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800aa4:	39 c2                	cmp    %eax,%edx
  800aa6:	77 85                	ja     800a2d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800aa8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800aac:	75 14                	jne    800ac2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	68 b8 4c 80 00       	push   $0x804cb8
  800ab6:	6a 3a                	push   $0x3a
  800ab8:	68 ac 4c 80 00       	push   $0x804cac
  800abd:	e8 88 fe ff ff       	call   80094a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800ac2:	ff 45 f0             	incl   -0x10(%ebp)
  800ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800acb:	0f 8c 2f ff ff ff    	jl     800a00 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800ad1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ad8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800adf:	eb 26                	jmp    800b07 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800ae1:	a1 20 60 80 00       	mov    0x806020,%eax
  800ae6:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  800aec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aef:	89 d0                	mov    %edx,%eax
  800af1:	01 c0                	add    %eax,%eax
  800af3:	01 d0                	add    %edx,%eax
  800af5:	c1 e0 03             	shl    $0x3,%eax
  800af8:	01 c8                	add    %ecx,%eax
  800afa:	8a 40 04             	mov    0x4(%eax),%al
  800afd:	3c 01                	cmp    $0x1,%al
  800aff:	75 03                	jne    800b04 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800b01:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b04:	ff 45 e0             	incl   -0x20(%ebp)
  800b07:	a1 20 60 80 00       	mov    0x806020,%eax
  800b0c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  800b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b15:	39 c2                	cmp    %eax,%edx
  800b17:	77 c8                	ja     800ae1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b1c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b1f:	74 14                	je     800b35 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800b21:	83 ec 04             	sub    $0x4,%esp
  800b24:	68 0c 4d 80 00       	push   $0x804d0c
  800b29:	6a 44                	push   $0x44
  800b2b:	68 ac 4c 80 00       	push   $0x804cac
  800b30:	e8 15 fe ff ff       	call   80094a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b35:	90                   	nop
  800b36:	c9                   	leave  
  800b37:	c3                   	ret    

00800b38 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	53                   	push   %ebx
  800b3c:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	8d 48 01             	lea    0x1(%eax),%ecx
  800b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4a:	89 0a                	mov    %ecx,(%edx)
  800b4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4f:	88 d1                	mov    %dl,%cl
  800b51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b54:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	8b 00                	mov    (%eax),%eax
  800b5d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b62:	75 30                	jne    800b94 <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  800b64:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800b6a:	a0 44 60 80 00       	mov    0x806044,%al
  800b6f:	0f b6 c0             	movzbl %al,%eax
  800b72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b75:	8b 09                	mov    (%ecx),%ecx
  800b77:	89 cb                	mov    %ecx,%ebx
  800b79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b7c:	83 c1 08             	add    $0x8,%ecx
  800b7f:	52                   	push   %edx
  800b80:	50                   	push   %eax
  800b81:	53                   	push   %ebx
  800b82:	51                   	push   %ecx
  800b83:	e8 07 29 00 00       	call   80348f <sys_cputs>
  800b88:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b97:	8b 40 04             	mov    0x4(%eax),%eax
  800b9a:	8d 50 01             	lea    0x1(%eax),%edx
  800b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba0:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ba3:	90                   	nop
  800ba4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ba7:	c9                   	leave  
  800ba8:	c3                   	ret    

00800ba9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bb2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bb9:	00 00 00 
	b.cnt = 0;
  800bbc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800bc3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800bc6:	ff 75 0c             	pushl  0xc(%ebp)
  800bc9:	ff 75 08             	pushl  0x8(%ebp)
  800bcc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bd2:	50                   	push   %eax
  800bd3:	68 38 0b 80 00       	push   $0x800b38
  800bd8:	e8 5a 02 00 00       	call   800e37 <vprintfmt>
  800bdd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  800be0:	8b 15 1c e1 81 00    	mov    0x81e11c,%edx
  800be6:	a0 44 60 80 00       	mov    0x806044,%al
  800beb:	0f b6 c0             	movzbl %al,%eax
  800bee:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  800bf4:	52                   	push   %edx
  800bf5:	50                   	push   %eax
  800bf6:	51                   	push   %ecx
  800bf7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800bfd:	83 c0 08             	add    $0x8,%eax
  800c00:	50                   	push   %eax
  800c01:	e8 89 28 00 00       	call   80348f <sys_cputs>
  800c06:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c09:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
	return b.cnt;
  800c10:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c16:	c9                   	leave  
  800c17:	c3                   	ret    

00800c18 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c1e:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	va_start(ap, fmt);
  800c25:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 f4             	pushl  -0xc(%ebp)
  800c34:	50                   	push   %eax
  800c35:	e8 6f ff ff ff       	call   800ba9 <vcprintf>
  800c3a:	83 c4 10             	add    $0x10,%esp
  800c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c43:	c9                   	leave  
  800c44:	c3                   	ret    

00800c45 <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c4b:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
	curTextClr = (textClr << 8) ; //set text color by the given value
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
  800c55:	c1 e0 08             	shl    $0x8,%eax
  800c58:	a3 1c e1 81 00       	mov    %eax,0x81e11c
	va_start(ap, fmt);
  800c5d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c60:	83 c0 04             	add    $0x4,%eax
  800c63:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c69:	83 ec 08             	sub    $0x8,%esp
  800c6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c6f:	50                   	push   %eax
  800c70:	e8 34 ff ff ff       	call   800ba9 <vcprintf>
  800c75:	83 c4 10             	add    $0x10,%esp
  800c78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  800c7b:	c7 05 1c e1 81 00 00 	movl   $0x700,0x81e11c
  800c82:	07 00 00 

	return cnt;
  800c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c88:	c9                   	leave  
  800c89:	c3                   	ret    

00800c8a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800c90:	e8 3e 28 00 00       	call   8034d3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800c95:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c98:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	83 ec 08             	sub    $0x8,%esp
  800ca1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ca4:	50                   	push   %eax
  800ca5:	e8 ff fe ff ff       	call   800ba9 <vcprintf>
  800caa:	83 c4 10             	add    $0x10,%esp
  800cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800cb0:	e8 38 28 00 00       	call   8034ed <sys_unlock_cons>
	return cnt;
  800cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	53                   	push   %ebx
  800cbe:	83 ec 14             	sub    $0x14,%esp
  800cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ccd:	8b 45 18             	mov    0x18(%ebp),%eax
  800cd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd8:	77 55                	ja     800d2f <printnum+0x75>
  800cda:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cdd:	72 05                	jb     800ce4 <printnum+0x2a>
  800cdf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ce2:	77 4b                	ja     800d2f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ce4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ce7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800cea:	8b 45 18             	mov    0x18(%ebp),%eax
  800ced:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf2:	52                   	push   %edx
  800cf3:	50                   	push   %eax
  800cf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf7:	ff 75 f0             	pushl  -0x10(%ebp)
  800cfa:	e8 f5 38 00 00       	call   8045f4 <__udivdi3>
  800cff:	83 c4 10             	add    $0x10,%esp
  800d02:	83 ec 04             	sub    $0x4,%esp
  800d05:	ff 75 20             	pushl  0x20(%ebp)
  800d08:	53                   	push   %ebx
  800d09:	ff 75 18             	pushl  0x18(%ebp)
  800d0c:	52                   	push   %edx
  800d0d:	50                   	push   %eax
  800d0e:	ff 75 0c             	pushl  0xc(%ebp)
  800d11:	ff 75 08             	pushl  0x8(%ebp)
  800d14:	e8 a1 ff ff ff       	call   800cba <printnum>
  800d19:	83 c4 20             	add    $0x20,%esp
  800d1c:	eb 1a                	jmp    800d38 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d1e:	83 ec 08             	sub    $0x8,%esp
  800d21:	ff 75 0c             	pushl  0xc(%ebp)
  800d24:	ff 75 20             	pushl  0x20(%ebp)
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	ff d0                	call   *%eax
  800d2c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d2f:	ff 4d 1c             	decl   0x1c(%ebp)
  800d32:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d36:	7f e6                	jg     800d1e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d38:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d46:	53                   	push   %ebx
  800d47:	51                   	push   %ecx
  800d48:	52                   	push   %edx
  800d49:	50                   	push   %eax
  800d4a:	e8 b5 39 00 00       	call   804704 <__umoddi3>
  800d4f:	83 c4 10             	add    $0x10,%esp
  800d52:	05 74 4f 80 00       	add    $0x804f74,%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	0f be c0             	movsbl %al,%eax
  800d5c:	83 ec 08             	sub    $0x8,%esp
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	50                   	push   %eax
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	ff d0                	call   *%eax
  800d68:	83 c4 10             	add    $0x10,%esp
}
  800d6b:	90                   	nop
  800d6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d6f:	c9                   	leave  
  800d70:	c3                   	ret    

00800d71 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d74:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d78:	7e 1c                	jle    800d96 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	8b 00                	mov    (%eax),%eax
  800d7f:	8d 50 08             	lea    0x8(%eax),%edx
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	89 10                	mov    %edx,(%eax)
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	83 e8 08             	sub    $0x8,%eax
  800d8f:	8b 50 04             	mov    0x4(%eax),%edx
  800d92:	8b 00                	mov    (%eax),%eax
  800d94:	eb 40                	jmp    800dd6 <getuint+0x65>
	else if (lflag)
  800d96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9a:	74 1e                	je     800dba <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	8b 00                	mov    (%eax),%eax
  800da1:	8d 50 04             	lea    0x4(%eax),%edx
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	89 10                	mov    %edx,(%eax)
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8b 00                	mov    (%eax),%eax
  800dae:	83 e8 04             	sub    $0x4,%eax
  800db1:	8b 00                	mov    (%eax),%eax
  800db3:	ba 00 00 00 00       	mov    $0x0,%edx
  800db8:	eb 1c                	jmp    800dd6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8b 00                	mov    (%eax),%eax
  800dbf:	8d 50 04             	lea    0x4(%eax),%edx
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	89 10                	mov    %edx,(%eax)
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8b 00                	mov    (%eax),%eax
  800dcc:	83 e8 04             	sub    $0x4,%eax
  800dcf:	8b 00                	mov    (%eax),%eax
  800dd1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dd6:	5d                   	pop    %ebp
  800dd7:	c3                   	ret    

00800dd8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dd8:	55                   	push   %ebp
  800dd9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ddb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ddf:	7e 1c                	jle    800dfd <getint+0x25>
		return va_arg(*ap, long long);
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8b 00                	mov    (%eax),%eax
  800de6:	8d 50 08             	lea    0x8(%eax),%edx
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	89 10                	mov    %edx,(%eax)
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8b 00                	mov    (%eax),%eax
  800df3:	83 e8 08             	sub    $0x8,%eax
  800df6:	8b 50 04             	mov    0x4(%eax),%edx
  800df9:	8b 00                	mov    (%eax),%eax
  800dfb:	eb 38                	jmp    800e35 <getint+0x5d>
	else if (lflag)
  800dfd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e01:	74 1a                	je     800e1d <getint+0x45>
		return va_arg(*ap, long);
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	8b 00                	mov    (%eax),%eax
  800e08:	8d 50 04             	lea    0x4(%eax),%edx
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	89 10                	mov    %edx,(%eax)
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8b 00                	mov    (%eax),%eax
  800e15:	83 e8 04             	sub    $0x4,%eax
  800e18:	8b 00                	mov    (%eax),%eax
  800e1a:	99                   	cltd   
  800e1b:	eb 18                	jmp    800e35 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8b 00                	mov    (%eax),%eax
  800e22:	8d 50 04             	lea    0x4(%eax),%edx
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	89 10                	mov    %edx,(%eax)
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8b 00                	mov    (%eax),%eax
  800e2f:	83 e8 04             	sub    $0x4,%eax
  800e32:	8b 00                	mov    (%eax),%eax
  800e34:	99                   	cltd   
}
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    

00800e37 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
  800e3c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e3f:	eb 17                	jmp    800e58 <vprintfmt+0x21>
			if (ch == '\0')
  800e41:	85 db                	test   %ebx,%ebx
  800e43:	0f 84 c1 03 00 00    	je     80120a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800e49:	83 ec 08             	sub    $0x8,%esp
  800e4c:	ff 75 0c             	pushl  0xc(%ebp)
  800e4f:	53                   	push   %ebx
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	ff d0                	call   *%eax
  800e55:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e58:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5b:	8d 50 01             	lea    0x1(%eax),%edx
  800e5e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	0f b6 d8             	movzbl %al,%ebx
  800e66:	83 fb 25             	cmp    $0x25,%ebx
  800e69:	75 d6                	jne    800e41 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e6b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e6f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e76:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e7d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e84:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	8d 50 01             	lea    0x1(%eax),%edx
  800e91:	89 55 10             	mov    %edx,0x10(%ebp)
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f b6 d8             	movzbl %al,%ebx
  800e99:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e9c:	83 f8 5b             	cmp    $0x5b,%eax
  800e9f:	0f 87 3d 03 00 00    	ja     8011e2 <vprintfmt+0x3ab>
  800ea5:	8b 04 85 98 4f 80 00 	mov    0x804f98(,%eax,4),%eax
  800eac:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800eae:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800eb2:	eb d7                	jmp    800e8b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800eb4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800eb8:	eb d1                	jmp    800e8b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ec1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ec4:	89 d0                	mov    %edx,%eax
  800ec6:	c1 e0 02             	shl    $0x2,%eax
  800ec9:	01 d0                	add    %edx,%eax
  800ecb:	01 c0                	add    %eax,%eax
  800ecd:	01 d8                	add    %ebx,%eax
  800ecf:	83 e8 30             	sub    $0x30,%eax
  800ed2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ed5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800edd:	83 fb 2f             	cmp    $0x2f,%ebx
  800ee0:	7e 3e                	jle    800f20 <vprintfmt+0xe9>
  800ee2:	83 fb 39             	cmp    $0x39,%ebx
  800ee5:	7f 39                	jg     800f20 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ee7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800eea:	eb d5                	jmp    800ec1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800eec:	8b 45 14             	mov    0x14(%ebp),%eax
  800eef:	83 c0 04             	add    $0x4,%eax
  800ef2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ef5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef8:	83 e8 04             	sub    $0x4,%eax
  800efb:	8b 00                	mov    (%eax),%eax
  800efd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f00:	eb 1f                	jmp    800f21 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f06:	79 83                	jns    800e8b <vprintfmt+0x54>
				width = 0;
  800f08:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f0f:	e9 77 ff ff ff       	jmp    800e8b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f14:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f1b:	e9 6b ff ff ff       	jmp    800e8b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f20:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f25:	0f 89 60 ff ff ff    	jns    800e8b <vprintfmt+0x54>
				width = precision, precision = -1;
  800f2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f31:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f38:	e9 4e ff ff ff       	jmp    800e8b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f3d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f40:	e9 46 ff ff ff       	jmp    800e8b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f45:	8b 45 14             	mov    0x14(%ebp),%eax
  800f48:	83 c0 04             	add    $0x4,%eax
  800f4b:	89 45 14             	mov    %eax,0x14(%ebp)
  800f4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f51:	83 e8 04             	sub    $0x4,%eax
  800f54:	8b 00                	mov    (%eax),%eax
  800f56:	83 ec 08             	sub    $0x8,%esp
  800f59:	ff 75 0c             	pushl  0xc(%ebp)
  800f5c:	50                   	push   %eax
  800f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f60:	ff d0                	call   *%eax
  800f62:	83 c4 10             	add    $0x10,%esp
			break;
  800f65:	e9 9b 02 00 00       	jmp    801205 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6d:	83 c0 04             	add    $0x4,%eax
  800f70:	89 45 14             	mov    %eax,0x14(%ebp)
  800f73:	8b 45 14             	mov    0x14(%ebp),%eax
  800f76:	83 e8 04             	sub    $0x4,%eax
  800f79:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f7b:	85 db                	test   %ebx,%ebx
  800f7d:	79 02                	jns    800f81 <vprintfmt+0x14a>
				err = -err;
  800f7f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f81:	83 fb 64             	cmp    $0x64,%ebx
  800f84:	7f 0b                	jg     800f91 <vprintfmt+0x15a>
  800f86:	8b 34 9d e0 4d 80 00 	mov    0x804de0(,%ebx,4),%esi
  800f8d:	85 f6                	test   %esi,%esi
  800f8f:	75 19                	jne    800faa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f91:	53                   	push   %ebx
  800f92:	68 85 4f 80 00       	push   $0x804f85
  800f97:	ff 75 0c             	pushl  0xc(%ebp)
  800f9a:	ff 75 08             	pushl  0x8(%ebp)
  800f9d:	e8 70 02 00 00       	call   801212 <printfmt>
  800fa2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800fa5:	e9 5b 02 00 00       	jmp    801205 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800faa:	56                   	push   %esi
  800fab:	68 8e 4f 80 00       	push   $0x804f8e
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	ff 75 08             	pushl  0x8(%ebp)
  800fb6:	e8 57 02 00 00       	call   801212 <printfmt>
  800fbb:	83 c4 10             	add    $0x10,%esp
			break;
  800fbe:	e9 42 02 00 00       	jmp    801205 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800fcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcf:	83 e8 04             	sub    $0x4,%eax
  800fd2:	8b 30                	mov    (%eax),%esi
  800fd4:	85 f6                	test   %esi,%esi
  800fd6:	75 05                	jne    800fdd <vprintfmt+0x1a6>
				p = "(null)";
  800fd8:	be 91 4f 80 00       	mov    $0x804f91,%esi
			if (width > 0 && padc != '-')
  800fdd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe1:	7e 6d                	jle    801050 <vprintfmt+0x219>
  800fe3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fe7:	74 67                	je     801050 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fec:	83 ec 08             	sub    $0x8,%esp
  800fef:	50                   	push   %eax
  800ff0:	56                   	push   %esi
  800ff1:	e8 1e 03 00 00       	call   801314 <strnlen>
  800ff6:	83 c4 10             	add    $0x10,%esp
  800ff9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ffc:	eb 16                	jmp    801014 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ffe:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801002:	83 ec 08             	sub    $0x8,%esp
  801005:	ff 75 0c             	pushl  0xc(%ebp)
  801008:	50                   	push   %eax
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	ff d0                	call   *%eax
  80100e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801011:	ff 4d e4             	decl   -0x1c(%ebp)
  801014:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801018:	7f e4                	jg     800ffe <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80101a:	eb 34                	jmp    801050 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80101c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801020:	74 1c                	je     80103e <vprintfmt+0x207>
  801022:	83 fb 1f             	cmp    $0x1f,%ebx
  801025:	7e 05                	jle    80102c <vprintfmt+0x1f5>
  801027:	83 fb 7e             	cmp    $0x7e,%ebx
  80102a:	7e 12                	jle    80103e <vprintfmt+0x207>
					putch('?', putdat);
  80102c:	83 ec 08             	sub    $0x8,%esp
  80102f:	ff 75 0c             	pushl  0xc(%ebp)
  801032:	6a 3f                	push   $0x3f
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	ff d0                	call   *%eax
  801039:	83 c4 10             	add    $0x10,%esp
  80103c:	eb 0f                	jmp    80104d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80103e:	83 ec 08             	sub    $0x8,%esp
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	53                   	push   %ebx
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	ff d0                	call   *%eax
  80104a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80104d:	ff 4d e4             	decl   -0x1c(%ebp)
  801050:	89 f0                	mov    %esi,%eax
  801052:	8d 70 01             	lea    0x1(%eax),%esi
  801055:	8a 00                	mov    (%eax),%al
  801057:	0f be d8             	movsbl %al,%ebx
  80105a:	85 db                	test   %ebx,%ebx
  80105c:	74 24                	je     801082 <vprintfmt+0x24b>
  80105e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801062:	78 b8                	js     80101c <vprintfmt+0x1e5>
  801064:	ff 4d e0             	decl   -0x20(%ebp)
  801067:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80106b:	79 af                	jns    80101c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80106d:	eb 13                	jmp    801082 <vprintfmt+0x24b>
				putch(' ', putdat);
  80106f:	83 ec 08             	sub    $0x8,%esp
  801072:	ff 75 0c             	pushl  0xc(%ebp)
  801075:	6a 20                	push   $0x20
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	ff d0                	call   *%eax
  80107c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80107f:	ff 4d e4             	decl   -0x1c(%ebp)
  801082:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801086:	7f e7                	jg     80106f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801088:	e9 78 01 00 00       	jmp    801205 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80108d:	83 ec 08             	sub    $0x8,%esp
  801090:	ff 75 e8             	pushl  -0x18(%ebp)
  801093:	8d 45 14             	lea    0x14(%ebp),%eax
  801096:	50                   	push   %eax
  801097:	e8 3c fd ff ff       	call   800dd8 <getint>
  80109c:	83 c4 10             	add    $0x10,%esp
  80109f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8010a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ab:	85 d2                	test   %edx,%edx
  8010ad:	79 23                	jns    8010d2 <vprintfmt+0x29b>
				putch('-', putdat);
  8010af:	83 ec 08             	sub    $0x8,%esp
  8010b2:	ff 75 0c             	pushl  0xc(%ebp)
  8010b5:	6a 2d                	push   $0x2d
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	ff d0                	call   *%eax
  8010bc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c5:	f7 d8                	neg    %eax
  8010c7:	83 d2 00             	adc    $0x0,%edx
  8010ca:	f7 da                	neg    %edx
  8010cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010d2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010d9:	e9 bc 00 00 00       	jmp    80119a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8010e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e7:	50                   	push   %eax
  8010e8:	e8 84 fc ff ff       	call   800d71 <getuint>
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010f6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010fd:	e9 98 00 00 00       	jmp    80119a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801102:	83 ec 08             	sub    $0x8,%esp
  801105:	ff 75 0c             	pushl  0xc(%ebp)
  801108:	6a 58                	push   $0x58
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	ff d0                	call   *%eax
  80110f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801112:	83 ec 08             	sub    $0x8,%esp
  801115:	ff 75 0c             	pushl  0xc(%ebp)
  801118:	6a 58                	push   $0x58
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
  80111d:	ff d0                	call   *%eax
  80111f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	6a 58                	push   $0x58
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	ff d0                	call   *%eax
  80112f:	83 c4 10             	add    $0x10,%esp
			break;
  801132:	e9 ce 00 00 00       	jmp    801205 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801137:	83 ec 08             	sub    $0x8,%esp
  80113a:	ff 75 0c             	pushl  0xc(%ebp)
  80113d:	6a 30                	push   $0x30
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	ff d0                	call   *%eax
  801144:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801147:	83 ec 08             	sub    $0x8,%esp
  80114a:	ff 75 0c             	pushl  0xc(%ebp)
  80114d:	6a 78                	push   $0x78
  80114f:	8b 45 08             	mov    0x8(%ebp),%eax
  801152:	ff d0                	call   *%eax
  801154:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801157:	8b 45 14             	mov    0x14(%ebp),%eax
  80115a:	83 c0 04             	add    $0x4,%eax
  80115d:	89 45 14             	mov    %eax,0x14(%ebp)
  801160:	8b 45 14             	mov    0x14(%ebp),%eax
  801163:	83 e8 04             	sub    $0x4,%eax
  801166:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801168:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801172:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801179:	eb 1f                	jmp    80119a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80117b:	83 ec 08             	sub    $0x8,%esp
  80117e:	ff 75 e8             	pushl  -0x18(%ebp)
  801181:	8d 45 14             	lea    0x14(%ebp),%eax
  801184:	50                   	push   %eax
  801185:	e8 e7 fb ff ff       	call   800d71 <getuint>
  80118a:	83 c4 10             	add    $0x10,%esp
  80118d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801190:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801193:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80119a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80119e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011a1:	83 ec 04             	sub    $0x4,%esp
  8011a4:	52                   	push   %edx
  8011a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011a8:	50                   	push   %eax
  8011a9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8011af:	ff 75 0c             	pushl  0xc(%ebp)
  8011b2:	ff 75 08             	pushl  0x8(%ebp)
  8011b5:	e8 00 fb ff ff       	call   800cba <printnum>
  8011ba:	83 c4 20             	add    $0x20,%esp
			break;
  8011bd:	eb 46                	jmp    801205 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011bf:	83 ec 08             	sub    $0x8,%esp
  8011c2:	ff 75 0c             	pushl  0xc(%ebp)
  8011c5:	53                   	push   %ebx
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	ff d0                	call   *%eax
  8011cb:	83 c4 10             	add    $0x10,%esp
			break;
  8011ce:	eb 35                	jmp    801205 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8011d0:	c6 05 44 60 80 00 00 	movb   $0x0,0x806044
			break;
  8011d7:	eb 2c                	jmp    801205 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8011d9:	c6 05 44 60 80 00 01 	movb   $0x1,0x806044
			break;
  8011e0:	eb 23                	jmp    801205 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011e2:	83 ec 08             	sub    $0x8,%esp
  8011e5:	ff 75 0c             	pushl  0xc(%ebp)
  8011e8:	6a 25                	push   $0x25
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	ff d0                	call   *%eax
  8011ef:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011f2:	ff 4d 10             	decl   0x10(%ebp)
  8011f5:	eb 03                	jmp    8011fa <vprintfmt+0x3c3>
  8011f7:	ff 4d 10             	decl   0x10(%ebp)
  8011fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fd:	48                   	dec    %eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	3c 25                	cmp    $0x25,%al
  801202:	75 f3                	jne    8011f7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801204:	90                   	nop
		}
	}
  801205:	e9 35 fc ff ff       	jmp    800e3f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80120a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80120b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80120e:	5b                   	pop    %ebx
  80120f:	5e                   	pop    %esi
  801210:	5d                   	pop    %ebp
  801211:	c3                   	ret    

00801212 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
  801215:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801218:	8d 45 10             	lea    0x10(%ebp),%eax
  80121b:	83 c0 04             	add    $0x4,%eax
  80121e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801221:	8b 45 10             	mov    0x10(%ebp),%eax
  801224:	ff 75 f4             	pushl  -0xc(%ebp)
  801227:	50                   	push   %eax
  801228:	ff 75 0c             	pushl  0xc(%ebp)
  80122b:	ff 75 08             	pushl  0x8(%ebp)
  80122e:	e8 04 fc ff ff       	call   800e37 <vprintfmt>
  801233:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801236:	90                   	nop
  801237:	c9                   	leave  
  801238:	c3                   	ret    

00801239 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80123c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123f:	8b 40 08             	mov    0x8(%eax),%eax
  801242:	8d 50 01             	lea    0x1(%eax),%edx
  801245:	8b 45 0c             	mov    0xc(%ebp),%eax
  801248:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	8b 10                	mov    (%eax),%edx
  801250:	8b 45 0c             	mov    0xc(%ebp),%eax
  801253:	8b 40 04             	mov    0x4(%eax),%eax
  801256:	39 c2                	cmp    %eax,%edx
  801258:	73 12                	jae    80126c <sprintputch+0x33>
		*b->buf++ = ch;
  80125a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125d:	8b 00                	mov    (%eax),%eax
  80125f:	8d 48 01             	lea    0x1(%eax),%ecx
  801262:	8b 55 0c             	mov    0xc(%ebp),%edx
  801265:	89 0a                	mov    %ecx,(%edx)
  801267:	8b 55 08             	mov    0x8(%ebp),%edx
  80126a:	88 10                	mov    %dl,(%eax)
}
  80126c:	90                   	nop
  80126d:	5d                   	pop    %ebp
  80126e:	c3                   	ret    

0080126f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80126f:	55                   	push   %ebp
  801270:	89 e5                	mov    %esp,%ebp
  801272:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80127b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801289:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801290:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801294:	74 06                	je     80129c <vsnprintf+0x2d>
  801296:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80129a:	7f 07                	jg     8012a3 <vsnprintf+0x34>
		return -E_INVAL;
  80129c:	b8 03 00 00 00       	mov    $0x3,%eax
  8012a1:	eb 20                	jmp    8012c3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8012a3:	ff 75 14             	pushl  0x14(%ebp)
  8012a6:	ff 75 10             	pushl  0x10(%ebp)
  8012a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012ac:	50                   	push   %eax
  8012ad:	68 39 12 80 00       	push   $0x801239
  8012b2:	e8 80 fb ff ff       	call   800e37 <vprintfmt>
  8012b7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012bd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012c3:	c9                   	leave  
  8012c4:	c3                   	ret    

008012c5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012cb:	8d 45 10             	lea    0x10(%ebp),%eax
  8012ce:	83 c0 04             	add    $0x4,%eax
  8012d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012da:	50                   	push   %eax
  8012db:	ff 75 0c             	pushl  0xc(%ebp)
  8012de:	ff 75 08             	pushl  0x8(%ebp)
  8012e1:	e8 89 ff ff ff       	call   80126f <vsnprintf>
  8012e6:	83 c4 10             	add    $0x10,%esp
  8012e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fe:	eb 06                	jmp    801306 <strlen+0x15>
		n++;
  801300:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801303:	ff 45 08             	incl   0x8(%ebp)
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	84 c0                	test   %al,%al
  80130d:	75 f1                	jne    801300 <strlen+0xf>
		n++;
	return n;
  80130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801312:	c9                   	leave  
  801313:	c3                   	ret    

00801314 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801314:	55                   	push   %ebp
  801315:	89 e5                	mov    %esp,%ebp
  801317:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80131a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801321:	eb 09                	jmp    80132c <strnlen+0x18>
		n++;
  801323:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801326:	ff 45 08             	incl   0x8(%ebp)
  801329:	ff 4d 0c             	decl   0xc(%ebp)
  80132c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801330:	74 09                	je     80133b <strnlen+0x27>
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	84 c0                	test   %al,%al
  801339:	75 e8                	jne    801323 <strnlen+0xf>
		n++;
	return n;
  80133b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80134c:	90                   	nop
  80134d:	8b 45 08             	mov    0x8(%ebp),%eax
  801350:	8d 50 01             	lea    0x1(%eax),%edx
  801353:	89 55 08             	mov    %edx,0x8(%ebp)
  801356:	8b 55 0c             	mov    0xc(%ebp),%edx
  801359:	8d 4a 01             	lea    0x1(%edx),%ecx
  80135c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80135f:	8a 12                	mov    (%edx),%dl
  801361:	88 10                	mov    %dl,(%eax)
  801363:	8a 00                	mov    (%eax),%al
  801365:	84 c0                	test   %al,%al
  801367:	75 e4                	jne    80134d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801369:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80137a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801381:	eb 1f                	jmp    8013a2 <strncpy+0x34>
		*dst++ = *src;
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8d 50 01             	lea    0x1(%eax),%edx
  801389:	89 55 08             	mov    %edx,0x8(%ebp)
  80138c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138f:	8a 12                	mov    (%edx),%dl
  801391:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801393:	8b 45 0c             	mov    0xc(%ebp),%eax
  801396:	8a 00                	mov    (%eax),%al
  801398:	84 c0                	test   %al,%al
  80139a:	74 03                	je     80139f <strncpy+0x31>
			src++;
  80139c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80139f:	ff 45 fc             	incl   -0x4(%ebp)
  8013a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013a8:	72 d9                	jb     801383 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013ad:	c9                   	leave  
  8013ae:	c3                   	ret    

008013af <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013af:	55                   	push   %ebp
  8013b0:	89 e5                	mov    %esp,%ebp
  8013b2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8013bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013bf:	74 30                	je     8013f1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8013c1:	eb 16                	jmp    8013d9 <strlcpy+0x2a>
			*dst++ = *src++;
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8d 50 01             	lea    0x1(%eax),%edx
  8013c9:	89 55 08             	mov    %edx,0x8(%ebp)
  8013cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013d2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013d5:	8a 12                	mov    (%edx),%dl
  8013d7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013d9:	ff 4d 10             	decl   0x10(%ebp)
  8013dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e0:	74 09                	je     8013eb <strlcpy+0x3c>
  8013e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	84 c0                	test   %al,%al
  8013e9:	75 d8                	jne    8013c3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f7:	29 c2                	sub    %eax,%edx
  8013f9:	89 d0                	mov    %edx,%eax
}
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801400:	eb 06                	jmp    801408 <strcmp+0xb>
		p++, q++;
  801402:	ff 45 08             	incl   0x8(%ebp)
  801405:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	84 c0                	test   %al,%al
  80140f:	74 0e                	je     80141f <strcmp+0x22>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 10                	mov    (%eax),%dl
  801416:	8b 45 0c             	mov    0xc(%ebp),%eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	38 c2                	cmp    %al,%dl
  80141d:	74 e3                	je     801402 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	0f b6 d0             	movzbl %al,%edx
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	0f b6 c0             	movzbl %al,%eax
  80142f:	29 c2                	sub    %eax,%edx
  801431:	89 d0                	mov    %edx,%eax
}
  801433:	5d                   	pop    %ebp
  801434:	c3                   	ret    

00801435 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801438:	eb 09                	jmp    801443 <strncmp+0xe>
		n--, p++, q++;
  80143a:	ff 4d 10             	decl   0x10(%ebp)
  80143d:	ff 45 08             	incl   0x8(%ebp)
  801440:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801443:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801447:	74 17                	je     801460 <strncmp+0x2b>
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	84 c0                	test   %al,%al
  801450:	74 0e                	je     801460 <strncmp+0x2b>
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 10                	mov    (%eax),%dl
  801457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145a:	8a 00                	mov    (%eax),%al
  80145c:	38 c2                	cmp    %al,%dl
  80145e:	74 da                	je     80143a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801460:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801464:	75 07                	jne    80146d <strncmp+0x38>
		return 0;
  801466:	b8 00 00 00 00       	mov    $0x0,%eax
  80146b:	eb 14                	jmp    801481 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	0f b6 d0             	movzbl %al,%edx
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	8a 00                	mov    (%eax),%al
  80147a:	0f b6 c0             	movzbl %al,%eax
  80147d:	29 c2                	sub    %eax,%edx
  80147f:	89 d0                	mov    %edx,%eax
}
  801481:	5d                   	pop    %ebp
  801482:	c3                   	ret    

00801483 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80148f:	eb 12                	jmp    8014a3 <strchr+0x20>
		if (*s == c)
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	8a 00                	mov    (%eax),%al
  801496:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801499:	75 05                	jne    8014a0 <strchr+0x1d>
			return (char *) s;
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	eb 11                	jmp    8014b1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014a0:	ff 45 08             	incl   0x8(%ebp)
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	8a 00                	mov    (%eax),%al
  8014a8:	84 c0                	test   %al,%al
  8014aa:	75 e5                	jne    801491 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b1:	c9                   	leave  
  8014b2:	c3                   	ret    

008014b3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	83 ec 04             	sub    $0x4,%esp
  8014b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014bf:	eb 0d                	jmp    8014ce <strfind+0x1b>
		if (*s == c)
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	8a 00                	mov    (%eax),%al
  8014c6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014c9:	74 0e                	je     8014d9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014cb:	ff 45 08             	incl   0x8(%ebp)
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	8a 00                	mov    (%eax),%al
  8014d3:	84 c0                	test   %al,%al
  8014d5:	75 ea                	jne    8014c1 <strfind+0xe>
  8014d7:	eb 01                	jmp    8014da <strfind+0x27>
		if (*s == c)
			break;
  8014d9:	90                   	nop
	return (char *) s;
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  8014eb:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8014ef:	76 63                	jbe    801554 <memset+0x75>
		uint64 data_block = c;
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	99                   	cltd   
  8014f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  8014fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801501:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801505:	c1 e0 08             	shl    $0x8,%eax
  801508:	09 45 f0             	or     %eax,-0x10(%ebp)
  80150b:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  80150e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801511:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801514:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801518:	c1 e0 10             	shl    $0x10,%eax
  80151b:	09 45 f0             	or     %eax,-0x10(%ebp)
  80151e:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801521:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801524:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801527:	89 c2                	mov    %eax,%edx
  801529:	b8 00 00 00 00       	mov    $0x0,%eax
  80152e:	09 45 f0             	or     %eax,-0x10(%ebp)
  801531:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801534:	eb 18                	jmp    80154e <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801536:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801539:	8d 41 08             	lea    0x8(%ecx),%eax
  80153c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80153f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801542:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801545:	89 01                	mov    %eax,(%ecx)
  801547:	89 51 04             	mov    %edx,0x4(%ecx)
  80154a:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  80154e:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801552:	77 e2                	ja     801536 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801554:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801558:	74 23                	je     80157d <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  80155a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801560:	eb 0e                	jmp    801570 <memset+0x91>
			*p8++ = (uint8)c;
  801562:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801565:	8d 50 01             	lea    0x1(%eax),%edx
  801568:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80156b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156e:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801570:	8b 45 10             	mov    0x10(%ebp),%eax
  801573:	8d 50 ff             	lea    -0x1(%eax),%edx
  801576:	89 55 10             	mov    %edx,0x10(%ebp)
  801579:	85 c0                	test   %eax,%eax
  80157b:	75 e5                	jne    801562 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801588:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  80158e:	8b 45 08             	mov    0x8(%ebp),%eax
  801591:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801594:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801598:	76 24                	jbe    8015be <memcpy+0x3c>
		while(n >= 8){
  80159a:	eb 1c                	jmp    8015b8 <memcpy+0x36>
			*d64 = *s64;
  80159c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80159f:	8b 50 04             	mov    0x4(%eax),%edx
  8015a2:	8b 00                	mov    (%eax),%eax
  8015a4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015a7:	89 01                	mov    %eax,(%ecx)
  8015a9:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  8015ac:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  8015b0:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  8015b4:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  8015b8:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  8015bc:	77 de                	ja     80159c <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  8015be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015c2:	74 31                	je     8015f5 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  8015c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  8015ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  8015d0:	eb 16                	jmp    8015e8 <memcpy+0x66>
			*d8++ = *s8++;
  8015d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d5:	8d 50 01             	lea    0x1(%eax),%edx
  8015d8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8015db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015de:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e1:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8015e4:	8a 12                	mov    (%edx),%dl
  8015e6:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  8015e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015eb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015ee:	89 55 10             	mov    %edx,0x10(%ebp)
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	75 dd                	jne    8015d2 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801600:	8b 45 0c             	mov    0xc(%ebp),%eax
  801603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80160c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80160f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801612:	73 50                	jae    801664 <memmove+0x6a>
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8b 45 10             	mov    0x10(%ebp),%eax
  80161a:	01 d0                	add    %edx,%eax
  80161c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80161f:	76 43                	jbe    801664 <memmove+0x6a>
		s += n;
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801627:	8b 45 10             	mov    0x10(%ebp),%eax
  80162a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80162d:	eb 10                	jmp    80163f <memmove+0x45>
			*--d = *--s;
  80162f:	ff 4d f8             	decl   -0x8(%ebp)
  801632:	ff 4d fc             	decl   -0x4(%ebp)
  801635:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801638:	8a 10                	mov    (%eax),%dl
  80163a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80163d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80163f:	8b 45 10             	mov    0x10(%ebp),%eax
  801642:	8d 50 ff             	lea    -0x1(%eax),%edx
  801645:	89 55 10             	mov    %edx,0x10(%ebp)
  801648:	85 c0                	test   %eax,%eax
  80164a:	75 e3                	jne    80162f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80164c:	eb 23                	jmp    801671 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80164e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801651:	8d 50 01             	lea    0x1(%eax),%edx
  801654:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801657:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80165a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801660:	8a 12                	mov    (%edx),%dl
  801662:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801664:	8b 45 10             	mov    0x10(%ebp),%eax
  801667:	8d 50 ff             	lea    -0x1(%eax),%edx
  80166a:	89 55 10             	mov    %edx,0x10(%ebp)
  80166d:	85 c0                	test   %eax,%eax
  80166f:	75 dd                	jne    80164e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801682:	8b 45 0c             	mov    0xc(%ebp),%eax
  801685:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801688:	eb 2a                	jmp    8016b4 <memcmp+0x3e>
		if (*s1 != *s2)
  80168a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168d:	8a 10                	mov    (%eax),%dl
  80168f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	38 c2                	cmp    %al,%dl
  801696:	74 16                	je     8016ae <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801698:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f b6 d0             	movzbl %al,%edx
  8016a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016a3:	8a 00                	mov    (%eax),%al
  8016a5:	0f b6 c0             	movzbl %al,%eax
  8016a8:	29 c2                	sub    %eax,%edx
  8016aa:	89 d0                	mov    %edx,%eax
  8016ac:	eb 18                	jmp    8016c6 <memcmp+0x50>
		s1++, s2++;
  8016ae:	ff 45 fc             	incl   -0x4(%ebp)
  8016b1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016ba:	89 55 10             	mov    %edx,0x10(%ebp)
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	75 c9                	jne    80168a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c6:	c9                   	leave  
  8016c7:	c3                   	ret    

008016c8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d4:	01 d0                	add    %edx,%eax
  8016d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016d9:	eb 15                	jmp    8016f0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8a 00                	mov    (%eax),%al
  8016e0:	0f b6 d0             	movzbl %al,%edx
  8016e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e6:	0f b6 c0             	movzbl %al,%eax
  8016e9:	39 c2                	cmp    %eax,%edx
  8016eb:	74 0d                	je     8016fa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016ed:	ff 45 08             	incl   0x8(%ebp)
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8016f6:	72 e3                	jb     8016db <memfind+0x13>
  8016f8:	eb 01                	jmp    8016fb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8016fa:	90                   	nop
	return (void *) s;
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801706:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80170d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801714:	eb 03                	jmp    801719 <strtol+0x19>
		s++;
  801716:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	8a 00                	mov    (%eax),%al
  80171e:	3c 20                	cmp    $0x20,%al
  801720:	74 f4                	je     801716 <strtol+0x16>
  801722:	8b 45 08             	mov    0x8(%ebp),%eax
  801725:	8a 00                	mov    (%eax),%al
  801727:	3c 09                	cmp    $0x9,%al
  801729:	74 eb                	je     801716 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8a 00                	mov    (%eax),%al
  801730:	3c 2b                	cmp    $0x2b,%al
  801732:	75 05                	jne    801739 <strtol+0x39>
		s++;
  801734:	ff 45 08             	incl   0x8(%ebp)
  801737:	eb 13                	jmp    80174c <strtol+0x4c>
	else if (*s == '-')
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	3c 2d                	cmp    $0x2d,%al
  801740:	75 0a                	jne    80174c <strtol+0x4c>
		s++, neg = 1;
  801742:	ff 45 08             	incl   0x8(%ebp)
  801745:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80174c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801750:	74 06                	je     801758 <strtol+0x58>
  801752:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801756:	75 20                	jne    801778 <strtol+0x78>
  801758:	8b 45 08             	mov    0x8(%ebp),%eax
  80175b:	8a 00                	mov    (%eax),%al
  80175d:	3c 30                	cmp    $0x30,%al
  80175f:	75 17                	jne    801778 <strtol+0x78>
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	40                   	inc    %eax
  801765:	8a 00                	mov    (%eax),%al
  801767:	3c 78                	cmp    $0x78,%al
  801769:	75 0d                	jne    801778 <strtol+0x78>
		s += 2, base = 16;
  80176b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80176f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801776:	eb 28                	jmp    8017a0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801778:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80177c:	75 15                	jne    801793 <strtol+0x93>
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	8a 00                	mov    (%eax),%al
  801783:	3c 30                	cmp    $0x30,%al
  801785:	75 0c                	jne    801793 <strtol+0x93>
		s++, base = 8;
  801787:	ff 45 08             	incl   0x8(%ebp)
  80178a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801791:	eb 0d                	jmp    8017a0 <strtol+0xa0>
	else if (base == 0)
  801793:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801797:	75 07                	jne    8017a0 <strtol+0xa0>
		base = 10;
  801799:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	8a 00                	mov    (%eax),%al
  8017a5:	3c 2f                	cmp    $0x2f,%al
  8017a7:	7e 19                	jle    8017c2 <strtol+0xc2>
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	8a 00                	mov    (%eax),%al
  8017ae:	3c 39                	cmp    $0x39,%al
  8017b0:	7f 10                	jg     8017c2 <strtol+0xc2>
			dig = *s - '0';
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	8a 00                	mov    (%eax),%al
  8017b7:	0f be c0             	movsbl %al,%eax
  8017ba:	83 e8 30             	sub    $0x30,%eax
  8017bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017c0:	eb 42                	jmp    801804 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	8a 00                	mov    (%eax),%al
  8017c7:	3c 60                	cmp    $0x60,%al
  8017c9:	7e 19                	jle    8017e4 <strtol+0xe4>
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	3c 7a                	cmp    $0x7a,%al
  8017d2:	7f 10                	jg     8017e4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	8a 00                	mov    (%eax),%al
  8017d9:	0f be c0             	movsbl %al,%eax
  8017dc:	83 e8 57             	sub    $0x57,%eax
  8017df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017e2:	eb 20                	jmp    801804 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	8a 00                	mov    (%eax),%al
  8017e9:	3c 40                	cmp    $0x40,%al
  8017eb:	7e 39                	jle    801826 <strtol+0x126>
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	8a 00                	mov    (%eax),%al
  8017f2:	3c 5a                	cmp    $0x5a,%al
  8017f4:	7f 30                	jg     801826 <strtol+0x126>
			dig = *s - 'A' + 10;
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	8a 00                	mov    (%eax),%al
  8017fb:	0f be c0             	movsbl %al,%eax
  8017fe:	83 e8 37             	sub    $0x37,%eax
  801801:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801807:	3b 45 10             	cmp    0x10(%ebp),%eax
  80180a:	7d 19                	jge    801825 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80180c:	ff 45 08             	incl   0x8(%ebp)
  80180f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801812:	0f af 45 10          	imul   0x10(%ebp),%eax
  801816:	89 c2                	mov    %eax,%edx
  801818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181b:	01 d0                	add    %edx,%eax
  80181d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801820:	e9 7b ff ff ff       	jmp    8017a0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801825:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801826:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80182a:	74 08                	je     801834 <strtol+0x134>
		*endptr = (char *) s;
  80182c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182f:	8b 55 08             	mov    0x8(%ebp),%edx
  801832:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801834:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801838:	74 07                	je     801841 <strtol+0x141>
  80183a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80183d:	f7 d8                	neg    %eax
  80183f:	eb 03                	jmp    801844 <strtol+0x144>
  801841:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <ltostr>:

void
ltostr(long value, char *str)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
  801849:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80184c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801853:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80185a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80185e:	79 13                	jns    801873 <ltostr+0x2d>
	{
		neg = 1;
  801860:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801867:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80186d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801870:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80187b:	99                   	cltd   
  80187c:	f7 f9                	idiv   %ecx
  80187e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801881:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801884:	8d 50 01             	lea    0x1(%eax),%edx
  801887:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80188a:	89 c2                	mov    %eax,%edx
  80188c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188f:	01 d0                	add    %edx,%eax
  801891:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801894:	83 c2 30             	add    $0x30,%edx
  801897:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80189c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018a1:	f7 e9                	imul   %ecx
  8018a3:	c1 fa 02             	sar    $0x2,%edx
  8018a6:	89 c8                	mov    %ecx,%eax
  8018a8:	c1 f8 1f             	sar    $0x1f,%eax
  8018ab:	29 c2                	sub    %eax,%edx
  8018ad:	89 d0                	mov    %edx,%eax
  8018af:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018b6:	75 bb                	jne    801873 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c2:	48                   	dec    %eax
  8018c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ca:	74 3d                	je     801909 <ltostr+0xc3>
		start = 1 ;
  8018cc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018d3:	eb 34                	jmp    801909 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018db:	01 d0                	add    %edx,%eax
  8018dd:	8a 00                	mov    (%eax),%al
  8018df:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8018e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e8:	01 c2                	add    %eax,%edx
  8018ea:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f0:	01 c8                	add    %ecx,%eax
  8018f2:	8a 00                	mov    (%eax),%al
  8018f4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fc:	01 c2                	add    %eax,%edx
  8018fe:	8a 45 eb             	mov    -0x15(%ebp),%al
  801901:	88 02                	mov    %al,(%edx)
		start++ ;
  801903:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801906:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80190f:	7c c4                	jl     8018d5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801911:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801914:	8b 45 0c             	mov    0xc(%ebp),%eax
  801917:	01 d0                	add    %edx,%eax
  801919:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80191c:	90                   	nop
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801925:	ff 75 08             	pushl  0x8(%ebp)
  801928:	e8 c4 f9 ff ff       	call   8012f1 <strlen>
  80192d:	83 c4 04             	add    $0x4,%esp
  801930:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	e8 b6 f9 ff ff       	call   8012f1 <strlen>
  80193b:	83 c4 04             	add    $0x4,%esp
  80193e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801941:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801948:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80194f:	eb 17                	jmp    801968 <strcconcat+0x49>
		final[s] = str1[s] ;
  801951:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801954:	8b 45 10             	mov    0x10(%ebp),%eax
  801957:	01 c2                	add    %eax,%edx
  801959:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	01 c8                	add    %ecx,%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801965:	ff 45 fc             	incl   -0x4(%ebp)
  801968:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80196b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80196e:	7c e1                	jl     801951 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801970:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801977:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80197e:	eb 1f                	jmp    80199f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801980:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801983:	8d 50 01             	lea    0x1(%eax),%edx
  801986:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801989:	89 c2                	mov    %eax,%edx
  80198b:	8b 45 10             	mov    0x10(%ebp),%eax
  80198e:	01 c2                	add    %eax,%edx
  801990:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801993:	8b 45 0c             	mov    0xc(%ebp),%eax
  801996:	01 c8                	add    %ecx,%eax
  801998:	8a 00                	mov    (%eax),%al
  80199a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80199c:	ff 45 f8             	incl   -0x8(%ebp)
  80199f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a5:	7c d9                	jl     801980 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ad:	01 d0                	add    %edx,%eax
  8019af:	c6 00 00             	movb   $0x0,(%eax)
}
  8019b2:	90                   	nop
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c4:	8b 00                	mov    (%eax),%eax
  8019c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d0:	01 d0                	add    %edx,%eax
  8019d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019d8:	eb 0c                	jmp    8019e6 <strsplit+0x31>
			*string++ = 0;
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	8d 50 01             	lea    0x1(%eax),%edx
  8019e0:	89 55 08             	mov    %edx,0x8(%ebp)
  8019e3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	8a 00                	mov    (%eax),%al
  8019eb:	84 c0                	test   %al,%al
  8019ed:	74 18                	je     801a07 <strsplit+0x52>
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	8a 00                	mov    (%eax),%al
  8019f4:	0f be c0             	movsbl %al,%eax
  8019f7:	50                   	push   %eax
  8019f8:	ff 75 0c             	pushl  0xc(%ebp)
  8019fb:	e8 83 fa ff ff       	call   801483 <strchr>
  801a00:	83 c4 08             	add    $0x8,%esp
  801a03:	85 c0                	test   %eax,%eax
  801a05:	75 d3                	jne    8019da <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	8a 00                	mov    (%eax),%al
  801a0c:	84 c0                	test   %al,%al
  801a0e:	74 5a                	je     801a6a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a10:	8b 45 14             	mov    0x14(%ebp),%eax
  801a13:	8b 00                	mov    (%eax),%eax
  801a15:	83 f8 0f             	cmp    $0xf,%eax
  801a18:	75 07                	jne    801a21 <strsplit+0x6c>
		{
			return 0;
  801a1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1f:	eb 66                	jmp    801a87 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a21:	8b 45 14             	mov    0x14(%ebp),%eax
  801a24:	8b 00                	mov    (%eax),%eax
  801a26:	8d 48 01             	lea    0x1(%eax),%ecx
  801a29:	8b 55 14             	mov    0x14(%ebp),%edx
  801a2c:	89 0a                	mov    %ecx,(%edx)
  801a2e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a35:	8b 45 10             	mov    0x10(%ebp),%eax
  801a38:	01 c2                	add    %eax,%edx
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a3f:	eb 03                	jmp    801a44 <strsplit+0x8f>
			string++;
  801a41:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8a 00                	mov    (%eax),%al
  801a49:	84 c0                	test   %al,%al
  801a4b:	74 8b                	je     8019d8 <strsplit+0x23>
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	8a 00                	mov    (%eax),%al
  801a52:	0f be c0             	movsbl %al,%eax
  801a55:	50                   	push   %eax
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	e8 25 fa ff ff       	call   801483 <strchr>
  801a5e:	83 c4 08             	add    $0x8,%esp
  801a61:	85 c0                	test   %eax,%eax
  801a63:	74 dc                	je     801a41 <strsplit+0x8c>
			string++;
	}
  801a65:	e9 6e ff ff ff       	jmp    8019d8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a6a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6e:	8b 00                	mov    (%eax),%eax
  801a70:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a77:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7a:	01 d0                	add    %edx,%eax
  801a7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a82:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  801a95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a9c:	eb 4a                	jmp    801ae8 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  801a9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	01 c2                	add    %eax,%edx
  801aa6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aac:	01 c8                	add    %ecx,%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  801ab2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab8:	01 d0                	add    %edx,%eax
  801aba:	8a 00                	mov    (%eax),%al
  801abc:	3c 40                	cmp    $0x40,%al
  801abe:	7e 25                	jle    801ae5 <str2lower+0x5c>
  801ac0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac6:	01 d0                	add    %edx,%eax
  801ac8:	8a 00                	mov    (%eax),%al
  801aca:	3c 5a                	cmp    $0x5a,%al
  801acc:	7f 17                	jg     801ae5 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  801ace:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	01 d0                	add    %edx,%eax
  801ad6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ad9:	8b 55 08             	mov    0x8(%ebp),%edx
  801adc:	01 ca                	add    %ecx,%edx
  801ade:	8a 12                	mov    (%edx),%dl
  801ae0:	83 c2 20             	add    $0x20,%edx
  801ae3:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  801ae5:	ff 45 fc             	incl   -0x4(%ebp)
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	e8 01 f8 ff ff       	call   8012f1 <strlen>
  801af0:	83 c4 04             	add    $0x4,%esp
  801af3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801af6:	7f a6                	jg     801a9e <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  801af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  801b03:	a1 08 60 80 00       	mov    0x806008,%eax
  801b08:	85 c0                	test   %eax,%eax
  801b0a:	0f 84 95 00 00 00    	je     801ba5 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  801b10:	83 ec 08             	sub    $0x8,%esp
  801b13:	68 00 00 00 82       	push   $0x82000000
  801b18:	68 00 00 00 80       	push   $0x80000000
  801b1d:	e8 59 1f 00 00       	call   803a7b <initialize_dynamic_allocator>
  801b22:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  801b25:	e8 93 1d 00 00       	call   8038bd <sys_get_uheap_strategy>
  801b2a:	a3 60 e0 81 00       	mov    %eax,0x81e060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  801b2f:	a1 40 60 80 00       	mov    0x806040,%eax
  801b34:	05 00 10 00 00       	add    $0x1000,%eax
  801b39:	a3 10 e1 81 00       	mov    %eax,0x81e110
		uheapPageAllocBreak = uheapPageAllocStart;
  801b3e:	a1 10 e1 81 00       	mov    0x81e110,%eax
  801b43:	a3 68 e0 81 00       	mov    %eax,0x81e068
		init_uspinlock(&ulock,"malloc",1);
  801b48:	83 ec 04             	sub    $0x4,%esp
  801b4b:	6a 01                	push   $0x1
  801b4d:	68 08 51 80 00       	push   $0x805108
  801b52:	68 40 e1 81 00       	push   $0x81e140
  801b57:	e8 8d 29 00 00       	call   8044e9 <init_uspinlock>
  801b5c:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  801b5f:	c7 05 20 e1 81 00 00 	movl   $0x0,0x81e120
  801b66:	00 00 00 
  801b69:	c7 05 24 e1 81 00 00 	movl   $0x0,0x81e124
  801b70:	00 00 00 
  801b73:	c7 05 2c e1 81 00 00 	movl   $0x0,0x81e12c
  801b7a:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  801b7d:	c7 05 30 e1 81 00 00 	movl   $0x0,0x81e130
  801b84:	00 00 00 
  801b87:	c7 05 34 e1 81 00 00 	movl   $0x0,0x81e134
  801b8e:	00 00 00 
  801b91:	c7 05 3c e1 81 00 00 	movl   $0x0,0x81e13c
  801b98:	00 00 00 
		__firstTimeFlag = 0;
  801b9b:	c7 05 08 60 80 00 00 	movl   $0x0,0x806008
  801ba2:	00 00 00 
	}
}
  801ba5:	90                   	nop
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bbc:	83 ec 08             	sub    $0x8,%esp
  801bbf:	68 06 04 00 00       	push   $0x406
  801bc4:	50                   	push   %eax
  801bc5:	e8 3d 19 00 00       	call   803507 <__sys_allocate_page>
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801bd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bd4:	79 14                	jns    801bea <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  801bd6:	83 ec 04             	sub    $0x4,%esp
  801bd9:	68 10 51 80 00       	push   $0x805110
  801bde:	6a 2d                	push   $0x2d
  801be0:	68 4c 51 80 00       	push   $0x80514c
  801be5:	e8 60 ed ff ff       	call   80094a <_panic>
	return 0;
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
  801bf4:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  801bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c05:	83 ec 0c             	sub    $0xc,%esp
  801c08:	50                   	push   %eax
  801c09:	e8 40 19 00 00       	call   80354e <__sys_unmap_frame>
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  801c14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c18:	79 14                	jns    801c2e <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  801c1a:	83 ec 04             	sub    $0x4,%esp
  801c1d:	68 58 51 80 00       	push   $0x805158
  801c22:	6a 38                	push   $0x38
  801c24:	68 4c 51 80 00       	push   $0x80514c
  801c29:	e8 1c ed ff ff       	call   80094a <_panic>
}
  801c2e:	90                   	nop
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  801c37:	e8 c1 fe ff ff       	call   801afd <uheap_init>
	if (size == 0) return NULL ;
  801c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c40:	75 0a                	jne    801c4c <malloc+0x1b>
  801c42:	b8 00 00 00 00       	mov    $0x0,%eax
  801c47:	e9 e1 04 00 00       	jmp    80212d <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  801c4c:	83 ec 0c             	sub    $0xc,%esp
  801c4f:	68 40 e1 81 00       	push   $0x81e140
  801c54:	e8 df 28 00 00       	call   804538 <acquire_uspinlock>
  801c59:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  801c5c:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  801c63:	77 23                	ja     801c88 <malloc+0x57>
		release_uspinlock(&ulock);
  801c65:	83 ec 0c             	sub    $0xc,%esp
  801c68:	68 40 e1 81 00       	push   $0x81e140
  801c6d:	e8 1e 29 00 00       	call   804590 <release_uspinlock>
  801c72:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  801c75:	83 ec 0c             	sub    $0xc,%esp
  801c78:	ff 75 08             	pushl  0x8(%ebp)
  801c7b:	e8 dd 1f 00 00       	call   803c5d <alloc_block>
  801c80:	83 c4 10             	add    $0x10,%esp
  801c83:	e9 a5 04 00 00       	jmp    80212d <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  801c88:	83 ec 0c             	sub    $0xc,%esp
  801c8b:	6a 10                	push   $0x10
  801c8d:	e8 cb 1f 00 00       	call   803c5d <alloc_block>
  801c92:	83 c4 10             	add    $0x10,%esp
  801c95:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  801c98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c9c:	75 0a                	jne    801ca8 <malloc+0x77>
			return NULL;
  801c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca3:	e9 85 04 00 00       	jmp    80212d <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  801ca8:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  801caf:	8b 55 08             	mov    0x8(%ebp),%edx
  801cb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cb5:	01 d0                	add    %edx,%eax
  801cb7:	48                   	dec    %eax
  801cb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cbe:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc3:	f7 75 e8             	divl   -0x18(%ebp)
  801cc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cc9:	29 d0                	sub    %edx,%eax
  801ccb:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  801cce:	a1 24 e1 81 00       	mov    0x81e124,%eax
  801cd3:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  801cd6:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801cdb:	85 c0                	test   %eax,%eax
  801cdd:	74 0f                	je     801cee <malloc+0xbd>
  801cdf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ce2:	8b 40 04             	mov    0x4(%eax),%eax
  801ce5:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ce8:	0f 83 ea 00 00 00    	jae    801dd8 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  801cee:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801cf3:	2b 45 08             	sub    0x8(%ebp),%eax
  801cf6:	89 c2                	mov    %eax,%edx
  801cf8:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801cfd:	39 c2                	cmp    %eax,%edx
  801cff:	0f 86 b9 00 00 00    	jbe    801dbe <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  801d05:	a1 68 e0 81 00       	mov    0x81e068,%eax
  801d0a:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  801d0d:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	01 d0                	add    %edx,%eax
  801d18:	a3 68 e0 81 00       	mov    %eax,0x81e068
					allocblock->startva = requestedblockva;
  801d1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d20:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801d23:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  801d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d28:	8b 55 08             	mov    0x8(%ebp),%edx
  801d2b:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  801d2e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d32:	75 14                	jne    801d48 <malloc+0x117>
  801d34:	83 ec 04             	sub    $0x4,%esp
  801d37:	68 98 51 80 00       	push   $0x805198
  801d3c:	6a 60                	push   $0x60
  801d3e:	68 4c 51 80 00       	push   $0x80514c
  801d43:	e8 02 ec ff ff       	call   80094a <_panic>
  801d48:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801d4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d51:	89 50 0c             	mov    %edx,0xc(%eax)
  801d54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d57:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5a:	85 c0                	test   %eax,%eax
  801d5c:	74 0d                	je     801d6b <malloc+0x13a>
  801d5e:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801d63:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801d66:	89 50 08             	mov    %edx,0x8(%eax)
  801d69:	eb 08                	jmp    801d73 <malloc+0x142>
  801d6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6e:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d76:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801d85:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801d8a:	40                   	inc    %eax
  801d8b:	a3 3c e1 81 00       	mov    %eax,0x81e13c


					sys_allocate_user_mem(allocblock->startva ,size);
  801d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d93:	8b 00                	mov    (%eax),%eax
  801d95:	83 ec 08             	sub    $0x8,%esp
  801d98:	ff 75 08             	pushl  0x8(%ebp)
  801d9b:	50                   	push   %eax
  801d9c:	e8 34 1c 00 00       	call   8039d5 <sys_allocate_user_mem>
  801da1:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  801da4:	83 ec 0c             	sub    $0xc,%esp
  801da7:	68 40 e1 81 00       	push   $0x81e140
  801dac:	e8 df 27 00 00       	call   804590 <release_uspinlock>
  801db1:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  801db4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db7:	8b 00                	mov    (%eax),%eax
  801db9:	e9 6f 03 00 00       	jmp    80212d <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  801dbe:	83 ec 0c             	sub    $0xc,%esp
  801dc1:	68 40 e1 81 00       	push   $0x81e140
  801dc6:	e8 c5 27 00 00       	call   804590 <release_uspinlock>
  801dcb:	83 c4 10             	add    $0x10,%esp
					return NULL;
  801dce:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd3:	e9 55 03 00 00       	jmp    80212d <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  801dd8:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801ddd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  801de0:	e9 39 03 00 00       	jmp    80211e <malloc+0x4ed>
			if(size<currentfreeelement->size){
  801de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de8:	8b 40 04             	mov    0x4(%eax),%eax
  801deb:	3b 45 08             	cmp    0x8(%ebp),%eax
  801dee:	0f 86 e7 01 00 00    	jbe    801fdb <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  801df4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801df7:	8b 10                	mov    (%eax),%edx
  801df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dfc:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  801dfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e01:	8b 55 08             	mov    0x8(%ebp),%edx
  801e04:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  801e07:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e0b:	75 14                	jne    801e21 <malloc+0x1f0>
  801e0d:	83 ec 04             	sub    $0x4,%esp
  801e10:	68 98 51 80 00       	push   $0x805198
  801e15:	6a 72                	push   $0x72
  801e17:	68 4c 51 80 00       	push   $0x80514c
  801e1c:	e8 29 eb ff ff       	call   80094a <_panic>
  801e21:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  801e27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e2a:	89 50 0c             	mov    %edx,0xc(%eax)
  801e2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e30:	8b 40 0c             	mov    0xc(%eax),%eax
  801e33:	85 c0                	test   %eax,%eax
  801e35:	74 0d                	je     801e44 <malloc+0x213>
  801e37:	a1 34 e1 81 00       	mov    0x81e134,%eax
  801e3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801e3f:	89 50 08             	mov    %edx,0x8(%eax)
  801e42:	eb 08                	jmp    801e4c <malloc+0x21b>
  801e44:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e47:	a3 30 e1 81 00       	mov    %eax,0x81e130
  801e4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e4f:	a3 34 e1 81 00       	mov    %eax,0x81e134
  801e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801e5e:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  801e63:	40                   	inc    %eax
  801e64:	a3 3c e1 81 00       	mov    %eax,0x81e13c
                lastfreeelement->startva += size;
  801e69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e6c:	8b 10                	mov    (%eax),%edx
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	01 c2                	add    %eax,%edx
  801e73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e76:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  801e78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e7b:	8b 40 04             	mov    0x4(%eax),%eax
  801e7e:	2b 45 08             	sub    0x8(%ebp),%eax
  801e81:	89 c2                	mov    %eax,%edx
  801e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e86:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  801e89:	a1 20 e1 81 00       	mov    0x81e120,%eax
  801e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  801e91:	e9 0d 01 00 00       	jmp    801fa3 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  801e96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e99:	8b 50 04             	mov    0x4(%eax),%edx
  801e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9f:	8b 40 04             	mov    0x4(%eax),%eax
  801ea2:	39 c2                	cmp    %eax,%edx
  801ea4:	0f 83 f0 00 00 00    	jae    801f9a <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  801eaa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801eae:	75 14                	jne    801ec4 <malloc+0x293>
  801eb0:	83 ec 04             	sub    $0x4,%esp
  801eb3:	68 bb 51 80 00       	push   $0x8051bb
  801eb8:	6a 7a                	push   $0x7a
  801eba:	68 4c 51 80 00       	push   $0x80514c
  801ebf:	e8 86 ea ff ff       	call   80094a <_panic>
  801ec4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ec7:	8b 40 08             	mov    0x8(%eax),%eax
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	74 11                	je     801edf <malloc+0x2ae>
  801ece:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ed1:	8b 40 08             	mov    0x8(%eax),%eax
  801ed4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ed7:	8b 52 0c             	mov    0xc(%edx),%edx
  801eda:	89 50 0c             	mov    %edx,0xc(%eax)
  801edd:	eb 0b                	jmp    801eea <malloc+0x2b9>
  801edf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ee2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee5:	a3 24 e1 81 00       	mov    %eax,0x81e124
  801eea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eed:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef0:	85 c0                	test   %eax,%eax
  801ef2:	74 11                	je     801f05 <malloc+0x2d4>
  801ef4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ef7:	8b 40 0c             	mov    0xc(%eax),%eax
  801efa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801efd:	8b 52 08             	mov    0x8(%edx),%edx
  801f00:	89 50 08             	mov    %edx,0x8(%eax)
  801f03:	eb 0b                	jmp    801f10 <malloc+0x2df>
  801f05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f08:	8b 40 08             	mov    0x8(%eax),%eax
  801f0b:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801f10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f13:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  801f1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f1d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  801f24:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801f29:	48                   	dec    %eax
  801f2a:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  801f2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f33:	74 06                	je     801f3b <malloc+0x30a>
  801f35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801f39:	75 14                	jne    801f4f <malloc+0x31e>
  801f3b:	83 ec 04             	sub    $0x4,%esp
  801f3e:	68 dc 51 80 00       	push   $0x8051dc
  801f43:	6a 7b                	push   $0x7b
  801f45:	68 4c 51 80 00       	push   $0x80514c
  801f4a:	e8 fb e9 ff ff       	call   80094a <_panic>
  801f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f52:	8b 50 0c             	mov    0xc(%eax),%edx
  801f55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f58:	89 50 0c             	mov    %edx,0xc(%eax)
  801f5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f61:	89 50 08             	mov    %edx,0x8(%eax)
  801f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f67:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	74 0e                	je     801f7c <malloc+0x34b>
  801f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f71:	8b 40 0c             	mov    0xc(%eax),%eax
  801f74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f77:	89 50 08             	mov    %edx,0x8(%eax)
  801f7a:	eb 08                	jmp    801f84 <malloc+0x353>
  801f7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f7f:	a3 20 e1 81 00       	mov    %eax,0x81e120
  801f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f87:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f8a:	89 50 0c             	mov    %edx,0xc(%eax)
  801f8d:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  801f92:	40                   	inc    %eax
  801f93:	a3 2c e1 81 00       	mov    %eax,0x81e12c
                		break;
  801f98:	eb 13                	jmp    801fad <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  801f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9d:	8b 40 08             	mov    0x8(%eax),%eax
  801fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  801fa3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa7:	0f 85 e9 fe ff ff    	jne    801e96 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  801fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb0:	8b 00                	mov    (%eax),%eax
  801fb2:	83 ec 08             	sub    $0x8,%esp
  801fb5:	ff 75 08             	pushl  0x8(%ebp)
  801fb8:	50                   	push   %eax
  801fb9:	e8 17 1a 00 00       	call   8039d5 <sys_allocate_user_mem>
  801fbe:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	68 40 e1 81 00       	push   $0x81e140
  801fc9:	e8 c2 25 00 00       	call   804590 <release_uspinlock>
  801fce:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  801fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd4:	8b 00                	mov    (%eax),%eax
  801fd6:	e9 52 01 00 00       	jmp    80212d <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  801fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fde:	8b 40 04             	mov    0x4(%eax),%eax
  801fe1:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fe4:	0f 85 2b 01 00 00    	jne    802115 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  801fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fed:	8b 10                	mov    (%eax),%edx
  801fef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff2:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  801ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff7:	8b 55 08             	mov    0x8(%ebp),%edx
  801ffa:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  801ffd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802001:	75 17                	jne    80201a <malloc+0x3e9>
  802003:	83 ec 04             	sub    $0x4,%esp
  802006:	68 98 51 80 00       	push   $0x805198
  80200b:	68 89 00 00 00       	push   $0x89
  802010:	68 4c 51 80 00       	push   $0x80514c
  802015:	e8 30 e9 ff ff       	call   80094a <_panic>
  80201a:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802020:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802023:	89 50 0c             	mov    %edx,0xc(%eax)
  802026:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802029:	8b 40 0c             	mov    0xc(%eax),%eax
  80202c:	85 c0                	test   %eax,%eax
  80202e:	74 0d                	je     80203d <malloc+0x40c>
  802030:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802035:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802038:	89 50 08             	mov    %edx,0x8(%eax)
  80203b:	eb 08                	jmp    802045 <malloc+0x414>
  80203d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802040:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802045:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802048:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80204d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802050:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802057:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  80205c:	40                   	inc    %eax
  80205d:	a3 3c e1 81 00       	mov    %eax,0x81e13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  802062:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802066:	75 17                	jne    80207f <malloc+0x44e>
  802068:	83 ec 04             	sub    $0x4,%esp
  80206b:	68 bb 51 80 00       	push   $0x8051bb
  802070:	68 8a 00 00 00       	push   $0x8a
  802075:	68 4c 51 80 00       	push   $0x80514c
  80207a:	e8 cb e8 ff ff       	call   80094a <_panic>
  80207f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802082:	8b 40 08             	mov    0x8(%eax),%eax
  802085:	85 c0                	test   %eax,%eax
  802087:	74 11                	je     80209a <malloc+0x469>
  802089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208c:	8b 40 08             	mov    0x8(%eax),%eax
  80208f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802092:	8b 52 0c             	mov    0xc(%edx),%edx
  802095:	89 50 0c             	mov    %edx,0xc(%eax)
  802098:	eb 0b                	jmp    8020a5 <malloc+0x474>
  80209a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209d:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a0:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8020a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	74 11                	je     8020c0 <malloc+0x48f>
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b8:	8b 52 08             	mov    0x8(%edx),%edx
  8020bb:	89 50 08             	mov    %edx,0x8(%eax)
  8020be:	eb 0b                	jmp    8020cb <malloc+0x49a>
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	8b 40 08             	mov    0x8(%eax),%eax
  8020c6:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8020cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8020d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8020df:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8020e4:	48                   	dec    %eax
  8020e5:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				sys_allocate_user_mem(allocblock->startva ,size);
  8020ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ed:	8b 00                	mov    (%eax),%eax
  8020ef:	83 ec 08             	sub    $0x8,%esp
  8020f2:	ff 75 08             	pushl  0x8(%ebp)
  8020f5:	50                   	push   %eax
  8020f6:	e8 da 18 00 00       	call   8039d5 <sys_allocate_user_mem>
  8020fb:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  8020fe:	83 ec 0c             	sub    $0xc,%esp
  802101:	68 40 e1 81 00       	push   $0x81e140
  802106:	e8 85 24 00 00       	call   804590 <release_uspinlock>
  80210b:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  80210e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802111:	8b 00                	mov    (%eax),%eax
  802113:	eb 18                	jmp    80212d <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802118:	8b 40 08             	mov    0x8(%eax),%eax
  80211b:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  80211e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802122:	0f 85 bd fc ff ff    	jne    801de5 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  802128:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80213b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80213e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802143:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  802146:	e8 b2 f9 ff ff       	call   801afd <uheap_init>
		acquire_uspinlock(&ulock);
  80214b:	83 ec 0c             	sub    $0xc,%esp
  80214e:	68 40 e1 81 00       	push   $0x81e140
  802153:	e8 e0 23 00 00       	call   804538 <acquire_uspinlock>
  802158:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  80215b:	a1 10 e1 81 00       	mov    0x81e110,%eax
  802160:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802163:	73 23                	jae    802188 <free+0x59>
			free_block(virtual_address);
  802165:	83 ec 0c             	sub    $0xc,%esp
  802168:	ff 75 08             	pushl  0x8(%ebp)
  80216b:	e8 89 1f 00 00       	call   8040f9 <free_block>
  802170:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  802173:	83 ec 0c             	sub    $0xc,%esp
  802176:	68 40 e1 81 00       	push   $0x81e140
  80217b:	e8 10 24 00 00       	call   804590 <release_uspinlock>
  802180:	83 c4 10             	add    $0x10,%esp
			return;
  802183:	e9 35 07 00 00       	jmp    8028bd <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  802188:	a1 68 e0 81 00       	mov    0x81e068,%eax
  80218d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802190:	72 30                	jb     8021c2 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  802192:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802197:	83 ec 04             	sub    $0x4,%esp
  80219a:	50                   	push   %eax
  80219b:	ff 75 d8             	pushl  -0x28(%ebp)
  80219e:	68 11 52 80 00       	push   $0x805211
  8021a3:	e8 70 ea ff ff       	call   800c18 <cprintf>
  8021a8:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  8021ab:	83 ec 04             	sub    $0x4,%esp
  8021ae:	68 19 52 80 00       	push   $0x805219
  8021b3:	68 a7 00 00 00       	push   $0xa7
  8021b8:	68 4c 51 80 00       	push   $0x80514c
  8021bd:	e8 88 e7 ff ff       	call   80094a <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8021c2:	83 ec 0c             	sub    $0xc,%esp
  8021c5:	6a 10                	push   $0x10
  8021c7:	e8 91 1a 00 00       	call   803c5d <alloc_block>
  8021cc:	83 c4 10             	add    $0x10,%esp
  8021cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  8021d2:	83 ec 0c             	sub    $0xc,%esp
  8021d5:	6a 10                	push   $0x10
  8021d7:	e8 81 1a 00 00       	call   803c5d <alloc_block>
  8021dc:	83 c4 10             	add    $0x10,%esp
  8021df:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  8021e2:	a1 30 e1 81 00       	mov    0x81e130,%eax
  8021e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  8021ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  8021f1:	eb 1c                	jmp    80220f <free+0xe0>

			if (VA ==ToBefreed->startva ){
  8021f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f6:	8b 00                	mov    (%eax),%eax
  8021f8:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8021fb:	75 09                	jne    802206 <free+0xd7>
				foundVA = 1;
  8021fd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  802204:	eb 0f                	jmp    802215 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	8b 40 08             	mov    0x8(%eax),%eax
  80220c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  80220f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802213:	75 de                	jne    8021f3 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  802215:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802219:	75 17                	jne    802232 <free+0x103>
				panic("INVALID ADDRESS!");
  80221b:	83 ec 04             	sub    $0x4,%esp
  80221e:	68 36 52 80 00       	push   $0x805236
  802223:	68 be 00 00 00       	push   $0xbe
  802228:	68 4c 51 80 00       	push   $0x80514c
  80222d:	e8 18 e7 ff ff       	call   80094a <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	8b 10                	mov    (%eax),%edx
  802237:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80223a:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  80223c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223f:	8b 50 04             	mov    0x4(%eax),%edx
  802242:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802245:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  802248:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80224c:	75 17                	jne    802265 <free+0x136>
  80224e:	83 ec 04             	sub    $0x4,%esp
  802251:	68 bb 51 80 00       	push   $0x8051bb
  802256:	68 c8 00 00 00       	push   $0xc8
  80225b:	68 4c 51 80 00       	push   $0x80514c
  802260:	e8 e5 e6 ff ff       	call   80094a <_panic>
  802265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802268:	8b 40 08             	mov    0x8(%eax),%eax
  80226b:	85 c0                	test   %eax,%eax
  80226d:	74 11                	je     802280 <free+0x151>
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 40 08             	mov    0x8(%eax),%eax
  802275:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802278:	8b 52 0c             	mov    0xc(%edx),%edx
  80227b:	89 50 0c             	mov    %edx,0xc(%eax)
  80227e:	eb 0b                	jmp    80228b <free+0x15c>
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	8b 40 0c             	mov    0xc(%eax),%eax
  802286:	a3 34 e1 81 00       	mov    %eax,0x81e134
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 40 0c             	mov    0xc(%eax),%eax
  802291:	85 c0                	test   %eax,%eax
  802293:	74 11                	je     8022a6 <free+0x177>
  802295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802298:	8b 40 0c             	mov    0xc(%eax),%eax
  80229b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229e:	8b 52 08             	mov    0x8(%edx),%edx
  8022a1:	89 50 08             	mov    %edx,0x8(%eax)
  8022a4:	eb 0b                	jmp    8022b1 <free+0x182>
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	8b 40 08             	mov    0x8(%eax),%eax
  8022ac:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  8022c5:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8022ca:	48                   	dec    %eax
  8022cb:	a3 3c e1 81 00       	mov    %eax,0x81e13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  8022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d3:	8b 50 04             	mov    0x4(%eax),%edx
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	8b 00                	mov    (%eax),%eax
  8022db:	83 ec 08             	sub    $0x8,%esp
  8022de:	52                   	push   %edx
  8022df:	50                   	push   %eax
  8022e0:	e8 d4 16 00 00       	call   8039b9 <sys_free_user_mem>
  8022e5:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  8022e8:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	75 7a                	jne    80236b <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  8022f1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8022f5:	75 17                	jne    80230e <free+0x1df>
  8022f7:	83 ec 04             	sub    $0x4,%esp
  8022fa:	68 48 52 80 00       	push   $0x805248
  8022ff:	68 d0 00 00 00       	push   $0xd0
  802304:	68 4c 51 80 00       	push   $0x80514c
  802309:	e8 3c e6 ff ff       	call   80094a <_panic>
  80230e:	8b 15 20 e1 81 00    	mov    0x81e120,%edx
  802314:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802317:	89 50 08             	mov    %edx,0x8(%eax)
  80231a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80231d:	8b 40 08             	mov    0x8(%eax),%eax
  802320:	85 c0                	test   %eax,%eax
  802322:	74 0d                	je     802331 <free+0x202>
  802324:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802329:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80232c:	89 50 0c             	mov    %edx,0xc(%eax)
  80232f:	eb 08                	jmp    802339 <free+0x20a>
  802331:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802334:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802339:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80233c:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802341:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802344:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80234b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802350:	40                   	inc    %eax
  802351:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			release_uspinlock(&ulock);
  802356:	83 ec 0c             	sub    $0xc,%esp
  802359:	68 40 e1 81 00       	push   $0x81e140
  80235e:	e8 2d 22 00 00       	call   804590 <release_uspinlock>
  802363:	83 c4 10             	add    $0x10,%esp
			return;
  802366:	e9 52 05 00 00       	jmp    8028bd <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  80236b:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802370:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  802373:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  80237a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  802381:	e9 d2 00 00 00       	jmp    802458 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  802386:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802389:	8b 10                	mov    (%eax),%edx
  80238b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80238e:	8b 40 04             	mov    0x4(%eax),%eax
  802391:	01 c2                	add    %eax,%edx
  802393:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802396:	8b 00                	mov    (%eax),%eax
  802398:	39 c2                	cmp    %eax,%edx
  80239a:	0f 85 af 00 00 00    	jne    80244f <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  8023a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a3:	8b 10                	mov    (%eax),%edx
  8023a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023a8:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  8023aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ad:	8b 50 04             	mov    0x4(%eax),%edx
  8023b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023b3:	8b 40 04             	mov    0x4(%eax),%eax
  8023b6:	01 c2                	add    %eax,%edx
  8023b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8023bb:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  8023be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023c2:	75 17                	jne    8023db <free+0x2ac>
  8023c4:	83 ec 04             	sub    $0x4,%esp
  8023c7:	68 bb 51 80 00       	push   $0x8051bb
  8023cc:	68 df 00 00 00       	push   $0xdf
  8023d1:	68 4c 51 80 00       	push   $0x80514c
  8023d6:	e8 6f e5 ff ff       	call   80094a <_panic>
  8023db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023de:	8b 40 08             	mov    0x8(%eax),%eax
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	74 11                	je     8023f6 <free+0x2c7>
  8023e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e8:	8b 40 08             	mov    0x8(%eax),%eax
  8023eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023ee:	8b 52 0c             	mov    0xc(%edx),%edx
  8023f1:	89 50 0c             	mov    %edx,0xc(%eax)
  8023f4:	eb 0b                	jmp    802401 <free+0x2d2>
  8023f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fc:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802401:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802404:	8b 40 0c             	mov    0xc(%eax),%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	74 11                	je     80241c <free+0x2ed>
  80240b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240e:	8b 40 0c             	mov    0xc(%eax),%eax
  802411:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802414:	8b 52 08             	mov    0x8(%edx),%edx
  802417:	89 50 08             	mov    %edx,0x8(%eax)
  80241a:	eb 0b                	jmp    802427 <free+0x2f8>
  80241c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241f:	8b 40 08             	mov    0x8(%eax),%eax
  802422:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802427:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802431:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802434:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80243b:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802440:	48                   	dec    %eax
  802441:	a3 2c e1 81 00       	mov    %eax,0x81e12c
				mergeprev = 1;
  802446:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  80244d:	eb 13                	jmp    802462 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  80244f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802452:	8b 40 08             	mov    0x8(%eax),%eax
  802455:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  802458:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80245c:	0f 85 24 ff ff ff    	jne    802386 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  802462:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802465:	8b 10                	mov    (%eax),%edx
  802467:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80246a:	8b 40 04             	mov    0x4(%eax),%eax
  80246d:	01 c2                	add    %eax,%edx
  80246f:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802474:	39 c2                	cmp    %eax,%edx
  802476:	75 44                	jne    8024bc <free+0x38d>

			if(mergeprev){
  802478:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80247c:	74 1f                	je     80249d <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  80247e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802481:	8b 00                	mov    (%eax),%eax
  802483:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  802488:	83 ec 0c             	sub    $0xc,%esp
  80248b:	68 40 e1 81 00       	push   $0x81e140
  802490:	e8 fb 20 00 00       	call   804590 <release_uspinlock>
  802495:	83 c4 10             	add    $0x10,%esp
				return;
  802498:	e9 20 04 00 00       	jmp    8028bd <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  80249d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024a0:	8b 00                	mov    (%eax),%eax
  8024a2:	a3 68 e0 81 00       	mov    %eax,0x81e068
				release_uspinlock(&ulock);
  8024a7:	83 ec 0c             	sub    $0xc,%esp
  8024aa:	68 40 e1 81 00       	push   $0x81e140
  8024af:	e8 dc 20 00 00       	call   804590 <release_uspinlock>
  8024b4:	83 c4 10             	add    $0x10,%esp
				return;
  8024b7:	e9 01 04 00 00       	jmp    8028bd <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  8024bc:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8024c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  8024c4:	e9 7d 01 00 00       	jmp    802646 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  8024c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024cc:	8b 10                	mov    (%eax),%edx
  8024ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8024d1:	8b 40 04             	mov    0x4(%eax),%eax
  8024d4:	01 c2                	add    %eax,%edx
  8024d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d9:	8b 00                	mov    (%eax),%eax
  8024db:	39 c2                	cmp    %eax,%edx
  8024dd:	0f 85 5a 01 00 00    	jne    80263d <free+0x50e>
				if (mergeprev){
  8024e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024e7:	0f 84 a1 00 00 00    	je     80258e <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  8024ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024f0:	8b 50 04             	mov    0x4(%eax),%edx
  8024f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f6:	8b 40 04             	mov    0x4(%eax),%eax
  8024f9:	01 c2                	add    %eax,%edx
  8024fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8024fe:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802501:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802505:	75 17                	jne    80251e <free+0x3ef>
  802507:	83 ec 04             	sub    $0x4,%esp
  80250a:	68 bb 51 80 00       	push   $0x8051bb
  80250f:	68 0a 01 00 00       	push   $0x10a
  802514:	68 4c 51 80 00       	push   $0x80514c
  802519:	e8 2c e4 ff ff       	call   80094a <_panic>
  80251e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802521:	8b 40 08             	mov    0x8(%eax),%eax
  802524:	85 c0                	test   %eax,%eax
  802526:	74 11                	je     802539 <free+0x40a>
  802528:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252b:	8b 40 08             	mov    0x8(%eax),%eax
  80252e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802531:	8b 52 0c             	mov    0xc(%edx),%edx
  802534:	89 50 0c             	mov    %edx,0xc(%eax)
  802537:	eb 0b                	jmp    802544 <free+0x415>
  802539:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253c:	8b 40 0c             	mov    0xc(%eax),%eax
  80253f:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802544:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802547:	8b 40 0c             	mov    0xc(%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 11                	je     80255f <free+0x430>
  80254e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802551:	8b 40 0c             	mov    0xc(%eax),%eax
  802554:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802557:	8b 52 08             	mov    0x8(%edx),%edx
  80255a:	89 50 08             	mov    %edx,0x8(%eax)
  80255d:	eb 0b                	jmp    80256a <free+0x43b>
  80255f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802562:	8b 40 08             	mov    0x8(%eax),%eax
  802565:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80256a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802574:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802577:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80257e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802583:	48                   	dec    %eax
  802584:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					break;
  802589:	e9 c2 00 00 00       	jmp    802650 <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  80258e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802591:	8b 10                	mov    (%eax),%edx
  802593:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802596:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  802598:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80259b:	8b 50 04             	mov    0x4(%eax),%edx
  80259e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a1:	8b 40 04             	mov    0x4(%eax),%eax
  8025a4:	01 c2                	add    %eax,%edx
  8025a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025a9:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  8025ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025b0:	75 17                	jne    8025c9 <free+0x49a>
  8025b2:	83 ec 04             	sub    $0x4,%esp
  8025b5:	68 bb 51 80 00       	push   $0x8051bb
  8025ba:	68 10 01 00 00       	push   $0x110
  8025bf:	68 4c 51 80 00       	push   $0x80514c
  8025c4:	e8 81 e3 ff ff       	call   80094a <_panic>
  8025c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cc:	8b 40 08             	mov    0x8(%eax),%eax
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	74 11                	je     8025e4 <free+0x4b5>
  8025d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d6:	8b 40 08             	mov    0x8(%eax),%eax
  8025d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025dc:	8b 52 0c             	mov    0xc(%edx),%edx
  8025df:	89 50 0c             	mov    %edx,0xc(%eax)
  8025e2:	eb 0b                	jmp    8025ef <free+0x4c0>
  8025e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ea:	a3 24 e1 81 00       	mov    %eax,0x81e124
  8025ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	74 11                	je     80260a <free+0x4db>
  8025f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802602:	8b 52 08             	mov    0x8(%edx),%edx
  802605:	89 50 08             	mov    %edx,0x8(%eax)
  802608:	eb 0b                	jmp    802615 <free+0x4e6>
  80260a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80260d:	8b 40 08             	mov    0x8(%eax),%eax
  802610:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802618:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80261f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802622:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802629:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80262e:	48                   	dec    %eax
  80262f:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					mergenext = 1;
  802634:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  80263b:	eb 13                	jmp    802650 <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  80263d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802640:	8b 40 08             	mov    0x8(%eax),%eax
  802643:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  802646:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80264a:	0f 85 79 fe ff ff    	jne    8024c9 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  802650:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802655:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  802658:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80265c:	0f 85 ad 00 00 00    	jne    80270f <free+0x5e0>
  802662:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802666:	0f 84 c3 01 00 00    	je     80282f <free+0x700>
				while(currentfree != NULL){
  80266c:	e9 9e 00 00 00       	jmp    80270f <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  802671:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802674:	8b 50 04             	mov    0x4(%eax),%edx
  802677:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267a:	8b 40 04             	mov    0x4(%eax),%eax
  80267d:	39 c2                	cmp    %eax,%edx
  80267f:	0f 83 81 00 00 00    	jae    802706 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  802685:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802689:	74 06                	je     802691 <free+0x562>
  80268b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80268f:	75 17                	jne    8026a8 <free+0x579>
  802691:	83 ec 04             	sub    $0x4,%esp
  802694:	68 dc 51 80 00       	push   $0x8051dc
  802699:	68 23 01 00 00       	push   $0x123
  80269e:	68 4c 51 80 00       	push   $0x80514c
  8026a3:	e8 a2 e2 ff ff       	call   80094a <_panic>
  8026a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ab:	8b 50 0c             	mov    0xc(%eax),%edx
  8026ae:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026b1:	89 50 0c             	mov    %edx,0xc(%eax)
  8026b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026ba:	89 50 08             	mov    %edx,0x8(%eax)
  8026bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	74 0e                	je     8026d5 <free+0x5a6>
  8026c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cd:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8026d0:	89 50 08             	mov    %edx,0x8(%eax)
  8026d3:	eb 08                	jmp    8026dd <free+0x5ae>
  8026d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8026d8:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8026dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8026e3:	89 50 0c             	mov    %edx,0xc(%eax)
  8026e6:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8026eb:	40                   	inc    %eax
  8026ec:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  8026f1:	83 ec 0c             	sub    $0xc,%esp
  8026f4:	68 40 e1 81 00       	push   $0x81e140
  8026f9:	e8 92 1e 00 00       	call   804590 <release_uspinlock>
  8026fe:	83 c4 10             	add    $0x10,%esp
							return;
  802701:	e9 b7 01 00 00       	jmp    8028bd <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802706:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802709:	8b 40 08             	mov    0x8(%eax),%eax
  80270c:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  80270f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802713:	0f 85 58 ff ff ff    	jne    802671 <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  802719:	83 ec 0c             	sub    $0xc,%esp
  80271c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80271f:	e8 d5 19 00 00       	call   8040f9 <free_block>
  802724:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  802727:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80272b:	75 17                	jne    802744 <free+0x615>
  80272d:	83 ec 04             	sub    $0x4,%esp
  802730:	68 98 51 80 00       	push   $0x805198
  802735:	68 2a 01 00 00       	push   $0x12a
  80273a:	68 4c 51 80 00       	push   $0x80514c
  80273f:	e8 06 e2 ff ff       	call   80094a <_panic>
  802744:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  80274a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80274d:	89 50 0c             	mov    %edx,0xc(%eax)
  802750:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802753:	8b 40 0c             	mov    0xc(%eax),%eax
  802756:	85 c0                	test   %eax,%eax
  802758:	74 0d                	je     802767 <free+0x638>
  80275a:	a1 24 e1 81 00       	mov    0x81e124,%eax
  80275f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802762:	89 50 08             	mov    %edx,0x8(%eax)
  802765:	eb 08                	jmp    80276f <free+0x640>
  802767:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80276a:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80276f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802772:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802777:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80277a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802781:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802786:	40                   	inc    %eax
  802787:	a3 2c e1 81 00       	mov    %eax,0x81e12c
  80278c:	e9 1b 01 00 00       	jmp    8028ac <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  802791:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802794:	8b 50 04             	mov    0x4(%eax),%edx
  802797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279a:	8b 40 04             	mov    0x4(%eax),%eax
  80279d:	39 c2                	cmp    %eax,%edx
  80279f:	0f 83 81 00 00 00    	jae    802826 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  8027a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8027a9:	74 06                	je     8027b1 <free+0x682>
  8027ab:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8027af:	75 17                	jne    8027c8 <free+0x699>
  8027b1:	83 ec 04             	sub    $0x4,%esp
  8027b4:	68 dc 51 80 00       	push   $0x8051dc
  8027b9:	68 30 01 00 00       	push   $0x130
  8027be:	68 4c 51 80 00       	push   $0x80514c
  8027c3:	e8 82 e1 ff ff       	call   80094a <_panic>
  8027c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027cb:	8b 50 0c             	mov    0xc(%eax),%edx
  8027ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027d1:	89 50 0c             	mov    %edx,0xc(%eax)
  8027d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027da:	89 50 08             	mov    %edx,0x8(%eax)
  8027dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e3:	85 c0                	test   %eax,%eax
  8027e5:	74 0e                	je     8027f5 <free+0x6c6>
  8027e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ed:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8027f0:	89 50 08             	mov    %edx,0x8(%eax)
  8027f3:	eb 08                	jmp    8027fd <free+0x6ce>
  8027f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027f8:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8027fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802800:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802803:	89 50 0c             	mov    %edx,0xc(%eax)
  802806:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80280b:	40                   	inc    %eax
  80280c:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							release_uspinlock(&ulock);
  802811:	83 ec 0c             	sub    $0xc,%esp
  802814:	68 40 e1 81 00       	push   $0x81e140
  802819:	e8 72 1d 00 00       	call   804590 <release_uspinlock>
  80281e:	83 c4 10             	add    $0x10,%esp
							return;
  802821:	e9 97 00 00 00       	jmp    8028bd <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  802826:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802829:	8b 40 08             	mov    0x8(%eax),%eax
  80282c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  80282f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802833:	0f 85 58 ff ff ff    	jne    802791 <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  802839:	83 ec 0c             	sub    $0xc,%esp
  80283c:	ff 75 d0             	pushl  -0x30(%ebp)
  80283f:	e8 b5 18 00 00       	call   8040f9 <free_block>
  802844:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  802847:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80284b:	75 17                	jne    802864 <free+0x735>
  80284d:	83 ec 04             	sub    $0x4,%esp
  802850:	68 98 51 80 00       	push   $0x805198
  802855:	68 37 01 00 00       	push   $0x137
  80285a:	68 4c 51 80 00       	push   $0x80514c
  80285f:	e8 e6 e0 ff ff       	call   80094a <_panic>
  802864:	8b 15 24 e1 81 00    	mov    0x81e124,%edx
  80286a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80286d:	89 50 0c             	mov    %edx,0xc(%eax)
  802870:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802873:	8b 40 0c             	mov    0xc(%eax),%eax
  802876:	85 c0                	test   %eax,%eax
  802878:	74 0d                	je     802887 <free+0x758>
  80287a:	a1 24 e1 81 00       	mov    0x81e124,%eax
  80287f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802882:	89 50 08             	mov    %edx,0x8(%eax)
  802885:	eb 08                	jmp    80288f <free+0x760>
  802887:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80288a:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80288f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802892:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802897:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80289a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028a1:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  8028a6:	40                   	inc    %eax
  8028a7:	a3 2c e1 81 00       	mov    %eax,0x81e12c
			}
		release_uspinlock(&ulock);
  8028ac:	83 ec 0c             	sub    $0xc,%esp
  8028af:	68 40 e1 81 00       	push   $0x81e140
  8028b4:	e8 d7 1c 00 00       	call   804590 <release_uspinlock>
  8028b9:	83 c4 10             	add    $0x10,%esp
		return;
  8028bc:	90                   	nop
}
  8028bd:	c9                   	leave  
  8028be:	c3                   	ret    

008028bf <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8028bf:	55                   	push   %ebp
  8028c0:	89 e5                	mov    %esp,%ebp
  8028c2:	83 ec 48             	sub    $0x48,%esp
  8028c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c8:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  8028cb:	e8 2d f2 ff ff       	call   801afd <uheap_init>
	if (size == 0) return NULL;
  8028d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8028d4:	75 0a                	jne    8028e0 <smalloc+0x21>
  8028d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028db:	e9 84 05 00 00       	jmp    802e64 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  8028e0:	83 ec 0c             	sub    $0xc,%esp
  8028e3:	68 40 e1 81 00       	push   $0x81e140
  8028e8:	e8 4b 1c 00 00       	call   804538 <acquire_uspinlock>
  8028ed:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8028f0:	83 ec 0c             	sub    $0xc,%esp
  8028f3:	6a 10                	push   $0x10
  8028f5:	e8 63 13 00 00       	call   803c5d <alloc_block>
  8028fa:	83 c4 10             	add    $0x10,%esp
  8028fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  802900:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802904:	75 0a                	jne    802910 <smalloc+0x51>
				return NULL;
  802906:	b8 00 00 00 00       	mov    $0x0,%eax
  80290b:	e9 54 05 00 00       	jmp    802e64 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  802910:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80291a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291d:	01 d0                	add    %edx,%eax
  80291f:	48                   	dec    %eax
  802920:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802926:	ba 00 00 00 00       	mov    $0x0,%edx
  80292b:	f7 75 e8             	divl   -0x18(%ebp)
  80292e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802931:	29 d0                	sub    %edx,%eax
  802933:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802936:	a1 24 e1 81 00       	mov    0x81e124,%eax
  80293b:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80293e:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802943:	85 c0                	test   %eax,%eax
  802945:	74 0f                	je     802956 <smalloc+0x97>
  802947:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80294a:	8b 40 04             	mov    0x4(%eax),%eax
  80294d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802950:	0f 83 25 01 00 00    	jae    802a7b <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802956:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80295b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80295e:	89 c2                	mov    %eax,%edx
  802960:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802965:	39 c2                	cmp    %eax,%edx
  802967:	0f 82 f4 00 00 00    	jb     802a61 <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  80296d:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802972:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  802975:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  80297b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80297e:	01 d0                	add    %edx,%eax
  802980:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802988:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80298b:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  80298d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802990:	8b 55 0c             	mov    0xc(%ebp),%edx
  802993:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802996:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80299a:	75 17                	jne    8029b3 <smalloc+0xf4>
  80299c:	83 ec 04             	sub    $0x4,%esp
  80299f:	68 98 51 80 00       	push   $0x805198
  8029a4:	68 57 01 00 00       	push   $0x157
  8029a9:	68 4c 51 80 00       	push   $0x80514c
  8029ae:	e8 97 df ff ff       	call   80094a <_panic>
  8029b3:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8029b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bc:	89 50 0c             	mov    %edx,0xc(%eax)
  8029bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	74 0d                	je     8029d6 <smalloc+0x117>
  8029c9:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8029ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029d1:	89 50 08             	mov    %edx,0x8(%eax)
  8029d4:	eb 08                	jmp    8029de <smalloc+0x11f>
  8029d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d9:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8029de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e1:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8029e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8029f0:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8029f5:	40                   	inc    %eax
  8029f6:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  8029fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	89 c2                	mov    %eax,%edx
  802a02:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802a06:	52                   	push   %edx
  802a07:	50                   	push   %eax
  802a08:	ff 75 0c             	pushl  0xc(%ebp)
  802a0b:	ff 75 08             	pushl  0x8(%ebp)
  802a0e:	e8 48 0c 00 00       	call   80365b <sys_create_shared_object>
  802a13:	83 c4 10             	add    $0x10,%esp
  802a16:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  802a19:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  802a1d:	79 28                	jns    802a47 <smalloc+0x188>
							free_block(allocblock);
  802a1f:	83 ec 0c             	sub    $0xc,%esp
  802a22:	ff 75 ec             	pushl  -0x14(%ebp)
  802a25:	e8 cf 16 00 00       	call   8040f9 <free_block>
  802a2a:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802a2d:	83 ec 0c             	sub    $0xc,%esp
  802a30:	68 40 e1 81 00       	push   $0x81e140
  802a35:	e8 56 1b 00 00       	call   804590 <release_uspinlock>
  802a3a:	83 c4 10             	add    $0x10,%esp
							return NULL;
  802a3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802a42:	e9 1d 04 00 00       	jmp    802e64 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  802a47:	83 ec 0c             	sub    $0xc,%esp
  802a4a:	68 40 e1 81 00       	push   $0x81e140
  802a4f:	e8 3c 1b 00 00       	call   804590 <release_uspinlock>
  802a54:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  802a57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5a:	8b 00                	mov    (%eax),%eax
  802a5c:	e9 03 04 00 00       	jmp    802e64 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  802a61:	83 ec 0c             	sub    $0xc,%esp
  802a64:	68 40 e1 81 00       	push   $0x81e140
  802a69:	e8 22 1b 00 00       	call   804590 <release_uspinlock>
  802a6e:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802a71:	b8 00 00 00 00       	mov    $0x0,%eax
  802a76:	e9 e9 03 00 00       	jmp    802e64 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802a7b:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  802a83:	e9 af 03 00 00       	jmp    802e37 <smalloc+0x578>
				if(size<currentfreeelement->size){
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 40 04             	mov    0x4(%eax),%eax
  802a8e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a91:	0f 86 28 02 00 00    	jbe    802cbf <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  802a97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a9a:	8b 10                	mov    (%eax),%edx
  802a9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9f:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  802aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aa7:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802aaa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aae:	75 17                	jne    802ac7 <smalloc+0x208>
  802ab0:	83 ec 04             	sub    $0x4,%esp
  802ab3:	68 98 51 80 00       	push   $0x805198
  802ab8:	68 6f 01 00 00       	push   $0x16f
  802abd:	68 4c 51 80 00       	push   $0x80514c
  802ac2:	e8 83 de ff ff       	call   80094a <_panic>
  802ac7:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad0:	89 50 0c             	mov    %edx,0xc(%eax)
  802ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad9:	85 c0                	test   %eax,%eax
  802adb:	74 0d                	je     802aea <smalloc+0x22b>
  802add:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802ae2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae5:	89 50 08             	mov    %edx,0x8(%eax)
  802ae8:	eb 08                	jmp    802af2 <smalloc+0x233>
  802aea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aed:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af5:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802afa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b04:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802b09:	40                   	inc    %eax
  802b0a:	a3 3c e1 81 00       	mov    %eax,0x81e13c
	                lastfreeelement->startva += size;
  802b0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b12:	8b 10                	mov    (%eax),%edx
  802b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b17:	01 c2                	add    %eax,%edx
  802b19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b1c:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  802b1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b21:	8b 40 04             	mov    0x4(%eax),%eax
  802b24:	2b 45 0c             	sub    0xc(%ebp),%eax
  802b27:	89 c2                	mov    %eax,%edx
  802b29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2c:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  802b2f:	a1 20 e1 81 00       	mov    0x81e120,%eax
  802b34:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  802b37:	e9 13 01 00 00       	jmp    802c4f <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  802b3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b3f:	8b 50 04             	mov    0x4(%eax),%edx
  802b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b45:	8b 40 04             	mov    0x4(%eax),%eax
  802b48:	39 c2                	cmp    %eax,%edx
  802b4a:	0f 83 f6 00 00 00    	jae    802c46 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  802b50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b54:	75 17                	jne    802b6d <smalloc+0x2ae>
  802b56:	83 ec 04             	sub    $0x4,%esp
  802b59:	68 bb 51 80 00       	push   $0x8051bb
  802b5e:	68 77 01 00 00       	push   $0x177
  802b63:	68 4c 51 80 00       	push   $0x80514c
  802b68:	e8 dd dd ff ff       	call   80094a <_panic>
  802b6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b70:	8b 40 08             	mov    0x8(%eax),%eax
  802b73:	85 c0                	test   %eax,%eax
  802b75:	74 11                	je     802b88 <smalloc+0x2c9>
  802b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b7a:	8b 40 08             	mov    0x8(%eax),%eax
  802b7d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b80:	8b 52 0c             	mov    0xc(%edx),%edx
  802b83:	89 50 0c             	mov    %edx,0xc(%eax)
  802b86:	eb 0b                	jmp    802b93 <smalloc+0x2d4>
  802b88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8e:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802b93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b96:	8b 40 0c             	mov    0xc(%eax),%eax
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	74 11                	je     802bae <smalloc+0x2ef>
  802b9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ba6:	8b 52 08             	mov    0x8(%edx),%edx
  802ba9:	89 50 08             	mov    %edx,0x8(%eax)
  802bac:	eb 0b                	jmp    802bb9 <smalloc+0x2fa>
  802bae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb1:	8b 40 08             	mov    0x8(%eax),%eax
  802bb4:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802bb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bbc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802bc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802bcd:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802bd2:	48                   	dec    %eax
  802bd3:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  802bd8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bdc:	74 06                	je     802be4 <smalloc+0x325>
  802bde:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802be2:	75 17                	jne    802bfb <smalloc+0x33c>
  802be4:	83 ec 04             	sub    $0x4,%esp
  802be7:	68 dc 51 80 00       	push   $0x8051dc
  802bec:	68 78 01 00 00       	push   $0x178
  802bf1:	68 4c 51 80 00       	push   $0x80514c
  802bf6:	e8 4f dd ff ff       	call   80094a <_panic>
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	8b 50 0c             	mov    0xc(%eax),%edx
  802c01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c04:	89 50 0c             	mov    %edx,0xc(%eax)
  802c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c0d:	89 50 08             	mov    %edx,0x8(%eax)
  802c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c13:	8b 40 0c             	mov    0xc(%eax),%eax
  802c16:	85 c0                	test   %eax,%eax
  802c18:	74 0e                	je     802c28 <smalloc+0x369>
  802c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c20:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c23:	89 50 08             	mov    %edx,0x8(%eax)
  802c26:	eb 08                	jmp    802c30 <smalloc+0x371>
  802c28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c2b:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c33:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c36:	89 50 0c             	mov    %edx,0xc(%eax)
  802c39:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802c3e:	40                   	inc    %eax
  802c3f:	a3 2c e1 81 00       	mov    %eax,0x81e12c
	                		break;
  802c44:	eb 13                	jmp    802c59 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  802c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c49:	8b 40 08             	mov    0x8(%eax),%eax
  802c4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  802c4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c53:	0f 85 e3 fe ff ff    	jne    802b3c <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802c59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5c:	8b 00                	mov    (%eax),%eax
  802c5e:	89 c2                	mov    %eax,%edx
  802c60:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802c64:	52                   	push   %edx
  802c65:	50                   	push   %eax
  802c66:	ff 75 0c             	pushl  0xc(%ebp)
  802c69:	ff 75 08             	pushl  0x8(%ebp)
  802c6c:	e8 ea 09 00 00       	call   80365b <sys_create_shared_object>
  802c71:	83 c4 10             	add    $0x10,%esp
  802c74:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  802c77:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802c7b:	79 28                	jns    802ca5 <smalloc+0x3e6>
	                	free_block(allocblock);
  802c7d:	83 ec 0c             	sub    $0xc,%esp
  802c80:	ff 75 ec             	pushl  -0x14(%ebp)
  802c83:	e8 71 14 00 00       	call   8040f9 <free_block>
  802c88:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  802c8b:	83 ec 0c             	sub    $0xc,%esp
  802c8e:	68 40 e1 81 00       	push   $0x81e140
  802c93:	e8 f8 18 00 00       	call   804590 <release_uspinlock>
  802c98:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  802c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca0:	e9 bf 01 00 00       	jmp    802e64 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  802ca5:	83 ec 0c             	sub    $0xc,%esp
  802ca8:	68 40 e1 81 00       	push   $0x81e140
  802cad:	e8 de 18 00 00       	call   804590 <release_uspinlock>
  802cb2:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  802cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb8:	8b 00                	mov    (%eax),%eax
  802cba:	e9 a5 01 00 00       	jmp    802e64 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 40 04             	mov    0x4(%eax),%eax
  802cc5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802cc8:	0f 85 60 01 00 00    	jne    802e2e <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	8b 10                	mov    (%eax),%edx
  802cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd6:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802cd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cde:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802ce1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ce5:	75 17                	jne    802cfe <smalloc+0x43f>
  802ce7:	83 ec 04             	sub    $0x4,%esp
  802cea:	68 98 51 80 00       	push   $0x805198
  802cef:	68 8c 01 00 00       	push   $0x18c
  802cf4:	68 4c 51 80 00       	push   $0x80514c
  802cf9:	e8 4c dc ff ff       	call   80094a <_panic>
  802cfe:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802d04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d07:	89 50 0c             	mov    %edx,0xc(%eax)
  802d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d10:	85 c0                	test   %eax,%eax
  802d12:	74 0d                	je     802d21 <smalloc+0x462>
  802d14:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802d19:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d1c:	89 50 08             	mov    %edx,0x8(%eax)
  802d1f:	eb 08                	jmp    802d29 <smalloc+0x46a>
  802d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d24:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2c:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d34:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d3b:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802d40:	40                   	inc    %eax
  802d41:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  802d46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4a:	75 17                	jne    802d63 <smalloc+0x4a4>
  802d4c:	83 ec 04             	sub    $0x4,%esp
  802d4f:	68 bb 51 80 00       	push   $0x8051bb
  802d54:	68 8d 01 00 00       	push   $0x18d
  802d59:	68 4c 51 80 00       	push   $0x80514c
  802d5e:	e8 e7 db ff ff       	call   80094a <_panic>
  802d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d66:	8b 40 08             	mov    0x8(%eax),%eax
  802d69:	85 c0                	test   %eax,%eax
  802d6b:	74 11                	je     802d7e <smalloc+0x4bf>
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 40 08             	mov    0x8(%eax),%eax
  802d73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d76:	8b 52 0c             	mov    0xc(%edx),%edx
  802d79:	89 50 0c             	mov    %edx,0xc(%eax)
  802d7c:	eb 0b                	jmp    802d89 <smalloc+0x4ca>
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 40 0c             	mov    0xc(%eax),%eax
  802d84:	a3 24 e1 81 00       	mov    %eax,0x81e124
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	74 11                	je     802da4 <smalloc+0x4e5>
  802d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d96:	8b 40 0c             	mov    0xc(%eax),%eax
  802d99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d9c:	8b 52 08             	mov    0x8(%edx),%edx
  802d9f:	89 50 08             	mov    %edx,0x8(%eax)
  802da2:	eb 0b                	jmp    802daf <smalloc+0x4f0>
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 40 08             	mov    0x8(%eax),%eax
  802daa:	a3 20 e1 81 00       	mov    %eax,0x81e120
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802dc3:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802dc8:	48                   	dec    %eax
  802dc9:	a3 2c e1 81 00       	mov    %eax,0x81e12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  802dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd1:	8b 00                	mov    (%eax),%eax
  802dd3:	89 c2                	mov    %eax,%edx
  802dd5:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  802dd9:	52                   	push   %edx
  802dda:	50                   	push   %eax
  802ddb:	ff 75 0c             	pushl  0xc(%ebp)
  802dde:	ff 75 08             	pushl  0x8(%ebp)
  802de1:	e8 75 08 00 00       	call   80365b <sys_create_shared_object>
  802de6:	83 c4 10             	add    $0x10,%esp
  802de9:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  802dec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802df0:	79 25                	jns    802e17 <smalloc+0x558>
						free_block(allocblock);
  802df2:	83 ec 0c             	sub    $0xc,%esp
  802df5:	ff 75 ec             	pushl  -0x14(%ebp)
  802df8:	e8 fc 12 00 00       	call   8040f9 <free_block>
  802dfd:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  802e00:	83 ec 0c             	sub    $0xc,%esp
  802e03:	68 40 e1 81 00       	push   $0x81e140
  802e08:	e8 83 17 00 00       	call   804590 <release_uspinlock>
  802e0d:	83 c4 10             	add    $0x10,%esp
						return NULL;
  802e10:	b8 00 00 00 00       	mov    $0x0,%eax
  802e15:	eb 4d                	jmp    802e64 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  802e17:	83 ec 0c             	sub    $0xc,%esp
  802e1a:	68 40 e1 81 00       	push   $0x81e140
  802e1f:	e8 6c 17 00 00       	call   804590 <release_uspinlock>
  802e24:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  802e27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2a:	8b 00                	mov    (%eax),%eax
  802e2c:	eb 36                	jmp    802e64 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 40 08             	mov    0x8(%eax),%eax
  802e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  802e37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e3b:	0f 85 47 fc ff ff    	jne    802a88 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  802e41:	83 ec 0c             	sub    $0xc,%esp
  802e44:	ff 75 ec             	pushl  -0x14(%ebp)
  802e47:	e8 ad 12 00 00       	call   8040f9 <free_block>
  802e4c:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  802e4f:	83 ec 0c             	sub    $0xc,%esp
  802e52:	68 40 e1 81 00       	push   $0x81e140
  802e57:	e8 34 17 00 00       	call   804590 <release_uspinlock>
  802e5c:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e64:	c9                   	leave  
  802e65:	c3                   	ret    

00802e66 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802e66:	55                   	push   %ebp
  802e67:	89 e5                	mov    %esp,%ebp
  802e69:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  802e6c:	e8 8c ec ff ff       	call   801afd <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  802e71:	83 ec 0c             	sub    $0xc,%esp
  802e74:	68 40 e1 81 00       	push   $0x81e140
  802e79:	e8 ba 16 00 00       	call   804538 <acquire_uspinlock>
  802e7e:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  802e81:	83 ec 08             	sub    $0x8,%esp
  802e84:	ff 75 0c             	pushl  0xc(%ebp)
  802e87:	ff 75 08             	pushl  0x8(%ebp)
  802e8a:	e8 f6 07 00 00       	call   803685 <sys_size_of_shared_object>
  802e8f:	83 c4 10             	add    $0x10,%esp
  802e92:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  802e95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e99:	79 1a                	jns    802eb5 <sget+0x4f>
			release_uspinlock(&ulock);
  802e9b:	83 ec 0c             	sub    $0xc,%esp
  802e9e:	68 40 e1 81 00       	push   $0x81e140
  802ea3:	e8 e8 16 00 00       	call   804590 <release_uspinlock>
  802ea8:	83 c4 10             	add    $0x10,%esp
			return NULL;
  802eab:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb0:	e9 6e 05 00 00       	jmp    803423 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  802eb5:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  802ebc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ebf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec2:	01 d0                	add    %edx,%eax
  802ec4:	48                   	dec    %eax
  802ec5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802ec8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ecb:	ba 00 00 00 00       	mov    $0x0,%edx
  802ed0:	f7 75 e8             	divl   -0x18(%ebp)
  802ed3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed6:	29 d0                	sub    %edx,%eax
  802ed8:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802edb:	83 ec 0c             	sub    $0xc,%esp
  802ede:	6a 10                	push   $0x10
  802ee0:	e8 78 0d 00 00       	call   803c5d <alloc_block>
  802ee5:	83 c4 10             	add    $0x10,%esp
  802ee8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  802eeb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802eef:	75 0a                	jne    802efb <sget+0x95>
			return NULL;
  802ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef6:	e9 28 05 00 00       	jmp    803423 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  802efb:	a1 24 e1 81 00       	mov    0x81e124,%eax
  802f00:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802f03:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  802f08:	85 c0                	test   %eax,%eax
  802f0a:	74 11                	je     802f1d <sget+0xb7>
  802f0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802f0f:	8b 50 04             	mov    0x4(%eax),%edx
  802f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f15:	39 c2                	cmp    %eax,%edx
  802f17:	0f 83 21 01 00 00    	jae    80303e <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  802f1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f20:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  802f25:	29 c2                	sub    %eax,%edx
  802f27:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802f2c:	39 c2                	cmp    %eax,%edx
  802f2e:	0f 82 f0 00 00 00    	jb     803024 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  802f34:	a1 68 e0 81 00       	mov    0x81e068,%eax
  802f39:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  802f3c:	8b 15 68 e0 81 00    	mov    0x81e068,%edx
  802f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f45:	01 d0                	add    %edx,%eax
  802f47:	a3 68 e0 81 00       	mov    %eax,0x81e068
						allocblock->startva = requestedblockva;
  802f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f4f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  802f52:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  802f54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f5a:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  802f5d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f61:	75 17                	jne    802f7a <sget+0x114>
  802f63:	83 ec 04             	sub    $0x4,%esp
  802f66:	68 98 51 80 00       	push   $0x805198
  802f6b:	68 c8 01 00 00       	push   $0x1c8
  802f70:	68 4c 51 80 00       	push   $0x80514c
  802f75:	e8 d0 d9 ff ff       	call   80094a <_panic>
  802f7a:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  802f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f83:	89 50 0c             	mov    %edx,0xc(%eax)
  802f86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f89:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8c:	85 c0                	test   %eax,%eax
  802f8e:	74 0d                	je     802f9d <sget+0x137>
  802f90:	a1 34 e1 81 00       	mov    0x81e134,%eax
  802f95:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f98:	89 50 08             	mov    %edx,0x8(%eax)
  802f9b:	eb 08                	jmp    802fa5 <sget+0x13f>
  802f9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa0:	a3 30 e1 81 00       	mov    %eax,0x81e130
  802fa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa8:	a3 34 e1 81 00       	mov    %eax,0x81e134
  802fad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fb7:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  802fbc:	40                   	inc    %eax
  802fbd:	a3 3c e1 81 00       	mov    %eax,0x81e13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  802fc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc5:	8b 00                	mov    (%eax),%eax
  802fc7:	83 ec 04             	sub    $0x4,%esp
  802fca:	50                   	push   %eax
  802fcb:	ff 75 0c             	pushl  0xc(%ebp)
  802fce:	ff 75 08             	pushl  0x8(%ebp)
  802fd1:	e8 cc 06 00 00       	call   8036a2 <sys_get_shared_object>
  802fd6:	83 c4 10             	add    $0x10,%esp
  802fd9:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  802fdc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  802fe0:	79 28                	jns    80300a <sget+0x1a4>
							free_block(allocblock);
  802fe2:	83 ec 0c             	sub    $0xc,%esp
  802fe5:	ff 75 e0             	pushl  -0x20(%ebp)
  802fe8:	e8 0c 11 00 00       	call   8040f9 <free_block>
  802fed:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  802ff0:	83 ec 0c             	sub    $0xc,%esp
  802ff3:	68 40 e1 81 00       	push   $0x81e140
  802ff8:	e8 93 15 00 00       	call   804590 <release_uspinlock>
  802ffd:	83 c4 10             	add    $0x10,%esp
							return NULL;
  803000:	b8 00 00 00 00       	mov    $0x0,%eax
  803005:	e9 19 04 00 00       	jmp    803423 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  80300a:	83 ec 0c             	sub    $0xc,%esp
  80300d:	68 40 e1 81 00       	push   $0x81e140
  803012:	e8 79 15 00 00       	call   804590 <release_uspinlock>
  803017:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  80301a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80301d:	8b 00                	mov    (%eax),%eax
  80301f:	e9 ff 03 00 00       	jmp    803423 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  803024:	83 ec 0c             	sub    $0xc,%esp
  803027:	68 40 e1 81 00       	push   $0x81e140
  80302c:	e8 5f 15 00 00       	call   804590 <release_uspinlock>
  803031:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803034:	b8 00 00 00 00       	mov    $0x0,%eax
  803039:	e9 e5 03 00 00       	jmp    803423 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  80303e:	a1 20 e1 81 00       	mov    0x81e120,%eax
  803043:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  803046:	e9 ab 03 00 00       	jmp    8033f6 <sget+0x590>
				if(size<currentfreeelement->size){
  80304b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304e:	8b 50 04             	mov    0x4(%eax),%edx
  803051:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803054:	39 c2                	cmp    %eax,%edx
  803056:	0f 86 24 02 00 00    	jbe    803280 <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  80305c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305f:	8b 10                	mov    (%eax),%edx
  803061:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803064:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803066:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803069:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80306c:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  80306f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803073:	75 17                	jne    80308c <sget+0x226>
  803075:	83 ec 04             	sub    $0x4,%esp
  803078:	68 98 51 80 00       	push   $0x805198
  80307d:	68 e0 01 00 00       	push   $0x1e0
  803082:	68 4c 51 80 00       	push   $0x80514c
  803087:	e8 be d8 ff ff       	call   80094a <_panic>
  80308c:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  803092:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803095:	89 50 0c             	mov    %edx,0xc(%eax)
  803098:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80309b:	8b 40 0c             	mov    0xc(%eax),%eax
  80309e:	85 c0                	test   %eax,%eax
  8030a0:	74 0d                	je     8030af <sget+0x249>
  8030a2:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8030a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030aa:	89 50 08             	mov    %edx,0x8(%eax)
  8030ad:	eb 08                	jmp    8030b7 <sget+0x251>
  8030af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030b2:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8030b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ba:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8030bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030c9:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  8030ce:	40                   	inc    %eax
  8030cf:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					lastfreeelement->startva += size;
  8030d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030d7:	8b 10                	mov    (%eax),%edx
  8030d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030dc:	01 c2                	add    %eax,%edx
  8030de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e1:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  8030e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030e6:	8b 50 04             	mov    0x4(%eax),%edx
  8030e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ec:	29 c2                	sub    %eax,%edx
  8030ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8030f1:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8030f4:	a1 20 e1 81 00       	mov    0x81e120,%eax
  8030f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  8030fc:	e9 13 01 00 00       	jmp    803214 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  803101:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803104:	8b 50 04             	mov    0x4(%eax),%edx
  803107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310a:	8b 40 04             	mov    0x4(%eax),%eax
  80310d:	39 c2                	cmp    %eax,%edx
  80310f:	0f 83 f6 00 00 00    	jae    80320b <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  803115:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803119:	75 17                	jne    803132 <sget+0x2cc>
  80311b:	83 ec 04             	sub    $0x4,%esp
  80311e:	68 bb 51 80 00       	push   $0x8051bb
  803123:	68 e8 01 00 00       	push   $0x1e8
  803128:	68 4c 51 80 00       	push   $0x80514c
  80312d:	e8 18 d8 ff ff       	call   80094a <_panic>
  803132:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803135:	8b 40 08             	mov    0x8(%eax),%eax
  803138:	85 c0                	test   %eax,%eax
  80313a:	74 11                	je     80314d <sget+0x2e7>
  80313c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80313f:	8b 40 08             	mov    0x8(%eax),%eax
  803142:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803145:	8b 52 0c             	mov    0xc(%edx),%edx
  803148:	89 50 0c             	mov    %edx,0xc(%eax)
  80314b:	eb 0b                	jmp    803158 <sget+0x2f2>
  80314d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803150:	8b 40 0c             	mov    0xc(%eax),%eax
  803153:	a3 24 e1 81 00       	mov    %eax,0x81e124
  803158:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80315b:	8b 40 0c             	mov    0xc(%eax),%eax
  80315e:	85 c0                	test   %eax,%eax
  803160:	74 11                	je     803173 <sget+0x30d>
  803162:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803165:	8b 40 0c             	mov    0xc(%eax),%eax
  803168:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80316b:	8b 52 08             	mov    0x8(%edx),%edx
  80316e:	89 50 08             	mov    %edx,0x8(%eax)
  803171:	eb 0b                	jmp    80317e <sget+0x318>
  803173:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803176:	8b 40 08             	mov    0x8(%eax),%eax
  803179:	a3 20 e1 81 00       	mov    %eax,0x81e120
  80317e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803181:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803188:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80318b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803192:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803197:	48                   	dec    %eax
  803198:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  80319d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031a1:	74 06                	je     8031a9 <sget+0x343>
  8031a3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8031a7:	75 17                	jne    8031c0 <sget+0x35a>
  8031a9:	83 ec 04             	sub    $0x4,%esp
  8031ac:	68 dc 51 80 00       	push   $0x8051dc
  8031b1:	68 e9 01 00 00       	push   $0x1e9
  8031b6:	68 4c 51 80 00       	push   $0x80514c
  8031bb:	e8 8a d7 ff ff       	call   80094a <_panic>
  8031c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c3:	8b 50 0c             	mov    0xc(%eax),%edx
  8031c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031c9:	89 50 0c             	mov    %edx,0xc(%eax)
  8031cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d2:	89 50 08             	mov    %edx,0x8(%eax)
  8031d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031db:	85 c0                	test   %eax,%eax
  8031dd:	74 0e                	je     8031ed <sget+0x387>
  8031df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031e8:	89 50 08             	mov    %edx,0x8(%eax)
  8031eb:	eb 08                	jmp    8031f5 <sget+0x38f>
  8031ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031f0:	a3 20 e1 81 00       	mov    %eax,0x81e120
  8031f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031fb:	89 50 0c             	mov    %edx,0xc(%eax)
  8031fe:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  803203:	40                   	inc    %eax
  803204:	a3 2c e1 81 00       	mov    %eax,0x81e12c
							break;
  803209:	eb 13                	jmp    80321e <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  80320b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80320e:	8b 40 08             	mov    0x8(%eax),%eax
  803211:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  803214:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803218:	0f 85 e3 fe ff ff    	jne    803101 <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  80321e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803221:	8b 00                	mov    (%eax),%eax
  803223:	83 ec 04             	sub    $0x4,%esp
  803226:	50                   	push   %eax
  803227:	ff 75 0c             	pushl  0xc(%ebp)
  80322a:	ff 75 08             	pushl  0x8(%ebp)
  80322d:	e8 70 04 00 00       	call   8036a2 <sys_get_shared_object>
  803232:	83 c4 10             	add    $0x10,%esp
  803235:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  803238:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80323c:	79 28                	jns    803266 <sget+0x400>
						free_block(allocblock);
  80323e:	83 ec 0c             	sub    $0xc,%esp
  803241:	ff 75 e0             	pushl  -0x20(%ebp)
  803244:	e8 b0 0e 00 00       	call   8040f9 <free_block>
  803249:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  80324c:	83 ec 0c             	sub    $0xc,%esp
  80324f:	68 40 e1 81 00       	push   $0x81e140
  803254:	e8 37 13 00 00       	call   804590 <release_uspinlock>
  803259:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80325c:	b8 00 00 00 00       	mov    $0x0,%eax
  803261:	e9 bd 01 00 00       	jmp    803423 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  803266:	83 ec 0c             	sub    $0xc,%esp
  803269:	68 40 e1 81 00       	push   $0x81e140
  80326e:	e8 1d 13 00 00       	call   804590 <release_uspinlock>
  803273:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803276:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803279:	8b 00                	mov    (%eax),%eax
  80327b:	e9 a3 01 00 00       	jmp    803423 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  803280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803283:	8b 50 04             	mov    0x4(%eax),%edx
  803286:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803289:	39 c2                	cmp    %eax,%edx
  80328b:	0f 85 5c 01 00 00    	jne    8033ed <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	8b 10                	mov    (%eax),%edx
  803296:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803299:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  80329b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80329e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032a1:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  8032a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8032a8:	75 17                	jne    8032c1 <sget+0x45b>
  8032aa:	83 ec 04             	sub    $0x4,%esp
  8032ad:	68 98 51 80 00       	push   $0x805198
  8032b2:	68 fe 01 00 00       	push   $0x1fe
  8032b7:	68 4c 51 80 00       	push   $0x80514c
  8032bc:	e8 89 d6 ff ff       	call   80094a <_panic>
  8032c1:	8b 15 34 e1 81 00    	mov    0x81e134,%edx
  8032c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ca:	89 50 0c             	mov    %edx,0xc(%eax)
  8032cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d3:	85 c0                	test   %eax,%eax
  8032d5:	74 0d                	je     8032e4 <sget+0x47e>
  8032d7:	a1 34 e1 81 00       	mov    0x81e134,%eax
  8032dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032df:	89 50 08             	mov    %edx,0x8(%eax)
  8032e2:	eb 08                	jmp    8032ec <sget+0x486>
  8032e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e7:	a3 30 e1 81 00       	mov    %eax,0x81e130
  8032ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ef:	a3 34 e1 81 00       	mov    %eax,0x81e134
  8032f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032fe:	a1 3c e1 81 00       	mov    0x81e13c,%eax
  803303:	40                   	inc    %eax
  803304:	a3 3c e1 81 00       	mov    %eax,0x81e13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803309:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80330d:	75 17                	jne    803326 <sget+0x4c0>
  80330f:	83 ec 04             	sub    $0x4,%esp
  803312:	68 bb 51 80 00       	push   $0x8051bb
  803317:	68 ff 01 00 00       	push   $0x1ff
  80331c:	68 4c 51 80 00       	push   $0x80514c
  803321:	e8 24 d6 ff ff       	call   80094a <_panic>
  803326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803329:	8b 40 08             	mov    0x8(%eax),%eax
  80332c:	85 c0                	test   %eax,%eax
  80332e:	74 11                	je     803341 <sget+0x4db>
  803330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803333:	8b 40 08             	mov    0x8(%eax),%eax
  803336:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803339:	8b 52 0c             	mov    0xc(%edx),%edx
  80333c:	89 50 0c             	mov    %edx,0xc(%eax)
  80333f:	eb 0b                	jmp    80334c <sget+0x4e6>
  803341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803344:	8b 40 0c             	mov    0xc(%eax),%eax
  803347:	a3 24 e1 81 00       	mov    %eax,0x81e124
  80334c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334f:	8b 40 0c             	mov    0xc(%eax),%eax
  803352:	85 c0                	test   %eax,%eax
  803354:	74 11                	je     803367 <sget+0x501>
  803356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803359:	8b 40 0c             	mov    0xc(%eax),%eax
  80335c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335f:	8b 52 08             	mov    0x8(%edx),%edx
  803362:	89 50 08             	mov    %edx,0x8(%eax)
  803365:	eb 0b                	jmp    803372 <sget+0x50c>
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	8b 40 08             	mov    0x8(%eax),%eax
  80336d:	a3 20 e1 81 00       	mov    %eax,0x81e120
  803372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803375:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80337c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803386:	a1 2c e1 81 00       	mov    0x81e12c,%eax
  80338b:	48                   	dec    %eax
  80338c:	a3 2c e1 81 00       	mov    %eax,0x81e12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803391:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803394:	8b 00                	mov    (%eax),%eax
  803396:	83 ec 04             	sub    $0x4,%esp
  803399:	50                   	push   %eax
  80339a:	ff 75 0c             	pushl  0xc(%ebp)
  80339d:	ff 75 08             	pushl  0x8(%ebp)
  8033a0:	e8 fd 02 00 00       	call   8036a2 <sys_get_shared_object>
  8033a5:	83 c4 10             	add    $0x10,%esp
  8033a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  8033ab:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8033af:	79 25                	jns    8033d6 <sget+0x570>
						free_block(allocblock);
  8033b1:	83 ec 0c             	sub    $0xc,%esp
  8033b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8033b7:	e8 3d 0d 00 00       	call   8040f9 <free_block>
  8033bc:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  8033bf:	83 ec 0c             	sub    $0xc,%esp
  8033c2:	68 40 e1 81 00       	push   $0x81e140
  8033c7:	e8 c4 11 00 00       	call   804590 <release_uspinlock>
  8033cc:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8033cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d4:	eb 4d                	jmp    803423 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  8033d6:	83 ec 0c             	sub    $0xc,%esp
  8033d9:	68 40 e1 81 00       	push   $0x81e140
  8033de:	e8 ad 11 00 00       	call   804590 <release_uspinlock>
  8033e3:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8033e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e9:	8b 00                	mov    (%eax),%eax
  8033eb:	eb 36                	jmp    803423 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  8033ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f0:	8b 40 08             	mov    0x8(%eax),%eax
  8033f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  8033f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033fa:	0f 85 4b fc ff ff    	jne    80304b <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  803400:	83 ec 0c             	sub    $0xc,%esp
  803403:	ff 75 e0             	pushl  -0x20(%ebp)
  803406:	e8 ee 0c 00 00       	call   8040f9 <free_block>
  80340b:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  80340e:	83 ec 0c             	sub    $0xc,%esp
  803411:	68 40 e1 81 00       	push   $0x81e140
  803416:	e8 75 11 00 00       	call   804590 <release_uspinlock>
  80341b:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80341e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803423:	c9                   	leave  
  803424:	c3                   	ret    

00803425 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  803425:	55                   	push   %ebp
  803426:	89 e5                	mov    %esp,%ebp
  803428:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  80342b:	e8 cd e6 ff ff       	call   801afd <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  803430:	83 ec 04             	sub    $0x4,%esp
  803433:	68 6c 52 80 00       	push   $0x80526c
  803438:	68 2d 02 00 00       	push   $0x22d
  80343d:	68 4c 51 80 00       	push   $0x80514c
  803442:	e8 03 d5 ff ff       	call   80094a <_panic>

00803447 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803447:	55                   	push   %ebp
  803448:	89 e5                	mov    %esp,%ebp
  80344a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  80344d:	83 ec 04             	sub    $0x4,%esp
  803450:	68 94 52 80 00       	push   $0x805294
  803455:	68 40 02 00 00       	push   $0x240
  80345a:	68 4c 51 80 00       	push   $0x80514c
  80345f:	e8 e6 d4 ff ff       	call   80094a <_panic>

00803464 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803464:	55                   	push   %ebp
  803465:	89 e5                	mov    %esp,%ebp
  803467:	57                   	push   %edi
  803468:	56                   	push   %esi
  803469:	53                   	push   %ebx
  80346a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	8b 55 0c             	mov    0xc(%ebp),%edx
  803473:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803476:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803479:	8b 7d 18             	mov    0x18(%ebp),%edi
  80347c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80347f:	cd 30                	int    $0x30
  803481:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803484:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803487:	83 c4 10             	add    $0x10,%esp
  80348a:	5b                   	pop    %ebx
  80348b:	5e                   	pop    %esi
  80348c:	5f                   	pop    %edi
  80348d:	5d                   	pop    %ebp
  80348e:	c3                   	ret    

0080348f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  80348f:	55                   	push   %ebp
  803490:	89 e5                	mov    %esp,%ebp
  803492:	83 ec 04             	sub    $0x4,%esp
  803495:	8b 45 10             	mov    0x10(%ebp),%eax
  803498:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  80349b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80349e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8034a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a5:	6a 00                	push   $0x0
  8034a7:	51                   	push   %ecx
  8034a8:	52                   	push   %edx
  8034a9:	ff 75 0c             	pushl  0xc(%ebp)
  8034ac:	50                   	push   %eax
  8034ad:	6a 00                	push   $0x0
  8034af:	e8 b0 ff ff ff       	call   803464 <syscall>
  8034b4:	83 c4 18             	add    $0x18,%esp
}
  8034b7:	90                   	nop
  8034b8:	c9                   	leave  
  8034b9:	c3                   	ret    

008034ba <sys_cgetc>:

int
sys_cgetc(void)
{
  8034ba:	55                   	push   %ebp
  8034bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8034bd:	6a 00                	push   $0x0
  8034bf:	6a 00                	push   $0x0
  8034c1:	6a 00                	push   $0x0
  8034c3:	6a 00                	push   $0x0
  8034c5:	6a 00                	push   $0x0
  8034c7:	6a 02                	push   $0x2
  8034c9:	e8 96 ff ff ff       	call   803464 <syscall>
  8034ce:	83 c4 18             	add    $0x18,%esp
}
  8034d1:	c9                   	leave  
  8034d2:	c3                   	ret    

008034d3 <sys_lock_cons>:

void sys_lock_cons(void)
{
  8034d3:	55                   	push   %ebp
  8034d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8034d6:	6a 00                	push   $0x0
  8034d8:	6a 00                	push   $0x0
  8034da:	6a 00                	push   $0x0
  8034dc:	6a 00                	push   $0x0
  8034de:	6a 00                	push   $0x0
  8034e0:	6a 03                	push   $0x3
  8034e2:	e8 7d ff ff ff       	call   803464 <syscall>
  8034e7:	83 c4 18             	add    $0x18,%esp
}
  8034ea:	90                   	nop
  8034eb:	c9                   	leave  
  8034ec:	c3                   	ret    

008034ed <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  8034ed:	55                   	push   %ebp
  8034ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8034f0:	6a 00                	push   $0x0
  8034f2:	6a 00                	push   $0x0
  8034f4:	6a 00                	push   $0x0
  8034f6:	6a 00                	push   $0x0
  8034f8:	6a 00                	push   $0x0
  8034fa:	6a 04                	push   $0x4
  8034fc:	e8 63 ff ff ff       	call   803464 <syscall>
  803501:	83 c4 18             	add    $0x18,%esp
}
  803504:	90                   	nop
  803505:	c9                   	leave  
  803506:	c3                   	ret    

00803507 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803507:	55                   	push   %ebp
  803508:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80350a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80350d:	8b 45 08             	mov    0x8(%ebp),%eax
  803510:	6a 00                	push   $0x0
  803512:	6a 00                	push   $0x0
  803514:	6a 00                	push   $0x0
  803516:	52                   	push   %edx
  803517:	50                   	push   %eax
  803518:	6a 08                	push   $0x8
  80351a:	e8 45 ff ff ff       	call   803464 <syscall>
  80351f:	83 c4 18             	add    $0x18,%esp
}
  803522:	c9                   	leave  
  803523:	c3                   	ret    

00803524 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803524:	55                   	push   %ebp
  803525:	89 e5                	mov    %esp,%ebp
  803527:	56                   	push   %esi
  803528:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803529:	8b 75 18             	mov    0x18(%ebp),%esi
  80352c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80352f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803532:	8b 55 0c             	mov    0xc(%ebp),%edx
  803535:	8b 45 08             	mov    0x8(%ebp),%eax
  803538:	56                   	push   %esi
  803539:	53                   	push   %ebx
  80353a:	51                   	push   %ecx
  80353b:	52                   	push   %edx
  80353c:	50                   	push   %eax
  80353d:	6a 09                	push   $0x9
  80353f:	e8 20 ff ff ff       	call   803464 <syscall>
  803544:	83 c4 18             	add    $0x18,%esp
}
  803547:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80354a:	5b                   	pop    %ebx
  80354b:	5e                   	pop    %esi
  80354c:	5d                   	pop    %ebp
  80354d:	c3                   	ret    

0080354e <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  80354e:	55                   	push   %ebp
  80354f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803551:	6a 00                	push   $0x0
  803553:	6a 00                	push   $0x0
  803555:	6a 00                	push   $0x0
  803557:	6a 00                	push   $0x0
  803559:	ff 75 08             	pushl  0x8(%ebp)
  80355c:	6a 0a                	push   $0xa
  80355e:	e8 01 ff ff ff       	call   803464 <syscall>
  803563:	83 c4 18             	add    $0x18,%esp
}
  803566:	c9                   	leave  
  803567:	c3                   	ret    

00803568 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803568:	55                   	push   %ebp
  803569:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80356b:	6a 00                	push   $0x0
  80356d:	6a 00                	push   $0x0
  80356f:	6a 00                	push   $0x0
  803571:	ff 75 0c             	pushl  0xc(%ebp)
  803574:	ff 75 08             	pushl  0x8(%ebp)
  803577:	6a 0b                	push   $0xb
  803579:	e8 e6 fe ff ff       	call   803464 <syscall>
  80357e:	83 c4 18             	add    $0x18,%esp
}
  803581:	c9                   	leave  
  803582:	c3                   	ret    

00803583 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803583:	55                   	push   %ebp
  803584:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803586:	6a 00                	push   $0x0
  803588:	6a 00                	push   $0x0
  80358a:	6a 00                	push   $0x0
  80358c:	6a 00                	push   $0x0
  80358e:	6a 00                	push   $0x0
  803590:	6a 0c                	push   $0xc
  803592:	e8 cd fe ff ff       	call   803464 <syscall>
  803597:	83 c4 18             	add    $0x18,%esp
}
  80359a:	c9                   	leave  
  80359b:	c3                   	ret    

0080359c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80359c:	55                   	push   %ebp
  80359d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80359f:	6a 00                	push   $0x0
  8035a1:	6a 00                	push   $0x0
  8035a3:	6a 00                	push   $0x0
  8035a5:	6a 00                	push   $0x0
  8035a7:	6a 00                	push   $0x0
  8035a9:	6a 0d                	push   $0xd
  8035ab:	e8 b4 fe ff ff       	call   803464 <syscall>
  8035b0:	83 c4 18             	add    $0x18,%esp
}
  8035b3:	c9                   	leave  
  8035b4:	c3                   	ret    

008035b5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8035b5:	55                   	push   %ebp
  8035b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8035b8:	6a 00                	push   $0x0
  8035ba:	6a 00                	push   $0x0
  8035bc:	6a 00                	push   $0x0
  8035be:	6a 00                	push   $0x0
  8035c0:	6a 00                	push   $0x0
  8035c2:	6a 0e                	push   $0xe
  8035c4:	e8 9b fe ff ff       	call   803464 <syscall>
  8035c9:	83 c4 18             	add    $0x18,%esp
}
  8035cc:	c9                   	leave  
  8035cd:	c3                   	ret    

008035ce <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8035ce:	55                   	push   %ebp
  8035cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8035d1:	6a 00                	push   $0x0
  8035d3:	6a 00                	push   $0x0
  8035d5:	6a 00                	push   $0x0
  8035d7:	6a 00                	push   $0x0
  8035d9:	6a 00                	push   $0x0
  8035db:	6a 0f                	push   $0xf
  8035dd:	e8 82 fe ff ff       	call   803464 <syscall>
  8035e2:	83 c4 18             	add    $0x18,%esp
}
  8035e5:	c9                   	leave  
  8035e6:	c3                   	ret    

008035e7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8035e7:	55                   	push   %ebp
  8035e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8035ea:	6a 00                	push   $0x0
  8035ec:	6a 00                	push   $0x0
  8035ee:	6a 00                	push   $0x0
  8035f0:	6a 00                	push   $0x0
  8035f2:	ff 75 08             	pushl  0x8(%ebp)
  8035f5:	6a 10                	push   $0x10
  8035f7:	e8 68 fe ff ff       	call   803464 <syscall>
  8035fc:	83 c4 18             	add    $0x18,%esp
}
  8035ff:	c9                   	leave  
  803600:	c3                   	ret    

00803601 <sys_scarce_memory>:

void sys_scarce_memory()
{
  803601:	55                   	push   %ebp
  803602:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  803604:	6a 00                	push   $0x0
  803606:	6a 00                	push   $0x0
  803608:	6a 00                	push   $0x0
  80360a:	6a 00                	push   $0x0
  80360c:	6a 00                	push   $0x0
  80360e:	6a 11                	push   $0x11
  803610:	e8 4f fe ff ff       	call   803464 <syscall>
  803615:	83 c4 18             	add    $0x18,%esp
}
  803618:	90                   	nop
  803619:	c9                   	leave  
  80361a:	c3                   	ret    

0080361b <sys_cputc>:

void
sys_cputc(const char c)
{
  80361b:	55                   	push   %ebp
  80361c:	89 e5                	mov    %esp,%ebp
  80361e:	83 ec 04             	sub    $0x4,%esp
  803621:	8b 45 08             	mov    0x8(%ebp),%eax
  803624:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  803627:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80362b:	6a 00                	push   $0x0
  80362d:	6a 00                	push   $0x0
  80362f:	6a 00                	push   $0x0
  803631:	6a 00                	push   $0x0
  803633:	50                   	push   %eax
  803634:	6a 01                	push   $0x1
  803636:	e8 29 fe ff ff       	call   803464 <syscall>
  80363b:	83 c4 18             	add    $0x18,%esp
}
  80363e:	90                   	nop
  80363f:	c9                   	leave  
  803640:	c3                   	ret    

00803641 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  803641:	55                   	push   %ebp
  803642:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  803644:	6a 00                	push   $0x0
  803646:	6a 00                	push   $0x0
  803648:	6a 00                	push   $0x0
  80364a:	6a 00                	push   $0x0
  80364c:	6a 00                	push   $0x0
  80364e:	6a 14                	push   $0x14
  803650:	e8 0f fe ff ff       	call   803464 <syscall>
  803655:	83 c4 18             	add    $0x18,%esp
}
  803658:	90                   	nop
  803659:	c9                   	leave  
  80365a:	c3                   	ret    

0080365b <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80365b:	55                   	push   %ebp
  80365c:	89 e5                	mov    %esp,%ebp
  80365e:	83 ec 04             	sub    $0x4,%esp
  803661:	8b 45 10             	mov    0x10(%ebp),%eax
  803664:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  803667:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80366a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80366e:	8b 45 08             	mov    0x8(%ebp),%eax
  803671:	6a 00                	push   $0x0
  803673:	51                   	push   %ecx
  803674:	52                   	push   %edx
  803675:	ff 75 0c             	pushl  0xc(%ebp)
  803678:	50                   	push   %eax
  803679:	6a 15                	push   $0x15
  80367b:	e8 e4 fd ff ff       	call   803464 <syscall>
  803680:	83 c4 18             	add    $0x18,%esp
}
  803683:	c9                   	leave  
  803684:	c3                   	ret    

00803685 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  803685:	55                   	push   %ebp
  803686:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  803688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80368b:	8b 45 08             	mov    0x8(%ebp),%eax
  80368e:	6a 00                	push   $0x0
  803690:	6a 00                	push   $0x0
  803692:	6a 00                	push   $0x0
  803694:	52                   	push   %edx
  803695:	50                   	push   %eax
  803696:	6a 16                	push   $0x16
  803698:	e8 c7 fd ff ff       	call   803464 <syscall>
  80369d:	83 c4 18             	add    $0x18,%esp
}
  8036a0:	c9                   	leave  
  8036a1:	c3                   	ret    

008036a2 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8036a2:	55                   	push   %ebp
  8036a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8036a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8036a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ae:	6a 00                	push   $0x0
  8036b0:	6a 00                	push   $0x0
  8036b2:	51                   	push   %ecx
  8036b3:	52                   	push   %edx
  8036b4:	50                   	push   %eax
  8036b5:	6a 17                	push   $0x17
  8036b7:	e8 a8 fd ff ff       	call   803464 <syscall>
  8036bc:	83 c4 18             	add    $0x18,%esp
}
  8036bf:	c9                   	leave  
  8036c0:	c3                   	ret    

008036c1 <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8036c1:	55                   	push   %ebp
  8036c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8036c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8036c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ca:	6a 00                	push   $0x0
  8036cc:	6a 00                	push   $0x0
  8036ce:	6a 00                	push   $0x0
  8036d0:	52                   	push   %edx
  8036d1:	50                   	push   %eax
  8036d2:	6a 18                	push   $0x18
  8036d4:	e8 8b fd ff ff       	call   803464 <syscall>
  8036d9:	83 c4 18             	add    $0x18,%esp
}
  8036dc:	c9                   	leave  
  8036dd:	c3                   	ret    

008036de <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8036de:	55                   	push   %ebp
  8036df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8036e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e4:	6a 00                	push   $0x0
  8036e6:	ff 75 14             	pushl  0x14(%ebp)
  8036e9:	ff 75 10             	pushl  0x10(%ebp)
  8036ec:	ff 75 0c             	pushl  0xc(%ebp)
  8036ef:	50                   	push   %eax
  8036f0:	6a 19                	push   $0x19
  8036f2:	e8 6d fd ff ff       	call   803464 <syscall>
  8036f7:	83 c4 18             	add    $0x18,%esp
}
  8036fa:	c9                   	leave  
  8036fb:	c3                   	ret    

008036fc <sys_run_env>:

void sys_run_env(int32 envId)
{
  8036fc:	55                   	push   %ebp
  8036fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8036ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803702:	6a 00                	push   $0x0
  803704:	6a 00                	push   $0x0
  803706:	6a 00                	push   $0x0
  803708:	6a 00                	push   $0x0
  80370a:	50                   	push   %eax
  80370b:	6a 1a                	push   $0x1a
  80370d:	e8 52 fd ff ff       	call   803464 <syscall>
  803712:	83 c4 18             	add    $0x18,%esp
}
  803715:	90                   	nop
  803716:	c9                   	leave  
  803717:	c3                   	ret    

00803718 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  803718:	55                   	push   %ebp
  803719:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80371b:	8b 45 08             	mov    0x8(%ebp),%eax
  80371e:	6a 00                	push   $0x0
  803720:	6a 00                	push   $0x0
  803722:	6a 00                	push   $0x0
  803724:	6a 00                	push   $0x0
  803726:	50                   	push   %eax
  803727:	6a 1b                	push   $0x1b
  803729:	e8 36 fd ff ff       	call   803464 <syscall>
  80372e:	83 c4 18             	add    $0x18,%esp
}
  803731:	c9                   	leave  
  803732:	c3                   	ret    

00803733 <sys_getenvid>:

int32 sys_getenvid(void)
{
  803733:	55                   	push   %ebp
  803734:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  803736:	6a 00                	push   $0x0
  803738:	6a 00                	push   $0x0
  80373a:	6a 00                	push   $0x0
  80373c:	6a 00                	push   $0x0
  80373e:	6a 00                	push   $0x0
  803740:	6a 05                	push   $0x5
  803742:	e8 1d fd ff ff       	call   803464 <syscall>
  803747:	83 c4 18             	add    $0x18,%esp
}
  80374a:	c9                   	leave  
  80374b:	c3                   	ret    

0080374c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80374c:	55                   	push   %ebp
  80374d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80374f:	6a 00                	push   $0x0
  803751:	6a 00                	push   $0x0
  803753:	6a 00                	push   $0x0
  803755:	6a 00                	push   $0x0
  803757:	6a 00                	push   $0x0
  803759:	6a 06                	push   $0x6
  80375b:	e8 04 fd ff ff       	call   803464 <syscall>
  803760:	83 c4 18             	add    $0x18,%esp
}
  803763:	c9                   	leave  
  803764:	c3                   	ret    

00803765 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  803765:	55                   	push   %ebp
  803766:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803768:	6a 00                	push   $0x0
  80376a:	6a 00                	push   $0x0
  80376c:	6a 00                	push   $0x0
  80376e:	6a 00                	push   $0x0
  803770:	6a 00                	push   $0x0
  803772:	6a 07                	push   $0x7
  803774:	e8 eb fc ff ff       	call   803464 <syscall>
  803779:	83 c4 18             	add    $0x18,%esp
}
  80377c:	c9                   	leave  
  80377d:	c3                   	ret    

0080377e <sys_exit_env>:


void sys_exit_env(void)
{
  80377e:	55                   	push   %ebp
  80377f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803781:	6a 00                	push   $0x0
  803783:	6a 00                	push   $0x0
  803785:	6a 00                	push   $0x0
  803787:	6a 00                	push   $0x0
  803789:	6a 00                	push   $0x0
  80378b:	6a 1c                	push   $0x1c
  80378d:	e8 d2 fc ff ff       	call   803464 <syscall>
  803792:	83 c4 18             	add    $0x18,%esp
}
  803795:	90                   	nop
  803796:	c9                   	leave  
  803797:	c3                   	ret    

00803798 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  803798:	55                   	push   %ebp
  803799:	89 e5                	mov    %esp,%ebp
  80379b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80379e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8037a1:	8d 50 04             	lea    0x4(%eax),%edx
  8037a4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8037a7:	6a 00                	push   $0x0
  8037a9:	6a 00                	push   $0x0
  8037ab:	6a 00                	push   $0x0
  8037ad:	52                   	push   %edx
  8037ae:	50                   	push   %eax
  8037af:	6a 1d                	push   $0x1d
  8037b1:	e8 ae fc ff ff       	call   803464 <syscall>
  8037b6:	83 c4 18             	add    $0x18,%esp
	return result;
  8037b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8037bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8037bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8037c2:	89 01                	mov    %eax,(%ecx)
  8037c4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8037c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ca:	c9                   	leave  
  8037cb:	c2 04 00             	ret    $0x4

008037ce <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8037ce:	55                   	push   %ebp
  8037cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8037d1:	6a 00                	push   $0x0
  8037d3:	6a 00                	push   $0x0
  8037d5:	ff 75 10             	pushl  0x10(%ebp)
  8037d8:	ff 75 0c             	pushl  0xc(%ebp)
  8037db:	ff 75 08             	pushl  0x8(%ebp)
  8037de:	6a 13                	push   $0x13
  8037e0:	e8 7f fc ff ff       	call   803464 <syscall>
  8037e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8037e8:	90                   	nop
}
  8037e9:	c9                   	leave  
  8037ea:	c3                   	ret    

008037eb <sys_rcr2>:
uint32 sys_rcr2()
{
  8037eb:	55                   	push   %ebp
  8037ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8037ee:	6a 00                	push   $0x0
  8037f0:	6a 00                	push   $0x0
  8037f2:	6a 00                	push   $0x0
  8037f4:	6a 00                	push   $0x0
  8037f6:	6a 00                	push   $0x0
  8037f8:	6a 1e                	push   $0x1e
  8037fa:	e8 65 fc ff ff       	call   803464 <syscall>
  8037ff:	83 c4 18             	add    $0x18,%esp
}
  803802:	c9                   	leave  
  803803:	c3                   	ret    

00803804 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  803804:	55                   	push   %ebp
  803805:	89 e5                	mov    %esp,%ebp
  803807:	83 ec 04             	sub    $0x4,%esp
  80380a:	8b 45 08             	mov    0x8(%ebp),%eax
  80380d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803810:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803814:	6a 00                	push   $0x0
  803816:	6a 00                	push   $0x0
  803818:	6a 00                	push   $0x0
  80381a:	6a 00                	push   $0x0
  80381c:	50                   	push   %eax
  80381d:	6a 1f                	push   $0x1f
  80381f:	e8 40 fc ff ff       	call   803464 <syscall>
  803824:	83 c4 18             	add    $0x18,%esp
	return ;
  803827:	90                   	nop
}
  803828:	c9                   	leave  
  803829:	c3                   	ret    

0080382a <rsttst>:
void rsttst()
{
  80382a:	55                   	push   %ebp
  80382b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80382d:	6a 00                	push   $0x0
  80382f:	6a 00                	push   $0x0
  803831:	6a 00                	push   $0x0
  803833:	6a 00                	push   $0x0
  803835:	6a 00                	push   $0x0
  803837:	6a 21                	push   $0x21
  803839:	e8 26 fc ff ff       	call   803464 <syscall>
  80383e:	83 c4 18             	add    $0x18,%esp
	return ;
  803841:	90                   	nop
}
  803842:	c9                   	leave  
  803843:	c3                   	ret    

00803844 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803844:	55                   	push   %ebp
  803845:	89 e5                	mov    %esp,%ebp
  803847:	83 ec 04             	sub    $0x4,%esp
  80384a:	8b 45 14             	mov    0x14(%ebp),%eax
  80384d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803850:	8b 55 18             	mov    0x18(%ebp),%edx
  803853:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  803857:	52                   	push   %edx
  803858:	50                   	push   %eax
  803859:	ff 75 10             	pushl  0x10(%ebp)
  80385c:	ff 75 0c             	pushl  0xc(%ebp)
  80385f:	ff 75 08             	pushl  0x8(%ebp)
  803862:	6a 20                	push   $0x20
  803864:	e8 fb fb ff ff       	call   803464 <syscall>
  803869:	83 c4 18             	add    $0x18,%esp
	return ;
  80386c:	90                   	nop
}
  80386d:	c9                   	leave  
  80386e:	c3                   	ret    

0080386f <chktst>:
void chktst(uint32 n)
{
  80386f:	55                   	push   %ebp
  803870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803872:	6a 00                	push   $0x0
  803874:	6a 00                	push   $0x0
  803876:	6a 00                	push   $0x0
  803878:	6a 00                	push   $0x0
  80387a:	ff 75 08             	pushl  0x8(%ebp)
  80387d:	6a 22                	push   $0x22
  80387f:	e8 e0 fb ff ff       	call   803464 <syscall>
  803884:	83 c4 18             	add    $0x18,%esp
	return ;
  803887:	90                   	nop
}
  803888:	c9                   	leave  
  803889:	c3                   	ret    

0080388a <inctst>:

void inctst()
{
  80388a:	55                   	push   %ebp
  80388b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80388d:	6a 00                	push   $0x0
  80388f:	6a 00                	push   $0x0
  803891:	6a 00                	push   $0x0
  803893:	6a 00                	push   $0x0
  803895:	6a 00                	push   $0x0
  803897:	6a 23                	push   $0x23
  803899:	e8 c6 fb ff ff       	call   803464 <syscall>
  80389e:	83 c4 18             	add    $0x18,%esp
	return ;
  8038a1:	90                   	nop
}
  8038a2:	c9                   	leave  
  8038a3:	c3                   	ret    

008038a4 <gettst>:
uint32 gettst()
{
  8038a4:	55                   	push   %ebp
  8038a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8038a7:	6a 00                	push   $0x0
  8038a9:	6a 00                	push   $0x0
  8038ab:	6a 00                	push   $0x0
  8038ad:	6a 00                	push   $0x0
  8038af:	6a 00                	push   $0x0
  8038b1:	6a 24                	push   $0x24
  8038b3:	e8 ac fb ff ff       	call   803464 <syscall>
  8038b8:	83 c4 18             	add    $0x18,%esp
}
  8038bb:	c9                   	leave  
  8038bc:	c3                   	ret    

008038bd <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8038bd:	55                   	push   %ebp
  8038be:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8038c0:	6a 00                	push   $0x0
  8038c2:	6a 00                	push   $0x0
  8038c4:	6a 00                	push   $0x0
  8038c6:	6a 00                	push   $0x0
  8038c8:	6a 00                	push   $0x0
  8038ca:	6a 25                	push   $0x25
  8038cc:	e8 93 fb ff ff       	call   803464 <syscall>
  8038d1:	83 c4 18             	add    $0x18,%esp
  8038d4:	a3 60 e0 81 00       	mov    %eax,0x81e060
	return uheapPlaceStrategy ;
  8038d9:	a1 60 e0 81 00       	mov    0x81e060,%eax
}
  8038de:	c9                   	leave  
  8038df:	c3                   	ret    

008038e0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8038e0:	55                   	push   %ebp
  8038e1:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  8038e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e6:	a3 60 e0 81 00       	mov    %eax,0x81e060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8038eb:	6a 00                	push   $0x0
  8038ed:	6a 00                	push   $0x0
  8038ef:	6a 00                	push   $0x0
  8038f1:	6a 00                	push   $0x0
  8038f3:	ff 75 08             	pushl  0x8(%ebp)
  8038f6:	6a 26                	push   $0x26
  8038f8:	e8 67 fb ff ff       	call   803464 <syscall>
  8038fd:	83 c4 18             	add    $0x18,%esp
	return ;
  803900:	90                   	nop
}
  803901:	c9                   	leave  
  803902:	c3                   	ret    

00803903 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  803903:	55                   	push   %ebp
  803904:	89 e5                	mov    %esp,%ebp
  803906:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  803907:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80390a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80390d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803910:	8b 45 08             	mov    0x8(%ebp),%eax
  803913:	6a 00                	push   $0x0
  803915:	53                   	push   %ebx
  803916:	51                   	push   %ecx
  803917:	52                   	push   %edx
  803918:	50                   	push   %eax
  803919:	6a 27                	push   $0x27
  80391b:	e8 44 fb ff ff       	call   803464 <syscall>
  803920:	83 c4 18             	add    $0x18,%esp
}
  803923:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803926:	c9                   	leave  
  803927:	c3                   	ret    

00803928 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  803928:	55                   	push   %ebp
  803929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80392b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80392e:	8b 45 08             	mov    0x8(%ebp),%eax
  803931:	6a 00                	push   $0x0
  803933:	6a 00                	push   $0x0
  803935:	6a 00                	push   $0x0
  803937:	52                   	push   %edx
  803938:	50                   	push   %eax
  803939:	6a 28                	push   $0x28
  80393b:	e8 24 fb ff ff       	call   803464 <syscall>
  803940:	83 c4 18             	add    $0x18,%esp
}
  803943:	c9                   	leave  
  803944:	c3                   	ret    

00803945 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  803945:	55                   	push   %ebp
  803946:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  803948:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80394b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80394e:	8b 45 08             	mov    0x8(%ebp),%eax
  803951:	6a 00                	push   $0x0
  803953:	51                   	push   %ecx
  803954:	ff 75 10             	pushl  0x10(%ebp)
  803957:	52                   	push   %edx
  803958:	50                   	push   %eax
  803959:	6a 29                	push   $0x29
  80395b:	e8 04 fb ff ff       	call   803464 <syscall>
  803960:	83 c4 18             	add    $0x18,%esp
}
  803963:	c9                   	leave  
  803964:	c3                   	ret    

00803965 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  803965:	55                   	push   %ebp
  803966:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  803968:	6a 00                	push   $0x0
  80396a:	6a 00                	push   $0x0
  80396c:	ff 75 10             	pushl  0x10(%ebp)
  80396f:	ff 75 0c             	pushl  0xc(%ebp)
  803972:	ff 75 08             	pushl  0x8(%ebp)
  803975:	6a 12                	push   $0x12
  803977:	e8 e8 fa ff ff       	call   803464 <syscall>
  80397c:	83 c4 18             	add    $0x18,%esp
	return ;
  80397f:	90                   	nop
}
  803980:	c9                   	leave  
  803981:	c3                   	ret    

00803982 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  803982:	55                   	push   %ebp
  803983:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  803985:	8b 55 0c             	mov    0xc(%ebp),%edx
  803988:	8b 45 08             	mov    0x8(%ebp),%eax
  80398b:	6a 00                	push   $0x0
  80398d:	6a 00                	push   $0x0
  80398f:	6a 00                	push   $0x0
  803991:	52                   	push   %edx
  803992:	50                   	push   %eax
  803993:	6a 2a                	push   $0x2a
  803995:	e8 ca fa ff ff       	call   803464 <syscall>
  80399a:	83 c4 18             	add    $0x18,%esp
	return;
  80399d:	90                   	nop
}
  80399e:	c9                   	leave  
  80399f:	c3                   	ret    

008039a0 <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8039a0:	55                   	push   %ebp
  8039a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8039a3:	6a 00                	push   $0x0
  8039a5:	6a 00                	push   $0x0
  8039a7:	6a 00                	push   $0x0
  8039a9:	6a 00                	push   $0x0
  8039ab:	6a 00                	push   $0x0
  8039ad:	6a 2b                	push   $0x2b
  8039af:	e8 b0 fa ff ff       	call   803464 <syscall>
  8039b4:	83 c4 18             	add    $0x18,%esp
}
  8039b7:	c9                   	leave  
  8039b8:	c3                   	ret    

008039b9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8039b9:	55                   	push   %ebp
  8039ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8039bc:	6a 00                	push   $0x0
  8039be:	6a 00                	push   $0x0
  8039c0:	6a 00                	push   $0x0
  8039c2:	ff 75 0c             	pushl  0xc(%ebp)
  8039c5:	ff 75 08             	pushl  0x8(%ebp)
  8039c8:	6a 2d                	push   $0x2d
  8039ca:	e8 95 fa ff ff       	call   803464 <syscall>
  8039cf:	83 c4 18             	add    $0x18,%esp
	return;
  8039d2:	90                   	nop
}
  8039d3:	c9                   	leave  
  8039d4:	c3                   	ret    

008039d5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8039d5:	55                   	push   %ebp
  8039d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8039d8:	6a 00                	push   $0x0
  8039da:	6a 00                	push   $0x0
  8039dc:	6a 00                	push   $0x0
  8039de:	ff 75 0c             	pushl  0xc(%ebp)
  8039e1:	ff 75 08             	pushl  0x8(%ebp)
  8039e4:	6a 2c                	push   $0x2c
  8039e6:	e8 79 fa ff ff       	call   803464 <syscall>
  8039eb:	83 c4 18             	add    $0x18,%esp
	return ;
  8039ee:	90                   	nop
}
  8039ef:	c9                   	leave  
  8039f0:	c3                   	ret    

008039f1 <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  8039f1:	55                   	push   %ebp
  8039f2:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8039f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fa:	6a 00                	push   $0x0
  8039fc:	6a 00                	push   $0x0
  8039fe:	6a 00                	push   $0x0
  803a00:	52                   	push   %edx
  803a01:	50                   	push   %eax
  803a02:	6a 2e                	push   $0x2e
  803a04:	e8 5b fa ff ff       	call   803464 <syscall>
  803a09:	83 c4 18             	add    $0x18,%esp
	    return;
  803a0c:	90                   	nop
}
  803a0d:	c9                   	leave  
  803a0e:	c3                   	ret    

00803a0f <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  803a0f:	55                   	push   %ebp
  803a10:	89 e5                	mov    %esp,%ebp
  803a12:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  803a15:	8b 45 08             	mov    0x8(%ebp),%eax
  803a18:	ba 60 60 80 00       	mov    $0x806060,%edx
  803a1d:	29 d0                	sub    %edx,%eax
  803a1f:	c1 f8 02             	sar    $0x2,%eax
  803a22:	89 c2                	mov    %eax,%edx
  803a24:	89 d0                	mov    %edx,%eax
  803a26:	c1 e0 02             	shl    $0x2,%eax
  803a29:	01 d0                	add    %edx,%eax
  803a2b:	c1 e0 02             	shl    $0x2,%eax
  803a2e:	01 d0                	add    %edx,%eax
  803a30:	c1 e0 02             	shl    $0x2,%eax
  803a33:	01 d0                	add    %edx,%eax
  803a35:	89 c1                	mov    %eax,%ecx
  803a37:	c1 e1 08             	shl    $0x8,%ecx
  803a3a:	01 c8                	add    %ecx,%eax
  803a3c:	89 c1                	mov    %eax,%ecx
  803a3e:	c1 e1 10             	shl    $0x10,%ecx
  803a41:	01 c8                	add    %ecx,%eax
  803a43:	01 c0                	add    %eax,%eax
  803a45:	01 d0                	add    %edx,%eax
  803a47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  803a4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803a4d:	c1 e0 0c             	shl    $0xc,%eax
  803a50:	89 c2                	mov    %eax,%edx
  803a52:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803a57:	01 d0                	add    %edx,%eax
}
  803a59:	c9                   	leave  
  803a5a:	c3                   	ret    

00803a5b <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  803a5b:	55                   	push   %ebp
  803a5c:	89 e5                	mov    %esp,%ebp
  803a5e:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  803a61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  803a68:	eb 06                	jmp    803a70 <log2+0x15>
			n >>=1;
  803a6a:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  803a6d:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  803a70:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  803a74:	77 f4                	ja     803a6a <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  803a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  803a79:	c9                   	leave  
  803a7a:	c3                   	ret    

00803a7b <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  803a7b:	55                   	push   %ebp
  803a7c:	89 e5                	mov    %esp,%ebp
  803a7e:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  803a81:	8b 45 08             	mov    0x8(%ebp),%eax
  803a84:	05 00 00 00 02       	add    $0x2000000,%eax
  803a89:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803a8c:	73 16                	jae    803aa4 <initialize_dynamic_allocator+0x29>
  803a8e:	68 b8 52 80 00       	push   $0x8052b8
  803a93:	68 de 52 80 00       	push   $0x8052de
  803a98:	6a 2d                	push   $0x2d
  803a9a:	68 f3 52 80 00       	push   $0x8052f3
  803a9f:	e8 a6 ce ff ff       	call   80094a <_panic>
		is_initialized = 1;
  803aa4:	c7 05 24 60 80 00 01 	movl   $0x1,0x806024
  803aab:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  803aae:	8b 45 08             	mov    0x8(%ebp),%eax
  803ab1:	a3 64 e0 81 00       	mov    %eax,0x81e064
	dynAllocEnd= daEnd;
  803ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ab9:	a3 40 60 80 00       	mov    %eax,0x806040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  803abe:	8b 15 40 60 80 00    	mov    0x806040,%edx
  803ac4:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803ac9:	29 c2                	sub    %eax,%edx
  803acb:	89 d0                	mov    %edx,%eax
  803acd:	c1 e8 0c             	shr    $0xc,%eax
  803ad0:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  803ad3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  803ada:	eb 2f                	jmp    803b0b <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  803adc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803adf:	89 d0                	mov    %edx,%eax
  803ae1:	01 c0                	add    %eax,%eax
  803ae3:	01 d0                	add    %edx,%eax
  803ae5:	c1 e0 02             	shl    $0x2,%eax
  803ae8:	05 68 60 80 00       	add    $0x806068,%eax
  803aed:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  803af2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803af5:	89 d0                	mov    %edx,%eax
  803af7:	01 c0                	add    %eax,%eax
  803af9:	01 d0                	add    %edx,%eax
  803afb:	c1 e0 02             	shl    $0x2,%eax
  803afe:	05 6a 60 80 00       	add    $0x80606a,%eax
  803b03:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  803b08:	ff 45 f4             	incl   -0xc(%ebp)
  803b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b0e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803b11:	7c c9                	jl     803adc <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  803b13:	c7 05 48 60 80 00 00 	movl   $0x0,0x806048
  803b1a:	00 00 00 
  803b1d:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  803b24:	00 00 00 
  803b27:	c7 05 54 60 80 00 00 	movl   $0x0,0x806054
  803b2e:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  803b31:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803b38:	e9 9c 00 00 00       	jmp    803bd9 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  803b3d:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803b43:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b46:	89 c8                	mov    %ecx,%eax
  803b48:	01 c0                	add    %eax,%eax
  803b4a:	01 c8                	add    %ecx,%eax
  803b4c:	c1 e0 02             	shl    $0x2,%eax
  803b4f:	05 64 60 80 00       	add    $0x806064,%eax
  803b54:	89 10                	mov    %edx,(%eax)
  803b56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b59:	89 d0                	mov    %edx,%eax
  803b5b:	01 c0                	add    %eax,%eax
  803b5d:	01 d0                	add    %edx,%eax
  803b5f:	c1 e0 02             	shl    $0x2,%eax
  803b62:	05 64 60 80 00       	add    $0x806064,%eax
  803b67:	8b 00                	mov    (%eax),%eax
  803b69:	85 c0                	test   %eax,%eax
  803b6b:	74 1b                	je     803b88 <initialize_dynamic_allocator+0x10d>
  803b6d:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  803b73:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b76:	89 c8                	mov    %ecx,%eax
  803b78:	01 c0                	add    %eax,%eax
  803b7a:	01 c8                	add    %ecx,%eax
  803b7c:	c1 e0 02             	shl    $0x2,%eax
  803b7f:	05 60 60 80 00       	add    $0x806060,%eax
  803b84:	89 02                	mov    %eax,(%edx)
  803b86:	eb 16                	jmp    803b9e <initialize_dynamic_allocator+0x123>
  803b88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803b8b:	89 d0                	mov    %edx,%eax
  803b8d:	01 c0                	add    %eax,%eax
  803b8f:	01 d0                	add    %edx,%eax
  803b91:	c1 e0 02             	shl    $0x2,%eax
  803b94:	05 60 60 80 00       	add    $0x806060,%eax
  803b99:	a3 48 60 80 00       	mov    %eax,0x806048
  803b9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ba1:	89 d0                	mov    %edx,%eax
  803ba3:	01 c0                	add    %eax,%eax
  803ba5:	01 d0                	add    %edx,%eax
  803ba7:	c1 e0 02             	shl    $0x2,%eax
  803baa:	05 60 60 80 00       	add    $0x806060,%eax
  803baf:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803bb4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bb7:	89 d0                	mov    %edx,%eax
  803bb9:	01 c0                	add    %eax,%eax
  803bbb:	01 d0                	add    %edx,%eax
  803bbd:	c1 e0 02             	shl    $0x2,%eax
  803bc0:	05 60 60 80 00       	add    $0x806060,%eax
  803bc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bcb:	a1 54 60 80 00       	mov    0x806054,%eax
  803bd0:	40                   	inc    %eax
  803bd1:	a3 54 60 80 00       	mov    %eax,0x806054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  803bd6:	ff 45 f0             	incl   -0x10(%ebp)
  803bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bdc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803bdf:	0f 8c 58 ff ff ff    	jl     803b3d <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803be5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  803bec:	eb 36                	jmp    803c24 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  803bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803bf1:	c1 e0 04             	shl    $0x4,%eax
  803bf4:	05 80 e0 81 00       	add    $0x81e080,%eax
  803bf9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c02:	c1 e0 04             	shl    $0x4,%eax
  803c05:	05 84 e0 81 00       	add    $0x81e084,%eax
  803c0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803c13:	c1 e0 04             	shl    $0x4,%eax
  803c16:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803c1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  803c21:	ff 45 ec             	incl   -0x14(%ebp)
  803c24:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  803c28:	7e c4                	jle    803bee <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  803c2a:	90                   	nop
  803c2b:	c9                   	leave  
  803c2c:	c3                   	ret    

00803c2d <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  803c2d:	55                   	push   %ebp
  803c2e:	89 e5                	mov    %esp,%ebp
  803c30:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  803c33:	8b 55 08             	mov    0x8(%ebp),%edx
  803c36:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803c3b:	29 c2                	sub    %eax,%edx
  803c3d:	89 d0                	mov    %edx,%eax
  803c3f:	c1 e8 0c             	shr    $0xc,%eax
  803c42:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  803c45:	8b 55 fc             	mov    -0x4(%ebp),%edx
  803c48:	89 d0                	mov    %edx,%eax
  803c4a:	01 c0                	add    %eax,%eax
  803c4c:	01 d0                	add    %edx,%eax
  803c4e:	c1 e0 02             	shl    $0x2,%eax
  803c51:	05 68 60 80 00       	add    $0x806068,%eax
  803c56:	8b 00                	mov    (%eax),%eax
  803c58:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  803c5b:	c9                   	leave  
  803c5c:	c3                   	ret    

00803c5d <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  803c5d:	55                   	push   %ebp
  803c5e:	89 e5                	mov    %esp,%ebp
  803c60:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  803c63:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  803c6a:	76 16                	jbe    803c82 <alloc_block+0x25>
  803c6c:	68 0c 53 80 00       	push   $0x80530c
  803c71:	68 de 52 80 00       	push   $0x8052de
  803c76:	6a 6c                	push   $0x6c
  803c78:	68 f3 52 80 00       	push   $0x8052f3
  803c7d:	e8 c8 cc ff ff       	call   80094a <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  803c82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c86:	75 0a                	jne    803c92 <alloc_block+0x35>
		return NULL;
  803c88:	b8 00 00 00 00       	mov    $0x0,%eax
  803c8d:	e9 65 04 00 00       	jmp    8040f7 <alloc_block+0x49a>
	}
	else if(size<=8){
  803c92:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  803c96:	77 09                	ja     803ca1 <alloc_block+0x44>
		size=8;
  803c98:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  803c9f:	eb 1f                	jmp    803cc0 <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  803ca1:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  803ca8:	eb 08                	jmp    803cb2 <alloc_block+0x55>
			reqsize*=2;
  803caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cad:	01 c0                	add    %eax,%eax
  803caf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  803cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb5:	3b 45 08             	cmp    0x8(%ebp),%eax
  803cb8:	72 f0                	jb     803caa <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  803cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbd:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  803cc0:	83 ec 0c             	sub    $0xc,%esp
  803cc3:	ff 75 08             	pushl  0x8(%ebp)
  803cc6:	e8 90 fd ff ff       	call   803a5b <log2>
  803ccb:	83 c4 10             	add    $0x10,%esp
  803cce:	83 e8 03             	sub    $0x3,%eax
  803cd1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  803cd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cd7:	c1 e0 04             	shl    $0x4,%eax
  803cda:	05 80 e0 81 00       	add    $0x81e080,%eax
  803cdf:	8b 00                	mov    (%eax),%eax
  803ce1:	85 c0                	test   %eax,%eax
  803ce3:	0f 84 fb 00 00 00    	je     803de4 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  803ce9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803cec:	c1 e0 04             	shl    $0x4,%eax
  803cef:	05 80 e0 81 00       	add    $0x81e080,%eax
  803cf4:	8b 00                	mov    (%eax),%eax
  803cf6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  803cf9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803cfd:	75 17                	jne    803d16 <alloc_block+0xb9>
  803cff:	83 ec 04             	sub    $0x4,%esp
  803d02:	68 2d 53 80 00       	push   $0x80532d
  803d07:	68 86 00 00 00       	push   $0x86
  803d0c:	68 f3 52 80 00       	push   $0x8052f3
  803d11:	e8 34 cc ff ff       	call   80094a <_panic>
  803d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d19:	8b 00                	mov    (%eax),%eax
  803d1b:	85 c0                	test   %eax,%eax
  803d1d:	74 10                	je     803d2f <alloc_block+0xd2>
  803d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d22:	8b 00                	mov    (%eax),%eax
  803d24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d27:	8b 52 04             	mov    0x4(%edx),%edx
  803d2a:	89 50 04             	mov    %edx,0x4(%eax)
  803d2d:	eb 14                	jmp    803d43 <alloc_block+0xe6>
  803d2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d32:	8b 40 04             	mov    0x4(%eax),%eax
  803d35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d38:	c1 e2 04             	shl    $0x4,%edx
  803d3b:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  803d41:	89 02                	mov    %eax,(%edx)
  803d43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d46:	8b 40 04             	mov    0x4(%eax),%eax
  803d49:	85 c0                	test   %eax,%eax
  803d4b:	74 0f                	je     803d5c <alloc_block+0xff>
  803d4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d50:	8b 40 04             	mov    0x4(%eax),%eax
  803d53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803d56:	8b 12                	mov    (%edx),%edx
  803d58:	89 10                	mov    %edx,(%eax)
  803d5a:	eb 13                	jmp    803d6f <alloc_block+0x112>
  803d5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d5f:	8b 00                	mov    (%eax),%eax
  803d61:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803d64:	c1 e2 04             	shl    $0x4,%edx
  803d67:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  803d6d:	89 02                	mov    %eax,(%edx)
  803d6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d85:	c1 e0 04             	shl    $0x4,%eax
  803d88:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803d8d:	8b 00                	mov    (%eax),%eax
  803d8f:	8d 50 ff             	lea    -0x1(%eax),%edx
  803d92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d95:	c1 e0 04             	shl    $0x4,%eax
  803d98:	05 8c e0 81 00       	add    $0x81e08c,%eax
  803d9d:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  803d9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803da2:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803da7:	29 c2                	sub    %eax,%edx
  803da9:	89 d0                	mov    %edx,%eax
  803dab:	c1 e8 0c             	shr    $0xc,%eax
  803dae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  803db1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803db4:	89 d0                	mov    %edx,%eax
  803db6:	01 c0                	add    %eax,%eax
  803db8:	01 d0                	add    %edx,%eax
  803dba:	c1 e0 02             	shl    $0x2,%eax
  803dbd:	05 6a 60 80 00       	add    $0x80606a,%eax
  803dc2:	66 8b 00             	mov    (%eax),%ax
  803dc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  803dc8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  803dcb:	89 c8                	mov    %ecx,%eax
  803dcd:	01 c0                	add    %eax,%eax
  803dcf:	01 c8                	add    %ecx,%eax
  803dd1:	c1 e0 02             	shl    $0x2,%eax
  803dd4:	05 6a 60 80 00       	add    $0x80606a,%eax
  803dd9:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  803ddc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ddf:	e9 13 03 00 00       	jmp    8040f7 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  803de4:	a1 48 60 80 00       	mov    0x806048,%eax
  803de9:	85 c0                	test   %eax,%eax
  803deb:	0f 84 c9 01 00 00    	je     803fba <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  803df1:	a1 48 60 80 00       	mov    0x806048,%eax
  803df6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  803df9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803dfd:	75 17                	jne    803e16 <alloc_block+0x1b9>
  803dff:	83 ec 04             	sub    $0x4,%esp
  803e02:	68 2d 53 80 00       	push   $0x80532d
  803e07:	68 8f 00 00 00       	push   $0x8f
  803e0c:	68 f3 52 80 00       	push   $0x8052f3
  803e11:	e8 34 cb ff ff       	call   80094a <_panic>
  803e16:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e19:	8b 00                	mov    (%eax),%eax
  803e1b:	85 c0                	test   %eax,%eax
  803e1d:	74 10                	je     803e2f <alloc_block+0x1d2>
  803e1f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e22:	8b 00                	mov    (%eax),%eax
  803e24:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e27:	8b 52 04             	mov    0x4(%edx),%edx
  803e2a:	89 50 04             	mov    %edx,0x4(%eax)
  803e2d:	eb 0b                	jmp    803e3a <alloc_block+0x1dd>
  803e2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e32:	8b 40 04             	mov    0x4(%eax),%eax
  803e35:	a3 4c 60 80 00       	mov    %eax,0x80604c
  803e3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e3d:	8b 40 04             	mov    0x4(%eax),%eax
  803e40:	85 c0                	test   %eax,%eax
  803e42:	74 0f                	je     803e53 <alloc_block+0x1f6>
  803e44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e47:	8b 40 04             	mov    0x4(%eax),%eax
  803e4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e4d:	8b 12                	mov    (%edx),%edx
  803e4f:	89 10                	mov    %edx,(%eax)
  803e51:	eb 0a                	jmp    803e5d <alloc_block+0x200>
  803e53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e56:	8b 00                	mov    (%eax),%eax
  803e58:	a3 48 60 80 00       	mov    %eax,0x806048
  803e5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803e69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e70:	a1 54 60 80 00       	mov    0x806054,%eax
  803e75:	48                   	dec    %eax
  803e76:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  803e7b:	83 ec 0c             	sub    $0xc,%esp
  803e7e:	ff 75 dc             	pushl  -0x24(%ebp)
  803e81:	e8 89 fb ff ff       	call   803a0f <to_page_va>
  803e86:	83 c4 10             	add    $0x10,%esp
  803e89:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  803e8c:	a1 64 e0 81 00       	mov    0x81e064,%eax
  803e91:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803e94:	29 c2                	sub    %eax,%edx
  803e96:	89 d0                	mov    %edx,%eax
  803e98:	c1 e8 0c             	shr    $0xc,%eax
  803e9b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  803e9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ea1:	83 ec 0c             	sub    $0xc,%esp
  803ea4:	50                   	push   %eax
  803ea5:	e8 fe dc ff ff       	call   801ba8 <get_page>
  803eaa:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  803ead:	8b 45 08             	mov    0x8(%ebp),%eax
  803eb0:	89 c2                	mov    %eax,%edx
  803eb2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803eb5:	89 c8                	mov    %ecx,%eax
  803eb7:	01 c0                	add    %eax,%eax
  803eb9:	01 c8                	add    %ecx,%eax
  803ebb:	c1 e0 02             	shl    $0x2,%eax
  803ebe:	05 68 60 80 00       	add    $0x806068,%eax
  803ec3:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  803ec6:	b8 00 10 00 00       	mov    $0x1000,%eax
  803ecb:	ba 00 00 00 00       	mov    $0x0,%edx
  803ed0:	f7 75 08             	divl   0x8(%ebp)
  803ed3:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  803ed6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803ed9:	8d 50 ff             	lea    -0x1(%eax),%edx
  803edc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  803edf:	89 c8                	mov    %ecx,%eax
  803ee1:	01 c0                	add    %eax,%eax
  803ee3:	01 c8                	add    %ecx,%eax
  803ee5:	c1 e0 02             	shl    $0x2,%eax
  803ee8:	05 6a 60 80 00       	add    $0x80606a,%eax
  803eed:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  803ef0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  803ef7:	e9 aa 00 00 00       	jmp    803fa6 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  803efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eff:	0f af 45 08          	imul   0x8(%ebp),%eax
  803f03:	89 c2                	mov    %eax,%edx
  803f05:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f08:	01 d0                	add    %edx,%eax
  803f0a:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  803f0d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803f11:	75 17                	jne    803f2a <alloc_block+0x2cd>
  803f13:	83 ec 04             	sub    $0x4,%esp
  803f16:	68 4c 53 80 00       	push   $0x80534c
  803f1b:	68 9d 00 00 00       	push   $0x9d
  803f20:	68 f3 52 80 00       	push   $0x8052f3
  803f25:	e8 20 ca ff ff       	call   80094a <_panic>
  803f2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f2d:	c1 e0 04             	shl    $0x4,%eax
  803f30:	05 84 e0 81 00       	add    $0x81e084,%eax
  803f35:	8b 10                	mov    (%eax),%edx
  803f37:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f3a:	89 50 04             	mov    %edx,0x4(%eax)
  803f3d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f40:	8b 40 04             	mov    0x4(%eax),%eax
  803f43:	85 c0                	test   %eax,%eax
  803f45:	74 14                	je     803f5b <alloc_block+0x2fe>
  803f47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f4a:	c1 e0 04             	shl    $0x4,%eax
  803f4d:	05 84 e0 81 00       	add    $0x81e084,%eax
  803f52:	8b 00                	mov    (%eax),%eax
  803f54:	8b 55 cc             	mov    -0x34(%ebp),%edx
  803f57:	89 10                	mov    %edx,(%eax)
  803f59:	eb 11                	jmp    803f6c <alloc_block+0x30f>
  803f5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f5e:	c1 e0 04             	shl    $0x4,%eax
  803f61:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  803f67:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f6a:	89 02                	mov    %eax,(%edx)
  803f6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f6f:	c1 e0 04             	shl    $0x4,%eax
  803f72:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  803f78:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803f7b:	89 02                	mov    %eax,(%edx)
  803f7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
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

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  803fa3:	ff 45 f0             	incl   -0x10(%ebp)
  803fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fa9:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  803fac:	0f 8c 4a ff ff ff    	jl     803efc <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  803fb2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803fb5:	e9 3d 01 00 00       	jmp    8040f7 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  803fba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803fbd:	40                   	inc    %eax
  803fbe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803fc1:	e9 10 01 00 00       	jmp    8040d6 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  803fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fc9:	c1 e0 04             	shl    $0x4,%eax
  803fcc:	05 80 e0 81 00       	add    $0x81e080,%eax
  803fd1:	8b 00                	mov    (%eax),%eax
  803fd3:	85 c0                	test   %eax,%eax
  803fd5:	0f 84 f8 00 00 00    	je     8040d3 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  803fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803fde:	c1 e0 04             	shl    $0x4,%eax
  803fe1:	05 80 e0 81 00       	add    $0x81e080,%eax
  803fe6:	8b 00                	mov    (%eax),%eax
  803fe8:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  803feb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  803fef:	75 17                	jne    804008 <alloc_block+0x3ab>
  803ff1:	83 ec 04             	sub    $0x4,%esp
  803ff4:	68 2d 53 80 00       	push   $0x80532d
  803ff9:	68 a8 00 00 00       	push   $0xa8
  803ffe:	68 f3 52 80 00       	push   $0x8052f3
  804003:	e8 42 c9 ff ff       	call   80094a <_panic>
  804008:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80400b:	8b 00                	mov    (%eax),%eax
  80400d:	85 c0                	test   %eax,%eax
  80400f:	74 10                	je     804021 <alloc_block+0x3c4>
  804011:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804014:	8b 00                	mov    (%eax),%eax
  804016:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804019:	8b 52 04             	mov    0x4(%edx),%edx
  80401c:	89 50 04             	mov    %edx,0x4(%eax)
  80401f:	eb 14                	jmp    804035 <alloc_block+0x3d8>
  804021:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804024:	8b 40 04             	mov    0x4(%eax),%eax
  804027:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80402a:	c1 e2 04             	shl    $0x4,%edx
  80402d:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  804033:	89 02                	mov    %eax,(%edx)
  804035:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804038:	8b 40 04             	mov    0x4(%eax),%eax
  80403b:	85 c0                	test   %eax,%eax
  80403d:	74 0f                	je     80404e <alloc_block+0x3f1>
  80403f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804042:	8b 40 04             	mov    0x4(%eax),%eax
  804045:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804048:	8b 12                	mov    (%edx),%edx
  80404a:	89 10                	mov    %edx,(%eax)
  80404c:	eb 13                	jmp    804061 <alloc_block+0x404>
  80404e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804051:	8b 00                	mov    (%eax),%eax
  804053:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804056:	c1 e2 04             	shl    $0x4,%edx
  804059:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  80405f:	89 02                	mov    %eax,(%edx)
  804061:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804064:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80406a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80406d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804074:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804077:	c1 e0 04             	shl    $0x4,%eax
  80407a:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80407f:	8b 00                	mov    (%eax),%eax
  804081:	8d 50 ff             	lea    -0x1(%eax),%edx
  804084:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804087:	c1 e0 04             	shl    $0x4,%eax
  80408a:	05 8c e0 81 00       	add    $0x81e08c,%eax
  80408f:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804091:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804094:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804099:	29 c2                	sub    %eax,%edx
  80409b:	89 d0                	mov    %edx,%eax
  80409d:	c1 e8 0c             	shr    $0xc,%eax
  8040a0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  8040a3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8040a6:	89 d0                	mov    %edx,%eax
  8040a8:	01 c0                	add    %eax,%eax
  8040aa:	01 d0                	add    %edx,%eax
  8040ac:	c1 e0 02             	shl    $0x2,%eax
  8040af:	05 6a 60 80 00       	add    $0x80606a,%eax
  8040b4:	66 8b 00             	mov    (%eax),%ax
  8040b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8040ba:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8040bd:	89 c8                	mov    %ecx,%eax
  8040bf:	01 c0                	add    %eax,%eax
  8040c1:	01 c8                	add    %ecx,%eax
  8040c3:	c1 e0 02             	shl    $0x2,%eax
  8040c6:	05 6a 60 80 00       	add    $0x80606a,%eax
  8040cb:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  8040ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8040d1:	eb 24                	jmp    8040f7 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  8040d3:	ff 45 ec             	incl   -0x14(%ebp)
  8040d6:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8040da:	0f 8e e6 fe ff ff    	jle    803fc6 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  8040e0:	83 ec 04             	sub    $0x4,%esp
  8040e3:	68 6f 53 80 00       	push   $0x80536f
  8040e8:	68 b1 00 00 00       	push   $0xb1
  8040ed:	68 f3 52 80 00       	push   $0x8052f3
  8040f2:	e8 53 c8 ff ff       	call   80094a <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  8040f7:	c9                   	leave  
  8040f8:	c3                   	ret    

008040f9 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  8040f9:	55                   	push   %ebp
  8040fa:	89 e5                	mov    %esp,%ebp
  8040fc:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  8040ff:	8b 55 08             	mov    0x8(%ebp),%edx
  804102:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804107:	39 c2                	cmp    %eax,%edx
  804109:	72 0c                	jb     804117 <free_block+0x1e>
  80410b:	8b 55 08             	mov    0x8(%ebp),%edx
  80410e:	a1 40 60 80 00       	mov    0x806040,%eax
  804113:	39 c2                	cmp    %eax,%edx
  804115:	72 19                	jb     804130 <free_block+0x37>
  804117:	68 8c 53 80 00       	push   $0x80538c
  80411c:	68 de 52 80 00       	push   $0x8052de
  804121:	68 c3 00 00 00       	push   $0xc3
  804126:	68 f3 52 80 00       	push   $0x8052f3
  80412b:	e8 1a c8 ff ff       	call   80094a <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804130:	8b 55 08             	mov    0x8(%ebp),%edx
  804133:	a1 64 e0 81 00       	mov    0x81e064,%eax
  804138:	29 c2                	sub    %eax,%edx
  80413a:	89 d0                	mov    %edx,%eax
  80413c:	c1 e8 0c             	shr    $0xc,%eax
  80413f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  804142:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804145:	89 d0                	mov    %edx,%eax
  804147:	01 c0                	add    %eax,%eax
  804149:	01 d0                	add    %edx,%eax
  80414b:	c1 e0 02             	shl    $0x2,%eax
  80414e:	05 68 60 80 00       	add    $0x806068,%eax
  804153:	8b 00                	mov    (%eax),%eax
  804155:	0f b7 c0             	movzwl %ax,%eax
  804158:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  80415b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80415f:	75 17                	jne    804178 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  804161:	83 ec 04             	sub    $0x4,%esp
  804164:	68 c4 53 80 00       	push   $0x8053c4
  804169:	68 cf 00 00 00       	push   $0xcf
  80416e:	68 f3 52 80 00       	push   $0x8052f3
  804173:	e8 d2 c7 ff ff       	call   80094a <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  804178:	83 ec 0c             	sub    $0xc,%esp
  80417b:	ff 75 ec             	pushl  -0x14(%ebp)
  80417e:	e8 d8 f8 ff ff       	call   803a5b <log2>
  804183:	83 c4 10             	add    $0x10,%esp
  804186:	83 e8 03             	sub    $0x3,%eax
  804189:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  80418c:	8b 45 08             	mov    0x8(%ebp),%eax
  80418f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  804192:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804196:	75 17                	jne    8041af <free_block+0xb6>
  804198:	83 ec 04             	sub    $0x4,%esp
  80419b:	68 4c 53 80 00       	push   $0x80534c
  8041a0:	68 d5 00 00 00       	push   $0xd5
  8041a5:	68 f3 52 80 00       	push   $0x8052f3
  8041aa:	e8 9b c7 ff ff       	call   80094a <_panic>
  8041af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041b2:	c1 e0 04             	shl    $0x4,%eax
  8041b5:	05 84 e0 81 00       	add    $0x81e084,%eax
  8041ba:	8b 10                	mov    (%eax),%edx
  8041bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041bf:	89 50 04             	mov    %edx,0x4(%eax)
  8041c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041c5:	8b 40 04             	mov    0x4(%eax),%eax
  8041c8:	85 c0                	test   %eax,%eax
  8041ca:	74 14                	je     8041e0 <free_block+0xe7>
  8041cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041cf:	c1 e0 04             	shl    $0x4,%eax
  8041d2:	05 84 e0 81 00       	add    $0x81e084,%eax
  8041d7:	8b 00                	mov    (%eax),%eax
  8041d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8041dc:	89 10                	mov    %edx,(%eax)
  8041de:	eb 11                	jmp    8041f1 <free_block+0xf8>
  8041e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041e3:	c1 e0 04             	shl    $0x4,%eax
  8041e6:	8d 90 80 e0 81 00    	lea    0x81e080(%eax),%edx
  8041ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8041ef:	89 02                	mov    %eax,(%edx)
  8041f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041f4:	c1 e0 04             	shl    $0x4,%eax
  8041f7:	8d 90 84 e0 81 00    	lea    0x81e084(%eax),%edx
  8041fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804200:	89 02                	mov    %eax,(%edx)
  804202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804205:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80420b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80420e:	c1 e0 04             	shl    $0x4,%eax
  804211:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804216:	8b 00                	mov    (%eax),%eax
  804218:	8d 50 01             	lea    0x1(%eax),%edx
  80421b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80421e:	c1 e0 04             	shl    $0x4,%eax
  804221:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804226:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  804228:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80422b:	89 d0                	mov    %edx,%eax
  80422d:	01 c0                	add    %eax,%eax
  80422f:	01 d0                	add    %edx,%eax
  804231:	c1 e0 02             	shl    $0x2,%eax
  804234:	05 6a 60 80 00       	add    $0x80606a,%eax
  804239:	66 8b 00             	mov    (%eax),%ax
  80423c:	8d 50 01             	lea    0x1(%eax),%edx
  80423f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804242:	89 c8                	mov    %ecx,%eax
  804244:	01 c0                	add    %eax,%eax
  804246:	01 c8                	add    %ecx,%eax
  804248:	c1 e0 02             	shl    $0x2,%eax
  80424b:	05 6a 60 80 00       	add    $0x80606a,%eax
  804250:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  804253:	b8 00 10 00 00       	mov    $0x1000,%eax
  804258:	ba 00 00 00 00       	mov    $0x0,%edx
  80425d:	f7 75 ec             	divl   -0x14(%ebp)
  804260:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  804263:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804266:	89 d0                	mov    %edx,%eax
  804268:	01 c0                	add    %eax,%eax
  80426a:	01 d0                	add    %edx,%eax
  80426c:	c1 e0 02             	shl    $0x2,%eax
  80426f:	05 6a 60 80 00       	add    $0x80606a,%eax
  804274:	66 8b 00             	mov    (%eax),%ax
  804277:	0f b7 c0             	movzwl %ax,%eax
  80427a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80427d:	0f 85 d3 01 00 00    	jne    804456 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  804283:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804286:	c1 e0 04             	shl    $0x4,%eax
  804289:	05 80 e0 81 00       	add    $0x81e080,%eax
  80428e:	8b 00                	mov    (%eax),%eax
  804290:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  804293:	e9 f1 00 00 00       	jmp    804389 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  804298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80429b:	8b 00                	mov    (%eax),%eax
  80429d:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  8042a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042a3:	c1 e0 0c             	shl    $0xc,%eax
  8042a6:	89 c2                	mov    %eax,%edx
  8042a8:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8042ad:	01 d0                	add    %edx,%eax
  8042af:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  8042b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8042b5:	40                   	inc    %eax
  8042b6:	c1 e0 0c             	shl    $0xc,%eax
  8042b9:	89 c2                	mov    %eax,%edx
  8042bb:	a1 64 e0 81 00       	mov    0x81e064,%eax
  8042c0:	01 d0                	add    %edx,%eax
  8042c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  8042c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042c8:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8042cb:	0f 82 b8 00 00 00    	jb     804389 <free_block+0x290>
  8042d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042d4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8042d7:	0f 83 ac 00 00 00    	jae    804389 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  8042dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8042e1:	75 17                	jne    8042fa <free_block+0x201>
  8042e3:	83 ec 04             	sub    $0x4,%esp
  8042e6:	68 2d 53 80 00       	push   $0x80532d
  8042eb:	68 e2 00 00 00       	push   $0xe2
  8042f0:	68 f3 52 80 00       	push   $0x8052f3
  8042f5:	e8 50 c6 ff ff       	call   80094a <_panic>
  8042fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042fd:	8b 00                	mov    (%eax),%eax
  8042ff:	85 c0                	test   %eax,%eax
  804301:	74 10                	je     804313 <free_block+0x21a>
  804303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804306:	8b 00                	mov    (%eax),%eax
  804308:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80430b:	8b 52 04             	mov    0x4(%edx),%edx
  80430e:	89 50 04             	mov    %edx,0x4(%eax)
  804311:	eb 14                	jmp    804327 <free_block+0x22e>
  804313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804316:	8b 40 04             	mov    0x4(%eax),%eax
  804319:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80431c:	c1 e2 04             	shl    $0x4,%edx
  80431f:	81 c2 84 e0 81 00    	add    $0x81e084,%edx
  804325:	89 02                	mov    %eax,(%edx)
  804327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80432a:	8b 40 04             	mov    0x4(%eax),%eax
  80432d:	85 c0                	test   %eax,%eax
  80432f:	74 0f                	je     804340 <free_block+0x247>
  804331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804334:	8b 40 04             	mov    0x4(%eax),%eax
  804337:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80433a:	8b 12                	mov    (%edx),%edx
  80433c:	89 10                	mov    %edx,(%eax)
  80433e:	eb 13                	jmp    804353 <free_block+0x25a>
  804340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804343:	8b 00                	mov    (%eax),%eax
  804345:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804348:	c1 e2 04             	shl    $0x4,%edx
  80434b:	81 c2 80 e0 81 00    	add    $0x81e080,%edx
  804351:	89 02                	mov    %eax,(%edx)
  804353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804356:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80435c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80435f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804369:	c1 e0 04             	shl    $0x4,%eax
  80436c:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804371:	8b 00                	mov    (%eax),%eax
  804373:	8d 50 ff             	lea    -0x1(%eax),%edx
  804376:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804379:	c1 e0 04             	shl    $0x4,%eax
  80437c:	05 8c e0 81 00       	add    $0x81e08c,%eax
  804381:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  804383:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804386:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  804389:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80438d:	0f 85 05 ff ff ff    	jne    804298 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  804393:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804396:	89 d0                	mov    %edx,%eax
  804398:	01 c0                	add    %eax,%eax
  80439a:	01 d0                	add    %edx,%eax
  80439c:	c1 e0 02             	shl    $0x2,%eax
  80439f:	05 68 60 80 00       	add    $0x806068,%eax
  8043a4:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  8043a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043ac:	89 d0                	mov    %edx,%eax
  8043ae:	01 c0                	add    %eax,%eax
  8043b0:	01 d0                	add    %edx,%eax
  8043b2:	c1 e0 02             	shl    $0x2,%eax
  8043b5:	05 6a 60 80 00       	add    $0x80606a,%eax
  8043ba:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  8043bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8043c2:	89 d0                	mov    %edx,%eax
  8043c4:	01 c0                	add    %eax,%eax
  8043c6:	01 d0                	add    %edx,%eax
  8043c8:	c1 e0 02             	shl    $0x2,%eax
  8043cb:	05 60 60 80 00       	add    $0x806060,%eax
  8043d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  8043d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8043d7:	75 17                	jne    8043f0 <free_block+0x2f7>
  8043d9:	83 ec 04             	sub    $0x4,%esp
  8043dc:	68 4c 53 80 00       	push   $0x80534c
  8043e1:	68 eb 00 00 00       	push   $0xeb
  8043e6:	68 f3 52 80 00       	push   $0x8052f3
  8043eb:	e8 5a c5 ff ff       	call   80094a <_panic>
  8043f0:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  8043f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8043f9:	89 50 04             	mov    %edx,0x4(%eax)
  8043fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8043ff:	8b 40 04             	mov    0x4(%eax),%eax
  804402:	85 c0                	test   %eax,%eax
  804404:	74 0c                	je     804412 <free_block+0x319>
  804406:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80440b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80440e:	89 10                	mov    %edx,(%eax)
  804410:	eb 08                	jmp    80441a <free_block+0x321>
  804412:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804415:	a3 48 60 80 00       	mov    %eax,0x806048
  80441a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80441d:	a3 4c 60 80 00       	mov    %eax,0x80604c
  804422:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80442b:	a1 54 60 80 00       	mov    0x806054,%eax
  804430:	40                   	inc    %eax
  804431:	a3 54 60 80 00       	mov    %eax,0x806054
		uint32 page_va = to_page_va(page_info);
  804436:	83 ec 0c             	sub    $0xc,%esp
  804439:	ff 75 d0             	pushl  -0x30(%ebp)
  80443c:	e8 ce f5 ff ff       	call   803a0f <to_page_va>
  804441:	83 c4 10             	add    $0x10,%esp
  804444:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  804447:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80444a:	83 ec 0c             	sub    $0xc,%esp
  80444d:	50                   	push   %eax
  80444e:	e8 9e d7 ff ff       	call   801bf1 <return_page>
  804453:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  804456:	90                   	nop
  804457:	c9                   	leave  
  804458:	c3                   	ret    

00804459 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  804459:	55                   	push   %ebp
  80445a:	89 e5                	mov    %esp,%ebp
  80445c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  80445f:	83 ec 04             	sub    $0x4,%esp
  804462:	68 ec 53 80 00       	push   $0x8053ec
  804467:	68 01 01 00 00       	push   $0x101
  80446c:	68 f3 52 80 00       	push   $0x8052f3
  804471:	e8 d4 c4 ff ff       	call   80094a <_panic>

00804476 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  804476:	55                   	push   %ebp
  804477:	89 e5                	mov    %esp,%ebp
  804479:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  80447c:	83 ec 04             	sub    $0x4,%esp
  80447f:	68 10 54 80 00       	push   $0x805410
  804484:	6a 07                	push   $0x7
  804486:	68 3f 54 80 00       	push   $0x80543f
  80448b:	e8 ba c4 ff ff       	call   80094a <_panic>

00804490 <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  804490:	55                   	push   %ebp
  804491:	89 e5                	mov    %esp,%ebp
  804493:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  804496:	83 ec 04             	sub    $0x4,%esp
  804499:	68 50 54 80 00       	push   $0x805450
  80449e:	6a 0b                	push   $0xb
  8044a0:	68 3f 54 80 00       	push   $0x80543f
  8044a5:	e8 a0 c4 ff ff       	call   80094a <_panic>

008044aa <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  8044aa:	55                   	push   %ebp
  8044ab:	89 e5                	mov    %esp,%ebp
  8044ad:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  8044b0:	83 ec 04             	sub    $0x4,%esp
  8044b3:	68 7c 54 80 00       	push   $0x80547c
  8044b8:	6a 10                	push   $0x10
  8044ba:	68 3f 54 80 00       	push   $0x80543f
  8044bf:	e8 86 c4 ff ff       	call   80094a <_panic>

008044c4 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  8044c4:	55                   	push   %ebp
  8044c5:	89 e5                	mov    %esp,%ebp
  8044c7:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  8044ca:	83 ec 04             	sub    $0x4,%esp
  8044cd:	68 ac 54 80 00       	push   $0x8054ac
  8044d2:	6a 15                	push   $0x15
  8044d4:	68 3f 54 80 00       	push   $0x80543f
  8044d9:	e8 6c c4 ff ff       	call   80094a <_panic>

008044de <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  8044de:	55                   	push   %ebp
  8044df:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8044e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8044e4:	8b 40 10             	mov    0x10(%eax),%eax
}
  8044e7:	5d                   	pop    %ebp
  8044e8:	c3                   	ret    

008044e9 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  8044e9:	55                   	push   %ebp
  8044ea:	89 e5                	mov    %esp,%ebp
  8044ec:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  8044ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8044f3:	74 1c                	je     804511 <init_uspinlock+0x28>
  8044f5:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  8044f9:	74 16                	je     804511 <init_uspinlock+0x28>
  8044fb:	68 dc 54 80 00       	push   $0x8054dc
  804500:	68 fb 54 80 00       	push   $0x8054fb
  804505:	6a 10                	push   $0x10
  804507:	68 10 55 80 00       	push   $0x805510
  80450c:	e8 39 c4 ff ff       	call   80094a <_panic>
	strcpy(lk->name, name);
  804511:	8b 45 08             	mov    0x8(%ebp),%eax
  804514:	83 c0 04             	add    $0x4,%eax
  804517:	83 ec 08             	sub    $0x8,%esp
  80451a:	ff 75 0c             	pushl  0xc(%ebp)
  80451d:	50                   	push   %eax
  80451e:	e8 1d ce ff ff       	call   801340 <strcpy>
  804523:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  804526:	b8 01 00 00 00       	mov    $0x1,%eax
  80452b:	2b 45 10             	sub    0x10(%ebp),%eax
  80452e:	89 c2                	mov    %eax,%edx
  804530:	8b 45 08             	mov    0x8(%ebp),%eax
  804533:	89 10                	mov    %edx,(%eax)
}
  804535:	90                   	nop
  804536:	c9                   	leave  
  804537:	c3                   	ret    

00804538 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  804538:	55                   	push   %ebp
  804539:	89 e5                	mov    %esp,%ebp
  80453b:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  80453e:	90                   	nop
  80453f:	8b 45 08             	mov    0x8(%ebp),%eax
  804542:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804545:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  80454c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80454f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804552:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  804555:	f0 87 02             	lock xchg %eax,(%edx)
  804558:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  80455b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80455e:	85 c0                	test   %eax,%eax
  804560:	75 dd                	jne    80453f <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  804562:	8b 45 08             	mov    0x8(%ebp),%eax
  804565:	8d 48 04             	lea    0x4(%eax),%ecx
  804568:	a1 20 60 80 00       	mov    0x806020,%eax
  80456d:	8d 50 20             	lea    0x20(%eax),%edx
  804570:	a1 20 60 80 00       	mov    0x806020,%eax
  804575:	8b 40 10             	mov    0x10(%eax),%eax
  804578:	51                   	push   %ecx
  804579:	52                   	push   %edx
  80457a:	50                   	push   %eax
  80457b:	68 20 55 80 00       	push   $0x805520
  804580:	e8 93 c6 ff ff       	call   800c18 <cprintf>
  804585:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  804588:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  80458d:	90                   	nop
  80458e:	c9                   	leave  
  80458f:	c3                   	ret    

00804590 <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  804590:	55                   	push   %ebp
  804591:	89 e5                	mov    %esp,%ebp
  804593:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  804596:	8b 45 08             	mov    0x8(%ebp),%eax
  804599:	8b 00                	mov    (%eax),%eax
  80459b:	85 c0                	test   %eax,%eax
  80459d:	75 18                	jne    8045b7 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  80459f:	8b 45 08             	mov    0x8(%ebp),%eax
  8045a2:	83 c0 04             	add    $0x4,%eax
  8045a5:	50                   	push   %eax
  8045a6:	68 44 55 80 00       	push   $0x805544
  8045ab:	6a 2b                	push   $0x2b
  8045ad:	68 10 55 80 00       	push   $0x805510
  8045b2:	e8 93 c3 ff ff       	call   80094a <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  8045b7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  8045bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8045bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8045c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8045c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8045cb:	8d 48 04             	lea    0x4(%eax),%ecx
  8045ce:	a1 20 60 80 00       	mov    0x806020,%eax
  8045d3:	8d 50 20             	lea    0x20(%eax),%edx
  8045d6:	a1 20 60 80 00       	mov    0x806020,%eax
  8045db:	8b 40 10             	mov    0x10(%eax),%eax
  8045de:	51                   	push   %ecx
  8045df:	52                   	push   %edx
  8045e0:	50                   	push   %eax
  8045e1:	68 64 55 80 00       	push   $0x805564
  8045e6:	e8 2d c6 ff ff       	call   800c18 <cprintf>
  8045eb:	83 c4 10             	add    $0x10,%esp
}
  8045ee:	90                   	nop
  8045ef:	c9                   	leave  
  8045f0:	c3                   	ret    
  8045f1:	66 90                	xchg   %ax,%ax
  8045f3:	90                   	nop

008045f4 <__udivdi3>:
  8045f4:	55                   	push   %ebp
  8045f5:	57                   	push   %edi
  8045f6:	56                   	push   %esi
  8045f7:	53                   	push   %ebx
  8045f8:	83 ec 1c             	sub    $0x1c,%esp
  8045fb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8045ff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804603:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804607:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80460b:	89 ca                	mov    %ecx,%edx
  80460d:	89 f8                	mov    %edi,%eax
  80460f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804613:	85 f6                	test   %esi,%esi
  804615:	75 2d                	jne    804644 <__udivdi3+0x50>
  804617:	39 cf                	cmp    %ecx,%edi
  804619:	77 65                	ja     804680 <__udivdi3+0x8c>
  80461b:	89 fd                	mov    %edi,%ebp
  80461d:	85 ff                	test   %edi,%edi
  80461f:	75 0b                	jne    80462c <__udivdi3+0x38>
  804621:	b8 01 00 00 00       	mov    $0x1,%eax
  804626:	31 d2                	xor    %edx,%edx
  804628:	f7 f7                	div    %edi
  80462a:	89 c5                	mov    %eax,%ebp
  80462c:	31 d2                	xor    %edx,%edx
  80462e:	89 c8                	mov    %ecx,%eax
  804630:	f7 f5                	div    %ebp
  804632:	89 c1                	mov    %eax,%ecx
  804634:	89 d8                	mov    %ebx,%eax
  804636:	f7 f5                	div    %ebp
  804638:	89 cf                	mov    %ecx,%edi
  80463a:	89 fa                	mov    %edi,%edx
  80463c:	83 c4 1c             	add    $0x1c,%esp
  80463f:	5b                   	pop    %ebx
  804640:	5e                   	pop    %esi
  804641:	5f                   	pop    %edi
  804642:	5d                   	pop    %ebp
  804643:	c3                   	ret    
  804644:	39 ce                	cmp    %ecx,%esi
  804646:	77 28                	ja     804670 <__udivdi3+0x7c>
  804648:	0f bd fe             	bsr    %esi,%edi
  80464b:	83 f7 1f             	xor    $0x1f,%edi
  80464e:	75 40                	jne    804690 <__udivdi3+0x9c>
  804650:	39 ce                	cmp    %ecx,%esi
  804652:	72 0a                	jb     80465e <__udivdi3+0x6a>
  804654:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804658:	0f 87 9e 00 00 00    	ja     8046fc <__udivdi3+0x108>
  80465e:	b8 01 00 00 00       	mov    $0x1,%eax
  804663:	89 fa                	mov    %edi,%edx
  804665:	83 c4 1c             	add    $0x1c,%esp
  804668:	5b                   	pop    %ebx
  804669:	5e                   	pop    %esi
  80466a:	5f                   	pop    %edi
  80466b:	5d                   	pop    %ebp
  80466c:	c3                   	ret    
  80466d:	8d 76 00             	lea    0x0(%esi),%esi
  804670:	31 ff                	xor    %edi,%edi
  804672:	31 c0                	xor    %eax,%eax
  804674:	89 fa                	mov    %edi,%edx
  804676:	83 c4 1c             	add    $0x1c,%esp
  804679:	5b                   	pop    %ebx
  80467a:	5e                   	pop    %esi
  80467b:	5f                   	pop    %edi
  80467c:	5d                   	pop    %ebp
  80467d:	c3                   	ret    
  80467e:	66 90                	xchg   %ax,%ax
  804680:	89 d8                	mov    %ebx,%eax
  804682:	f7 f7                	div    %edi
  804684:	31 ff                	xor    %edi,%edi
  804686:	89 fa                	mov    %edi,%edx
  804688:	83 c4 1c             	add    $0x1c,%esp
  80468b:	5b                   	pop    %ebx
  80468c:	5e                   	pop    %esi
  80468d:	5f                   	pop    %edi
  80468e:	5d                   	pop    %ebp
  80468f:	c3                   	ret    
  804690:	bd 20 00 00 00       	mov    $0x20,%ebp
  804695:	89 eb                	mov    %ebp,%ebx
  804697:	29 fb                	sub    %edi,%ebx
  804699:	89 f9                	mov    %edi,%ecx
  80469b:	d3 e6                	shl    %cl,%esi
  80469d:	89 c5                	mov    %eax,%ebp
  80469f:	88 d9                	mov    %bl,%cl
  8046a1:	d3 ed                	shr    %cl,%ebp
  8046a3:	89 e9                	mov    %ebp,%ecx
  8046a5:	09 f1                	or     %esi,%ecx
  8046a7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8046ab:	89 f9                	mov    %edi,%ecx
  8046ad:	d3 e0                	shl    %cl,%eax
  8046af:	89 c5                	mov    %eax,%ebp
  8046b1:	89 d6                	mov    %edx,%esi
  8046b3:	88 d9                	mov    %bl,%cl
  8046b5:	d3 ee                	shr    %cl,%esi
  8046b7:	89 f9                	mov    %edi,%ecx
  8046b9:	d3 e2                	shl    %cl,%edx
  8046bb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8046bf:	88 d9                	mov    %bl,%cl
  8046c1:	d3 e8                	shr    %cl,%eax
  8046c3:	09 c2                	or     %eax,%edx
  8046c5:	89 d0                	mov    %edx,%eax
  8046c7:	89 f2                	mov    %esi,%edx
  8046c9:	f7 74 24 0c          	divl   0xc(%esp)
  8046cd:	89 d6                	mov    %edx,%esi
  8046cf:	89 c3                	mov    %eax,%ebx
  8046d1:	f7 e5                	mul    %ebp
  8046d3:	39 d6                	cmp    %edx,%esi
  8046d5:	72 19                	jb     8046f0 <__udivdi3+0xfc>
  8046d7:	74 0b                	je     8046e4 <__udivdi3+0xf0>
  8046d9:	89 d8                	mov    %ebx,%eax
  8046db:	31 ff                	xor    %edi,%edi
  8046dd:	e9 58 ff ff ff       	jmp    80463a <__udivdi3+0x46>
  8046e2:	66 90                	xchg   %ax,%ax
  8046e4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8046e8:	89 f9                	mov    %edi,%ecx
  8046ea:	d3 e2                	shl    %cl,%edx
  8046ec:	39 c2                	cmp    %eax,%edx
  8046ee:	73 e9                	jae    8046d9 <__udivdi3+0xe5>
  8046f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8046f3:	31 ff                	xor    %edi,%edi
  8046f5:	e9 40 ff ff ff       	jmp    80463a <__udivdi3+0x46>
  8046fa:	66 90                	xchg   %ax,%ax
  8046fc:	31 c0                	xor    %eax,%eax
  8046fe:	e9 37 ff ff ff       	jmp    80463a <__udivdi3+0x46>
  804703:	90                   	nop

00804704 <__umoddi3>:
  804704:	55                   	push   %ebp
  804705:	57                   	push   %edi
  804706:	56                   	push   %esi
  804707:	53                   	push   %ebx
  804708:	83 ec 1c             	sub    $0x1c,%esp
  80470b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80470f:	8b 74 24 34          	mov    0x34(%esp),%esi
  804713:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804717:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80471b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80471f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804723:	89 f3                	mov    %esi,%ebx
  804725:	89 fa                	mov    %edi,%edx
  804727:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80472b:	89 34 24             	mov    %esi,(%esp)
  80472e:	85 c0                	test   %eax,%eax
  804730:	75 1a                	jne    80474c <__umoddi3+0x48>
  804732:	39 f7                	cmp    %esi,%edi
  804734:	0f 86 a2 00 00 00    	jbe    8047dc <__umoddi3+0xd8>
  80473a:	89 c8                	mov    %ecx,%eax
  80473c:	89 f2                	mov    %esi,%edx
  80473e:	f7 f7                	div    %edi
  804740:	89 d0                	mov    %edx,%eax
  804742:	31 d2                	xor    %edx,%edx
  804744:	83 c4 1c             	add    $0x1c,%esp
  804747:	5b                   	pop    %ebx
  804748:	5e                   	pop    %esi
  804749:	5f                   	pop    %edi
  80474a:	5d                   	pop    %ebp
  80474b:	c3                   	ret    
  80474c:	39 f0                	cmp    %esi,%eax
  80474e:	0f 87 ac 00 00 00    	ja     804800 <__umoddi3+0xfc>
  804754:	0f bd e8             	bsr    %eax,%ebp
  804757:	83 f5 1f             	xor    $0x1f,%ebp
  80475a:	0f 84 ac 00 00 00    	je     80480c <__umoddi3+0x108>
  804760:	bf 20 00 00 00       	mov    $0x20,%edi
  804765:	29 ef                	sub    %ebp,%edi
  804767:	89 fe                	mov    %edi,%esi
  804769:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80476d:	89 e9                	mov    %ebp,%ecx
  80476f:	d3 e0                	shl    %cl,%eax
  804771:	89 d7                	mov    %edx,%edi
  804773:	89 f1                	mov    %esi,%ecx
  804775:	d3 ef                	shr    %cl,%edi
  804777:	09 c7                	or     %eax,%edi
  804779:	89 e9                	mov    %ebp,%ecx
  80477b:	d3 e2                	shl    %cl,%edx
  80477d:	89 14 24             	mov    %edx,(%esp)
  804780:	89 d8                	mov    %ebx,%eax
  804782:	d3 e0                	shl    %cl,%eax
  804784:	89 c2                	mov    %eax,%edx
  804786:	8b 44 24 08          	mov    0x8(%esp),%eax
  80478a:	d3 e0                	shl    %cl,%eax
  80478c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804790:	8b 44 24 08          	mov    0x8(%esp),%eax
  804794:	89 f1                	mov    %esi,%ecx
  804796:	d3 e8                	shr    %cl,%eax
  804798:	09 d0                	or     %edx,%eax
  80479a:	d3 eb                	shr    %cl,%ebx
  80479c:	89 da                	mov    %ebx,%edx
  80479e:	f7 f7                	div    %edi
  8047a0:	89 d3                	mov    %edx,%ebx
  8047a2:	f7 24 24             	mull   (%esp)
  8047a5:	89 c6                	mov    %eax,%esi
  8047a7:	89 d1                	mov    %edx,%ecx
  8047a9:	39 d3                	cmp    %edx,%ebx
  8047ab:	0f 82 87 00 00 00    	jb     804838 <__umoddi3+0x134>
  8047b1:	0f 84 91 00 00 00    	je     804848 <__umoddi3+0x144>
  8047b7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8047bb:	29 f2                	sub    %esi,%edx
  8047bd:	19 cb                	sbb    %ecx,%ebx
  8047bf:	89 d8                	mov    %ebx,%eax
  8047c1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8047c5:	d3 e0                	shl    %cl,%eax
  8047c7:	89 e9                	mov    %ebp,%ecx
  8047c9:	d3 ea                	shr    %cl,%edx
  8047cb:	09 d0                	or     %edx,%eax
  8047cd:	89 e9                	mov    %ebp,%ecx
  8047cf:	d3 eb                	shr    %cl,%ebx
  8047d1:	89 da                	mov    %ebx,%edx
  8047d3:	83 c4 1c             	add    $0x1c,%esp
  8047d6:	5b                   	pop    %ebx
  8047d7:	5e                   	pop    %esi
  8047d8:	5f                   	pop    %edi
  8047d9:	5d                   	pop    %ebp
  8047da:	c3                   	ret    
  8047db:	90                   	nop
  8047dc:	89 fd                	mov    %edi,%ebp
  8047de:	85 ff                	test   %edi,%edi
  8047e0:	75 0b                	jne    8047ed <__umoddi3+0xe9>
  8047e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8047e7:	31 d2                	xor    %edx,%edx
  8047e9:	f7 f7                	div    %edi
  8047eb:	89 c5                	mov    %eax,%ebp
  8047ed:	89 f0                	mov    %esi,%eax
  8047ef:	31 d2                	xor    %edx,%edx
  8047f1:	f7 f5                	div    %ebp
  8047f3:	89 c8                	mov    %ecx,%eax
  8047f5:	f7 f5                	div    %ebp
  8047f7:	89 d0                	mov    %edx,%eax
  8047f9:	e9 44 ff ff ff       	jmp    804742 <__umoddi3+0x3e>
  8047fe:	66 90                	xchg   %ax,%ax
  804800:	89 c8                	mov    %ecx,%eax
  804802:	89 f2                	mov    %esi,%edx
  804804:	83 c4 1c             	add    $0x1c,%esp
  804807:	5b                   	pop    %ebx
  804808:	5e                   	pop    %esi
  804809:	5f                   	pop    %edi
  80480a:	5d                   	pop    %ebp
  80480b:	c3                   	ret    
  80480c:	3b 04 24             	cmp    (%esp),%eax
  80480f:	72 06                	jb     804817 <__umoddi3+0x113>
  804811:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804815:	77 0f                	ja     804826 <__umoddi3+0x122>
  804817:	89 f2                	mov    %esi,%edx
  804819:	29 f9                	sub    %edi,%ecx
  80481b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80481f:	89 14 24             	mov    %edx,(%esp)
  804822:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804826:	8b 44 24 04          	mov    0x4(%esp),%eax
  80482a:	8b 14 24             	mov    (%esp),%edx
  80482d:	83 c4 1c             	add    $0x1c,%esp
  804830:	5b                   	pop    %ebx
  804831:	5e                   	pop    %esi
  804832:	5f                   	pop    %edi
  804833:	5d                   	pop    %ebp
  804834:	c3                   	ret    
  804835:	8d 76 00             	lea    0x0(%esi),%esi
  804838:	2b 04 24             	sub    (%esp),%eax
  80483b:	19 fa                	sbb    %edi,%edx
  80483d:	89 d1                	mov    %edx,%ecx
  80483f:	89 c6                	mov    %eax,%esi
  804841:	e9 71 ff ff ff       	jmp    8047b7 <__umoddi3+0xb3>
  804846:	66 90                	xchg   %ax,%ax
  804848:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80484c:	72 ea                	jb     804838 <__umoddi3+0x134>
  80484e:	89 d9                	mov    %ebx,%ecx
  804850:	e9 62 ff ff ff       	jmp    8047b7 <__umoddi3+0xb3>
