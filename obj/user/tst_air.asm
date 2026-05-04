
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 91 0f 00 00       	call   800fc7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 03 00 00    	sub    $0x39c,%esp
	int envID = sys_getenvid();
  800044:	e8 28 41 00 00       	call   804171 <sys_getenvid>
  800049:	89 45 a0             	mov    %eax,-0x60(%ebp)

	int numOfClerks = 3;
  80004c:	c7 45 9c 03 00 00 00 	movl   $0x3,-0x64(%ebp)
	int agentCapacity = 20;
  800053:	c7 45 e4 14 00 00 00 	movl   $0x14,-0x1c(%ebp)
	int numOfCustomers = 30;
  80005a:	c7 45 e0 1e 00 00 00 	movl   $0x1e,-0x20(%ebp)
	int flight1NumOfCustomers = numOfCustomers/3;
  800061:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800064:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800069:	f7 e9                	imul   %ecx
  80006b:	c1 f9 1f             	sar    $0x1f,%ecx
  80006e:	89 d0                	mov    %edx,%eax
  800070:	29 c8                	sub    %ecx,%eax
  800072:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int flight2NumOfCustomers = numOfCustomers/3;
  800075:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800078:	b8 56 55 55 55       	mov    $0x55555556,%eax
  80007d:	f7 e9                	imul   %ecx
  80007f:	c1 f9 1f             	sar    $0x1f,%ecx
  800082:	89 d0                	mov    %edx,%eax
  800084:	29 c8                	sub    %ecx,%eax
  800086:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int flight3NumOfCustomers = numOfCustomers - (flight1NumOfCustomers + flight2NumOfCustomers);
  800089:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80008c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80008f:	01 c2                	add    %eax,%edx
  800091:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800094:	29 d0                	sub    %edx,%eax
  800096:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int flight1NumOfTickets = 15;
  800099:	c7 45 d0 0f 00 00 00 	movl   $0xf,-0x30(%ebp)
	int flight2NumOfTickets = 8;
  8000a0:	c7 45 cc 08 00 00 00 	movl   $0x8,-0x34(%ebp)
	// *************************************************************************************************
	/// Reading Inputs *********************************************************************************
	// *************************************************************************************************
	char Line[255] ;
	char Chose;
	sys_lock_cons();
  8000a7:	e8 65 3e 00 00       	call   803f11 <sys_lock_cons>
	{
		cprintf("\n");
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 60 53 80 00       	push   $0x805360
  8000b4:	e8 95 13 00 00       	call   80144e <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	68 64 53 80 00       	push   $0x805364
  8000c4:	e8 85 13 00 00       	call   80144e <cprintf>
  8000c9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! AIR PLANE RESERVATION !!!!\n");
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	68 88 53 80 00       	push   $0x805388
  8000d4:	e8 75 13 00 00       	call   80144e <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 64 53 80 00       	push   $0x805364
  8000e4:	e8 65 13 00 00       	call   80144e <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 60 53 80 00       	push   $0x805360
  8000f4:	e8 55 13 00 00       	call   80144e <cprintf>
  8000f9:	83 c4 10             	add    $0x10,%esp
		cprintf("%~Default #customers = %d (equally divided over the 3 flights).\n"
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800102:	ff 75 cc             	pushl  -0x34(%ebp)
  800105:	ff 75 d0             	pushl  -0x30(%ebp)
  800108:	ff 75 e0             	pushl  -0x20(%ebp)
  80010b:	68 ac 53 80 00       	push   $0x8053ac
  800110:	e8 39 13 00 00       	call   80144e <cprintf>
  800115:	83 c4 20             	add    $0x20,%esp
				"Flight1 Tickets = %d, Flight2 Tickets = %d\n"
				"Agent Capacity = %d\n", numOfCustomers, flight1NumOfTickets, flight2NumOfTickets, agentCapacity) ;
		Chose = 0 ;
  800118:	c6 45 cb 00          	movb   $0x0,-0x35(%ebp)
		while (Chose != 'y' && Chose != 'n' && Chose != 'Y' && Chose != 'N')
  80011c:	eb 42                	jmp    800160 <_main+0x128>
		{
			cprintf("%~Do you want to change these values(y/n)? ") ;
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 2c 54 80 00       	push   $0x80542c
  800126:	e8 23 13 00 00       	call   80144e <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012e:	e8 77 0e 00 00       	call   800faa <getchar>
  800133:	88 45 cb             	mov    %al,-0x35(%ebp)
			cputchar(Chose);
  800136:	0f be 45 cb          	movsbl -0x35(%ebp),%eax
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	50                   	push   %eax
  80013e:	e8 48 0e 00 00       	call   800f8b <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800146:	83 ec 0c             	sub    $0xc,%esp
  800149:	6a 0a                	push   $0xa
  80014b:	e8 3b 0e 00 00       	call   800f8b <cputchar>
  800150:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	6a 0a                	push   $0xa
  800158:	e8 2e 0e 00 00       	call   800f8b <cputchar>
  80015d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
		cprintf("%~Default #customers = %d (equally divided over the 3 flights).\n"
				"Flight1 Tickets = %d, Flight2 Tickets = %d\n"
				"Agent Capacity = %d\n", numOfCustomers, flight1NumOfTickets, flight2NumOfTickets, agentCapacity) ;
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n' && Chose != 'Y' && Chose != 'N')
  800160:	80 7d cb 79          	cmpb   $0x79,-0x35(%ebp)
  800164:	74 12                	je     800178 <_main+0x140>
  800166:	80 7d cb 6e          	cmpb   $0x6e,-0x35(%ebp)
  80016a:	74 0c                	je     800178 <_main+0x140>
  80016c:	80 7d cb 59          	cmpb   $0x59,-0x35(%ebp)
  800170:	74 06                	je     800178 <_main+0x140>
  800172:	80 7d cb 4e          	cmpb   $0x4e,-0x35(%ebp)
  800176:	75 a6                	jne    80011e <_main+0xe6>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		if (Chose == 'y' || Chose == 'Y')
  800178:	80 7d cb 79          	cmpb   $0x79,-0x35(%ebp)
  80017c:	74 0a                	je     800188 <_main+0x150>
  80017e:	80 7d cb 59          	cmpb   $0x59,-0x35(%ebp)
  800182:	0f 85 ea 00 00 00    	jne    800272 <_main+0x23a>
		{
			readline("Enter the capacity of the agent: ", Line);
  800188:	83 ec 08             	sub    $0x8,%esp
  80018b:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800191:	50                   	push   %eax
  800192:	68 58 54 80 00       	push   $0x805458
  800197:	e8 8b 19 00 00       	call   801b27 <readline>
  80019c:	83 c4 10             	add    $0x10,%esp
			agentCapacity = strtol(Line, NULL, 10) ;
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	6a 0a                	push   $0xa
  8001a4:	6a 00                	push   $0x0
  8001a6:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001ac:	50                   	push   %eax
  8001ad:	e8 8c 1f 00 00       	call   80213e <strtol>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			readline("Enter the total number of customers: ", Line);
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001c1:	50                   	push   %eax
  8001c2:	68 7c 54 80 00       	push   $0x80547c
  8001c7:	e8 5b 19 00 00       	call   801b27 <readline>
  8001cc:	83 c4 10             	add    $0x10,%esp
			numOfCustomers = strtol(Line, NULL, 10) ;
  8001cf:	83 ec 04             	sub    $0x4,%esp
  8001d2:	6a 0a                	push   $0xa
  8001d4:	6a 00                	push   $0x0
  8001d6:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  8001dc:	50                   	push   %eax
  8001dd:	e8 5c 1f 00 00       	call   80213e <strtol>
  8001e2:	83 c4 10             	add    $0x10,%esp
  8001e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			flight1NumOfCustomers = flight2NumOfCustomers = numOfCustomers / 3;
  8001e8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8001eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8001f0:	f7 e9                	imul   %ecx
  8001f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8001f5:	89 d0                	mov    %edx,%eax
  8001f7:	29 c8                	sub    %ecx,%eax
  8001f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
			flight3NumOfCustomers = numOfCustomers - (flight1NumOfCustomers + flight2NumOfCustomers);
  800202:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800205:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800208:	01 c2                	add    %eax,%edx
  80020a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80020d:	29 d0                	sub    %edx,%eax
  80020f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			readline("Enter # tickets of flight#1: ", Line);
  800212:	83 ec 08             	sub    $0x8,%esp
  800215:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  80021b:	50                   	push   %eax
  80021c:	68 a2 54 80 00       	push   $0x8054a2
  800221:	e8 01 19 00 00       	call   801b27 <readline>
  800226:	83 c4 10             	add    $0x10,%esp
			flight1NumOfTickets = strtol(Line, NULL, 10) ;
  800229:	83 ec 04             	sub    $0x4,%esp
  80022c:	6a 0a                	push   $0xa
  80022e:	6a 00                	push   $0x0
  800230:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	e8 02 1f 00 00       	call   80213e <strtol>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 d0             	mov    %eax,-0x30(%ebp)
			readline("Enter # tickets of flight#2: ", Line);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	68 c0 54 80 00       	push   $0x8054c0
  800251:	e8 d1 18 00 00       	call   801b27 <readline>
  800256:	83 c4 10             	add    $0x10,%esp
			flight2NumOfTickets = strtol(Line, NULL, 10) ;
  800259:	83 ec 04             	sub    $0x4,%esp
  80025c:	6a 0a                	push   $0xa
  80025e:	6a 00                	push   $0x0
  800260:	8d 85 59 fe ff ff    	lea    -0x1a7(%ebp),%eax
  800266:	50                   	push   %eax
  800267:	e8 d2 1e 00 00       	call   80213e <strtol>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		}
	}
	sys_unlock_cons();
  800272:	e8 b4 3c 00 00       	call   803f2b <sys_unlock_cons>

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************
	char _isOpened[] = "isOpened";
  800277:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  80027d:	bb d6 58 80 00       	mov    $0x8058d6,%ebx
  800282:	ba 09 00 00 00       	mov    $0x9,%edx
  800287:	89 c7                	mov    %eax,%edi
  800289:	89 de                	mov    %ebx,%esi
  80028b:	89 d1                	mov    %edx,%ecx
  80028d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _agentCapacity[] = "agentCapacity";
  80028f:	8d 85 42 fe ff ff    	lea    -0x1be(%ebp),%eax
  800295:	bb df 58 80 00       	mov    $0x8058df,%ebx
  80029a:	ba 0e 00 00 00       	mov    $0xe,%edx
  80029f:	89 c7                	mov    %eax,%edi
  8002a1:	89 de                	mov    %ebx,%esi
  8002a3:	89 d1                	mov    %edx,%ecx
  8002a5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _customers[] = "customers";
  8002a7:	8d 85 38 fe ff ff    	lea    -0x1c8(%ebp),%eax
  8002ad:	bb ed 58 80 00       	mov    $0x8058ed,%ebx
  8002b2:	ba 0a 00 00 00       	mov    $0xa,%edx
  8002b7:	89 c7                	mov    %eax,%edi
  8002b9:	89 de                	mov    %ebx,%esi
  8002bb:	89 d1                	mov    %edx,%ecx
  8002bd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  8002bf:	8d 85 2c fe ff ff    	lea    -0x1d4(%ebp),%eax
  8002c5:	bb f7 58 80 00       	mov    $0x8058f7,%ebx
  8002ca:	ba 03 00 00 00       	mov    $0x3,%edx
  8002cf:	89 c7                	mov    %eax,%edi
  8002d1:	89 de                	mov    %ebx,%esi
  8002d3:	89 d1                	mov    %edx,%ecx
  8002d5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Customers[] = "flight1Customers";
  8002d7:	8d 85 1b fe ff ff    	lea    -0x1e5(%ebp),%eax
  8002dd:	bb 03 59 80 00       	mov    $0x805903,%ebx
  8002e2:	ba 11 00 00 00       	mov    $0x11,%edx
  8002e7:	89 c7                	mov    %eax,%edi
  8002e9:	89 de                	mov    %ebx,%esi
  8002eb:	89 d1                	mov    %edx,%ecx
  8002ed:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Customers[] = "flight2Customers";
  8002ef:	8d 85 0a fe ff ff    	lea    -0x1f6(%ebp),%eax
  8002f5:	bb 14 59 80 00       	mov    $0x805914,%ebx
  8002fa:	ba 11 00 00 00       	mov    $0x11,%edx
  8002ff:	89 c7                	mov    %eax,%edi
  800301:	89 de                	mov    %ebx,%esi
  800303:	89 d1                	mov    %edx,%ecx
  800305:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight3Customers[] = "flight3Customers";
  800307:	8d 85 f9 fd ff ff    	lea    -0x207(%ebp),%eax
  80030d:	bb 25 59 80 00       	mov    $0x805925,%ebx
  800312:	ba 11 00 00 00       	mov    $0x11,%edx
  800317:	89 c7                	mov    %eax,%edi
  800319:	89 de                	mov    %ebx,%esi
  80031b:	89 d1                	mov    %edx,%ecx
  80031d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  80031f:	8d 85 ea fd ff ff    	lea    -0x216(%ebp),%eax
  800325:	bb 36 59 80 00       	mov    $0x805936,%ebx
  80032a:	ba 0f 00 00 00       	mov    $0xf,%edx
  80032f:	89 c7                	mov    %eax,%edi
  800331:	89 de                	mov    %ebx,%esi
  800333:	89 d1                	mov    %edx,%ecx
  800335:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  800337:	8d 85 db fd ff ff    	lea    -0x225(%ebp),%eax
  80033d:	bb 45 59 80 00       	mov    $0x805945,%ebx
  800342:	ba 0f 00 00 00       	mov    $0xf,%edx
  800347:	89 c7                	mov    %eax,%edi
  800349:	89 de                	mov    %ebx,%esi
  80034b:	89 d1                	mov    %edx,%ecx
  80034d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  80034f:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
  800355:	bb 54 59 80 00       	mov    $0x805954,%ebx
  80035a:	ba 15 00 00 00       	mov    $0x15,%edx
  80035f:	89 c7                	mov    %eax,%edi
  800361:	89 de                	mov    %ebx,%esi
  800363:	89 d1                	mov    %edx,%ecx
  800365:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  800367:	8d 85 b1 fd ff ff    	lea    -0x24f(%ebp),%eax
  80036d:	bb 69 59 80 00       	mov    $0x805969,%ebx
  800372:	ba 15 00 00 00       	mov    $0x15,%edx
  800377:	89 c7                	mov    %eax,%edi
  800379:	89 de                	mov    %ebx,%esi
  80037b:	89 d1                	mov    %edx,%ecx
  80037d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  80037f:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  800385:	bb 7e 59 80 00       	mov    $0x80597e,%ebx
  80038a:	ba 11 00 00 00       	mov    $0x11,%edx
  80038f:	89 c7                	mov    %eax,%edi
  800391:	89 de                	mov    %ebx,%esi
  800393:	89 d1                	mov    %edx,%ecx
  800395:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  800397:	8d 85 8f fd ff ff    	lea    -0x271(%ebp),%eax
  80039d:	bb 8f 59 80 00       	mov    $0x80598f,%ebx
  8003a2:	ba 11 00 00 00       	mov    $0x11,%edx
  8003a7:	89 c7                	mov    %eax,%edi
  8003a9:	89 de                	mov    %ebx,%esi
  8003ab:	89 d1                	mov    %edx,%ecx
  8003ad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8003af:	8d 85 7e fd ff ff    	lea    -0x282(%ebp),%eax
  8003b5:	bb a0 59 80 00       	mov    $0x8059a0,%ebx
  8003ba:	ba 11 00 00 00       	mov    $0x11,%edx
  8003bf:	89 c7                	mov    %eax,%edi
  8003c1:	89 de                	mov    %ebx,%esi
  8003c3:	89 d1                	mov    %edx,%ecx
  8003c5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  8003c7:	8d 85 75 fd ff ff    	lea    -0x28b(%ebp),%eax
  8003cd:	bb b1 59 80 00       	mov    $0x8059b1,%ebx
  8003d2:	ba 09 00 00 00       	mov    $0x9,%edx
  8003d7:	89 c7                	mov    %eax,%edi
  8003d9:	89 de                	mov    %ebx,%esi
  8003db:	89 d1                	mov    %edx,%ecx
  8003dd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  8003df:	8d 85 6b fd ff ff    	lea    -0x295(%ebp),%eax
  8003e5:	bb ba 59 80 00       	mov    $0x8059ba,%ebx
  8003ea:	ba 0a 00 00 00       	mov    $0xa,%edx
  8003ef:	89 c7                	mov    %eax,%edi
  8003f1:	89 de                	mov    %ebx,%esi
  8003f3:	89 d1                	mov    %edx,%ecx
  8003f5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  8003f7:	8d 85 60 fd ff ff    	lea    -0x2a0(%ebp),%eax
  8003fd:	bb c4 59 80 00       	mov    $0x8059c4,%ebx
  800402:	ba 0b 00 00 00       	mov    $0xb,%edx
  800407:	89 c7                	mov    %eax,%edi
  800409:	89 de                	mov    %ebx,%esi
  80040b:	89 d1                	mov    %edx,%ecx
  80040d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80040f:	8d 85 54 fd ff ff    	lea    -0x2ac(%ebp),%eax
  800415:	bb cf 59 80 00       	mov    $0x8059cf,%ebx
  80041a:	ba 03 00 00 00       	mov    $0x3,%edx
  80041f:	89 c7                	mov    %eax,%edi
  800421:	89 de                	mov    %ebx,%esi
  800423:	89 d1                	mov    %edx,%ecx
  800425:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800427:	8d 85 4a fd ff ff    	lea    -0x2b6(%ebp),%eax
  80042d:	bb db 59 80 00       	mov    $0x8059db,%ebx
  800432:	ba 0a 00 00 00       	mov    $0xa,%edx
  800437:	89 c7                	mov    %eax,%edi
  800439:	89 de                	mov    %ebx,%esi
  80043b:	89 d1                	mov    %edx,%ecx
  80043d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80043f:	8d 85 40 fd ff ff    	lea    -0x2c0(%ebp),%eax
  800445:	bb e5 59 80 00       	mov    $0x8059e5,%ebx
  80044a:	ba 0a 00 00 00       	mov    $0xa,%edx
  80044f:	89 c7                	mov    %eax,%edi
  800451:	89 de                	mov    %ebx,%esi
  800453:	89 d1                	mov    %edx,%ecx
  800455:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  800457:	c7 85 3a fd ff ff 63 	movl   $0x72656c63,-0x2c6(%ebp)
  80045e:	6c 65 72 
  800461:	66 c7 85 3e fd ff ff 	movw   $0x6b,-0x2c2(%ebp)
  800468:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  80046a:	8d 85 2c fd ff ff    	lea    -0x2d4(%ebp),%eax
  800470:	bb ef 59 80 00       	mov    $0x8059ef,%ebx
  800475:	ba 0e 00 00 00       	mov    $0xe,%edx
  80047a:	89 c7                	mov    %eax,%edi
  80047c:	89 de                	mov    %ebx,%esi
  80047e:	89 d1                	mov    %edx,%ecx
  800480:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800482:	8d 85 1d fd ff ff    	lea    -0x2e3(%ebp),%eax
  800488:	bb fd 59 80 00       	mov    $0x8059fd,%ebx
  80048d:	ba 0f 00 00 00       	mov    $0xf,%edx
  800492:	89 c7                	mov    %eax,%edi
  800494:	89 de                	mov    %ebx,%esi
  800496:	89 d1                	mov    %edx,%ecx
  800498:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _clerkTerminated[] = "clerkTerminated";
  80049a:	8d 85 0d fd ff ff    	lea    -0x2f3(%ebp),%eax
  8004a0:	bb 0c 5a 80 00       	mov    $0x805a0c,%ebx
  8004a5:	ba 04 00 00 00       	mov    $0x4,%edx
  8004aa:	89 c7                	mov    %eax,%edi
  8004ac:	89 de                	mov    %ebx,%esi
  8004ae:	89 d1                	mov    %edx,%ecx
  8004b0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8004b2:	8d 85 06 fd ff ff    	lea    -0x2fa(%ebp),%eax
  8004b8:	bb 1c 5a 80 00       	mov    $0x805a1c,%ebx
  8004bd:	ba 07 00 00 00       	mov    $0x7,%edx
  8004c2:	89 c7                	mov    %eax,%edi
  8004c4:	89 de                	mov    %ebx,%esi
  8004c6:	89 d1                	mov    %edx,%ecx
  8004c8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  8004ca:	8d 85 ff fc ff ff    	lea    -0x301(%ebp),%eax
  8004d0:	bb 23 5a 80 00       	mov    $0x805a23,%ebx
  8004d5:	ba 07 00 00 00       	mov    $0x7,%edx
  8004da:	89 c7                	mov    %eax,%edi
  8004dc:	89 de                	mov    %ebx,%esi
  8004de:	89 d1                	mov    %edx,%ecx
  8004e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*(numOfCustomers+1), 1);
  8004e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e5:	40                   	inc    %eax
  8004e6:	c1 e0 03             	shl    $0x3,%eax
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	6a 01                	push   $0x1
  8004ee:	50                   	push   %eax
  8004ef:	8d 85 38 fe ff ff    	lea    -0x1c8(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 02 2e 00 00       	call   8032fd <smalloc>
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	89 45 98             	mov    %eax,-0x68(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);

	int* flight1Customers = smalloc(_flight1Customers, sizeof(int), 1); *flight1Customers = flight1NumOfCustomers;
  800501:	83 ec 04             	sub    $0x4,%esp
  800504:	6a 01                	push   $0x1
  800506:	6a 04                	push   $0x4
  800508:	8d 85 1b fe ff ff    	lea    -0x1e5(%ebp),%eax
  80050e:	50                   	push   %eax
  80050f:	e8 e9 2d 00 00       	call   8032fd <smalloc>
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	89 45 94             	mov    %eax,-0x6c(%ebp)
  80051a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80051d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800520:	89 10                	mov    %edx,(%eax)
	int* flight2Customers = smalloc(_flight2Customers, sizeof(int), 1); *flight2Customers = flight2NumOfCustomers;
  800522:	83 ec 04             	sub    $0x4,%esp
  800525:	6a 01                	push   $0x1
  800527:	6a 04                	push   $0x4
  800529:	8d 85 0a fe ff ff    	lea    -0x1f6(%ebp),%eax
  80052f:	50                   	push   %eax
  800530:	e8 c8 2d 00 00       	call   8032fd <smalloc>
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	89 45 90             	mov    %eax,-0x70(%ebp)
  80053b:	8b 45 90             	mov    -0x70(%ebp),%eax
  80053e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800541:	89 10                	mov    %edx,(%eax)
	int* flight3Customers = smalloc(_flight3Customers, sizeof(int), 1); *flight3Customers = flight3NumOfCustomers;
  800543:	83 ec 04             	sub    $0x4,%esp
  800546:	6a 01                	push   $0x1
  800548:	6a 04                	push   $0x4
  80054a:	8d 85 f9 fd ff ff    	lea    -0x207(%ebp),%eax
  800550:	50                   	push   %eax
  800551:	e8 a7 2d 00 00       	call   8032fd <smalloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 8c             	mov    %eax,-0x74(%ebp)
  80055c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80055f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800562:	89 10                	mov    %edx,(%eax)

	int* isOpened = smalloc(_isOpened, sizeof(int), 0);
  800564:	83 ec 04             	sub    $0x4,%esp
  800567:	6a 00                	push   $0x0
  800569:	6a 04                	push   $0x4
  80056b:	8d 85 50 fe ff ff    	lea    -0x1b0(%ebp),%eax
  800571:	50                   	push   %eax
  800572:	e8 86 2d 00 00       	call   8032fd <smalloc>
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	89 45 88             	mov    %eax,-0x78(%ebp)
	*isOpened = 1;
  80057d:	8b 45 88             	mov    -0x78(%ebp),%eax
  800580:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800586:	83 ec 04             	sub    $0x4,%esp
  800589:	6a 01                	push   $0x1
  80058b:	6a 04                	push   $0x4
  80058d:	8d 85 2c fe ff ff    	lea    -0x1d4(%ebp),%eax
  800593:	50                   	push   %eax
  800594:	e8 64 2d 00 00       	call   8032fd <smalloc>
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	89 45 84             	mov    %eax,-0x7c(%ebp)
	*custCounter = 0;
  80059f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8005a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  8005a8:	83 ec 04             	sub    $0x4,%esp
  8005ab:	6a 01                	push   $0x1
  8005ad:	6a 04                	push   $0x4
  8005af:	8d 85 ea fd ff ff    	lea    -0x216(%ebp),%eax
  8005b5:	50                   	push   %eax
  8005b6:	e8 42 2d 00 00       	call   8032fd <smalloc>
  8005bb:	83 c4 10             	add    $0x10,%esp
  8005be:	89 45 80             	mov    %eax,-0x80(%ebp)
	*flight1Counter = flight1NumOfTickets;
  8005c1:	8b 45 80             	mov    -0x80(%ebp),%eax
  8005c4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005c7:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	6a 01                	push   $0x1
  8005ce:	6a 04                	push   $0x4
  8005d0:	8d 85 db fd ff ff    	lea    -0x225(%ebp),%eax
  8005d6:	50                   	push   %eax
  8005d7:	e8 21 2d 00 00       	call   8032fd <smalloc>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*flight2Counter = flight2NumOfTickets;
  8005e5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005eb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8005ee:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	6a 01                	push   $0x1
  8005f5:	6a 04                	push   $0x4
  8005f7:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
  8005fd:	50                   	push   %eax
  8005fe:	e8 fa 2c 00 00       	call   8032fd <smalloc>
  800603:	83 c4 10             	add    $0x10,%esp
  800606:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*flight1BookedCounter = 0;
  80060c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800612:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	6a 01                	push   $0x1
  80061d:	6a 04                	push   $0x4
  80061f:	8d 85 b1 fd ff ff    	lea    -0x24f(%ebp),%eax
  800625:	50                   	push   %eax
  800626:	e8 d2 2c 00 00       	call   8032fd <smalloc>
  80062b:	83 c4 10             	add    $0x10,%esp
  80062e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	*flight2BookedCounter = 0;
  800634:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80063a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  800640:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800643:	c1 e0 02             	shl    $0x2,%eax
  800646:	83 ec 04             	sub    $0x4,%esp
  800649:	6a 01                	push   $0x1
  80064b:	50                   	push   %eax
  80064c:	8d 85 a0 fd ff ff    	lea    -0x260(%ebp),%eax
  800652:	50                   	push   %eax
  800653:	e8 a5 2c 00 00       	call   8032fd <smalloc>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  800661:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800664:	c1 e0 02             	shl    $0x2,%eax
  800667:	83 ec 04             	sub    $0x4,%esp
  80066a:	6a 01                	push   $0x1
  80066c:	50                   	push   %eax
  80066d:	8d 85 8f fd ff ff    	lea    -0x271(%ebp),%eax
  800673:	50                   	push   %eax
  800674:	e8 84 2c 00 00       	call   8032fd <smalloc>
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*(numOfCustomers+1), 1);
  800682:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800685:	40                   	inc    %eax
  800686:	c1 e0 02             	shl    $0x2,%eax
  800689:	83 ec 04             	sub    $0x4,%esp
  80068c:	6a 01                	push   $0x1
  80068e:	50                   	push   %eax
  80068f:	8d 85 7e fd ff ff    	lea    -0x282(%ebp),%eax
  800695:	50                   	push   %eax
  800696:	e8 62 2c 00 00       	call   8032fd <smalloc>
  80069b:	83 c4 10             	add    $0x10,%esp
  80069e:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  8006a4:	83 ec 04             	sub    $0x4,%esp
  8006a7:	6a 01                	push   $0x1
  8006a9:	6a 04                	push   $0x4
  8006ab:	8d 85 75 fd ff ff    	lea    -0x28b(%ebp),%eax
  8006b1:	50                   	push   %eax
  8006b2:	e8 46 2c 00 00       	call   8032fd <smalloc>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
	*queue_in = 0;
  8006c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8006c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  8006cc:	83 ec 04             	sub    $0x4,%esp
  8006cf:	6a 01                	push   $0x1
  8006d1:	6a 04                	push   $0x4
  8006d3:	8d 85 6b fd ff ff    	lea    -0x295(%ebp),%eax
  8006d9:	50                   	push   %eax
  8006da:	e8 1e 2c 00 00       	call   8032fd <smalloc>
  8006df:	83 c4 10             	add    $0x10,%esp
  8006e2:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	*queue_out = 0;
  8006e8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8006ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************
	struct semaphore capacity = create_semaphore(_agentCapacity, agentCapacity);
  8006f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006f7:	8d 85 f8 fc ff ff    	lea    -0x308(%ebp),%eax
  8006fd:	83 ec 04             	sub    $0x4,%esp
  800700:	52                   	push   %edx
  800701:	8d 95 42 fe ff ff    	lea    -0x1be(%ebp),%edx
  800707:	52                   	push   %edx
  800708:	50                   	push   %eax
  800709:	e8 a6 47 00 00       	call   804eb4 <create_semaphore>
  80070e:	83 c4 0c             	add    $0xc,%esp

	struct semaphore flight1CS = create_semaphore(_flight1CS, 1);
  800711:	8d 85 f4 fc ff ff    	lea    -0x30c(%ebp),%eax
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	6a 01                	push   $0x1
  80071c:	8d 95 4a fd ff ff    	lea    -0x2b6(%ebp),%edx
  800722:	52                   	push   %edx
  800723:	50                   	push   %eax
  800724:	e8 8b 47 00 00       	call   804eb4 <create_semaphore>
  800729:	83 c4 0c             	add    $0xc,%esp
	struct semaphore flight2CS = create_semaphore(_flight2CS, 1);
  80072c:	8d 85 f0 fc ff ff    	lea    -0x310(%ebp),%eax
  800732:	83 ec 04             	sub    $0x4,%esp
  800735:	6a 01                	push   $0x1
  800737:	8d 95 40 fd ff ff    	lea    -0x2c0(%ebp),%edx
  80073d:	52                   	push   %edx
  80073e:	50                   	push   %eax
  80073f:	e8 70 47 00 00       	call   804eb4 <create_semaphore>
  800744:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custCounterCS = create_semaphore(_custCounterCS, 1);
  800747:	8d 85 ec fc ff ff    	lea    -0x314(%ebp),%eax
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	6a 01                	push   $0x1
  800752:	8d 95 2c fd ff ff    	lea    -0x2d4(%ebp),%edx
  800758:	52                   	push   %edx
  800759:	50                   	push   %eax
  80075a:	e8 55 47 00 00       	call   804eb4 <create_semaphore>
  80075f:	83 c4 0c             	add    $0xc,%esp
	struct semaphore custQueueCS = create_semaphore(_custQueueCS, 1);
  800762:	8d 85 e8 fc ff ff    	lea    -0x318(%ebp),%eax
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	6a 01                	push   $0x1
  80076d:	8d 95 54 fd ff ff    	lea    -0x2ac(%ebp),%edx
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	e8 3a 47 00 00       	call   804eb4 <create_semaphore>
  80077a:	83 c4 0c             	add    $0xc,%esp

	struct semaphore clerk = create_semaphore(_clerk, 3);
  80077d:	8d 85 e4 fc ff ff    	lea    -0x31c(%ebp),%eax
  800783:	83 ec 04             	sub    $0x4,%esp
  800786:	6a 03                	push   $0x3
  800788:	8d 95 3a fd ff ff    	lea    -0x2c6(%ebp),%edx
  80078e:	52                   	push   %edx
  80078f:	50                   	push   %eax
  800790:	e8 1f 47 00 00       	call   804eb4 <create_semaphore>
  800795:	83 c4 0c             	add    $0xc,%esp

	struct semaphore cust_ready = create_semaphore(_cust_ready, 0);
  800798:	8d 85 e0 fc ff ff    	lea    -0x320(%ebp),%eax
  80079e:	83 ec 04             	sub    $0x4,%esp
  8007a1:	6a 00                	push   $0x0
  8007a3:	8d 95 60 fd ff ff    	lea    -0x2a0(%ebp),%edx
  8007a9:	52                   	push   %edx
  8007aa:	50                   	push   %eax
  8007ab:	e8 04 47 00 00       	call   804eb4 <create_semaphore>
  8007b0:	83 c4 0c             	add    $0xc,%esp

	struct semaphore custTerminated = create_semaphore(_custTerminated, 0);
  8007b3:	8d 85 dc fc ff ff    	lea    -0x324(%ebp),%eax
  8007b9:	83 ec 04             	sub    $0x4,%esp
  8007bc:	6a 00                	push   $0x0
  8007be:	8d 95 1d fd ff ff    	lea    -0x2e3(%ebp),%edx
  8007c4:	52                   	push   %edx
  8007c5:	50                   	push   %eax
  8007c6:	e8 e9 46 00 00       	call   804eb4 <create_semaphore>
  8007cb:	83 c4 0c             	add    $0xc,%esp
	struct semaphore clerkTerminated = create_semaphore(_clerkTerminated, 0);
  8007ce:	8d 85 d8 fc ff ff    	lea    -0x328(%ebp),%eax
  8007d4:	83 ec 04             	sub    $0x4,%esp
  8007d7:	6a 00                	push   $0x0
  8007d9:	8d 95 0d fd ff ff    	lea    -0x2f3(%ebp),%edx
  8007df:	52                   	push   %edx
  8007e0:	50                   	push   %eax
  8007e1:	e8 ce 46 00 00       	call   804eb4 <create_semaphore>
  8007e6:	83 c4 0c             	add    $0xc,%esp

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);
  8007e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007ec:	c1 e0 02             	shl    $0x2,%eax
  8007ef:	83 ec 04             	sub    $0x4,%esp
  8007f2:	6a 01                	push   $0x1
  8007f4:	50                   	push   %eax
  8007f5:	68 de 54 80 00       	push   $0x8054de
  8007fa:	e8 fe 2a 00 00       	call   8032fd <smalloc>
  8007ff:	83 c4 10             	add    $0x10,%esp
  800802:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)

	int s=0;
  800808:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  80080f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  800816:	e9 9a 00 00 00       	jmp    8008b5 <_main+0x87d>
	{
		char prefix[30]="cust_finished";
  80081b:	8d 85 ae fc ff ff    	lea    -0x352(%ebp),%eax
  800821:	bb 2a 5a 80 00       	mov    $0x805a2a,%ebx
  800826:	ba 0e 00 00 00       	mov    $0xe,%edx
  80082b:	89 c7                	mov    %eax,%edi
  80082d:	89 de                	mov    %ebx,%esi
  80082f:	89 d1                	mov    %edx,%ecx
  800831:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800833:	8d 95 bc fc ff ff    	lea    -0x344(%ebp),%edx
  800839:	b9 04 00 00 00       	mov    $0x4,%ecx
  80083e:	b8 00 00 00 00       	mov    $0x0,%eax
  800843:	89 d7                	mov    %edx,%edi
  800845:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  800847:	83 ec 08             	sub    $0x8,%esp
  80084a:	8d 85 a9 fc ff ff    	lea    -0x357(%ebp),%eax
  800850:	50                   	push   %eax
  800851:	ff 75 c4             	pushl  -0x3c(%ebp)
  800854:	e8 2b 1a 00 00       	call   802284 <ltostr>
  800859:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  80085c:	83 ec 04             	sub    $0x4,%esp
  80085f:	8d 85 77 fc ff ff    	lea    -0x389(%ebp),%eax
  800865:	50                   	push   %eax
  800866:	8d 85 a9 fc ff ff    	lea    -0x357(%ebp),%eax
  80086c:	50                   	push   %eax
  80086d:	8d 85 ae fc ff ff    	lea    -0x352(%ebp),%eax
  800873:	50                   	push   %eax
  800874:	e8 e4 1a 00 00       	call   80235d <strcconcat>
  800879:	83 c4 10             	add    $0x10,%esp
		//sys_createSemaphore(sname, 0);
		cust_finished[s] = create_semaphore(sname, 0);
  80087c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80087f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800886:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  80088c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
  80088f:	8d 85 64 fc ff ff    	lea    -0x39c(%ebp),%eax
  800895:	83 ec 04             	sub    $0x4,%esp
  800898:	6a 00                	push   $0x0
  80089a:	8d 95 77 fc ff ff    	lea    -0x389(%ebp),%edx
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	e8 0d 46 00 00       	call   804eb4 <create_semaphore>
  8008a7:	83 c4 0c             	add    $0xc,%esp
  8008aa:	8b 85 64 fc ff ff    	mov    -0x39c(%ebp),%eax
  8008b0:	89 03                	mov    %eax,(%ebx)
	struct semaphore clerkTerminated = create_semaphore(_clerkTerminated, 0);

	struct semaphore* cust_finished = smalloc("cust_finished_array", numOfCustomers*sizeof(struct semaphore), 1);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  8008b2:	ff 45 c4             	incl   -0x3c(%ebp)
  8008b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8008b8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8008bb:	0f 8c 5a ff ff ff    	jl     80081b <_main+0x7e3>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//clerks
	uint32 envId;
	for (int k = 0; k < numOfClerks; ++k)
  8008c1:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  8008c8:	eb 50                	jmp    80091a <_main+0x8e2>
	{
		envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8008ca:	a1 20 70 80 00       	mov    0x807020,%eax
  8008cf:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8008d5:	a1 20 70 80 00       	mov    0x807020,%eax
  8008da:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  8008e0:	89 c1                	mov    %eax,%ecx
  8008e2:	a1 20 70 80 00       	mov    0x807020,%eax
  8008e7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  8008ed:	52                   	push   %edx
  8008ee:	51                   	push   %ecx
  8008ef:	50                   	push   %eax
  8008f0:	8d 85 06 fd ff ff    	lea    -0x2fa(%ebp),%eax
  8008f6:	50                   	push   %eax
  8008f7:	e8 20 38 00 00       	call   80411c <sys_create_env>
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		sys_run_env(envId);
  800905:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80090b:	83 ec 0c             	sub    $0xc,%esp
  80090e:	50                   	push   %eax
  80090f:	e8 26 38 00 00       	call   80413a <sys_run_env>
  800914:	83 c4 10             	add    $0x10,%esp
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//clerks
	uint32 envId;
	for (int k = 0; k < numOfClerks; ++k)
  800917:	ff 45 c0             	incl   -0x40(%ebp)
  80091a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80091d:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800920:	7c a8                	jl     8008ca <_main+0x892>
		sys_run_env(envId);
	}

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800922:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  800929:	eb 70                	jmp    80099b <_main+0x963>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80092b:	a1 20 70 80 00       	mov    0x807020,%eax
  800930:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800936:	a1 20 70 80 00       	mov    0x807020,%eax
  80093b:	8b 80 a0 05 00 00    	mov    0x5a0(%eax),%eax
  800941:	89 c1                	mov    %eax,%ecx
  800943:	a1 20 70 80 00       	mov    0x807020,%eax
  800948:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80094e:	52                   	push   %edx
  80094f:	51                   	push   %ecx
  800950:	50                   	push   %eax
  800951:	8d 85 ff fc ff ff    	lea    -0x301(%ebp),%eax
  800957:	50                   	push   %eax
  800958:	e8 bf 37 00 00       	call   80411c <sys_create_env>
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  800966:	83 bd 58 ff ff ff ef 	cmpl   $0xffffffef,-0xa8(%ebp)
  80096d:	75 17                	jne    800986 <_main+0x94e>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	68 f4 54 80 00       	push   $0x8054f4
  800977:	68 b5 00 00 00       	push   $0xb5
  80097c:	68 3a 55 80 00       	push   $0x80553a
  800981:	e8 fa 07 00 00       	call   801180 <_panic>

		sys_run_env(envId);
  800986:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  80098c:	83 ec 0c             	sub    $0xc,%esp
  80098f:	50                   	push   %eax
  800990:	e8 a5 37 00 00       	call   80413a <sys_run_env>
  800995:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envId);
	}

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800998:	ff 45 bc             	incl   -0x44(%ebp)
  80099b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80099e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009a1:	7c 88                	jl     80092b <_main+0x8f3>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8009a3:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  8009aa:	eb 14                	jmp    8009c0 <_main+0x988>
	{
		wait_semaphore(custTerminated);
  8009ac:	83 ec 0c             	sub    $0xc,%esp
  8009af:	ff b5 dc fc ff ff    	pushl  -0x324(%ebp)
  8009b5:	e8 2e 45 00 00       	call   804ee8 <wait_semaphore>
  8009ba:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8009bd:	ff 45 bc             	incl   -0x44(%ebp)
  8009c0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8009c3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8009c6:	7c e4                	jl     8009ac <_main+0x974>
	{
		wait_semaphore(custTerminated);
	}

	env_sleep(1500);
  8009c8:	83 ec 0c             	sub    $0xc,%esp
  8009cb:	68 dc 05 00 00       	push   $0x5dc
  8009d0:	e8 52 45 00 00       	call   804f27 <env_sleep>
  8009d5:	83 c4 10             	add    $0x10,%esp
	int b;

	sys_lock_cons();
  8009d8:	e8 34 35 00 00       	call   803f11 <sys_lock_cons>
	{
	//print out the results
	for(b=0; b< (*flight1BookedCounter);++b)
  8009dd:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  8009e4:	eb 4b                	jmp    800a31 <_main+0x9f9>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  8009e6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8009e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009f0:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	8b 00                	mov    (%eax),%eax
  8009fa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800a01:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a04:	01 d0                	add    %edx,%eax
  800a06:	8b 10                	mov    (%eax),%edx
  800a08:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a0b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a12:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a18:	01 c8                	add    %ecx,%eax
  800a1a:	8b 00                	mov    (%eax),%eax
  800a1c:	83 ec 04             	sub    $0x4,%esp
  800a1f:	52                   	push   %edx
  800a20:	50                   	push   %eax
  800a21:	68 4c 55 80 00       	push   $0x80554c
  800a26:	e8 23 0a 00 00       	call   80144e <cprintf>
  800a2b:	83 c4 10             	add    $0x10,%esp
	int b;

	sys_lock_cons();
	{
	//print out the results
	for(b=0; b< (*flight1BookedCounter);++b)
  800a2e:	ff 45 b8             	incl   -0x48(%ebp)
  800a31:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800a37:	8b 00                	mov    (%eax),%eax
  800a39:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800a3c:	7f a8                	jg     8009e6 <_main+0x9ae>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  800a3e:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  800a45:	eb 4b                	jmp    800a92 <_main+0xa5a>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800a47:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a4a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a51:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a57:	01 d0                	add    %edx,%eax
  800a59:	8b 00                	mov    (%eax),%eax
  800a5b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800a62:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a65:	01 d0                	add    %edx,%eax
  800a67:	8b 10                	mov    (%eax),%edx
  800a69:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800a6c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a73:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a79:	01 c8                	add    %ecx,%eax
  800a7b:	8b 00                	mov    (%eax),%eax
  800a7d:	83 ec 04             	sub    $0x4,%esp
  800a80:	52                   	push   %edx
  800a81:	50                   	push   %eax
  800a82:	68 7c 55 80 00       	push   $0x80557c
  800a87:	e8 c2 09 00 00       	call   80144e <cprintf>
  800a8c:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  800a8f:	ff 45 b8             	incl   -0x48(%ebp)
  800a92:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800a98:	8b 00                	mov    (%eax),%eax
  800a9a:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800a9d:	7f a8                	jg     800a47 <_main+0xa0f>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}
	}
	sys_unlock_cons();
  800a9f:	e8 87 34 00 00       	call   803f2b <sys_unlock_cons>

	int numOfBookings = 0;
  800aa4:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
	int numOfFCusts[3] = {0};
  800aab:	8d 95 cc fc ff ff    	lea    -0x334(%ebp),%edx
  800ab1:	b9 03 00 00 00       	mov    $0x3,%ecx
  800ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  800abb:	89 d7                	mov    %edx,%edi
  800abd:	f3 ab                	rep stos %eax,%es:(%edi)

	for(b=0; b< numOfCustomers;++b)
  800abf:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  800ac6:	eb 3d                	jmp    800b05 <_main+0xacd>
	{
		if (custs[b].booked)
  800ac8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800acb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800ad2:	8b 45 98             	mov    -0x68(%ebp),%eax
  800ad5:	01 d0                	add    %edx,%eax
  800ad7:	8b 40 04             	mov    0x4(%eax),%eax
  800ada:	85 c0                	test   %eax,%eax
  800adc:	74 24                	je     800b02 <_main+0xaca>
		{
			numOfBookings++;
  800ade:	ff 45 b4             	incl   -0x4c(%ebp)
			numOfFCusts[custs[b].flightType - 1]++ ;
  800ae1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ae4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800aeb:	8b 45 98             	mov    -0x68(%ebp),%eax
  800aee:	01 d0                	add    %edx,%eax
  800af0:	8b 00                	mov    (%eax),%eax
  800af2:	48                   	dec    %eax
  800af3:	8b 94 85 cc fc ff ff 	mov    -0x334(%ebp,%eax,4),%edx
  800afa:	42                   	inc    %edx
  800afb:	89 94 85 cc fc ff ff 	mov    %edx,-0x334(%ebp,%eax,4)
	sys_unlock_cons();

	int numOfBookings = 0;
	int numOfFCusts[3] = {0};

	for(b=0; b< numOfCustomers;++b)
  800b02:	ff 45 b8             	incl   -0x48(%ebp)
  800b05:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800b08:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800b0b:	7c bb                	jl     800ac8 <_main+0xa90>
			numOfBookings++;
			numOfFCusts[custs[b].flightType - 1]++ ;
		}
	}

	sys_lock_cons();
  800b0d:	e8 ff 33 00 00       	call   803f11 <sys_lock_cons>
	{
	cprintf("%~[*] FINAL RESULTS:\n");
  800b12:	83 ec 0c             	sub    $0xc,%esp
  800b15:	68 ac 55 80 00       	push   $0x8055ac
  800b1a:	e8 2f 09 00 00       	call   80144e <cprintf>
  800b1f:	83 c4 10             	add    $0x10,%esp
	cprintf("%~\tTotal number of customers = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfCustomers, flight1NumOfCustomers,flight2NumOfCustomers,flight3NumOfCustomers);
  800b22:	83 ec 0c             	sub    $0xc,%esp
  800b25:	ff 75 d4             	pushl  -0x2c(%ebp)
  800b28:	ff 75 d8             	pushl  -0x28(%ebp)
  800b2b:	ff 75 dc             	pushl  -0x24(%ebp)
  800b2e:	ff 75 e0             	pushl  -0x20(%ebp)
  800b31:	68 c4 55 80 00       	push   $0x8055c4
  800b36:	e8 13 09 00 00       	call   80144e <cprintf>
  800b3b:	83 c4 20             	add    $0x20,%esp
	cprintf("%~\tTotal number of customers who receive tickets = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfBookings, numOfFCusts[0],numOfFCusts[1],numOfFCusts[2]);
  800b3e:	8b 8d d4 fc ff ff    	mov    -0x32c(%ebp),%ecx
  800b44:	8b 95 d0 fc ff ff    	mov    -0x330(%ebp),%edx
  800b4a:	8b 85 cc fc ff ff    	mov    -0x334(%ebp),%eax
  800b50:	83 ec 0c             	sub    $0xc,%esp
  800b53:	51                   	push   %ecx
  800b54:	52                   	push   %edx
  800b55:	50                   	push   %eax
  800b56:	ff 75 b4             	pushl  -0x4c(%ebp)
  800b59:	68 18 56 80 00       	push   $0x805618
  800b5e:	e8 eb 08 00 00       	call   80144e <cprintf>
  800b63:	83 c4 20             	add    $0x20,%esp
	}
	sys_unlock_cons();
  800b66:	e8 c0 33 00 00       	call   803f2b <sys_unlock_cons>
	//check out the final results and semaphores
	{
		for(int c = 0; c < numOfCustomers; ++c)
  800b6b:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  800b72:	e9 13 01 00 00       	jmp    800c8a <_main+0xc52>
		{
			if (custs[c].booked)
  800b77:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800b7a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800b81:	8b 45 98             	mov    -0x68(%ebp),%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	8b 40 04             	mov    0x4(%eax),%eax
  800b89:	85 c0                	test   %eax,%eax
  800b8b:	0f 84 f6 00 00 00    	je     800c87 <_main+0xc4f>
			{
				if(custs[c].flightType ==1 && find(flight1BookedArr, flight1NumOfTickets, c) != 1)
  800b91:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800b94:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800b9b:	8b 45 98             	mov    -0x68(%ebp),%eax
  800b9e:	01 d0                	add    %edx,%eax
  800ba0:	8b 00                	mov    (%eax),%eax
  800ba2:	83 f8 01             	cmp    $0x1,%eax
  800ba5:	75 33                	jne    800bda <_main+0xba2>
  800ba7:	83 ec 04             	sub    $0x4,%esp
  800baa:	ff 75 b0             	pushl  -0x50(%ebp)
  800bad:	ff 75 d0             	pushl  -0x30(%ebp)
  800bb0:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  800bb6:	e8 8b 03 00 00       	call   800f46 <find>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	83 f8 01             	cmp    $0x1,%eax
  800bc1:	74 17                	je     800bda <_main+0xba2>
				{
					panic("Error, wrong booking for user %d\n", c);
  800bc3:	ff 75 b0             	pushl  -0x50(%ebp)
  800bc6:	68 80 56 80 00       	push   $0x805680
  800bcb:	68 ed 00 00 00       	push   $0xed
  800bd0:	68 3a 55 80 00       	push   $0x80553a
  800bd5:	e8 a6 05 00 00       	call   801180 <_panic>
				}
				if(custs[c].flightType ==2 && find(flight2BookedArr, flight2NumOfTickets, c) != 1)
  800bda:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800bdd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800be4:	8b 45 98             	mov    -0x68(%ebp),%eax
  800be7:	01 d0                	add    %edx,%eax
  800be9:	8b 00                	mov    (%eax),%eax
  800beb:	83 f8 02             	cmp    $0x2,%eax
  800bee:	75 33                	jne    800c23 <_main+0xbeb>
  800bf0:	83 ec 04             	sub    $0x4,%esp
  800bf3:	ff 75 b0             	pushl  -0x50(%ebp)
  800bf6:	ff 75 cc             	pushl  -0x34(%ebp)
  800bf9:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  800bff:	e8 42 03 00 00       	call   800f46 <find>
  800c04:	83 c4 10             	add    $0x10,%esp
  800c07:	83 f8 01             	cmp    $0x1,%eax
  800c0a:	74 17                	je     800c23 <_main+0xbeb>
				{
					panic("Error, wrong booking for user %d\n", c);
  800c0c:	ff 75 b0             	pushl  -0x50(%ebp)
  800c0f:	68 80 56 80 00       	push   $0x805680
  800c14:	68 f1 00 00 00       	push   $0xf1
  800c19:	68 3a 55 80 00       	push   $0x80553a
  800c1e:	e8 5d 05 00 00       	call   801180 <_panic>
				}
				if(custs[c].flightType ==3 && ((find(flight1BookedArr, flight1NumOfTickets, c) + find(flight2BookedArr, flight2NumOfTickets, c)) != 2))
  800c23:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c26:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800c2d:	8b 45 98             	mov    -0x68(%ebp),%eax
  800c30:	01 d0                	add    %edx,%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	83 f8 03             	cmp    $0x3,%eax
  800c37:	75 4e                	jne    800c87 <_main+0xc4f>
  800c39:	83 ec 04             	sub    $0x4,%esp
  800c3c:	ff 75 b0             	pushl  -0x50(%ebp)
  800c3f:	ff 75 d0             	pushl  -0x30(%ebp)
  800c42:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  800c48:	e8 f9 02 00 00       	call   800f46 <find>
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	89 c3                	mov    %eax,%ebx
  800c52:	83 ec 04             	sub    $0x4,%esp
  800c55:	ff 75 b0             	pushl  -0x50(%ebp)
  800c58:	ff 75 cc             	pushl  -0x34(%ebp)
  800c5b:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  800c61:	e8 e0 02 00 00       	call   800f46 <find>
  800c66:	83 c4 10             	add    $0x10,%esp
  800c69:	01 d8                	add    %ebx,%eax
  800c6b:	83 f8 02             	cmp    $0x2,%eax
  800c6e:	74 17                	je     800c87 <_main+0xc4f>
				{
					panic("Error, wrong booking for user %d\n", c);
  800c70:	ff 75 b0             	pushl  -0x50(%ebp)
  800c73:	68 80 56 80 00       	push   $0x805680
  800c78:	68 f5 00 00 00       	push   $0xf5
  800c7d:	68 3a 55 80 00       	push   $0x80553a
  800c82:	e8 f9 04 00 00       	call   801180 <_panic>
	cprintf("%~\tTotal number of customers who receive tickets = %d (Flight1# = %d, Flight2# = %d, Flight3# = %d)\n", numOfBookings, numOfFCusts[0],numOfFCusts[1],numOfFCusts[2]);
	}
	sys_unlock_cons();
	//check out the final results and semaphores
	{
		for(int c = 0; c < numOfCustomers; ++c)
  800c87:	ff 45 b0             	incl   -0x50(%ebp)
  800c8a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800c8d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800c90:	0f 8c e1 fe ff ff    	jl     800b77 <_main+0xb3f>
					panic("Error, wrong booking for user %d\n", c);
				}
			}
		}

		assert(semaphore_count(capacity) == agentCapacity);
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	ff b5 f8 fc ff ff    	pushl  -0x308(%ebp)
  800c9f:	e8 78 42 00 00       	call   804f1c <semaphore_count>
  800ca4:	83 c4 10             	add    $0x10,%esp
  800ca7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800caa:	74 19                	je     800cc5 <_main+0xc8d>
  800cac:	68 a4 56 80 00       	push   $0x8056a4
  800cb1:	68 cf 56 80 00       	push   $0x8056cf
  800cb6:	68 fa 00 00 00       	push   $0xfa
  800cbb:	68 3a 55 80 00       	push   $0x80553a
  800cc0:	e8 bb 04 00 00       	call   801180 <_panic>

		assert(semaphore_count(flight1CS) == 1);
  800cc5:	83 ec 0c             	sub    $0xc,%esp
  800cc8:	ff b5 f4 fc ff ff    	pushl  -0x30c(%ebp)
  800cce:	e8 49 42 00 00       	call   804f1c <semaphore_count>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	83 f8 01             	cmp    $0x1,%eax
  800cd9:	74 19                	je     800cf4 <_main+0xcbc>
  800cdb:	68 e4 56 80 00       	push   $0x8056e4
  800ce0:	68 cf 56 80 00       	push   $0x8056cf
  800ce5:	68 fc 00 00 00       	push   $0xfc
  800cea:	68 3a 55 80 00       	push   $0x80553a
  800cef:	e8 8c 04 00 00       	call   801180 <_panic>
		assert(semaphore_count(flight2CS) == 1);
  800cf4:	83 ec 0c             	sub    $0xc,%esp
  800cf7:	ff b5 f0 fc ff ff    	pushl  -0x310(%ebp)
  800cfd:	e8 1a 42 00 00       	call   804f1c <semaphore_count>
  800d02:	83 c4 10             	add    $0x10,%esp
  800d05:	83 f8 01             	cmp    $0x1,%eax
  800d08:	74 19                	je     800d23 <_main+0xceb>
  800d0a:	68 04 57 80 00       	push   $0x805704
  800d0f:	68 cf 56 80 00       	push   $0x8056cf
  800d14:	68 fd 00 00 00       	push   $0xfd
  800d19:	68 3a 55 80 00       	push   $0x80553a
  800d1e:	e8 5d 04 00 00       	call   801180 <_panic>

		assert(semaphore_count(custCounterCS) ==  1);
  800d23:	83 ec 0c             	sub    $0xc,%esp
  800d26:	ff b5 ec fc ff ff    	pushl  -0x314(%ebp)
  800d2c:	e8 eb 41 00 00       	call   804f1c <semaphore_count>
  800d31:	83 c4 10             	add    $0x10,%esp
  800d34:	83 f8 01             	cmp    $0x1,%eax
  800d37:	74 19                	je     800d52 <_main+0xd1a>
  800d39:	68 24 57 80 00       	push   $0x805724
  800d3e:	68 cf 56 80 00       	push   $0x8056cf
  800d43:	68 ff 00 00 00       	push   $0xff
  800d48:	68 3a 55 80 00       	push   $0x80553a
  800d4d:	e8 2e 04 00 00       	call   801180 <_panic>
		assert(semaphore_count(custQueueCS)  ==  1);
  800d52:	83 ec 0c             	sub    $0xc,%esp
  800d55:	ff b5 e8 fc ff ff    	pushl  -0x318(%ebp)
  800d5b:	e8 bc 41 00 00       	call   804f1c <semaphore_count>
  800d60:	83 c4 10             	add    $0x10,%esp
  800d63:	83 f8 01             	cmp    $0x1,%eax
  800d66:	74 19                	je     800d81 <_main+0xd49>
  800d68:	68 48 57 80 00       	push   $0x805748
  800d6d:	68 cf 56 80 00       	push   $0x8056cf
  800d72:	68 00 01 00 00       	push   $0x100
  800d77:	68 3a 55 80 00       	push   $0x80553a
  800d7c:	e8 ff 03 00 00       	call   801180 <_panic>

		assert(semaphore_count(clerk)  == 3);
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	ff b5 e4 fc ff ff    	pushl  -0x31c(%ebp)
  800d8a:	e8 8d 41 00 00       	call   804f1c <semaphore_count>
  800d8f:	83 c4 10             	add    $0x10,%esp
  800d92:	83 f8 03             	cmp    $0x3,%eax
  800d95:	74 19                	je     800db0 <_main+0xd78>
  800d97:	68 6a 57 80 00       	push   $0x80576a
  800d9c:	68 cf 56 80 00       	push   $0x8056cf
  800da1:	68 02 01 00 00       	push   $0x102
  800da6:	68 3a 55 80 00       	push   $0x80553a
  800dab:	e8 d0 03 00 00       	call   801180 <_panic>

		assert(semaphore_count(cust_ready) == -3);
  800db0:	83 ec 0c             	sub    $0xc,%esp
  800db3:	ff b5 e0 fc ff ff    	pushl  -0x320(%ebp)
  800db9:	e8 5e 41 00 00       	call   804f1c <semaphore_count>
  800dbe:	83 c4 10             	add    $0x10,%esp
  800dc1:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800dc4:	74 19                	je     800ddf <_main+0xda7>
  800dc6:	68 88 57 80 00       	push   $0x805788
  800dcb:	68 cf 56 80 00       	push   $0x8056cf
  800dd0:	68 04 01 00 00       	push   $0x104
  800dd5:	68 3a 55 80 00       	push   $0x80553a
  800dda:	e8 a1 03 00 00       	call   801180 <_panic>

		assert(semaphore_count(custTerminated) ==  0);
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	ff b5 dc fc ff ff    	pushl  -0x324(%ebp)
  800de8:	e8 2f 41 00 00       	call   804f1c <semaphore_count>
  800ded:	83 c4 10             	add    $0x10,%esp
  800df0:	85 c0                	test   %eax,%eax
  800df2:	74 19                	je     800e0d <_main+0xdd5>
  800df4:	68 ac 57 80 00       	push   $0x8057ac
  800df9:	68 cf 56 80 00       	push   $0x8056cf
  800dfe:	68 06 01 00 00       	push   $0x106
  800e03:	68 3a 55 80 00       	push   $0x80553a
  800e08:	e8 73 03 00 00       	call   801180 <_panic>

		int s=0;
  800e0d:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800e14:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
  800e1b:	eb 3f                	jmp    800e5c <_main+0xe24>
		{
			assert(semaphore_count(cust_finished[s]) ==  0);
  800e1d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800e20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e27:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800e2d:	01 d0                	add    %edx,%eax
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	ff 30                	pushl  (%eax)
  800e34:	e8 e3 40 00 00       	call   804f1c <semaphore_count>
  800e39:	83 c4 10             	add    $0x10,%esp
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	74 19                	je     800e59 <_main+0xe21>
  800e40:	68 d4 57 80 00       	push   $0x8057d4
  800e45:	68 cf 56 80 00       	push   $0x8056cf
  800e4a:	68 0b 01 00 00       	push   $0x10b
  800e4f:	68 3a 55 80 00       	push   $0x80553a
  800e54:	e8 27 03 00 00       	call   801180 <_panic>
		assert(semaphore_count(cust_ready) == -3);

		assert(semaphore_count(custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800e59:	ff 45 ac             	incl   -0x54(%ebp)
  800e5c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800e5f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800e62:	7c b9                	jl     800e1d <_main+0xde5>
		{
			assert(semaphore_count(cust_finished[s]) ==  0);
		}

		atomic_cprintf("%~\nAll reservations are successfully done... have a nice flight :)\n");
  800e64:	83 ec 0c             	sub    $0xc,%esp
  800e67:	68 fc 57 80 00       	push   $0x8057fc
  800e6c:	e8 4f 06 00 00       	call   8014c0 <atomic_cprintf>
  800e71:	83 c4 10             	add    $0x10,%esp

		//waste some time then close the agency
		env_sleep(5000) ;
  800e74:	83 ec 0c             	sub    $0xc,%esp
  800e77:	68 88 13 00 00       	push   $0x1388
  800e7c:	e8 a6 40 00 00       	call   804f27 <env_sleep>
  800e81:	83 c4 10             	add    $0x10,%esp
		*isOpened = 0;
  800e84:	8b 45 88             	mov    -0x78(%ebp),%eax
  800e87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		atomic_cprintf("\n%~The agency is closing now...\n");
  800e8d:	83 ec 0c             	sub    $0xc,%esp
  800e90:	68 40 58 80 00       	push   $0x805840
  800e95:	e8 26 06 00 00       	call   8014c0 <atomic_cprintf>
  800e9a:	83 c4 10             	add    $0x10,%esp

		//Signal all clerks to continue and recheck the isOpened flag
		cust_ready_queue[numOfCustomers] = -1; //to indicate, for the clerk, there's no more customers
  800e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ea0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ea7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800ead:	01 d0                	add    %edx,%eax
  800eaf:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
		for (int k = 0; k < numOfClerks; ++k)
  800eb5:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
  800ebc:	eb 14                	jmp    800ed2 <_main+0xe9a>
		{
			signal_semaphore(cust_ready);
  800ebe:	83 ec 0c             	sub    $0xc,%esp
  800ec1:	ff b5 e0 fc ff ff    	pushl  -0x320(%ebp)
  800ec7:	e8 36 40 00 00       	call   804f02 <signal_semaphore>
  800ecc:	83 c4 10             	add    $0x10,%esp
		*isOpened = 0;
		atomic_cprintf("\n%~The agency is closing now...\n");

		//Signal all clerks to continue and recheck the isOpened flag
		cust_ready_queue[numOfCustomers] = -1; //to indicate, for the clerk, there's no more customers
		for (int k = 0; k < numOfClerks; ++k)
  800ecf:	ff 45 a8             	incl   -0x58(%ebp)
  800ed2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800ed5:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800ed8:	7c e4                	jl     800ebe <_main+0xe86>
		{
			signal_semaphore(cust_ready);
		}

		//Wait all clerks to finished
		for (int k = 0; k < numOfClerks; ++k)
  800eda:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
  800ee1:	eb 14                	jmp    800ef7 <_main+0xebf>
		{
			wait_semaphore(clerkTerminated);
  800ee3:	83 ec 0c             	sub    $0xc,%esp
  800ee6:	ff b5 d8 fc ff ff    	pushl  -0x328(%ebp)
  800eec:	e8 f7 3f 00 00       	call   804ee8 <wait_semaphore>
  800ef1:	83 c4 10             	add    $0x10,%esp
		{
			signal_semaphore(cust_ready);
		}

		//Wait all clerks to finished
		for (int k = 0; k < numOfClerks; ++k)
  800ef4:	ff 45 a4             	incl   -0x5c(%ebp)
  800ef7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800efa:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  800efd:	7c e4                	jl     800ee3 <_main+0xeab>
		{
			wait_semaphore(clerkTerminated);
		}

		assert(semaphore_count(clerkTerminated) ==  0);
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	ff b5 d8 fc ff ff    	pushl  -0x328(%ebp)
  800f08:	e8 0f 40 00 00       	call   804f1c <semaphore_count>
  800f0d:	83 c4 10             	add    $0x10,%esp
  800f10:	85 c0                	test   %eax,%eax
  800f12:	74 19                	je     800f2d <_main+0xef5>
  800f14:	68 64 58 80 00       	push   $0x805864
  800f19:	68 cf 56 80 00       	push   $0x8056cf
  800f1e:	68 22 01 00 00       	push   $0x122
  800f23:	68 3a 55 80 00       	push   $0x80553a
  800f28:	e8 53 02 00 00       	call   801180 <_panic>

		atomic_cprintf("%~\nCongratulations... Airplane Reservation App is Finished Successfully\n\n");
  800f2d:	83 ec 0c             	sub    $0xc,%esp
  800f30:	68 8c 58 80 00       	push   $0x80588c
  800f35:	e8 86 05 00 00       	call   8014c0 <atomic_cprintf>
  800f3a:	83 c4 10             	add    $0x10,%esp
	}

}
  800f3d:	90                   	nop
  800f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <find>:


int find(int* arr, int size, int val)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800f4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800f53:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f5a:	eb 22                	jmp    800f7e <find+0x38>
	{
		if(arr[i] == val)
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	01 d0                	add    %edx,%eax
  800f6b:	8b 00                	mov    (%eax),%eax
  800f6d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f70:	75 09                	jne    800f7b <find+0x35>
		{
			result = 1;
  800f72:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800f79:	eb 0b                	jmp    800f86 <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800f7b:	ff 45 f8             	incl   -0x8(%ebp)
  800f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f81:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800f84:	7c d6                	jl     800f5c <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f89:	c9                   	leave  
  800f8a:	c3                   	ret    

00800f8b <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800f97:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800f9b:	83 ec 0c             	sub    $0xc,%esp
  800f9e:	50                   	push   %eax
  800f9f:	e8 b5 30 00 00       	call   804059 <sys_cputc>
  800fa4:	83 c4 10             	add    $0x10,%esp
}
  800fa7:	90                   	nop
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <getchar>:


int
getchar(void)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  800fb0:	e8 43 2f 00 00       	call   803ef8 <sys_cgetc>
  800fb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  800fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <iscons>:

int iscons(int fdnum)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800fc0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	57                   	push   %edi
  800fcb:	56                   	push   %esi
  800fcc:	53                   	push   %ebx
  800fcd:	83 ec 7c             	sub    $0x7c,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800fd0:	e8 b5 31 00 00       	call   80418a <sys_getenvindex>
  800fd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	myEnv = &(envs[envIndex]);
  800fd8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fdb:	89 d0                	mov    %edx,%eax
  800fdd:	c1 e0 02             	shl    $0x2,%eax
  800fe0:	01 d0                	add    %edx,%eax
  800fe2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fe9:	01 d0                	add    %edx,%eax
  800feb:	89 c2                	mov    %eax,%edx
  800fed:	c1 e2 04             	shl    $0x4,%edx
  800ff0:	29 c2                	sub    %eax,%edx
  800ff2:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  800ff9:	89 c2                	mov    %eax,%edx
  800ffb:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  801001:	a3 20 70 80 00       	mov    %eax,0x807020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801006:	a1 20 70 80 00       	mov    0x807020,%eax
  80100b:	8a 40 20             	mov    0x20(%eax),%al
  80100e:	84 c0                	test   %al,%al
  801010:	74 0d                	je     80101f <libmain+0x58>
		binaryname = myEnv->prog_name;
  801012:	a1 20 70 80 00       	mov    0x807020,%eax
  801017:	83 c0 20             	add    $0x20,%eax
  80101a:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80101f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801023:	7e 0a                	jle    80102f <libmain+0x68>
		binaryname = argv[0];
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	8b 00                	mov    (%eax),%eax
  80102a:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  80102f:	83 ec 08             	sub    $0x8,%esp
  801032:	ff 75 0c             	pushl  0xc(%ebp)
  801035:	ff 75 08             	pushl  0x8(%ebp)
  801038:	e8 fb ef ff ff       	call   800038 <_main>
  80103d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801040:	a1 00 70 80 00       	mov    0x807000,%eax
  801045:	85 c0                	test   %eax,%eax
  801047:	0f 84 01 01 00 00    	je     80114e <libmain+0x187>
	{
		char isOPTReplCmd[100] = "__IsOPTRepl__" ;
  80104d:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801053:	bb 40 5b 80 00       	mov    $0x805b40,%ebx
  801058:	ba 0e 00 00 00       	mov    $0xe,%edx
  80105d:	89 c7                	mov    %eax,%edi
  80105f:	89 de                	mov    %ebx,%esi
  801061:	89 d1                	mov    %edx,%ecx
  801063:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801065:	8d 55 8a             	lea    -0x76(%ebp),%edx
  801068:	b9 56 00 00 00       	mov    $0x56,%ecx
  80106d:	b0 00                	mov    $0x0,%al
  80106f:	89 d7                	mov    %edx,%edi
  801071:	f3 aa                	rep stos %al,%es:(%edi)
		int isOPTRepl = 0;
  801073:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		sys_utilities(isOPTReplCmd, (uint32)(&isOPTRepl));
  80107a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80107d:	83 ec 08             	sub    $0x8,%esp
  801080:	50                   	push   %eax
  801081:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  801087:	50                   	push   %eax
  801088:	e8 33 33 00 00       	call   8043c0 <sys_utilities>
  80108d:	83 c4 10             	add    $0x10,%esp

		sys_lock_cons();
  801090:	e8 7c 2e 00 00       	call   803f11 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801095:	83 ec 0c             	sub    $0xc,%esp
  801098:	68 60 5a 80 00       	push   $0x805a60
  80109d:	e8 ac 03 00 00       	call   80144e <cprintf>
  8010a2:	83 c4 10             	add    $0x10,%esp
			if (isOPTRepl)
  8010a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010a8:	85 c0                	test   %eax,%eax
  8010aa:	74 18                	je     8010c4 <libmain+0xfd>
			{
				cprintf("OPTIMAL number of page faults = %d\n", sys_get_optimal_num_faults());
  8010ac:	e8 2d 33 00 00       	call   8043de <sys_get_optimal_num_faults>
  8010b1:	83 ec 08             	sub    $0x8,%esp
  8010b4:	50                   	push   %eax
  8010b5:	68 88 5a 80 00       	push   $0x805a88
  8010ba:	e8 8f 03 00 00       	call   80144e <cprintf>
  8010bf:	83 c4 10             	add    $0x10,%esp
  8010c2:	eb 59                	jmp    80111d <libmain+0x156>
			}
			else
			{
				cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8010c4:	a1 20 70 80 00       	mov    0x807020,%eax
  8010c9:	8b 90 bc 05 00 00    	mov    0x5bc(%eax),%edx
  8010cf:	a1 20 70 80 00       	mov    0x807020,%eax
  8010d4:	8b 80 ac 05 00 00    	mov    0x5ac(%eax),%eax
  8010da:	83 ec 04             	sub    $0x4,%esp
  8010dd:	52                   	push   %edx
  8010de:	50                   	push   %eax
  8010df:	68 ac 5a 80 00       	push   $0x805aac
  8010e4:	e8 65 03 00 00       	call   80144e <cprintf>
  8010e9:	83 c4 10             	add    $0x10,%esp
				cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8010ec:	a1 20 70 80 00       	mov    0x807020,%eax
  8010f1:	8b 88 d0 05 00 00    	mov    0x5d0(%eax),%ecx
  8010f7:	a1 20 70 80 00       	mov    0x807020,%eax
  8010fc:	8b 90 cc 05 00 00    	mov    0x5cc(%eax),%edx
  801102:	a1 20 70 80 00       	mov    0x807020,%eax
  801107:	8b 80 c8 05 00 00    	mov    0x5c8(%eax),%eax
  80110d:	51                   	push   %ecx
  80110e:	52                   	push   %edx
  80110f:	50                   	push   %eax
  801110:	68 d4 5a 80 00       	push   $0x805ad4
  801115:	e8 34 03 00 00       	call   80144e <cprintf>
  80111a:	83 c4 10             	add    $0x10,%esp
			}
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80111d:	a1 20 70 80 00       	mov    0x807020,%eax
  801122:	8b 80 d4 05 00 00    	mov    0x5d4(%eax),%eax
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	50                   	push   %eax
  80112c:	68 2c 5b 80 00       	push   $0x805b2c
  801131:	e8 18 03 00 00       	call   80144e <cprintf>
  801136:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801139:	83 ec 0c             	sub    $0xc,%esp
  80113c:	68 60 5a 80 00       	push   $0x805a60
  801141:	e8 08 03 00 00       	call   80144e <cprintf>
  801146:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801149:	e8 dd 2d 00 00       	call   803f2b <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80114e:	e8 1f 00 00 00       	call   801172 <exit>
}
  801153:	90                   	nop
  801154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801157:	5b                   	pop    %ebx
  801158:	5e                   	pop    %esi
  801159:	5f                   	pop    %edi
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    

0080115c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801162:	83 ec 0c             	sub    $0xc,%esp
  801165:	6a 00                	push   $0x0
  801167:	e8 ea 2f 00 00       	call   804156 <sys_destroy_env>
  80116c:	83 c4 10             	add    $0x10,%esp
}
  80116f:	90                   	nop
  801170:	c9                   	leave  
  801171:	c3                   	ret    

00801172 <exit>:

void
exit(void)
{
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
  801175:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801178:	e8 3f 30 00 00       	call   8041bc <sys_exit_env>
}
  80117d:	90                   	nop
  80117e:	c9                   	leave  
  80117f:	c3                   	ret    

00801180 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801180:	55                   	push   %ebp
  801181:	89 e5                	mov    %esp,%ebp
  801183:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801186:	8d 45 10             	lea    0x10(%ebp),%eax
  801189:	83 c0 04             	add    $0x4,%eax
  80118c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80118f:	a1 18 f1 81 00       	mov    0x81f118,%eax
  801194:	85 c0                	test   %eax,%eax
  801196:	74 16                	je     8011ae <_panic+0x2e>
		cprintf("%s: ", argv0);
  801198:	a1 18 f1 81 00       	mov    0x81f118,%eax
  80119d:	83 ec 08             	sub    $0x8,%esp
  8011a0:	50                   	push   %eax
  8011a1:	68 a4 5b 80 00       	push   $0x805ba4
  8011a6:	e8 a3 02 00 00       	call   80144e <cprintf>
  8011ab:	83 c4 10             	add    $0x10,%esp
	cprintf_colored(TEXT_PANIC_CLR, "user [EVAL_FINAL]panic in %s at %s:%d: ", binaryname, file, line);
  8011ae:	a1 04 70 80 00       	mov    0x807004,%eax
  8011b3:	83 ec 0c             	sub    $0xc,%esp
  8011b6:	ff 75 0c             	pushl  0xc(%ebp)
  8011b9:	ff 75 08             	pushl  0x8(%ebp)
  8011bc:	50                   	push   %eax
  8011bd:	68 ac 5b 80 00       	push   $0x805bac
  8011c2:	6a 74                	push   $0x74
  8011c4:	e8 b2 02 00 00       	call   80147b <cprintf_colored>
  8011c9:	83 c4 20             	add    $0x20,%esp
	vcprintf(fmt, ap);
  8011cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011cf:	83 ec 08             	sub    $0x8,%esp
  8011d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8011d5:	50                   	push   %eax
  8011d6:	e8 04 02 00 00       	call   8013df <vcprintf>
  8011db:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8011de:	83 ec 08             	sub    $0x8,%esp
  8011e1:	6a 00                	push   $0x0
  8011e3:	68 d4 5b 80 00       	push   $0x805bd4
  8011e8:	e8 f2 01 00 00       	call   8013df <vcprintf>
  8011ed:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8011f0:	e8 7d ff ff ff       	call   801172 <exit>

	// should not return here
	while (1) ;
  8011f5:	eb fe                	jmp    8011f5 <_panic+0x75>

008011f7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8011fd:	a1 20 70 80 00       	mov    0x807020,%eax
  801202:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	39 c2                	cmp    %eax,%edx
  80120d:	74 14                	je     801223 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	68 d8 5b 80 00       	push   $0x805bd8
  801217:	6a 26                	push   $0x26
  801219:	68 24 5c 80 00       	push   $0x805c24
  80121e:	e8 5d ff ff ff       	call   801180 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801223:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80122a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801231:	e9 c5 00 00 00       	jmp    8012fb <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801239:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	01 d0                	add    %edx,%eax
  801245:	8b 00                	mov    (%eax),%eax
  801247:	85 c0                	test   %eax,%eax
  801249:	75 08                	jne    801253 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80124b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80124e:	e9 a5 00 00 00       	jmp    8012f8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801253:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80125a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801261:	eb 69                	jmp    8012cc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801263:	a1 20 70 80 00       	mov    0x807020,%eax
  801268:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80126e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801271:	89 d0                	mov    %edx,%eax
  801273:	01 c0                	add    %eax,%eax
  801275:	01 d0                	add    %edx,%eax
  801277:	c1 e0 03             	shl    $0x3,%eax
  80127a:	01 c8                	add    %ecx,%eax
  80127c:	8a 40 04             	mov    0x4(%eax),%al
  80127f:	84 c0                	test   %al,%al
  801281:	75 46                	jne    8012c9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801283:	a1 20 70 80 00       	mov    0x807020,%eax
  801288:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  80128e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801291:	89 d0                	mov    %edx,%eax
  801293:	01 c0                	add    %eax,%eax
  801295:	01 d0                	add    %edx,%eax
  801297:	c1 e0 03             	shl    $0x3,%eax
  80129a:	01 c8                	add    %ecx,%eax
  80129c:	8b 00                	mov    (%eax),%eax
  80129e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8012a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012a9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8012ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ae:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	01 c8                	add    %ecx,%eax
  8012ba:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8012bc:	39 c2                	cmp    %eax,%edx
  8012be:	75 09                	jne    8012c9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8012c0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8012c7:	eb 15                	jmp    8012de <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8012c9:	ff 45 e8             	incl   -0x18(%ebp)
  8012cc:	a1 20 70 80 00       	mov    0x807020,%eax
  8012d1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  8012d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012da:	39 c2                	cmp    %eax,%edx
  8012dc:	77 85                	ja     801263 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8012de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8012e2:	75 14                	jne    8012f8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8012e4:	83 ec 04             	sub    $0x4,%esp
  8012e7:	68 30 5c 80 00       	push   $0x805c30
  8012ec:	6a 3a                	push   $0x3a
  8012ee:	68 24 5c 80 00       	push   $0x805c24
  8012f3:	e8 88 fe ff ff       	call   801180 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8012f8:	ff 45 f0             	incl   -0x10(%ebp)
  8012fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801301:	0f 8c 2f ff ff ff    	jl     801236 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801307:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80130e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801315:	eb 26                	jmp    80133d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801317:	a1 20 70 80 00       	mov    0x807020,%eax
  80131c:	8b 88 a4 05 00 00    	mov    0x5a4(%eax),%ecx
  801322:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801325:	89 d0                	mov    %edx,%eax
  801327:	01 c0                	add    %eax,%eax
  801329:	01 d0                	add    %edx,%eax
  80132b:	c1 e0 03             	shl    $0x3,%eax
  80132e:	01 c8                	add    %ecx,%eax
  801330:	8a 40 04             	mov    0x4(%eax),%al
  801333:	3c 01                	cmp    $0x1,%al
  801335:	75 03                	jne    80133a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801337:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80133a:	ff 45 e0             	incl   -0x20(%ebp)
  80133d:	a1 20 70 80 00       	mov    0x807020,%eax
  801342:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
  801348:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80134b:	39 c2                	cmp    %eax,%edx
  80134d:	77 c8                	ja     801317 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80134f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801352:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801355:	74 14                	je     80136b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801357:	83 ec 04             	sub    $0x4,%esp
  80135a:	68 84 5c 80 00       	push   $0x805c84
  80135f:	6a 44                	push   $0x44
  801361:	68 24 5c 80 00       	push   $0x805c24
  801366:	e8 15 fe ff ff       	call   801180 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80136b:	90                   	nop
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	53                   	push   %ebx
  801372:	83 ec 04             	sub    $0x4,%esp
	b->buf[b->idx++] = ch;
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	8b 00                	mov    (%eax),%eax
  80137a:	8d 48 01             	lea    0x1(%eax),%ecx
  80137d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801380:	89 0a                	mov    %ecx,(%edx)
  801382:	8b 55 08             	mov    0x8(%ebp),%edx
  801385:	88 d1                	mov    %dl,%cl
  801387:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80138e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801391:	8b 00                	mov    (%eax),%eax
  801393:	3d ff 00 00 00       	cmp    $0xff,%eax
  801398:	75 30                	jne    8013ca <putch+0x5c>
		sys_cputs(b->buf, b->idx, printProgName, curTextClr);
  80139a:	8b 15 1c f1 81 00    	mov    0x81f11c,%edx
  8013a0:	a0 44 70 80 00       	mov    0x807044,%al
  8013a5:	0f b6 c0             	movzbl %al,%eax
  8013a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ab:	8b 09                	mov    (%ecx),%ecx
  8013ad:	89 cb                	mov    %ecx,%ebx
  8013af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b2:	83 c1 08             	add    $0x8,%ecx
  8013b5:	52                   	push   %edx
  8013b6:	50                   	push   %eax
  8013b7:	53                   	push   %ebx
  8013b8:	51                   	push   %ecx
  8013b9:	e8 0f 2b 00 00       	call   803ecd <sys_cputs>
  8013be:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8013ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cd:	8b 40 04             	mov    0x4(%eax),%eax
  8013d0:	8d 50 01             	lea    0x1(%eax),%edx
  8013d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8013d9:	90                   	nop
  8013da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013dd:	c9                   	leave  
  8013de:	c3                   	ret    

008013df <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
  8013e2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8013e8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8013ef:	00 00 00 
	b.cnt = 0;
  8013f2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8013f9:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8013fc:	ff 75 0c             	pushl  0xc(%ebp)
  8013ff:	ff 75 08             	pushl  0x8(%ebp)
  801402:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801408:	50                   	push   %eax
  801409:	68 6e 13 80 00       	push   $0x80136e
  80140e:	e8 5a 02 00 00       	call   80166d <vprintfmt>
  801413:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName, curTextClr);
  801416:	8b 15 1c f1 81 00    	mov    0x81f11c,%edx
  80141c:	a0 44 70 80 00       	mov    0x807044,%al
  801421:	0f b6 c0             	movzbl %al,%eax
  801424:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  80142a:	52                   	push   %edx
  80142b:	50                   	push   %eax
  80142c:	51                   	push   %ecx
  80142d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801433:	83 c0 08             	add    $0x8,%eax
  801436:	50                   	push   %eax
  801437:	e8 91 2a 00 00       	call   803ecd <sys_cputs>
  80143c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80143f:	c6 05 44 70 80 00 00 	movb   $0x0,0x807044
	return b.cnt;
  801446:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    

0080144e <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801454:	c6 05 44 70 80 00 01 	movb   $0x1,0x807044
	va_start(ap, fmt);
  80145b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80145e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	83 ec 08             	sub    $0x8,%esp
  801467:	ff 75 f4             	pushl  -0xc(%ebp)
  80146a:	50                   	push   %eax
  80146b:	e8 6f ff ff ff       	call   8013df <vcprintf>
  801470:	83 c4 10             	add    $0x10,%esp
  801473:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801476:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <cprintf_colored>:

// *************** This text coloring feature is implemented by *************
// ********** Abd-Alrahman Zedan From Team Frozen-Bytes - FCIS'24-25 ********
int cprintf_colored(int textClr, const char *fmt, ...) {
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801481:	c6 05 44 70 80 00 01 	movb   $0x1,0x807044
	curTextClr = (textClr << 8) ; //set text color by the given value
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	c1 e0 08             	shl    $0x8,%eax
  80148e:	a3 1c f1 81 00       	mov    %eax,0x81f11c
	va_start(ap, fmt);
  801493:	8d 45 0c             	lea    0xc(%ebp),%eax
  801496:	83 c0 04             	add    $0x4,%eax
  801499:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80149c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80149f:	83 ec 08             	sub    $0x8,%esp
  8014a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a5:	50                   	push   %eax
  8014a6:	e8 34 ff ff ff       	call   8013df <vcprintf>
  8014ab:	83 c4 10             	add    $0x10,%esp
  8014ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);
	curTextClr = TEXT_DEFAULT_CLR; //restore default color
  8014b1:	c7 05 1c f1 81 00 00 	movl   $0x700,0x81f11c
  8014b8:	07 00 00 

	return cnt;
  8014bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8014c6:	e8 46 2a 00 00       	call   803f11 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8014cb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8014ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8014da:	50                   	push   %eax
  8014db:	e8 ff fe ff ff       	call   8013df <vcprintf>
  8014e0:	83 c4 10             	add    $0x10,%esp
  8014e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8014e6:	e8 40 2a 00 00       	call   803f2b <sys_unlock_cons>
	return cnt;
  8014eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	53                   	push   %ebx
  8014f4:	83 ec 14             	sub    $0x14,%esp
  8014f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801500:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801503:	8b 45 18             	mov    0x18(%ebp),%eax
  801506:	ba 00 00 00 00       	mov    $0x0,%edx
  80150b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80150e:	77 55                	ja     801565 <printnum+0x75>
  801510:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801513:	72 05                	jb     80151a <printnum+0x2a>
  801515:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801518:	77 4b                	ja     801565 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80151a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80151d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801520:	8b 45 18             	mov    0x18(%ebp),%eax
  801523:	ba 00 00 00 00       	mov    $0x0,%edx
  801528:	52                   	push   %edx
  801529:	50                   	push   %eax
  80152a:	ff 75 f4             	pushl  -0xc(%ebp)
  80152d:	ff 75 f0             	pushl  -0x10(%ebp)
  801530:	e8 bb 3b 00 00       	call   8050f0 <__udivdi3>
  801535:	83 c4 10             	add    $0x10,%esp
  801538:	83 ec 04             	sub    $0x4,%esp
  80153b:	ff 75 20             	pushl  0x20(%ebp)
  80153e:	53                   	push   %ebx
  80153f:	ff 75 18             	pushl  0x18(%ebp)
  801542:	52                   	push   %edx
  801543:	50                   	push   %eax
  801544:	ff 75 0c             	pushl  0xc(%ebp)
  801547:	ff 75 08             	pushl  0x8(%ebp)
  80154a:	e8 a1 ff ff ff       	call   8014f0 <printnum>
  80154f:	83 c4 20             	add    $0x20,%esp
  801552:	eb 1a                	jmp    80156e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801554:	83 ec 08             	sub    $0x8,%esp
  801557:	ff 75 0c             	pushl  0xc(%ebp)
  80155a:	ff 75 20             	pushl  0x20(%ebp)
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	ff d0                	call   *%eax
  801562:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801565:	ff 4d 1c             	decl   0x1c(%ebp)
  801568:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80156c:	7f e6                	jg     801554 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80156e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801571:	bb 00 00 00 00       	mov    $0x0,%ebx
  801576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801579:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157c:	53                   	push   %ebx
  80157d:	51                   	push   %ecx
  80157e:	52                   	push   %edx
  80157f:	50                   	push   %eax
  801580:	e8 7b 3c 00 00       	call   805200 <__umoddi3>
  801585:	83 c4 10             	add    $0x10,%esp
  801588:	05 f4 5e 80 00       	add    $0x805ef4,%eax
  80158d:	8a 00                	mov    (%eax),%al
  80158f:	0f be c0             	movsbl %al,%eax
  801592:	83 ec 08             	sub    $0x8,%esp
  801595:	ff 75 0c             	pushl  0xc(%ebp)
  801598:	50                   	push   %eax
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	ff d0                	call   *%eax
  80159e:	83 c4 10             	add    $0x10,%esp
}
  8015a1:	90                   	nop
  8015a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8015aa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8015ae:	7e 1c                	jle    8015cc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8b 00                	mov    (%eax),%eax
  8015b5:	8d 50 08             	lea    0x8(%eax),%edx
  8015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bb:	89 10                	mov    %edx,(%eax)
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	8b 00                	mov    (%eax),%eax
  8015c2:	83 e8 08             	sub    $0x8,%eax
  8015c5:	8b 50 04             	mov    0x4(%eax),%edx
  8015c8:	8b 00                	mov    (%eax),%eax
  8015ca:	eb 40                	jmp    80160c <getuint+0x65>
	else if (lflag)
  8015cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015d0:	74 1e                	je     8015f0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	8b 00                	mov    (%eax),%eax
  8015d7:	8d 50 04             	lea    0x4(%eax),%edx
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	89 10                	mov    %edx,(%eax)
  8015df:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e2:	8b 00                	mov    (%eax),%eax
  8015e4:	83 e8 04             	sub    $0x4,%eax
  8015e7:	8b 00                	mov    (%eax),%eax
  8015e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ee:	eb 1c                	jmp    80160c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	8b 00                	mov    (%eax),%eax
  8015f5:	8d 50 04             	lea    0x4(%eax),%edx
  8015f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fb:	89 10                	mov    %edx,(%eax)
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	8b 00                	mov    (%eax),%eax
  801602:	83 e8 04             	sub    $0x4,%eax
  801605:	8b 00                	mov    (%eax),%eax
  801607:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80160c:	5d                   	pop    %ebp
  80160d:	c3                   	ret    

0080160e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801611:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801615:	7e 1c                	jle    801633 <getint+0x25>
		return va_arg(*ap, long long);
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	8b 00                	mov    (%eax),%eax
  80161c:	8d 50 08             	lea    0x8(%eax),%edx
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	89 10                	mov    %edx,(%eax)
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	8b 00                	mov    (%eax),%eax
  801629:	83 e8 08             	sub    $0x8,%eax
  80162c:	8b 50 04             	mov    0x4(%eax),%edx
  80162f:	8b 00                	mov    (%eax),%eax
  801631:	eb 38                	jmp    80166b <getint+0x5d>
	else if (lflag)
  801633:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801637:	74 1a                	je     801653 <getint+0x45>
		return va_arg(*ap, long);
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	8b 00                	mov    (%eax),%eax
  80163e:	8d 50 04             	lea    0x4(%eax),%edx
  801641:	8b 45 08             	mov    0x8(%ebp),%eax
  801644:	89 10                	mov    %edx,(%eax)
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8b 00                	mov    (%eax),%eax
  80164b:	83 e8 04             	sub    $0x4,%eax
  80164e:	8b 00                	mov    (%eax),%eax
  801650:	99                   	cltd   
  801651:	eb 18                	jmp    80166b <getint+0x5d>
	else
		return va_arg(*ap, int);
  801653:	8b 45 08             	mov    0x8(%ebp),%eax
  801656:	8b 00                	mov    (%eax),%eax
  801658:	8d 50 04             	lea    0x4(%eax),%edx
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	89 10                	mov    %edx,(%eax)
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	8b 00                	mov    (%eax),%eax
  801665:	83 e8 04             	sub    $0x4,%eax
  801668:	8b 00                	mov    (%eax),%eax
  80166a:	99                   	cltd   
}
  80166b:	5d                   	pop    %ebp
  80166c:	c3                   	ret    

0080166d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	56                   	push   %esi
  801671:	53                   	push   %ebx
  801672:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801675:	eb 17                	jmp    80168e <vprintfmt+0x21>
			if (ch == '\0')
  801677:	85 db                	test   %ebx,%ebx
  801679:	0f 84 c1 03 00 00    	je     801a40 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80167f:	83 ec 08             	sub    $0x8,%esp
  801682:	ff 75 0c             	pushl  0xc(%ebp)
  801685:	53                   	push   %ebx
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	ff d0                	call   *%eax
  80168b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80168e:	8b 45 10             	mov    0x10(%ebp),%eax
  801691:	8d 50 01             	lea    0x1(%eax),%edx
  801694:	89 55 10             	mov    %edx,0x10(%ebp)
  801697:	8a 00                	mov    (%eax),%al
  801699:	0f b6 d8             	movzbl %al,%ebx
  80169c:	83 fb 25             	cmp    $0x25,%ebx
  80169f:	75 d6                	jne    801677 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8016a1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8016a5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8016ac:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8016b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8016ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8016c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c4:	8d 50 01             	lea    0x1(%eax),%edx
  8016c7:	89 55 10             	mov    %edx,0x10(%ebp)
  8016ca:	8a 00                	mov    (%eax),%al
  8016cc:	0f b6 d8             	movzbl %al,%ebx
  8016cf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8016d2:	83 f8 5b             	cmp    $0x5b,%eax
  8016d5:	0f 87 3d 03 00 00    	ja     801a18 <vprintfmt+0x3ab>
  8016db:	8b 04 85 18 5f 80 00 	mov    0x805f18(,%eax,4),%eax
  8016e2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8016e4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8016e8:	eb d7                	jmp    8016c1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8016ea:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8016ee:	eb d1                	jmp    8016c1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8016f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8016f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016fa:	89 d0                	mov    %edx,%eax
  8016fc:	c1 e0 02             	shl    $0x2,%eax
  8016ff:	01 d0                	add    %edx,%eax
  801701:	01 c0                	add    %eax,%eax
  801703:	01 d8                	add    %ebx,%eax
  801705:	83 e8 30             	sub    $0x30,%eax
  801708:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80170b:	8b 45 10             	mov    0x10(%ebp),%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801713:	83 fb 2f             	cmp    $0x2f,%ebx
  801716:	7e 3e                	jle    801756 <vprintfmt+0xe9>
  801718:	83 fb 39             	cmp    $0x39,%ebx
  80171b:	7f 39                	jg     801756 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80171d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801720:	eb d5                	jmp    8016f7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801722:	8b 45 14             	mov    0x14(%ebp),%eax
  801725:	83 c0 04             	add    $0x4,%eax
  801728:	89 45 14             	mov    %eax,0x14(%ebp)
  80172b:	8b 45 14             	mov    0x14(%ebp),%eax
  80172e:	83 e8 04             	sub    $0x4,%eax
  801731:	8b 00                	mov    (%eax),%eax
  801733:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801736:	eb 1f                	jmp    801757 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801738:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80173c:	79 83                	jns    8016c1 <vprintfmt+0x54>
				width = 0;
  80173e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801745:	e9 77 ff ff ff       	jmp    8016c1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80174a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801751:	e9 6b ff ff ff       	jmp    8016c1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801756:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801757:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80175b:	0f 89 60 ff ff ff    	jns    8016c1 <vprintfmt+0x54>
				width = precision, precision = -1;
  801761:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801764:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801767:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80176e:	e9 4e ff ff ff       	jmp    8016c1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801773:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801776:	e9 46 ff ff ff       	jmp    8016c1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80177b:	8b 45 14             	mov    0x14(%ebp),%eax
  80177e:	83 c0 04             	add    $0x4,%eax
  801781:	89 45 14             	mov    %eax,0x14(%ebp)
  801784:	8b 45 14             	mov    0x14(%ebp),%eax
  801787:	83 e8 04             	sub    $0x4,%eax
  80178a:	8b 00                	mov    (%eax),%eax
  80178c:	83 ec 08             	sub    $0x8,%esp
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	50                   	push   %eax
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	ff d0                	call   *%eax
  801798:	83 c4 10             	add    $0x10,%esp
			break;
  80179b:	e9 9b 02 00 00       	jmp    801a3b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8017a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a3:	83 c0 04             	add    $0x4,%eax
  8017a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8017a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ac:	83 e8 04             	sub    $0x4,%eax
  8017af:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8017b1:	85 db                	test   %ebx,%ebx
  8017b3:	79 02                	jns    8017b7 <vprintfmt+0x14a>
				err = -err;
  8017b5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8017b7:	83 fb 64             	cmp    $0x64,%ebx
  8017ba:	7f 0b                	jg     8017c7 <vprintfmt+0x15a>
  8017bc:	8b 34 9d 60 5d 80 00 	mov    0x805d60(,%ebx,4),%esi
  8017c3:	85 f6                	test   %esi,%esi
  8017c5:	75 19                	jne    8017e0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8017c7:	53                   	push   %ebx
  8017c8:	68 05 5f 80 00       	push   $0x805f05
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	ff 75 08             	pushl  0x8(%ebp)
  8017d3:	e8 70 02 00 00       	call   801a48 <printfmt>
  8017d8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8017db:	e9 5b 02 00 00       	jmp    801a3b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8017e0:	56                   	push   %esi
  8017e1:	68 0e 5f 80 00       	push   $0x805f0e
  8017e6:	ff 75 0c             	pushl  0xc(%ebp)
  8017e9:	ff 75 08             	pushl  0x8(%ebp)
  8017ec:	e8 57 02 00 00       	call   801a48 <printfmt>
  8017f1:	83 c4 10             	add    $0x10,%esp
			break;
  8017f4:	e9 42 02 00 00       	jmp    801a3b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8017f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fc:	83 c0 04             	add    $0x4,%eax
  8017ff:	89 45 14             	mov    %eax,0x14(%ebp)
  801802:	8b 45 14             	mov    0x14(%ebp),%eax
  801805:	83 e8 04             	sub    $0x4,%eax
  801808:	8b 30                	mov    (%eax),%esi
  80180a:	85 f6                	test   %esi,%esi
  80180c:	75 05                	jne    801813 <vprintfmt+0x1a6>
				p = "(null)";
  80180e:	be 11 5f 80 00       	mov    $0x805f11,%esi
			if (width > 0 && padc != '-')
  801813:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801817:	7e 6d                	jle    801886 <vprintfmt+0x219>
  801819:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80181d:	74 67                	je     801886 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80181f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801822:	83 ec 08             	sub    $0x8,%esp
  801825:	50                   	push   %eax
  801826:	56                   	push   %esi
  801827:	e8 26 05 00 00       	call   801d52 <strnlen>
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801832:	eb 16                	jmp    80184a <vprintfmt+0x1dd>
					putch(padc, putdat);
  801834:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801838:	83 ec 08             	sub    $0x8,%esp
  80183b:	ff 75 0c             	pushl  0xc(%ebp)
  80183e:	50                   	push   %eax
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	ff d0                	call   *%eax
  801844:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801847:	ff 4d e4             	decl   -0x1c(%ebp)
  80184a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80184e:	7f e4                	jg     801834 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801850:	eb 34                	jmp    801886 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801852:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801856:	74 1c                	je     801874 <vprintfmt+0x207>
  801858:	83 fb 1f             	cmp    $0x1f,%ebx
  80185b:	7e 05                	jle    801862 <vprintfmt+0x1f5>
  80185d:	83 fb 7e             	cmp    $0x7e,%ebx
  801860:	7e 12                	jle    801874 <vprintfmt+0x207>
					putch('?', putdat);
  801862:	83 ec 08             	sub    $0x8,%esp
  801865:	ff 75 0c             	pushl  0xc(%ebp)
  801868:	6a 3f                	push   $0x3f
  80186a:	8b 45 08             	mov    0x8(%ebp),%eax
  80186d:	ff d0                	call   *%eax
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	eb 0f                	jmp    801883 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801874:	83 ec 08             	sub    $0x8,%esp
  801877:	ff 75 0c             	pushl  0xc(%ebp)
  80187a:	53                   	push   %ebx
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	ff d0                	call   *%eax
  801880:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801883:	ff 4d e4             	decl   -0x1c(%ebp)
  801886:	89 f0                	mov    %esi,%eax
  801888:	8d 70 01             	lea    0x1(%eax),%esi
  80188b:	8a 00                	mov    (%eax),%al
  80188d:	0f be d8             	movsbl %al,%ebx
  801890:	85 db                	test   %ebx,%ebx
  801892:	74 24                	je     8018b8 <vprintfmt+0x24b>
  801894:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801898:	78 b8                	js     801852 <vprintfmt+0x1e5>
  80189a:	ff 4d e0             	decl   -0x20(%ebp)
  80189d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018a1:	79 af                	jns    801852 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8018a3:	eb 13                	jmp    8018b8 <vprintfmt+0x24b>
				putch(' ', putdat);
  8018a5:	83 ec 08             	sub    $0x8,%esp
  8018a8:	ff 75 0c             	pushl  0xc(%ebp)
  8018ab:	6a 20                	push   $0x20
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	ff d0                	call   *%eax
  8018b2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8018b5:	ff 4d e4             	decl   -0x1c(%ebp)
  8018b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018bc:	7f e7                	jg     8018a5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8018be:	e9 78 01 00 00       	jmp    801a3b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8018c3:	83 ec 08             	sub    $0x8,%esp
  8018c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8018c9:	8d 45 14             	lea    0x14(%ebp),%eax
  8018cc:	50                   	push   %eax
  8018cd:	e8 3c fd ff ff       	call   80160e <getint>
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8018db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e1:	85 d2                	test   %edx,%edx
  8018e3:	79 23                	jns    801908 <vprintfmt+0x29b>
				putch('-', putdat);
  8018e5:	83 ec 08             	sub    $0x8,%esp
  8018e8:	ff 75 0c             	pushl  0xc(%ebp)
  8018eb:	6a 2d                	push   $0x2d
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	ff d0                	call   *%eax
  8018f2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8018f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018fb:	f7 d8                	neg    %eax
  8018fd:	83 d2 00             	adc    $0x0,%edx
  801900:	f7 da                	neg    %edx
  801902:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801905:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801908:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80190f:	e9 bc 00 00 00       	jmp    8019d0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801914:	83 ec 08             	sub    $0x8,%esp
  801917:	ff 75 e8             	pushl  -0x18(%ebp)
  80191a:	8d 45 14             	lea    0x14(%ebp),%eax
  80191d:	50                   	push   %eax
  80191e:	e8 84 fc ff ff       	call   8015a7 <getuint>
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801929:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80192c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801933:	e9 98 00 00 00       	jmp    8019d0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801938:	83 ec 08             	sub    $0x8,%esp
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	6a 58                	push   $0x58
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	ff d0                	call   *%eax
  801945:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801948:	83 ec 08             	sub    $0x8,%esp
  80194b:	ff 75 0c             	pushl  0xc(%ebp)
  80194e:	6a 58                	push   $0x58
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	ff d0                	call   *%eax
  801955:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801958:	83 ec 08             	sub    $0x8,%esp
  80195b:	ff 75 0c             	pushl  0xc(%ebp)
  80195e:	6a 58                	push   $0x58
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	ff d0                	call   *%eax
  801965:	83 c4 10             	add    $0x10,%esp
			break;
  801968:	e9 ce 00 00 00       	jmp    801a3b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80196d:	83 ec 08             	sub    $0x8,%esp
  801970:	ff 75 0c             	pushl  0xc(%ebp)
  801973:	6a 30                	push   $0x30
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	ff d0                	call   *%eax
  80197a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80197d:	83 ec 08             	sub    $0x8,%esp
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	6a 78                	push   $0x78
  801985:	8b 45 08             	mov    0x8(%ebp),%eax
  801988:	ff d0                	call   *%eax
  80198a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80198d:	8b 45 14             	mov    0x14(%ebp),%eax
  801990:	83 c0 04             	add    $0x4,%eax
  801993:	89 45 14             	mov    %eax,0x14(%ebp)
  801996:	8b 45 14             	mov    0x14(%ebp),%eax
  801999:	83 e8 04             	sub    $0x4,%eax
  80199c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80199e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8019a8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8019af:	eb 1f                	jmp    8019d0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8019b1:	83 ec 08             	sub    $0x8,%esp
  8019b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8019b7:	8d 45 14             	lea    0x14(%ebp),%eax
  8019ba:	50                   	push   %eax
  8019bb:	e8 e7 fb ff ff       	call   8015a7 <getuint>
  8019c0:	83 c4 10             	add    $0x10,%esp
  8019c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8019c9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8019d0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8019d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	52                   	push   %edx
  8019db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019de:	50                   	push   %eax
  8019df:	ff 75 f4             	pushl  -0xc(%ebp)
  8019e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8019e5:	ff 75 0c             	pushl  0xc(%ebp)
  8019e8:	ff 75 08             	pushl  0x8(%ebp)
  8019eb:	e8 00 fb ff ff       	call   8014f0 <printnum>
  8019f0:	83 c4 20             	add    $0x20,%esp
			break;
  8019f3:	eb 46                	jmp    801a3b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8019f5:	83 ec 08             	sub    $0x8,%esp
  8019f8:	ff 75 0c             	pushl  0xc(%ebp)
  8019fb:	53                   	push   %ebx
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	ff d0                	call   *%eax
  801a01:	83 c4 10             	add    $0x10,%esp
			break;
  801a04:	eb 35                	jmp    801a3b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801a06:	c6 05 44 70 80 00 00 	movb   $0x0,0x807044
			break;
  801a0d:	eb 2c                	jmp    801a3b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801a0f:	c6 05 44 70 80 00 01 	movb   $0x1,0x807044
			break;
  801a16:	eb 23                	jmp    801a3b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801a18:	83 ec 08             	sub    $0x8,%esp
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	6a 25                	push   $0x25
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	ff d0                	call   *%eax
  801a25:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801a28:	ff 4d 10             	decl   0x10(%ebp)
  801a2b:	eb 03                	jmp    801a30 <vprintfmt+0x3c3>
  801a2d:	ff 4d 10             	decl   0x10(%ebp)
  801a30:	8b 45 10             	mov    0x10(%ebp),%eax
  801a33:	48                   	dec    %eax
  801a34:	8a 00                	mov    (%eax),%al
  801a36:	3c 25                	cmp    $0x25,%al
  801a38:	75 f3                	jne    801a2d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801a3a:	90                   	nop
		}
	}
  801a3b:	e9 35 fc ff ff       	jmp    801675 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801a40:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801a41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a44:	5b                   	pop    %ebx
  801a45:	5e                   	pop    %esi
  801a46:	5d                   	pop    %ebp
  801a47:	c3                   	ret    

00801a48 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801a4e:	8d 45 10             	lea    0x10(%ebp),%eax
  801a51:	83 c0 04             	add    $0x4,%eax
  801a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801a57:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a5d:	50                   	push   %eax
  801a5e:	ff 75 0c             	pushl  0xc(%ebp)
  801a61:	ff 75 08             	pushl  0x8(%ebp)
  801a64:	e8 04 fc ff ff       	call   80166d <vprintfmt>
  801a69:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801a6c:	90                   	nop
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801a72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a75:	8b 40 08             	mov    0x8(%eax),%eax
  801a78:	8d 50 01             	lea    0x1(%eax),%edx
  801a7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a84:	8b 10                	mov    (%eax),%edx
  801a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a89:	8b 40 04             	mov    0x4(%eax),%eax
  801a8c:	39 c2                	cmp    %eax,%edx
  801a8e:	73 12                	jae    801aa2 <sprintputch+0x33>
		*b->buf++ = ch;
  801a90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a93:	8b 00                	mov    (%eax),%eax
  801a95:	8d 48 01             	lea    0x1(%eax),%ecx
  801a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9b:	89 0a                	mov    %ecx,(%edx)
  801a9d:	8b 55 08             	mov    0x8(%ebp),%edx
  801aa0:	88 10                	mov    %dl,(%eax)
}
  801aa2:	90                   	nop
  801aa3:	5d                   	pop    %ebp
  801aa4:	c3                   	ret    

00801aa5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab4:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	01 d0                	add    %edx,%eax
  801abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801abf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801ac6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801aca:	74 06                	je     801ad2 <vsnprintf+0x2d>
  801acc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ad0:	7f 07                	jg     801ad9 <vsnprintf+0x34>
		return -E_INVAL;
  801ad2:	b8 03 00 00 00       	mov    $0x3,%eax
  801ad7:	eb 20                	jmp    801af9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ad9:	ff 75 14             	pushl  0x14(%ebp)
  801adc:	ff 75 10             	pushl  0x10(%ebp)
  801adf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ae2:	50                   	push   %eax
  801ae3:	68 6f 1a 80 00       	push   $0x801a6f
  801ae8:	e8 80 fb ff ff       	call   80166d <vprintfmt>
  801aed:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b01:	8d 45 10             	lea    0x10(%ebp),%eax
  801b04:	83 c0 04             	add    $0x4,%eax
  801b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801b0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b10:	50                   	push   %eax
  801b11:	ff 75 0c             	pushl  0xc(%ebp)
  801b14:	ff 75 08             	pushl  0x8(%ebp)
  801b17:	e8 89 ff ff ff       	call   801aa5 <vsnprintf>
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  801b2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b31:	74 13                	je     801b46 <readline+0x1f>
		cprintf("%s", prompt);
  801b33:	83 ec 08             	sub    $0x8,%esp
  801b36:	ff 75 08             	pushl  0x8(%ebp)
  801b39:	68 88 60 80 00       	push   $0x806088
  801b3e:	e8 0b f9 ff ff       	call   80144e <cprintf>
  801b43:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801b46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801b4d:	83 ec 0c             	sub    $0xc,%esp
  801b50:	6a 00                	push   $0x0
  801b52:	e8 66 f4 ff ff       	call   800fbd <iscons>
  801b57:	83 c4 10             	add    $0x10,%esp
  801b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801b5d:	e8 48 f4 ff ff       	call   800faa <getchar>
  801b62:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801b65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b69:	79 22                	jns    801b8d <readline+0x66>
			if (c != -E_EOF)
  801b6b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801b6f:	0f 84 ad 00 00 00    	je     801c22 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801b75:	83 ec 08             	sub    $0x8,%esp
  801b78:	ff 75 ec             	pushl  -0x14(%ebp)
  801b7b:	68 8b 60 80 00       	push   $0x80608b
  801b80:	e8 c9 f8 ff ff       	call   80144e <cprintf>
  801b85:	83 c4 10             	add    $0x10,%esp
			break;
  801b88:	e9 95 00 00 00       	jmp    801c22 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801b8d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801b91:	7e 34                	jle    801bc7 <readline+0xa0>
  801b93:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801b9a:	7f 2b                	jg     801bc7 <readline+0xa0>
			if (echoing)
  801b9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ba0:	74 0e                	je     801bb0 <readline+0x89>
				cputchar(c);
  801ba2:	83 ec 0c             	sub    $0xc,%esp
  801ba5:	ff 75 ec             	pushl  -0x14(%ebp)
  801ba8:	e8 de f3 ff ff       	call   800f8b <cputchar>
  801bad:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb3:	8d 50 01             	lea    0x1(%eax),%edx
  801bb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801bb9:	89 c2                	mov    %eax,%edx
  801bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbe:	01 d0                	add    %edx,%eax
  801bc0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801bc3:	88 10                	mov    %dl,(%eax)
  801bc5:	eb 56                	jmp    801c1d <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801bc7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801bcb:	75 1f                	jne    801bec <readline+0xc5>
  801bcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bd1:	7e 19                	jle    801bec <readline+0xc5>
			if (echoing)
  801bd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bd7:	74 0e                	je     801be7 <readline+0xc0>
				cputchar(c);
  801bd9:	83 ec 0c             	sub    $0xc,%esp
  801bdc:	ff 75 ec             	pushl  -0x14(%ebp)
  801bdf:	e8 a7 f3 ff ff       	call   800f8b <cputchar>
  801be4:	83 c4 10             	add    $0x10,%esp

			i--;
  801be7:	ff 4d f4             	decl   -0xc(%ebp)
  801bea:	eb 31                	jmp    801c1d <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801bec:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801bf0:	74 0a                	je     801bfc <readline+0xd5>
  801bf2:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801bf6:	0f 85 61 ff ff ff    	jne    801b5d <readline+0x36>
			if (echoing)
  801bfc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c00:	74 0e                	je     801c10 <readline+0xe9>
				cputchar(c);
  801c02:	83 ec 0c             	sub    $0xc,%esp
  801c05:	ff 75 ec             	pushl  -0x14(%ebp)
  801c08:	e8 7e f3 ff ff       	call   800f8b <cputchar>
  801c0d:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801c10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c16:	01 d0                	add    %edx,%eax
  801c18:	c6 00 00             	movb   $0x0,(%eax)
			break;
  801c1b:	eb 06                	jmp    801c23 <readline+0xfc>
		}
	}
  801c1d:	e9 3b ff ff ff       	jmp    801b5d <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  801c22:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  801c23:	90                   	nop
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  801c2c:	e8 e0 22 00 00       	call   803f11 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  801c31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c35:	74 13                	je     801c4a <atomic_readline+0x24>
			cprintf("%s", prompt);
  801c37:	83 ec 08             	sub    $0x8,%esp
  801c3a:	ff 75 08             	pushl  0x8(%ebp)
  801c3d:	68 88 60 80 00       	push   $0x806088
  801c42:	e8 07 f8 ff ff       	call   80144e <cprintf>
  801c47:	83 c4 10             	add    $0x10,%esp

		i = 0;
  801c4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  801c51:	83 ec 0c             	sub    $0xc,%esp
  801c54:	6a 00                	push   $0x0
  801c56:	e8 62 f3 ff ff       	call   800fbd <iscons>
  801c5b:	83 c4 10             	add    $0x10,%esp
  801c5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  801c61:	e8 44 f3 ff ff       	call   800faa <getchar>
  801c66:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  801c69:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c6d:	79 22                	jns    801c91 <atomic_readline+0x6b>
				if (c != -E_EOF)
  801c6f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801c73:	0f 84 ad 00 00 00    	je     801d26 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  801c79:	83 ec 08             	sub    $0x8,%esp
  801c7c:	ff 75 ec             	pushl  -0x14(%ebp)
  801c7f:	68 8b 60 80 00       	push   $0x80608b
  801c84:	e8 c5 f7 ff ff       	call   80144e <cprintf>
  801c89:	83 c4 10             	add    $0x10,%esp
				break;
  801c8c:	e9 95 00 00 00       	jmp    801d26 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  801c91:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801c95:	7e 34                	jle    801ccb <atomic_readline+0xa5>
  801c97:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801c9e:	7f 2b                	jg     801ccb <atomic_readline+0xa5>
				if (echoing)
  801ca0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ca4:	74 0e                	je     801cb4 <atomic_readline+0x8e>
					cputchar(c);
  801ca6:	83 ec 0c             	sub    $0xc,%esp
  801ca9:	ff 75 ec             	pushl  -0x14(%ebp)
  801cac:	e8 da f2 ff ff       	call   800f8b <cputchar>
  801cb1:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  801cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb7:	8d 50 01             	lea    0x1(%eax),%edx
  801cba:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801cbd:	89 c2                	mov    %eax,%edx
  801cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc2:	01 d0                	add    %edx,%eax
  801cc4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cc7:	88 10                	mov    %dl,(%eax)
  801cc9:	eb 56                	jmp    801d21 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  801ccb:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801ccf:	75 1f                	jne    801cf0 <atomic_readline+0xca>
  801cd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cd5:	7e 19                	jle    801cf0 <atomic_readline+0xca>
				if (echoing)
  801cd7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cdb:	74 0e                	je     801ceb <atomic_readline+0xc5>
					cputchar(c);
  801cdd:	83 ec 0c             	sub    $0xc,%esp
  801ce0:	ff 75 ec             	pushl  -0x14(%ebp)
  801ce3:	e8 a3 f2 ff ff       	call   800f8b <cputchar>
  801ce8:	83 c4 10             	add    $0x10,%esp
				i--;
  801ceb:	ff 4d f4             	decl   -0xc(%ebp)
  801cee:	eb 31                	jmp    801d21 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  801cf0:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801cf4:	74 0a                	je     801d00 <atomic_readline+0xda>
  801cf6:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801cfa:	0f 85 61 ff ff ff    	jne    801c61 <atomic_readline+0x3b>
				if (echoing)
  801d00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d04:	74 0e                	je     801d14 <atomic_readline+0xee>
					cputchar(c);
  801d06:	83 ec 0c             	sub    $0xc,%esp
  801d09:	ff 75 ec             	pushl  -0x14(%ebp)
  801d0c:	e8 7a f2 ff ff       	call   800f8b <cputchar>
  801d11:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  801d14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1a:	01 d0                	add    %edx,%eax
  801d1c:	c6 00 00             	movb   $0x0,(%eax)
				break;
  801d1f:	eb 06                	jmp    801d27 <atomic_readline+0x101>
			}
		}
  801d21:	e9 3b ff ff ff       	jmp    801c61 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  801d26:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  801d27:	e8 ff 21 00 00       	call   803f2b <sys_unlock_cons>
}
  801d2c:	90                   	nop
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d3c:	eb 06                	jmp    801d44 <strlen+0x15>
		n++;
  801d3e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d41:	ff 45 08             	incl   0x8(%ebp)
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	8a 00                	mov    (%eax),%al
  801d49:	84 c0                	test   %al,%al
  801d4b:	75 f1                	jne    801d3e <strlen+0xf>
		n++;
	return n;
  801d4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d5f:	eb 09                	jmp    801d6a <strnlen+0x18>
		n++;
  801d61:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d64:	ff 45 08             	incl   0x8(%ebp)
  801d67:	ff 4d 0c             	decl   0xc(%ebp)
  801d6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d6e:	74 09                	je     801d79 <strnlen+0x27>
  801d70:	8b 45 08             	mov    0x8(%ebp),%eax
  801d73:	8a 00                	mov    (%eax),%al
  801d75:	84 c0                	test   %al,%al
  801d77:	75 e8                	jne    801d61 <strnlen+0xf>
		n++;
	return n;
  801d79:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801d8a:	90                   	nop
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	8d 50 01             	lea    0x1(%eax),%edx
  801d91:	89 55 08             	mov    %edx,0x8(%ebp)
  801d94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d97:	8d 4a 01             	lea    0x1(%edx),%ecx
  801d9a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801d9d:	8a 12                	mov    (%edx),%dl
  801d9f:	88 10                	mov    %dl,(%eax)
  801da1:	8a 00                	mov    (%eax),%al
  801da3:	84 c0                	test   %al,%al
  801da5:	75 e4                	jne    801d8b <strcpy+0xd>
		/* do nothing */;
	return ret;
  801da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801db8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801dbf:	eb 1f                	jmp    801de0 <strncpy+0x34>
		*dst++ = *src;
  801dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc4:	8d 50 01             	lea    0x1(%eax),%edx
  801dc7:	89 55 08             	mov    %edx,0x8(%ebp)
  801dca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcd:	8a 12                	mov    (%edx),%dl
  801dcf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd4:	8a 00                	mov    (%eax),%al
  801dd6:	84 c0                	test   %al,%al
  801dd8:	74 03                	je     801ddd <strncpy+0x31>
			src++;
  801dda:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801ddd:	ff 45 fc             	incl   -0x4(%ebp)
  801de0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de3:	3b 45 10             	cmp    0x10(%ebp),%eax
  801de6:	72 d9                	jb     801dc1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801de8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801df3:	8b 45 08             	mov    0x8(%ebp),%eax
  801df6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801df9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dfd:	74 30                	je     801e2f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801dff:	eb 16                	jmp    801e17 <strlcpy+0x2a>
			*dst++ = *src++;
  801e01:	8b 45 08             	mov    0x8(%ebp),%eax
  801e04:	8d 50 01             	lea    0x1(%eax),%edx
  801e07:	89 55 08             	mov    %edx,0x8(%ebp)
  801e0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e10:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e13:	8a 12                	mov    (%edx),%dl
  801e15:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e17:	ff 4d 10             	decl   0x10(%ebp)
  801e1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e1e:	74 09                	je     801e29 <strlcpy+0x3c>
  801e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e23:	8a 00                	mov    (%eax),%al
  801e25:	84 c0                	test   %al,%al
  801e27:	75 d8                	jne    801e01 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  801e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e35:	29 c2                	sub    %eax,%edx
  801e37:	89 d0                	mov    %edx,%eax
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e3e:	eb 06                	jmp    801e46 <strcmp+0xb>
		p++, q++;
  801e40:	ff 45 08             	incl   0x8(%ebp)
  801e43:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	8a 00                	mov    (%eax),%al
  801e4b:	84 c0                	test   %al,%al
  801e4d:	74 0e                	je     801e5d <strcmp+0x22>
  801e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e52:	8a 10                	mov    (%eax),%dl
  801e54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e57:	8a 00                	mov    (%eax),%al
  801e59:	38 c2                	cmp    %al,%dl
  801e5b:	74 e3                	je     801e40 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	8a 00                	mov    (%eax),%al
  801e62:	0f b6 d0             	movzbl %al,%edx
  801e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e68:	8a 00                	mov    (%eax),%al
  801e6a:	0f b6 c0             	movzbl %al,%eax
  801e6d:	29 c2                	sub    %eax,%edx
  801e6f:	89 d0                	mov    %edx,%eax
}
  801e71:	5d                   	pop    %ebp
  801e72:	c3                   	ret    

00801e73 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801e76:	eb 09                	jmp    801e81 <strncmp+0xe>
		n--, p++, q++;
  801e78:	ff 4d 10             	decl   0x10(%ebp)
  801e7b:	ff 45 08             	incl   0x8(%ebp)
  801e7e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801e81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e85:	74 17                	je     801e9e <strncmp+0x2b>
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	8a 00                	mov    (%eax),%al
  801e8c:	84 c0                	test   %al,%al
  801e8e:	74 0e                	je     801e9e <strncmp+0x2b>
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	8a 10                	mov    (%eax),%dl
  801e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e98:	8a 00                	mov    (%eax),%al
  801e9a:	38 c2                	cmp    %al,%dl
  801e9c:	74 da                	je     801e78 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801e9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ea2:	75 07                	jne    801eab <strncmp+0x38>
		return 0;
  801ea4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea9:	eb 14                	jmp    801ebf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	8a 00                	mov    (%eax),%al
  801eb0:	0f b6 d0             	movzbl %al,%edx
  801eb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb6:	8a 00                	mov    (%eax),%al
  801eb8:	0f b6 c0             	movzbl %al,%eax
  801ebb:	29 c2                	sub    %eax,%edx
  801ebd:	89 d0                	mov    %edx,%eax
}
  801ebf:	5d                   	pop    %ebp
  801ec0:	c3                   	ret    

00801ec1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 04             	sub    $0x4,%esp
  801ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eca:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801ecd:	eb 12                	jmp    801ee1 <strchr+0x20>
		if (*s == c)
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	8a 00                	mov    (%eax),%al
  801ed4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801ed7:	75 05                	jne    801ede <strchr+0x1d>
			return (char *) s;
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	eb 11                	jmp    801eef <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801ede:	ff 45 08             	incl   0x8(%ebp)
  801ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee4:	8a 00                	mov    (%eax),%al
  801ee6:	84 c0                	test   %al,%al
  801ee8:	75 e5                	jne    801ecf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801eea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 04             	sub    $0x4,%esp
  801ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801efd:	eb 0d                	jmp    801f0c <strfind+0x1b>
		if (*s == c)
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	8a 00                	mov    (%eax),%al
  801f04:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f07:	74 0e                	je     801f17 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f09:	ff 45 08             	incl   0x8(%ebp)
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	8a 00                	mov    (%eax),%al
  801f11:	84 c0                	test   %al,%al
  801f13:	75 ea                	jne    801eff <strfind+0xe>
  801f15:	eb 01                	jmp    801f18 <strfind+0x27>
		if (*s == c)
			break;
  801f17:	90                   	nop
	return (char *) s;
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <memset>:

// *************** The faster implementation of memset & memcpy is implemented by *************
// ****************** Team80 (Yahia Khaled, Malek Ahmed et al) - FCIS'24-25 *******************
void *
memset(void *v, int c, uint32 n)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 10             	sub    $0x10,%esp
//	m = n;
//	while (--m >= 0)
//		*p++ = c;

	/*Faster Implementation*/
	uint64* p64 = (uint64*)v;
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if(n >= 8){
  801f29:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f2d:	76 63                	jbe    801f92 <memset+0x75>
		uint64 data_block = c;
  801f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f32:	99                   	cltd   
  801f33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f36:	89 55 f4             	mov    %edx,-0xc(%ebp)
		data_block |= data_block << 8;
  801f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3f:	0f a4 c2 08          	shld   $0x8,%eax,%edx
  801f43:	c1 e0 08             	shl    $0x8,%eax
  801f46:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f49:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 16;
  801f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f52:	0f a4 c2 10          	shld   $0x10,%eax,%edx
  801f56:	c1 e0 10             	shl    $0x10,%eax
  801f59:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f5c:	09 55 f4             	or     %edx,-0xc(%ebp)
		data_block |= data_block << 32;
  801f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f65:	89 c2                	mov    %eax,%edx
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6c:	09 45 f0             	or     %eax,-0x10(%ebp)
  801f6f:	09 55 f4             	or     %edx,-0xc(%ebp)

		while(n >= 8)
  801f72:	eb 18                	jmp    801f8c <memset+0x6f>
			*p64++ = data_block, n -= 8;
  801f74:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801f77:	8d 41 08             	lea    0x8(%ecx),%eax
  801f7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f83:	89 01                	mov    %eax,(%ecx)
  801f85:	89 51 04             	mov    %edx,0x4(%ecx)
  801f88:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
		uint64 data_block = c;
		data_block |= data_block << 8;
		data_block |= data_block << 16;
		data_block |= data_block << 32;

		while(n >= 8)
  801f8c:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801f90:	77 e2                	ja     801f74 <memset+0x57>
			*p64++ = data_block, n -= 8;
	}

	if(n){
  801f92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f96:	74 23                	je     801fbb <memset+0x9e>
		uint8* p8 = (uint8*)p64;
  801f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		while (n-- > 0)
  801f9e:	eb 0e                	jmp    801fae <memset+0x91>
			*p8++ = (uint8)c;
  801fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fa3:	8d 50 01             	lea    0x1(%eax),%edx
  801fa6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fac:	88 10                	mov    %dl,(%eax)
			*p64++ = data_block, n -= 8;
	}

	if(n){
		uint8* p8 = (uint8*)p64;
		while (n-- > 0)
  801fae:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb1:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fb4:	89 55 10             	mov    %edx,0x10(%ebp)
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	75 e5                	jne    801fa0 <memset+0x83>
			*p8++ = (uint8)c;
	}

	return v;
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 10             	sub    $0x10,%esp
	//	s = src;
	//	d = dst;
	//	while (n-- > 0)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
  801fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint64* d64 = (uint64*)dst;
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if(n >= 8){
  801fd2:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801fd6:	76 24                	jbe    801ffc <memcpy+0x3c>
		while(n >= 8){
  801fd8:	eb 1c                	jmp    801ff6 <memcpy+0x36>
			*d64 = *s64;
  801fda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fdd:	8b 50 04             	mov    0x4(%eax),%edx
  801fe0:	8b 00                	mov    (%eax),%eax
  801fe2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801fe5:	89 01                	mov    %eax,(%ecx)
  801fe7:	89 51 04             	mov    %edx,0x4(%ecx)
			n -= 8;
  801fea:	83 6d 10 08          	subl   $0x8,0x10(%ebp)
			++s64;
  801fee:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
			++d64;
  801ff2:	83 45 f8 08          	addl   $0x8,-0x8(%ebp)
	//		*d++ = *s++;
	/*Faster Implementation*/
	uint64* s64 = (uint64*)src;
	uint64* d64 = (uint64*)dst;
	if(n >= 8){
		while(n >= 8){
  801ff6:	83 7d 10 07          	cmpl   $0x7,0x10(%ebp)
  801ffa:	77 de                	ja     801fda <memcpy+0x1a>
			++s64;
			++d64;
		}
	}

	if(n){
  801ffc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802000:	74 31                	je     802033 <memcpy+0x73>
		uint8* s8 = (uint8*)s64;
  802002:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802005:	89 45 f4             	mov    %eax,-0xc(%ebp)
		uint8* d8 = (uint8*)d64;
  802008:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80200b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (n-- > 0)
  80200e:	eb 16                	jmp    802026 <memcpy+0x66>
			*d8++ = *s8++;
  802010:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802013:	8d 50 01             	lea    0x1(%eax),%edx
  802016:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802019:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80201f:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802022:	8a 12                	mov    (%edx),%dl
  802024:	88 10                	mov    %dl,(%eax)
	}

	if(n){
		uint8* s8 = (uint8*)s64;
		uint8* d8 = (uint8*)d64;
		while (n-- > 0)
  802026:	8b 45 10             	mov    0x10(%ebp),%eax
  802029:	8d 50 ff             	lea    -0x1(%eax),%edx
  80202c:	89 55 10             	mov    %edx,0x10(%ebp)
  80202f:	85 c0                	test   %eax,%eax
  802031:	75 dd                	jne    802010 <memcpy+0x50>
			*d8++ = *s8++;
	}
	return dst;
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80203e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802041:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80204a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802050:	73 50                	jae    8020a2 <memmove+0x6a>
  802052:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802055:	8b 45 10             	mov    0x10(%ebp),%eax
  802058:	01 d0                	add    %edx,%eax
  80205a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80205d:	76 43                	jbe    8020a2 <memmove+0x6a>
		s += n;
  80205f:	8b 45 10             	mov    0x10(%ebp),%eax
  802062:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  802065:	8b 45 10             	mov    0x10(%ebp),%eax
  802068:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80206b:	eb 10                	jmp    80207d <memmove+0x45>
			*--d = *--s;
  80206d:	ff 4d f8             	decl   -0x8(%ebp)
  802070:	ff 4d fc             	decl   -0x4(%ebp)
  802073:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802076:	8a 10                	mov    (%eax),%dl
  802078:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80207b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80207d:	8b 45 10             	mov    0x10(%ebp),%eax
  802080:	8d 50 ff             	lea    -0x1(%eax),%edx
  802083:	89 55 10             	mov    %edx,0x10(%ebp)
  802086:	85 c0                	test   %eax,%eax
  802088:	75 e3                	jne    80206d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80208a:	eb 23                	jmp    8020af <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80208c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80208f:	8d 50 01             	lea    0x1(%eax),%edx
  802092:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802095:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802098:	8d 4a 01             	lea    0x1(%edx),%ecx
  80209b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80209e:	8a 12                	mov    (%edx),%dl
  8020a0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8020a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	75 dd                	jne    80208c <memmove+0x54>
			*d++ = *s++;

	return dst;
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8020c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8020c6:	eb 2a                	jmp    8020f2 <memcmp+0x3e>
		if (*s1 != *s2)
  8020c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020cb:	8a 10                	mov    (%eax),%dl
  8020cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020d0:	8a 00                	mov    (%eax),%al
  8020d2:	38 c2                	cmp    %al,%dl
  8020d4:	74 16                	je     8020ec <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8020d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d9:	8a 00                	mov    (%eax),%al
  8020db:	0f b6 d0             	movzbl %al,%edx
  8020de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020e1:	8a 00                	mov    (%eax),%al
  8020e3:	0f b6 c0             	movzbl %al,%eax
  8020e6:	29 c2                	sub    %eax,%edx
  8020e8:	89 d0                	mov    %edx,%eax
  8020ea:	eb 18                	jmp    802104 <memcmp+0x50>
		s1++, s2++;
  8020ec:	ff 45 fc             	incl   -0x4(%ebp)
  8020ef:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8020f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020f8:	89 55 10             	mov    %edx,0x10(%ebp)
  8020fb:	85 c0                	test   %eax,%eax
  8020fd:	75 c9                	jne    8020c8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8020ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80210c:	8b 55 08             	mov    0x8(%ebp),%edx
  80210f:	8b 45 10             	mov    0x10(%ebp),%eax
  802112:	01 d0                	add    %edx,%eax
  802114:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802117:	eb 15                	jmp    80212e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	8a 00                	mov    (%eax),%al
  80211e:	0f b6 d0             	movzbl %al,%edx
  802121:	8b 45 0c             	mov    0xc(%ebp),%eax
  802124:	0f b6 c0             	movzbl %al,%eax
  802127:	39 c2                	cmp    %eax,%edx
  802129:	74 0d                	je     802138 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80212b:	ff 45 08             	incl   0x8(%ebp)
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802134:	72 e3                	jb     802119 <memfind+0x13>
  802136:	eb 01                	jmp    802139 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  802138:	90                   	nop
	return (void *) s;
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  802144:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80214b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802152:	eb 03                	jmp    802157 <strtol+0x19>
		s++;
  802154:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	8a 00                	mov    (%eax),%al
  80215c:	3c 20                	cmp    $0x20,%al
  80215e:	74 f4                	je     802154 <strtol+0x16>
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	8a 00                	mov    (%eax),%al
  802165:	3c 09                	cmp    $0x9,%al
  802167:	74 eb                	je     802154 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	8a 00                	mov    (%eax),%al
  80216e:	3c 2b                	cmp    $0x2b,%al
  802170:	75 05                	jne    802177 <strtol+0x39>
		s++;
  802172:	ff 45 08             	incl   0x8(%ebp)
  802175:	eb 13                	jmp    80218a <strtol+0x4c>
	else if (*s == '-')
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	8a 00                	mov    (%eax),%al
  80217c:	3c 2d                	cmp    $0x2d,%al
  80217e:	75 0a                	jne    80218a <strtol+0x4c>
		s++, neg = 1;
  802180:	ff 45 08             	incl   0x8(%ebp)
  802183:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80218a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80218e:	74 06                	je     802196 <strtol+0x58>
  802190:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802194:	75 20                	jne    8021b6 <strtol+0x78>
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	8a 00                	mov    (%eax),%al
  80219b:	3c 30                	cmp    $0x30,%al
  80219d:	75 17                	jne    8021b6 <strtol+0x78>
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	40                   	inc    %eax
  8021a3:	8a 00                	mov    (%eax),%al
  8021a5:	3c 78                	cmp    $0x78,%al
  8021a7:	75 0d                	jne    8021b6 <strtol+0x78>
		s += 2, base = 16;
  8021a9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8021ad:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8021b4:	eb 28                	jmp    8021de <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8021b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021ba:	75 15                	jne    8021d1 <strtol+0x93>
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	8a 00                	mov    (%eax),%al
  8021c1:	3c 30                	cmp    $0x30,%al
  8021c3:	75 0c                	jne    8021d1 <strtol+0x93>
		s++, base = 8;
  8021c5:	ff 45 08             	incl   0x8(%ebp)
  8021c8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8021cf:	eb 0d                	jmp    8021de <strtol+0xa0>
	else if (base == 0)
  8021d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021d5:	75 07                	jne    8021de <strtol+0xa0>
		base = 10;
  8021d7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	8a 00                	mov    (%eax),%al
  8021e3:	3c 2f                	cmp    $0x2f,%al
  8021e5:	7e 19                	jle    802200 <strtol+0xc2>
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	8a 00                	mov    (%eax),%al
  8021ec:	3c 39                	cmp    $0x39,%al
  8021ee:	7f 10                	jg     802200 <strtol+0xc2>
			dig = *s - '0';
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	8a 00                	mov    (%eax),%al
  8021f5:	0f be c0             	movsbl %al,%eax
  8021f8:	83 e8 30             	sub    $0x30,%eax
  8021fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021fe:	eb 42                	jmp    802242 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	8a 00                	mov    (%eax),%al
  802205:	3c 60                	cmp    $0x60,%al
  802207:	7e 19                	jle    802222 <strtol+0xe4>
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	8a 00                	mov    (%eax),%al
  80220e:	3c 7a                	cmp    $0x7a,%al
  802210:	7f 10                	jg     802222 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	8a 00                	mov    (%eax),%al
  802217:	0f be c0             	movsbl %al,%eax
  80221a:	83 e8 57             	sub    $0x57,%eax
  80221d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802220:	eb 20                	jmp    802242 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	8a 00                	mov    (%eax),%al
  802227:	3c 40                	cmp    $0x40,%al
  802229:	7e 39                	jle    802264 <strtol+0x126>
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	8a 00                	mov    (%eax),%al
  802230:	3c 5a                	cmp    $0x5a,%al
  802232:	7f 30                	jg     802264 <strtol+0x126>
			dig = *s - 'A' + 10;
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	8a 00                	mov    (%eax),%al
  802239:	0f be c0             	movsbl %al,%eax
  80223c:	83 e8 37             	sub    $0x37,%eax
  80223f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	3b 45 10             	cmp    0x10(%ebp),%eax
  802248:	7d 19                	jge    802263 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80224a:	ff 45 08             	incl   0x8(%ebp)
  80224d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802250:	0f af 45 10          	imul   0x10(%ebp),%eax
  802254:	89 c2                	mov    %eax,%edx
  802256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802259:	01 d0                	add    %edx,%eax
  80225b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80225e:	e9 7b ff ff ff       	jmp    8021de <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802263:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802264:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802268:	74 08                	je     802272 <strtol+0x134>
		*endptr = (char *) s;
  80226a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226d:	8b 55 08             	mov    0x8(%ebp),%edx
  802270:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802272:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802276:	74 07                	je     80227f <strtol+0x141>
  802278:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80227b:	f7 d8                	neg    %eax
  80227d:	eb 03                	jmp    802282 <strtol+0x144>
  80227f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <ltostr>:

void
ltostr(long value, char *str)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
  802287:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80228a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802291:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802298:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229c:	79 13                	jns    8022b1 <ltostr+0x2d>
	{
		neg = 1;
  80229e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8022a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8022ab:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8022ae:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8022b9:	99                   	cltd   
  8022ba:	f7 f9                	idiv   %ecx
  8022bc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8022bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022c2:	8d 50 01             	lea    0x1(%eax),%edx
  8022c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8022c8:	89 c2                	mov    %eax,%edx
  8022ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cd:	01 d0                	add    %edx,%eax
  8022cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022d2:	83 c2 30             	add    $0x30,%edx
  8022d5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8022d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022da:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8022df:	f7 e9                	imul   %ecx
  8022e1:	c1 fa 02             	sar    $0x2,%edx
  8022e4:	89 c8                	mov    %ecx,%eax
  8022e6:	c1 f8 1f             	sar    $0x1f,%eax
  8022e9:	29 c2                	sub    %eax,%edx
  8022eb:	89 d0                	mov    %edx,%eax
  8022ed:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8022f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022f4:	75 bb                	jne    8022b1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8022f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8022fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802300:	48                   	dec    %eax
  802301:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802304:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802308:	74 3d                	je     802347 <ltostr+0xc3>
		start = 1 ;
  80230a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802311:	eb 34                	jmp    802347 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  802313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802316:	8b 45 0c             	mov    0xc(%ebp),%eax
  802319:	01 d0                	add    %edx,%eax
  80231b:	8a 00                	mov    (%eax),%al
  80231d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802323:	8b 45 0c             	mov    0xc(%ebp),%eax
  802326:	01 c2                	add    %eax,%edx
  802328:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80232b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232e:	01 c8                	add    %ecx,%eax
  802330:	8a 00                	mov    (%eax),%al
  802332:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  802334:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233a:	01 c2                	add    %eax,%edx
  80233c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80233f:	88 02                	mov    %al,(%edx)
		start++ ;
  802341:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802344:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80234d:	7c c4                	jl     802313 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80234f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802352:	8b 45 0c             	mov    0xc(%ebp),%eax
  802355:	01 d0                	add    %edx,%eax
  802357:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80235a:	90                   	nop
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
  802360:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802363:	ff 75 08             	pushl  0x8(%ebp)
  802366:	e8 c4 f9 ff ff       	call   801d2f <strlen>
  80236b:	83 c4 04             	add    $0x4,%esp
  80236e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802371:	ff 75 0c             	pushl  0xc(%ebp)
  802374:	e8 b6 f9 ff ff       	call   801d2f <strlen>
  802379:	83 c4 04             	add    $0x4,%esp
  80237c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80237f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80238d:	eb 17                	jmp    8023a6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80238f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802392:	8b 45 10             	mov    0x10(%ebp),%eax
  802395:	01 c2                	add    %eax,%edx
  802397:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	01 c8                	add    %ecx,%eax
  80239f:	8a 00                	mov    (%eax),%al
  8023a1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8023a3:	ff 45 fc             	incl   -0x4(%ebp)
  8023a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8023ac:	7c e1                	jl     80238f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8023ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8023b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8023bc:	eb 1f                	jmp    8023dd <strcconcat+0x80>
		final[s++] = str2[i] ;
  8023be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023c1:	8d 50 01             	lea    0x1(%eax),%edx
  8023c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8023c7:	89 c2                	mov    %eax,%edx
  8023c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8023cc:	01 c2                	add    %eax,%edx
  8023ce:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8023d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d4:	01 c8                	add    %ecx,%eax
  8023d6:	8a 00                	mov    (%eax),%al
  8023d8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8023da:	ff 45 f8             	incl   -0x8(%ebp)
  8023dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023e3:	7c d9                	jl     8023be <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8023e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8023eb:	01 d0                	add    %edx,%eax
  8023ed:	c6 00 00             	movb   $0x0,(%eax)
}
  8023f0:	90                   	nop
  8023f1:	c9                   	leave  
  8023f2:	c3                   	ret    

008023f3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8023f3:	55                   	push   %ebp
  8023f4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8023f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8023ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802402:	8b 00                	mov    (%eax),%eax
  802404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80240b:	8b 45 10             	mov    0x10(%ebp),%eax
  80240e:	01 d0                	add    %edx,%eax
  802410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802416:	eb 0c                	jmp    802424 <strsplit+0x31>
			*string++ = 0;
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	8d 50 01             	lea    0x1(%eax),%edx
  80241e:	89 55 08             	mov    %edx,0x8(%ebp)
  802421:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	8a 00                	mov    (%eax),%al
  802429:	84 c0                	test   %al,%al
  80242b:	74 18                	je     802445 <strsplit+0x52>
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	8a 00                	mov    (%eax),%al
  802432:	0f be c0             	movsbl %al,%eax
  802435:	50                   	push   %eax
  802436:	ff 75 0c             	pushl  0xc(%ebp)
  802439:	e8 83 fa ff ff       	call   801ec1 <strchr>
  80243e:	83 c4 08             	add    $0x8,%esp
  802441:	85 c0                	test   %eax,%eax
  802443:	75 d3                	jne    802418 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802445:	8b 45 08             	mov    0x8(%ebp),%eax
  802448:	8a 00                	mov    (%eax),%al
  80244a:	84 c0                	test   %al,%al
  80244c:	74 5a                	je     8024a8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80244e:	8b 45 14             	mov    0x14(%ebp),%eax
  802451:	8b 00                	mov    (%eax),%eax
  802453:	83 f8 0f             	cmp    $0xf,%eax
  802456:	75 07                	jne    80245f <strsplit+0x6c>
		{
			return 0;
  802458:	b8 00 00 00 00       	mov    $0x0,%eax
  80245d:	eb 66                	jmp    8024c5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80245f:	8b 45 14             	mov    0x14(%ebp),%eax
  802462:	8b 00                	mov    (%eax),%eax
  802464:	8d 48 01             	lea    0x1(%eax),%ecx
  802467:	8b 55 14             	mov    0x14(%ebp),%edx
  80246a:	89 0a                	mov    %ecx,(%edx)
  80246c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802473:	8b 45 10             	mov    0x10(%ebp),%eax
  802476:	01 c2                	add    %eax,%edx
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80247d:	eb 03                	jmp    802482 <strsplit+0x8f>
			string++;
  80247f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802482:	8b 45 08             	mov    0x8(%ebp),%eax
  802485:	8a 00                	mov    (%eax),%al
  802487:	84 c0                	test   %al,%al
  802489:	74 8b                	je     802416 <strsplit+0x23>
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	8a 00                	mov    (%eax),%al
  802490:	0f be c0             	movsbl %al,%eax
  802493:	50                   	push   %eax
  802494:	ff 75 0c             	pushl  0xc(%ebp)
  802497:	e8 25 fa ff ff       	call   801ec1 <strchr>
  80249c:	83 c4 08             	add    $0x8,%esp
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	74 dc                	je     80247f <strsplit+0x8c>
			string++;
	}
  8024a3:	e9 6e ff ff ff       	jmp    802416 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8024a8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8024a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ac:	8b 00                	mov    (%eax),%eax
  8024ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8024b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8024b8:	01 d0                	add    %edx,%eax
  8024ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8024c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8024c5:	c9                   	leave  
  8024c6:	c3                   	ret    

008024c7 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
  8024ca:	83 ec 10             	sub    $0x10,%esp
	char* ret = dst;
  8024cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (int i = 0; i < strlen(src); ++i)
  8024d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8024da:	eb 4a                	jmp    802526 <str2lower+0x5f>
	{
		dst[i] = src[i] ;
  8024dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024df:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e2:	01 c2                	add    %eax,%edx
  8024e4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ea:	01 c8                	add    %ecx,%eax
  8024ec:	8a 00                	mov    (%eax),%al
  8024ee:	88 02                	mov    %al,(%edx)
		if (src[i] >= 'A' && src[i] <= 'Z')
  8024f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f6:	01 d0                	add    %edx,%eax
  8024f8:	8a 00                	mov    (%eax),%al
  8024fa:	3c 40                	cmp    $0x40,%al
  8024fc:	7e 25                	jle    802523 <str2lower+0x5c>
  8024fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802501:	8b 45 0c             	mov    0xc(%ebp),%eax
  802504:	01 d0                	add    %edx,%eax
  802506:	8a 00                	mov    (%eax),%al
  802508:	3c 5a                	cmp    $0x5a,%al
  80250a:	7f 17                	jg     802523 <str2lower+0x5c>
		{
			dst[i] += 32 ;
  80250c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
  802512:	01 d0                	add    %edx,%eax
  802514:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802517:	8b 55 08             	mov    0x8(%ebp),%edx
  80251a:	01 ca                	add    %ecx,%edx
  80251c:	8a 12                	mov    (%edx),%dl
  80251e:	83 c2 20             	add    $0x20,%edx
  802521:	88 10                	mov    %dl,(%eax)


char* str2lower(char *dst, const char *src)
{
	char* ret = dst;
	for (int i = 0; i < strlen(src); ++i)
  802523:	ff 45 fc             	incl   -0x4(%ebp)
  802526:	ff 75 0c             	pushl  0xc(%ebp)
  802529:	e8 01 f8 ff ff       	call   801d2f <strlen>
  80252e:	83 c4 04             	add    $0x4,%esp
  802531:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  802534:	7f a6                	jg     8024dc <str2lower+0x15>
		if (src[i] >= 'A' && src[i] <= 'Z')
		{
			dst[i] += 32 ;
		}
	}
	return ret;
  802536:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <uheap_init>:
//==============================================
// [1] INITIALIZE USER HEAP:
//==============================================
int __firstTimeFlag = 1;
void uheap_init()
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
  80253e:	83 ec 08             	sub    $0x8,%esp
	if(__firstTimeFlag)
  802541:	a1 08 70 80 00       	mov    0x807008,%eax
  802546:	85 c0                	test   %eax,%eax
  802548:	0f 84 95 00 00 00    	je     8025e3 <uheap_init+0xa8>
	{
		initialize_dynamic_allocator(USER_HEAP_START, USER_HEAP_START + DYN_ALLOC_MAX_SIZE);
  80254e:	83 ec 08             	sub    $0x8,%esp
  802551:	68 00 00 00 82       	push   $0x82000000
  802556:	68 00 00 00 80       	push   $0x80000000
  80255b:	e8 59 1f 00 00       	call   8044b9 <initialize_dynamic_allocator>
  802560:	83 c4 10             	add    $0x10,%esp
		uheapPlaceStrategy = sys_get_uheap_strategy();
  802563:	e8 93 1d 00 00       	call   8042fb <sys_get_uheap_strategy>
  802568:	a3 60 f0 81 00       	mov    %eax,0x81f060
		uheapPageAllocStart = dynAllocEnd + PAGE_SIZE;
  80256d:	a1 40 70 80 00       	mov    0x807040,%eax
  802572:	05 00 10 00 00       	add    $0x1000,%eax
  802577:	a3 10 f1 81 00       	mov    %eax,0x81f110
		uheapPageAllocBreak = uheapPageAllocStart;
  80257c:	a1 10 f1 81 00       	mov    0x81f110,%eax
  802581:	a3 68 f0 81 00       	mov    %eax,0x81f068
		init_uspinlock(&ulock,"malloc",1);
  802586:	83 ec 04             	sub    $0x4,%esp
  802589:	6a 01                	push   $0x1
  80258b:	68 9c 60 80 00       	push   $0x80609c
  802590:	68 40 f1 81 00       	push   $0x81f140
  802595:	e8 4b 2a 00 00       	call   804fe5 <init_uspinlock>
  80259a:	83 c4 10             	add    $0x10,%esp
		LIST_INIT(&u_freelist);
  80259d:	c7 05 20 f1 81 00 00 	movl   $0x0,0x81f120
  8025a4:	00 00 00 
  8025a7:	c7 05 24 f1 81 00 00 	movl   $0x0,0x81f124
  8025ae:	00 00 00 
  8025b1:	c7 05 2c f1 81 00 00 	movl   $0x0,0x81f12c
  8025b8:	00 00 00 
		LIST_INIT(&u_allocatedlist);
  8025bb:	c7 05 30 f1 81 00 00 	movl   $0x0,0x81f130
  8025c2:	00 00 00 
  8025c5:	c7 05 34 f1 81 00 00 	movl   $0x0,0x81f134
  8025cc:	00 00 00 
  8025cf:	c7 05 3c f1 81 00 00 	movl   $0x0,0x81f13c
  8025d6:	00 00 00 
		__firstTimeFlag = 0;
  8025d9:	c7 05 08 70 80 00 00 	movl   $0x0,0x807008
  8025e0:	00 00 00 
	}
}
  8025e3:	90                   	nop
  8025e4:	c9                   	leave  
  8025e5:	c3                   	ret    

008025e6 <get_page>:

//==============================================
// [2] GET A PAGE FROM THE KERNEL FOR DA:
//==============================================
int get_page(void* va)
{
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
  8025e9:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_allocate_page(ROUNDDOWN(va, PAGE_SIZE), PERM_USER|PERM_WRITEABLE|PERM_UHPAGE);
  8025ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8025fa:	83 ec 08             	sub    $0x8,%esp
  8025fd:	68 06 04 00 00       	push   $0x406
  802602:	50                   	push   %eax
  802603:	e8 3d 19 00 00       	call   803f45 <__sys_allocate_page>
  802608:	83 c4 10             	add    $0x10,%esp
  80260b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  80260e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802612:	79 14                	jns    802628 <get_page+0x42>
		panic("get_page() in user: failed to allocate page from the kernel");
  802614:	83 ec 04             	sub    $0x4,%esp
  802617:	68 a4 60 80 00       	push   $0x8060a4
  80261c:	6a 2d                	push   $0x2d
  80261e:	68 e0 60 80 00       	push   $0x8060e0
  802623:	e8 58 eb ff ff       	call   801180 <_panic>
	return 0;
  802628:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <return_page>:

//==============================================
// [3] RETURN A PAGE FROM THE DA TO KERNEL:
//==============================================
void return_page(void* va)
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
  802632:	83 ec 18             	sub    $0x18,%esp
	int ret = __sys_unmap_frame(ROUNDDOWN((uint32)va, PAGE_SIZE));
  802635:	8b 45 08             	mov    0x8(%ebp),%eax
  802638:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802643:	83 ec 0c             	sub    $0xc,%esp
  802646:	50                   	push   %eax
  802647:	e8 40 19 00 00       	call   803f8c <__sys_unmap_frame>
  80264c:	83 c4 10             	add    $0x10,%esp
  80264f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (ret < 0)
  802652:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802656:	79 14                	jns    80266c <return_page+0x3d>
		panic("return_page() in user: failed to return a page to the kernel");
  802658:	83 ec 04             	sub    $0x4,%esp
  80265b:	68 ec 60 80 00       	push   $0x8060ec
  802660:	6a 38                	push   $0x38
  802662:	68 e0 60 80 00       	push   $0x8060e0
  802667:	e8 14 eb ff ff       	call   801180 <_panic>
}
  80266c:	90                   	nop
  80266d:	c9                   	leave  
  80266e:	c3                   	ret    

0080266f <malloc>:

//=================================
// [1] ALLOCATE SPACE IN USER HEAP:
//=================================
void* malloc(uint32 size)
{
  80266f:	55                   	push   %ebp
  802670:	89 e5                	mov    %esp,%ebp
  802672:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  802675:	e8 c1 fe ff ff       	call   80253b <uheap_init>
	if (size == 0) return NULL ;
  80267a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80267e:	75 0a                	jne    80268a <malloc+0x1b>
  802680:	b8 00 00 00 00       	mov    $0x0,%eax
  802685:	e9 e1 04 00 00       	jmp    802b6b <malloc+0x4fc>
	//==============================================================

	acquire_uspinlock(&ulock);
  80268a:	83 ec 0c             	sub    $0xc,%esp
  80268d:	68 40 f1 81 00       	push   $0x81f140
  802692:	e8 9d 29 00 00       	call   805034 <acquire_uspinlock>
  802697:	83 c4 10             	add    $0x10,%esp
	if(size <  DYN_ALLOC_MAX_BLOCK_SIZE){
  80269a:	81 7d 08 ff 07 00 00 	cmpl   $0x7ff,0x8(%ebp)
  8026a1:	77 23                	ja     8026c6 <malloc+0x57>
		release_uspinlock(&ulock);
  8026a3:	83 ec 0c             	sub    $0xc,%esp
  8026a6:	68 40 f1 81 00       	push   $0x81f140
  8026ab:	e8 dc 29 00 00       	call   80508c <release_uspinlock>
  8026b0:	83 c4 10             	add    $0x10,%esp
		return alloc_block(size);
  8026b3:	83 ec 0c             	sub    $0xc,%esp
  8026b6:	ff 75 08             	pushl  0x8(%ebp)
  8026b9:	e8 dd 1f 00 00       	call   80469b <alloc_block>
  8026be:	83 c4 10             	add    $0x10,%esp
  8026c1:	e9 a5 04 00 00       	jmp    802b6b <malloc+0x4fc>
	}

	struct UserHeapStruct* allocblock= (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  8026c6:	83 ec 0c             	sub    $0xc,%esp
  8026c9:	6a 10                	push   $0x10
  8026cb:	e8 cb 1f 00 00       	call   80469b <alloc_block>
  8026d0:	83 c4 10             	add    $0x10,%esp
  8026d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (allocblock == NULL){
  8026d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026da:	75 0a                	jne    8026e6 <malloc+0x77>
			return NULL;
  8026dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e1:	e9 85 04 00 00       	jmp    802b6b <malloc+0x4fc>
	}

	size = ROUNDUP(size,PAGE_SIZE);
  8026e6:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8026ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f3:	01 d0                	add    %edx,%eax
  8026f5:	48                   	dec    %eax
  8026f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8026f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802701:	f7 75 e8             	divl   -0x18(%ebp)
  802704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802707:	29 d0                	sub    %edx,%eax
  802709:	89 45 08             	mov    %eax,0x8(%ebp)
	struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  80270c:	a1 24 f1 81 00       	mov    0x81f124,%eax
  802711:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  802714:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  802719:	85 c0                	test   %eax,%eax
  80271b:	74 0f                	je     80272c <malloc+0xbd>
  80271d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802720:	8b 40 04             	mov    0x4(%eax),%eax
  802723:	3b 45 08             	cmp    0x8(%ebp),%eax
  802726:	0f 83 ea 00 00 00    	jae    802816 <malloc+0x1a7>
			if(uheapPageAllocBreak < USER_HEAP_MAX - size){
  80272c:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802731:	2b 45 08             	sub    0x8(%ebp),%eax
  802734:	89 c2                	mov    %eax,%edx
  802736:	a1 68 f0 81 00       	mov    0x81f068,%eax
  80273b:	39 c2                	cmp    %eax,%edx
  80273d:	0f 86 b9 00 00 00    	jbe    8027fc <malloc+0x18d>
					uint32 requestedblockva = uheapPageAllocBreak;
  802743:	a1 68 f0 81 00       	mov    0x81f068,%eax
  802748:	89 45 dc             	mov    %eax,-0x24(%ebp)
					uheapPageAllocBreak+=size;
  80274b:	8b 15 68 f0 81 00    	mov    0x81f068,%edx
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	01 d0                	add    %edx,%eax
  802756:	a3 68 f0 81 00       	mov    %eax,0x81f068
					allocblock->startva = requestedblockva;
  80275b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802761:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  802763:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802766:	8b 55 08             	mov    0x8(%ebp),%edx
  802769:	89 50 04             	mov    %edx,0x4(%eax)

					LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80276c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802770:	75 14                	jne    802786 <malloc+0x117>
  802772:	83 ec 04             	sub    $0x4,%esp
  802775:	68 2c 61 80 00       	push   $0x80612c
  80277a:	6a 60                	push   $0x60
  80277c:	68 e0 60 80 00       	push   $0x8060e0
  802781:	e8 fa e9 ff ff       	call   801180 <_panic>
  802786:	8b 15 34 f1 81 00    	mov    0x81f134,%edx
  80278c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278f:	89 50 0c             	mov    %edx,0xc(%eax)
  802792:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802795:	8b 40 0c             	mov    0xc(%eax),%eax
  802798:	85 c0                	test   %eax,%eax
  80279a:	74 0d                	je     8027a9 <malloc+0x13a>
  80279c:	a1 34 f1 81 00       	mov    0x81f134,%eax
  8027a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027a4:	89 50 08             	mov    %edx,0x8(%eax)
  8027a7:	eb 08                	jmp    8027b1 <malloc+0x142>
  8027a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ac:	a3 30 f1 81 00       	mov    %eax,0x81f130
  8027b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b4:	a3 34 f1 81 00       	mov    %eax,0x81f134
  8027b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8027c3:	a1 3c f1 81 00       	mov    0x81f13c,%eax
  8027c8:	40                   	inc    %eax
  8027c9:	a3 3c f1 81 00       	mov    %eax,0x81f13c


					sys_allocate_user_mem(allocblock->startva ,size);
  8027ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d1:	8b 00                	mov    (%eax),%eax
  8027d3:	83 ec 08             	sub    $0x8,%esp
  8027d6:	ff 75 08             	pushl  0x8(%ebp)
  8027d9:	50                   	push   %eax
  8027da:	e8 34 1c 00 00       	call   804413 <sys_allocate_user_mem>
  8027df:	83 c4 10             	add    $0x10,%esp
					release_uspinlock(&ulock);
  8027e2:	83 ec 0c             	sub    $0xc,%esp
  8027e5:	68 40 f1 81 00       	push   $0x81f140
  8027ea:	e8 9d 28 00 00       	call   80508c <release_uspinlock>
  8027ef:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  8027f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	e9 6f 03 00 00       	jmp    802b6b <malloc+0x4fc>
			}else{
					release_uspinlock(&ulock);
  8027fc:	83 ec 0c             	sub    $0xc,%esp
  8027ff:	68 40 f1 81 00       	push   $0x81f140
  802804:	e8 83 28 00 00       	call   80508c <release_uspinlock>
  802809:	83 c4 10             	add    $0x10,%esp
					return NULL;
  80280c:	b8 00 00 00 00       	mov    $0x0,%eax
  802811:	e9 55 03 00 00       	jmp    802b6b <malloc+0x4fc>
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  802816:	a1 20 f1 81 00       	mov    0x81f120,%eax
  80281b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//worst fit
		while(currentfreeelement != NULL){
  80281e:	e9 39 03 00 00       	jmp    802b5c <malloc+0x4ed>
			if(size<currentfreeelement->size){
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 40 04             	mov    0x4(%eax),%eax
  802829:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282c:	0f 86 e7 01 00 00    	jbe    802a19 <malloc+0x3aa>
				allocblock->startva = lastfreeelement->startva;
  802832:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802835:	8b 10                	mov    (%eax),%edx
  802837:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283a:	89 10                	mov    %edx,(%eax)
                allocblock->size = size;
  80283c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283f:	8b 55 08             	mov    0x8(%ebp),%edx
  802842:	89 50 04             	mov    %edx,0x4(%eax)
                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  802845:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802849:	75 14                	jne    80285f <malloc+0x1f0>
  80284b:	83 ec 04             	sub    $0x4,%esp
  80284e:	68 2c 61 80 00       	push   $0x80612c
  802853:	6a 72                	push   $0x72
  802855:	68 e0 60 80 00       	push   $0x8060e0
  80285a:	e8 21 e9 ff ff       	call   801180 <_panic>
  80285f:	8b 15 34 f1 81 00    	mov    0x81f134,%edx
  802865:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802868:	89 50 0c             	mov    %edx,0xc(%eax)
  80286b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286e:	8b 40 0c             	mov    0xc(%eax),%eax
  802871:	85 c0                	test   %eax,%eax
  802873:	74 0d                	je     802882 <malloc+0x213>
  802875:	a1 34 f1 81 00       	mov    0x81f134,%eax
  80287a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80287d:	89 50 08             	mov    %edx,0x8(%eax)
  802880:	eb 08                	jmp    80288a <malloc+0x21b>
  802882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802885:	a3 30 f1 81 00       	mov    %eax,0x81f130
  80288a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288d:	a3 34 f1 81 00       	mov    %eax,0x81f134
  802892:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802895:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80289c:	a1 3c f1 81 00       	mov    0x81f13c,%eax
  8028a1:	40                   	inc    %eax
  8028a2:	a3 3c f1 81 00       	mov    %eax,0x81f13c
                lastfreeelement->startva += size;
  8028a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028aa:	8b 10                	mov    (%eax),%edx
  8028ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8028af:	01 c2                	add    %eax,%edx
  8028b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b4:	89 10                	mov    %edx,(%eax)
                lastfreeelement->size -= size;
  8028b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b9:	8b 40 04             	mov    0x4(%eax),%eax
  8028bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8028bf:	89 c2                	mov    %eax,%edx
  8028c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c4:	89 50 04             	mov    %edx,0x4(%eax)
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  8028c7:	a1 20 f1 81 00       	mov    0x81f120,%eax
  8028cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
                //check order of last element

                while (currentfree2 != NULL){
  8028cf:	e9 0d 01 00 00       	jmp    8029e1 <malloc+0x372>
                	if(lastfreeelement->size <currentfree2->size){
  8028d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d7:	8b 50 04             	mov    0x4(%eax),%edx
  8028da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dd:	8b 40 04             	mov    0x4(%eax),%eax
  8028e0:	39 c2                	cmp    %eax,%edx
  8028e2:	0f 83 f0 00 00 00    	jae    8029d8 <malloc+0x369>
                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  8028e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8028ec:	75 14                	jne    802902 <malloc+0x293>
  8028ee:	83 ec 04             	sub    $0x4,%esp
  8028f1:	68 4f 61 80 00       	push   $0x80614f
  8028f6:	6a 7a                	push   $0x7a
  8028f8:	68 e0 60 80 00       	push   $0x8060e0
  8028fd:	e8 7e e8 ff ff       	call   801180 <_panic>
  802902:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802905:	8b 40 08             	mov    0x8(%eax),%eax
  802908:	85 c0                	test   %eax,%eax
  80290a:	74 11                	je     80291d <malloc+0x2ae>
  80290c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80290f:	8b 40 08             	mov    0x8(%eax),%eax
  802912:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802915:	8b 52 0c             	mov    0xc(%edx),%edx
  802918:	89 50 0c             	mov    %edx,0xc(%eax)
  80291b:	eb 0b                	jmp    802928 <malloc+0x2b9>
  80291d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802920:	8b 40 0c             	mov    0xc(%eax),%eax
  802923:	a3 24 f1 81 00       	mov    %eax,0x81f124
  802928:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80292b:	8b 40 0c             	mov    0xc(%eax),%eax
  80292e:	85 c0                	test   %eax,%eax
  802930:	74 11                	je     802943 <malloc+0x2d4>
  802932:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802935:	8b 40 0c             	mov    0xc(%eax),%eax
  802938:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80293b:	8b 52 08             	mov    0x8(%edx),%edx
  80293e:	89 50 08             	mov    %edx,0x8(%eax)
  802941:	eb 0b                	jmp    80294e <malloc+0x2df>
  802943:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802946:	8b 40 08             	mov    0x8(%eax),%eax
  802949:	a3 20 f1 81 00       	mov    %eax,0x81f120
  80294e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802951:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802958:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80295b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802962:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  802967:	48                   	dec    %eax
  802968:	a3 2c f1 81 00       	mov    %eax,0x81f12c
                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  80296d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802971:	74 06                	je     802979 <malloc+0x30a>
  802973:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802977:	75 14                	jne    80298d <malloc+0x31e>
  802979:	83 ec 04             	sub    $0x4,%esp
  80297c:	68 70 61 80 00       	push   $0x806170
  802981:	6a 7b                	push   $0x7b
  802983:	68 e0 60 80 00       	push   $0x8060e0
  802988:	e8 f3 e7 ff ff       	call   801180 <_panic>
  80298d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802990:	8b 50 0c             	mov    0xc(%eax),%edx
  802993:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802996:	89 50 0c             	mov    %edx,0xc(%eax)
  802999:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80299c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80299f:	89 50 08             	mov    %edx,0x8(%eax)
  8029a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	74 0e                	je     8029ba <malloc+0x34b>
  8029ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029af:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029b5:	89 50 08             	mov    %edx,0x8(%eax)
  8029b8:	eb 08                	jmp    8029c2 <malloc+0x353>
  8029ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029bd:	a3 20 f1 81 00       	mov    %eax,0x81f120
  8029c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029c8:	89 50 0c             	mov    %edx,0xc(%eax)
  8029cb:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  8029d0:	40                   	inc    %eax
  8029d1:	a3 2c f1 81 00       	mov    %eax,0x81f12c
                		break;
  8029d6:	eb 13                	jmp    8029eb <malloc+0x37c>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
  8029d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029db:	8b 40 08             	mov    0x8(%eax),%eax
  8029de:	89 45 f0             	mov    %eax,-0x10(%ebp)
                lastfreeelement->startva += size;
                lastfreeelement->size -= size;
                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
                //check order of last element

                while (currentfree2 != NULL){
  8029e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e5:	0f 85 e9 fe ff ff    	jne    8028d4 <malloc+0x265>
                	}
                	currentfree2 = currentfree2->prev_next_info.le_next;
                }


                sys_allocate_user_mem(allocblock->startva ,size);
  8029eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ee:	8b 00                	mov    (%eax),%eax
  8029f0:	83 ec 08             	sub    $0x8,%esp
  8029f3:	ff 75 08             	pushl  0x8(%ebp)
  8029f6:	50                   	push   %eax
  8029f7:	e8 17 1a 00 00       	call   804413 <sys_allocate_user_mem>
  8029fc:	83 c4 10             	add    $0x10,%esp
                release_uspinlock(&ulock);
  8029ff:	83 ec 0c             	sub    $0xc,%esp
  802a02:	68 40 f1 81 00       	push   $0x81f140
  802a07:	e8 80 26 00 00       	call   80508c <release_uspinlock>
  802a0c:	83 c4 10             	add    $0x10,%esp
                return (void*)allocblock->startva;
  802a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	e9 52 01 00 00       	jmp    802b6b <malloc+0x4fc>
                //exact fit
			}else if(size == currentfreeelement->size){
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	8b 40 04             	mov    0x4(%eax),%eax
  802a1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a22:	0f 85 2b 01 00 00    	jne    802b53 <malloc+0x4e4>
				allocblock->startva = currentfreeelement->startva;
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 10                	mov    (%eax),%edx
  802a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a30:	89 10                	mov    %edx,(%eax)
				allocblock->size = size;
  802a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a35:	8b 55 08             	mov    0x8(%ebp),%edx
  802a38:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  802a3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a3f:	75 17                	jne    802a58 <malloc+0x3e9>
  802a41:	83 ec 04             	sub    $0x4,%esp
  802a44:	68 2c 61 80 00       	push   $0x80612c
  802a49:	68 89 00 00 00       	push   $0x89
  802a4e:	68 e0 60 80 00       	push   $0x8060e0
  802a53:	e8 28 e7 ff ff       	call   801180 <_panic>
  802a58:	8b 15 34 f1 81 00    	mov    0x81f134,%edx
  802a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a61:	89 50 0c             	mov    %edx,0xc(%eax)
  802a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a67:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6a:	85 c0                	test   %eax,%eax
  802a6c:	74 0d                	je     802a7b <malloc+0x40c>
  802a6e:	a1 34 f1 81 00       	mov    0x81f134,%eax
  802a73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a76:	89 50 08             	mov    %edx,0x8(%eax)
  802a79:	eb 08                	jmp    802a83 <malloc+0x414>
  802a7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7e:	a3 30 f1 81 00       	mov    %eax,0x81f130
  802a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a86:	a3 34 f1 81 00       	mov    %eax,0x81f134
  802a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a95:	a1 3c f1 81 00       	mov    0x81f13c,%eax
  802a9a:	40                   	inc    %eax
  802a9b:	a3 3c f1 81 00       	mov    %eax,0x81f13c
				LIST_REMOVE(&u_freelist ,currentfreeelement);
  802aa0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa4:	75 17                	jne    802abd <malloc+0x44e>
  802aa6:	83 ec 04             	sub    $0x4,%esp
  802aa9:	68 4f 61 80 00       	push   $0x80614f
  802aae:	68 8a 00 00 00       	push   $0x8a
  802ab3:	68 e0 60 80 00       	push   $0x8060e0
  802ab8:	e8 c3 e6 ff ff       	call   801180 <_panic>
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 40 08             	mov    0x8(%eax),%eax
  802ac3:	85 c0                	test   %eax,%eax
  802ac5:	74 11                	je     802ad8 <malloc+0x469>
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	8b 40 08             	mov    0x8(%eax),%eax
  802acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad0:	8b 52 0c             	mov    0xc(%edx),%edx
  802ad3:	89 50 0c             	mov    %edx,0xc(%eax)
  802ad6:	eb 0b                	jmp    802ae3 <malloc+0x474>
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ade:	a3 24 f1 81 00       	mov    %eax,0x81f124
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	74 11                	je     802afe <malloc+0x48f>
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	8b 40 0c             	mov    0xc(%eax),%eax
  802af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af6:	8b 52 08             	mov    0x8(%edx),%edx
  802af9:	89 50 08             	mov    %edx,0x8(%eax)
  802afc:	eb 0b                	jmp    802b09 <malloc+0x49a>
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 40 08             	mov    0x8(%eax),%eax
  802b04:	a3 20 f1 81 00       	mov    %eax,0x81f120
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b16:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802b1d:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  802b22:	48                   	dec    %eax
  802b23:	a3 2c f1 81 00       	mov    %eax,0x81f12c
				sys_allocate_user_mem(allocblock->startva ,size);
  802b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	83 ec 08             	sub    $0x8,%esp
  802b30:	ff 75 08             	pushl  0x8(%ebp)
  802b33:	50                   	push   %eax
  802b34:	e8 da 18 00 00       	call   804413 <sys_allocate_user_mem>
  802b39:	83 c4 10             	add    $0x10,%esp
				release_uspinlock(&ulock);
  802b3c:	83 ec 0c             	sub    $0xc,%esp
  802b3f:	68 40 f1 81 00       	push   $0x81f140
  802b44:	e8 43 25 00 00       	call   80508c <release_uspinlock>
  802b49:	83 c4 10             	add    $0x10,%esp
				return (void*)allocblock->startva;
  802b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4f:	8b 00                	mov    (%eax),%eax
  802b51:	eb 18                	jmp    802b6b <malloc+0x4fc>
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	8b 40 08             	mov    0x8(%eax),%eax
  802b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
				}
	}else{
		//custom fit
		struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
		//worst fit
		while(currentfreeelement != NULL){
  802b5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b60:	0f 85 bd fc ff ff    	jne    802823 <malloc+0x1b4>
				return (void*)allocblock->startva;
			}
			currentfreeelement = currentfreeelement->prev_next_info.le_next;
		}
	}
	 return NULL;
  802b66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b6b:	c9                   	leave  
  802b6c:	c3                   	ret    

00802b6d <free>:

//=================================
// [2] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address)
{
  802b6d:	55                   	push   %ebp
  802b6e:	89 e5                	mov    %esp,%ebp
  802b70:	83 ec 38             	sub    $0x38,%esp
	uint32  VA = ROUNDDOWN(((uint32 ) virtual_address), PAGE_SIZE);
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802b79:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802b7c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802b81:	89 45 d8             	mov    %eax,-0x28(%ebp)


		uheap_init();
  802b84:	e8 b2 f9 ff ff       	call   80253b <uheap_init>
		acquire_uspinlock(&ulock);
  802b89:	83 ec 0c             	sub    $0xc,%esp
  802b8c:	68 40 f1 81 00       	push   $0x81f140
  802b91:	e8 9e 24 00 00       	call   805034 <acquire_uspinlock>
  802b96:	83 c4 10             	add    $0x10,%esp
		if (VA < uheapPageAllocStart){
  802b99:	a1 10 f1 81 00       	mov    0x81f110,%eax
  802b9e:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802ba1:	73 23                	jae    802bc6 <free+0x59>
			free_block(virtual_address);
  802ba3:	83 ec 0c             	sub    $0xc,%esp
  802ba6:	ff 75 08             	pushl  0x8(%ebp)
  802ba9:	e8 89 1f 00 00       	call   804b37 <free_block>
  802bae:	83 c4 10             	add    $0x10,%esp
			release_uspinlock(&ulock);
  802bb1:	83 ec 0c             	sub    $0xc,%esp
  802bb4:	68 40 f1 81 00       	push   $0x81f140
  802bb9:	e8 ce 24 00 00       	call   80508c <release_uspinlock>
  802bbe:	83 c4 10             	add    $0x10,%esp
			return;
  802bc1:	e9 35 07 00 00       	jmp    8032fb <free+0x78e>
		}
		if (VA >= uheapPageAllocBreak){
  802bc6:	a1 68 f0 81 00       	mov    0x81f068,%eax
  802bcb:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  802bce:	72 30                	jb     802c00 <free+0x93>
			cprintf("%d\n %d\n", VA, uheapPageAllocBreak);
  802bd0:	a1 68 f0 81 00       	mov    0x81f068,%eax
  802bd5:	83 ec 04             	sub    $0x4,%esp
  802bd8:	50                   	push   %eax
  802bd9:	ff 75 d8             	pushl  -0x28(%ebp)
  802bdc:	68 a5 61 80 00       	push   $0x8061a5
  802be1:	e8 68 e8 ff ff       	call   80144e <cprintf>
  802be6:	83 c4 10             	add    $0x10,%esp

			panic("freeing from restricted area");
  802be9:	83 ec 04             	sub    $0x4,%esp
  802bec:	68 ad 61 80 00       	push   $0x8061ad
  802bf1:	68 a7 00 00 00       	push   $0xa7
  802bf6:	68 e0 60 80 00       	push   $0x8060e0
  802bfb:	e8 80 e5 ff ff       	call   801180 <_panic>
			release_uspinlock(&ulock);
			return;
		}

		struct UserHeapStruct* newfree = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  802c00:	83 ec 0c             	sub    $0xc,%esp
  802c03:	6a 10                	push   $0x10
  802c05:	e8 91 1a 00 00       	call   80469b <alloc_block>
  802c0a:	83 c4 10             	add    $0x10,%esp
  802c0d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		struct UserHeapStruct* MergedBlock  = ( struct UserHeapStruct*)alloc_block(sizeof(struct UserHeapStruct));
  802c10:	83 ec 0c             	sub    $0xc,%esp
  802c13:	6a 10                	push   $0x10
  802c15:	e8 81 1a 00 00       	call   80469b <alloc_block>
  802c1a:	83 c4 10             	add    $0x10,%esp
  802c1d:	89 45 d0             	mov    %eax,-0x30(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
  802c20:	a1 30 f1 81 00       	mov    0x81f130,%eax
  802c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
		bool foundVA = 0;
  802c28:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		//find the allocated block
		while(ToBefreed !=NULL ){
  802c2f:	eb 1c                	jmp    802c4d <free+0xe0>

			if (VA ==ToBefreed->startva ){
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802c39:	75 09                	jne    802c44 <free+0xd7>
				foundVA = 1;
  802c3b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
				break;
  802c42:	eb 0f                	jmp    802c53 <free+0xe6>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
  802c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c47:	8b 40 08             	mov    0x8(%eax),%eax
  802c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)

		struct UserHeapStruct* ToBefreed = LIST_FIRST(&u_allocatedlist);
		bool foundVA = 0;

		//find the allocated block
		while(ToBefreed !=NULL ){
  802c4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c51:	75 de                	jne    802c31 <free+0xc4>
			}
				ToBefreed = ToBefreed->prev_next_info.le_next;
		}


		if(!foundVA){
  802c53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c57:	75 17                	jne    802c70 <free+0x103>
				panic("INVALID ADDRESS!");
  802c59:	83 ec 04             	sub    $0x4,%esp
  802c5c:	68 ca 61 80 00       	push   $0x8061ca
  802c61:	68 be 00 00 00       	push   $0xbe
  802c66:	68 e0 60 80 00       	push   $0x8060e0
  802c6b:	e8 10 e5 ff ff       	call   801180 <_panic>
				release_uspinlock(&ulock);
				return;
			}


		newfree->startva = ToBefreed->startva;
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 10                	mov    (%eax),%edx
  802c75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c78:	89 10                	mov    %edx,(%eax)
		newfree->size = ToBefreed->size;
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 50 04             	mov    0x4(%eax),%edx
  802c80:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c83:	89 50 04             	mov    %edx,0x4(%eax)

		//remove allocated block from alloclist
		LIST_REMOVE(&u_allocatedlist, ToBefreed);
  802c86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8a:	75 17                	jne    802ca3 <free+0x136>
  802c8c:	83 ec 04             	sub    $0x4,%esp
  802c8f:	68 4f 61 80 00       	push   $0x80614f
  802c94:	68 c8 00 00 00       	push   $0xc8
  802c99:	68 e0 60 80 00       	push   $0x8060e0
  802c9e:	e8 dd e4 ff ff       	call   801180 <_panic>
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 40 08             	mov    0x8(%eax),%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	74 11                	je     802cbe <free+0x151>
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 40 08             	mov    0x8(%eax),%eax
  802cb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb6:	8b 52 0c             	mov    0xc(%edx),%edx
  802cb9:	89 50 0c             	mov    %edx,0xc(%eax)
  802cbc:	eb 0b                	jmp    802cc9 <free+0x15c>
  802cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc4:	a3 34 f1 81 00       	mov    %eax,0x81f134
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccf:	85 c0                	test   %eax,%eax
  802cd1:	74 11                	je     802ce4 <free+0x177>
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cdc:	8b 52 08             	mov    0x8(%edx),%edx
  802cdf:	89 50 08             	mov    %edx,0x8(%eax)
  802ce2:	eb 0b                	jmp    802cef <free+0x182>
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 40 08             	mov    0x8(%eax),%eax
  802cea:	a3 30 f1 81 00       	mov    %eax,0x81f130
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d03:	a1 3c f1 81 00       	mov    0x81f13c,%eax
  802d08:	48                   	dec    %eax
  802d09:	a3 3c f1 81 00       	mov    %eax,0x81f13c

		sys_free_user_mem(ToBefreed->startva, ToBefreed->size);
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 50 04             	mov    0x4(%eax),%edx
  802d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d17:	8b 00                	mov    (%eax),%eax
  802d19:	83 ec 08             	sub    $0x8,%esp
  802d1c:	52                   	push   %edx
  802d1d:	50                   	push   %eax
  802d1e:	e8 d4 16 00 00       	call   8043f7 <sys_free_user_mem>
  802d23:	83 c4 10             	add    $0x10,%esp




		if(LIST_SIZE(&u_freelist) == 0){
  802d26:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  802d2b:	85 c0                	test   %eax,%eax
  802d2d:	75 7a                	jne    802da9 <free+0x23c>
			LIST_INSERT_HEAD(&u_freelist,newfree);
  802d2f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  802d33:	75 17                	jne    802d4c <free+0x1df>
  802d35:	83 ec 04             	sub    $0x4,%esp
  802d38:	68 dc 61 80 00       	push   $0x8061dc
  802d3d:	68 d0 00 00 00       	push   $0xd0
  802d42:	68 e0 60 80 00       	push   $0x8060e0
  802d47:	e8 34 e4 ff ff       	call   801180 <_panic>
  802d4c:	8b 15 20 f1 81 00    	mov    0x81f120,%edx
  802d52:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d55:	89 50 08             	mov    %edx,0x8(%eax)
  802d58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d5b:	8b 40 08             	mov    0x8(%eax),%eax
  802d5e:	85 c0                	test   %eax,%eax
  802d60:	74 0d                	je     802d6f <free+0x202>
  802d62:	a1 20 f1 81 00       	mov    0x81f120,%eax
  802d67:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  802d6a:	89 50 0c             	mov    %edx,0xc(%eax)
  802d6d:	eb 08                	jmp    802d77 <free+0x20a>
  802d6f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d72:	a3 24 f1 81 00       	mov    %eax,0x81f124
  802d77:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d7a:	a3 20 f1 81 00       	mov    %eax,0x81f120
  802d7f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d82:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802d89:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  802d8e:	40                   	inc    %eax
  802d8f:	a3 2c f1 81 00       	mov    %eax,0x81f12c
			release_uspinlock(&ulock);
  802d94:	83 ec 0c             	sub    $0xc,%esp
  802d97:	68 40 f1 81 00       	push   $0x81f140
  802d9c:	e8 eb 22 00 00       	call   80508c <release_uspinlock>
  802da1:	83 c4 10             	add    $0x10,%esp
			return;
  802da4:	e9 52 05 00 00       	jmp    8032fb <free+0x78e>
		}


		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
  802da9:	a1 20 f1 81 00       	mov    0x81f120,%eax
  802dae:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// merge with prev if possible
		bool mergeprev = 0;
  802db1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		bool mergenext = 0;
  802db8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		while(ToBeMerged != NULL){
  802dbf:	e9 d2 00 00 00       	jmp    802e96 <free+0x329>
			if((ToBeMerged->startva +ToBeMerged->size) == newfree->startva){
  802dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc7:	8b 10                	mov    (%eax),%edx
  802dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcc:	8b 40 04             	mov    0x4(%eax),%eax
  802dcf:	01 c2                	add    %eax,%edx
  802dd1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802dd4:	8b 00                	mov    (%eax),%eax
  802dd6:	39 c2                	cmp    %eax,%edx
  802dd8:	0f 85 af 00 00 00    	jne    802e8d <free+0x320>

				MergedBlock->startva = ToBeMerged->startva;
  802dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de1:	8b 10                	mov    (%eax),%edx
  802de3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802de6:	89 10                	mov    %edx,(%eax)
				MergedBlock->size = ToBeMerged->size + newfree->size;
  802de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802deb:	8b 50 04             	mov    0x4(%eax),%edx
  802dee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802df1:	8b 40 04             	mov    0x4(%eax),%eax
  802df4:	01 c2                	add    %eax,%edx
  802df6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802df9:	89 50 04             	mov    %edx,0x4(%eax)
				LIST_REMOVE(&u_freelist, ToBeMerged);
  802dfc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e00:	75 17                	jne    802e19 <free+0x2ac>
  802e02:	83 ec 04             	sub    $0x4,%esp
  802e05:	68 4f 61 80 00       	push   $0x80614f
  802e0a:	68 df 00 00 00       	push   $0xdf
  802e0f:	68 e0 60 80 00       	push   $0x8060e0
  802e14:	e8 67 e3 ff ff       	call   801180 <_panic>
  802e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1c:	8b 40 08             	mov    0x8(%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 11                	je     802e34 <free+0x2c7>
  802e23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e26:	8b 40 08             	mov    0x8(%eax),%eax
  802e29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e2c:	8b 52 0c             	mov    0xc(%edx),%edx
  802e2f:	89 50 0c             	mov    %edx,0xc(%eax)
  802e32:	eb 0b                	jmp    802e3f <free+0x2d2>
  802e34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e37:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3a:	a3 24 f1 81 00       	mov    %eax,0x81f124
  802e3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e42:	8b 40 0c             	mov    0xc(%eax),%eax
  802e45:	85 c0                	test   %eax,%eax
  802e47:	74 11                	je     802e5a <free+0x2ed>
  802e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e52:	8b 52 08             	mov    0x8(%edx),%edx
  802e55:	89 50 08             	mov    %edx,0x8(%eax)
  802e58:	eb 0b                	jmp    802e65 <free+0x2f8>
  802e5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5d:	8b 40 08             	mov    0x8(%eax),%eax
  802e60:	a3 20 f1 81 00       	mov    %eax,0x81f120
  802e65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e68:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e72:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802e79:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  802e7e:	48                   	dec    %eax
  802e7f:	a3 2c f1 81 00       	mov    %eax,0x81f12c
				mergeprev = 1;
  802e84:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
				break;
  802e8b:	eb 13                	jmp    802ea0 <free+0x333>
			}
				ToBeMerged = ToBeMerged->prev_next_info.le_next;
  802e8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e90:	8b 40 08             	mov    0x8(%eax),%eax
  802e93:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* ToBeMerged = LIST_FIRST(&u_freelist);
		// merge with prev if possible
		bool mergeprev = 0;
		bool mergenext = 0;
		while(ToBeMerged != NULL){
  802e96:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e9a:	0f 85 24 ff ff ff    	jne    802dc4 <free+0x257>
//									uheapPageAllocBreak = newfree->startva;
//						}
//					}


		if ( newfree ->startva + newfree->size == uheapPageAllocBreak){
  802ea0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ea3:	8b 10                	mov    (%eax),%edx
  802ea5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ea8:	8b 40 04             	mov    0x4(%eax),%eax
  802eab:	01 c2                	add    %eax,%edx
  802ead:	a1 68 f0 81 00       	mov    0x81f068,%eax
  802eb2:	39 c2                	cmp    %eax,%edx
  802eb4:	75 44                	jne    802efa <free+0x38d>

			if(mergeprev){
  802eb6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802eba:	74 1f                	je     802edb <free+0x36e>
				uheapPageAllocBreak = MergedBlock->startva;
  802ebc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ebf:	8b 00                	mov    (%eax),%eax
  802ec1:	a3 68 f0 81 00       	mov    %eax,0x81f068
				release_uspinlock(&ulock);
  802ec6:	83 ec 0c             	sub    $0xc,%esp
  802ec9:	68 40 f1 81 00       	push   $0x81f140
  802ece:	e8 b9 21 00 00       	call   80508c <release_uspinlock>
  802ed3:	83 c4 10             	add    $0x10,%esp
				return;
  802ed6:	e9 20 04 00 00       	jmp    8032fb <free+0x78e>

			}else{
				uheapPageAllocBreak = newfree->startva;
  802edb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ede:	8b 00                	mov    (%eax),%eax
  802ee0:	a3 68 f0 81 00       	mov    %eax,0x81f068
				release_uspinlock(&ulock);
  802ee5:	83 ec 0c             	sub    $0xc,%esp
  802ee8:	68 40 f1 81 00       	push   $0x81f140
  802eed:	e8 9a 21 00 00       	call   80508c <release_uspinlock>
  802ef2:	83 c4 10             	add    $0x10,%esp
				return;
  802ef5:	e9 01 04 00 00       	jmp    8032fb <free+0x78e>

		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
  802efa:	a1 20 f1 81 00       	mov    0x81f120,%eax
  802eff:	89 45 ec             	mov    %eax,-0x14(%ebp)
		while(ToBeMerged != NULL){
  802f02:	e9 7d 01 00 00       	jmp    803084 <free+0x517>
			if ((newfree->startva + newfree->size) == ToBeMerged->startva ){
  802f07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f0a:	8b 10                	mov    (%eax),%edx
  802f0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f0f:	8b 40 04             	mov    0x4(%eax),%eax
  802f12:	01 c2                	add    %eax,%edx
  802f14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f17:	8b 00                	mov    (%eax),%eax
  802f19:	39 c2                	cmp    %eax,%edx
  802f1b:	0f 85 5a 01 00 00    	jne    80307b <free+0x50e>
				if (mergeprev){
  802f21:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f25:	0f 84 a1 00 00 00    	je     802fcc <free+0x45f>
					MergedBlock->size += ToBeMerged->size;
  802f2b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f2e:	8b 50 04             	mov    0x4(%eax),%edx
  802f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f34:	8b 40 04             	mov    0x4(%eax),%eax
  802f37:	01 c2                	add    %eax,%edx
  802f39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802f3c:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802f3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f43:	75 17                	jne    802f5c <free+0x3ef>
  802f45:	83 ec 04             	sub    $0x4,%esp
  802f48:	68 4f 61 80 00       	push   $0x80614f
  802f4d:	68 0a 01 00 00       	push   $0x10a
  802f52:	68 e0 60 80 00       	push   $0x8060e0
  802f57:	e8 24 e2 ff ff       	call   801180 <_panic>
  802f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5f:	8b 40 08             	mov    0x8(%eax),%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	74 11                	je     802f77 <free+0x40a>
  802f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f69:	8b 40 08             	mov    0x8(%eax),%eax
  802f6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f6f:	8b 52 0c             	mov    0xc(%edx),%edx
  802f72:	89 50 0c             	mov    %edx,0xc(%eax)
  802f75:	eb 0b                	jmp    802f82 <free+0x415>
  802f77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7d:	a3 24 f1 81 00       	mov    %eax,0x81f124
  802f82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f85:	8b 40 0c             	mov    0xc(%eax),%eax
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	74 11                	je     802f9d <free+0x430>
  802f8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f92:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f95:	8b 52 08             	mov    0x8(%edx),%edx
  802f98:	89 50 08             	mov    %edx,0x8(%eax)
  802f9b:	eb 0b                	jmp    802fa8 <free+0x43b>
  802f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa0:	8b 40 08             	mov    0x8(%eax),%eax
  802fa3:	a3 20 f1 81 00       	mov    %eax,0x81f120
  802fa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  802fbc:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  802fc1:	48                   	dec    %eax
  802fc2:	a3 2c f1 81 00       	mov    %eax,0x81f12c
					break;
  802fc7:	e9 c2 00 00 00       	jmp    80308e <free+0x521>
		//if not merged find possible merge with next
				}else{
					MergedBlock->startva = newfree->startva;
  802fcc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fcf:	8b 10                	mov    (%eax),%edx
  802fd1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fd4:	89 10                	mov    %edx,(%eax)
					MergedBlock->size  = newfree->size + ToBeMerged->size;
  802fd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802fd9:	8b 50 04             	mov    0x4(%eax),%edx
  802fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fdf:	8b 40 04             	mov    0x4(%eax),%eax
  802fe2:	01 c2                	add    %eax,%edx
  802fe4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fe7:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_REMOVE(&u_freelist, ToBeMerged);
  802fea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fee:	75 17                	jne    803007 <free+0x49a>
  802ff0:	83 ec 04             	sub    $0x4,%esp
  802ff3:	68 4f 61 80 00       	push   $0x80614f
  802ff8:	68 10 01 00 00       	push   $0x110
  802ffd:	68 e0 60 80 00       	push   $0x8060e0
  803002:	e8 79 e1 ff ff       	call   801180 <_panic>
  803007:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300a:	8b 40 08             	mov    0x8(%eax),%eax
  80300d:	85 c0                	test   %eax,%eax
  80300f:	74 11                	je     803022 <free+0x4b5>
  803011:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803014:	8b 40 08             	mov    0x8(%eax),%eax
  803017:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80301a:	8b 52 0c             	mov    0xc(%edx),%edx
  80301d:	89 50 0c             	mov    %edx,0xc(%eax)
  803020:	eb 0b                	jmp    80302d <free+0x4c0>
  803022:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803025:	8b 40 0c             	mov    0xc(%eax),%eax
  803028:	a3 24 f1 81 00       	mov    %eax,0x81f124
  80302d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803030:	8b 40 0c             	mov    0xc(%eax),%eax
  803033:	85 c0                	test   %eax,%eax
  803035:	74 11                	je     803048 <free+0x4db>
  803037:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303a:	8b 40 0c             	mov    0xc(%eax),%eax
  80303d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803040:	8b 52 08             	mov    0x8(%edx),%edx
  803043:	89 50 08             	mov    %edx,0x8(%eax)
  803046:	eb 0b                	jmp    803053 <free+0x4e6>
  803048:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304b:	8b 40 08             	mov    0x8(%eax),%eax
  80304e:	a3 20 f1 81 00       	mov    %eax,0x81f120
  803053:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803056:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80305d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803060:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803067:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  80306c:	48                   	dec    %eax
  80306d:	a3 2c f1 81 00       	mov    %eax,0x81f12c
					mergenext = 1;
  803072:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
					break;
  803079:	eb 13                	jmp    80308e <free+0x521>
				}
			}
			ToBeMerged = ToBeMerged->prev_next_info.le_next;
  80307b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307e:	8b 40 08             	mov    0x8(%eax),%eax
  803081:	89 45 ec             	mov    %eax,-0x14(%ebp)
		}


		//check if block is merged with prev ,and find possible merge with next
		ToBeMerged = LIST_FIRST(&u_freelist);
		while(ToBeMerged != NULL){
  803084:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803088:	0f 85 79 fe ff ff    	jne    802f07 <free+0x39a>




			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);
  80308e:	a1 20 f1 81 00       	mov    0x81f120,%eax
  803093:	89 45 e0             	mov    %eax,-0x20(%ebp)

			if(mergeprev || mergenext){
  803096:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80309a:	0f 85 ad 00 00 00    	jne    80314d <free+0x5e0>
  8030a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030a4:	0f 84 c3 01 00 00    	je     80326d <free+0x700>
				while(currentfree != NULL){
  8030aa:	e9 9e 00 00 00       	jmp    80314d <free+0x5e0>
					if(MergedBlock->size < currentfree->size){
  8030af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030b2:	8b 50 04             	mov    0x4(%eax),%edx
  8030b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030b8:	8b 40 04             	mov    0x4(%eax),%eax
  8030bb:	39 c2                	cmp    %eax,%edx
  8030bd:	0f 83 81 00 00 00    	jae    803144 <free+0x5d7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,MergedBlock);
  8030c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030c7:	74 06                	je     8030cf <free+0x562>
  8030c9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8030cd:	75 17                	jne    8030e6 <free+0x579>
  8030cf:	83 ec 04             	sub    $0x4,%esp
  8030d2:	68 70 61 80 00       	push   $0x806170
  8030d7:	68 23 01 00 00       	push   $0x123
  8030dc:	68 e0 60 80 00       	push   $0x8060e0
  8030e1:	e8 9a e0 ff ff       	call   801180 <_panic>
  8030e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030ef:	89 50 0c             	mov    %edx,0xc(%eax)
  8030f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030f8:	89 50 08             	mov    %edx,0x8(%eax)
  8030fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803101:	85 c0                	test   %eax,%eax
  803103:	74 0e                	je     803113 <free+0x5a6>
  803105:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803108:	8b 40 0c             	mov    0xc(%eax),%eax
  80310b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80310e:	89 50 08             	mov    %edx,0x8(%eax)
  803111:	eb 08                	jmp    80311b <free+0x5ae>
  803113:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803116:	a3 20 f1 81 00       	mov    %eax,0x81f120
  80311b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80311e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803121:	89 50 0c             	mov    %edx,0xc(%eax)
  803124:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  803129:	40                   	inc    %eax
  80312a:	a3 2c f1 81 00       	mov    %eax,0x81f12c
							release_uspinlock(&ulock);
  80312f:	83 ec 0c             	sub    $0xc,%esp
  803132:	68 40 f1 81 00       	push   $0x81f140
  803137:	e8 50 1f 00 00       	call   80508c <release_uspinlock>
  80313c:	83 c4 10             	add    $0x10,%esp
							return;
  80313f:	e9 b7 01 00 00       	jmp    8032fb <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  803144:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803147:	8b 40 08             	mov    0x8(%eax),%eax
  80314a:	89 45 e0             	mov    %eax,-0x20(%ebp)

			// insertion
			struct UserHeapStruct* currentfree = LIST_FIRST(&u_freelist);

			if(mergeprev || mergenext){
				while(currentfree != NULL){
  80314d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803151:	0f 85 58 ff ff ff    	jne    8030af <free+0x542>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(newfree);
  803157:	83 ec 0c             	sub    $0xc,%esp
  80315a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80315d:	e8 d5 19 00 00       	call   804b37 <free_block>
  803162:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);
  803165:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  803169:	75 17                	jne    803182 <free+0x615>
  80316b:	83 ec 04             	sub    $0x4,%esp
  80316e:	68 2c 61 80 00       	push   $0x80612c
  803173:	68 2a 01 00 00       	push   $0x12a
  803178:	68 e0 60 80 00       	push   $0x8060e0
  80317d:	e8 fe df ff ff       	call   801180 <_panic>
  803182:	8b 15 24 f1 81 00    	mov    0x81f124,%edx
  803188:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80318b:	89 50 0c             	mov    %edx,0xc(%eax)
  80318e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803191:	8b 40 0c             	mov    0xc(%eax),%eax
  803194:	85 c0                	test   %eax,%eax
  803196:	74 0d                	je     8031a5 <free+0x638>
  803198:	a1 24 f1 81 00       	mov    0x81f124,%eax
  80319d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8031a0:	89 50 08             	mov    %edx,0x8(%eax)
  8031a3:	eb 08                	jmp    8031ad <free+0x640>
  8031a5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031a8:	a3 20 f1 81 00       	mov    %eax,0x81f120
  8031ad:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031b0:	a3 24 f1 81 00       	mov    %eax,0x81f124
  8031b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8031b8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8031bf:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  8031c4:	40                   	inc    %eax
  8031c5:	a3 2c f1 81 00       	mov    %eax,0x81f12c
  8031ca:	e9 1b 01 00 00       	jmp    8032ea <free+0x77d>

			}else{
				while(currentfree != NULL){
					if(newfree->size < currentfree->size){
  8031cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8031d2:	8b 50 04             	mov    0x4(%eax),%edx
  8031d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031d8:	8b 40 04             	mov    0x4(%eax),%eax
  8031db:	39 c2                	cmp    %eax,%edx
  8031dd:	0f 83 81 00 00 00    	jae    803264 <free+0x6f7>

							LIST_INSERT_BEFORE(&u_freelist,currentfree,newfree);
  8031e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031e7:	74 06                	je     8031ef <free+0x682>
  8031e9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8031ed:	75 17                	jne    803206 <free+0x699>
  8031ef:	83 ec 04             	sub    $0x4,%esp
  8031f2:	68 70 61 80 00       	push   $0x806170
  8031f7:	68 30 01 00 00       	push   $0x130
  8031fc:	68 e0 60 80 00       	push   $0x8060e0
  803201:	e8 7a df ff ff       	call   801180 <_panic>
  803206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803209:	8b 50 0c             	mov    0xc(%eax),%edx
  80320c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80320f:	89 50 0c             	mov    %edx,0xc(%eax)
  803212:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803215:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803218:	89 50 08             	mov    %edx,0x8(%eax)
  80321b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80321e:	8b 40 0c             	mov    0xc(%eax),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	74 0e                	je     803233 <free+0x6c6>
  803225:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803228:	8b 40 0c             	mov    0xc(%eax),%eax
  80322b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80322e:	89 50 08             	mov    %edx,0x8(%eax)
  803231:	eb 08                	jmp    80323b <free+0x6ce>
  803233:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803236:	a3 20 f1 81 00       	mov    %eax,0x81f120
  80323b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80323e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803241:	89 50 0c             	mov    %edx,0xc(%eax)
  803244:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  803249:	40                   	inc    %eax
  80324a:	a3 2c f1 81 00       	mov    %eax,0x81f12c
							release_uspinlock(&ulock);
  80324f:	83 ec 0c             	sub    $0xc,%esp
  803252:	68 40 f1 81 00       	push   $0x81f140
  803257:	e8 30 1e 00 00       	call   80508c <release_uspinlock>
  80325c:	83 c4 10             	add    $0x10,%esp
							return;
  80325f:	e9 97 00 00 00       	jmp    8032fb <free+0x78e>
					}
							currentfree = currentfree->prev_next_info.le_next;
  803264:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803267:	8b 40 08             	mov    0x8(%eax),%eax
  80326a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				}
				free_block(newfree);
				LIST_INSERT_TAIL(&u_freelist,MergedBlock);

			}else{
				while(currentfree != NULL){
  80326d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803271:	0f 85 58 ff ff ff    	jne    8031cf <free+0x662>
							release_uspinlock(&ulock);
							return;
					}
							currentfree = currentfree->prev_next_info.le_next;
				}
				free_block(MergedBlock);
  803277:	83 ec 0c             	sub    $0xc,%esp
  80327a:	ff 75 d0             	pushl  -0x30(%ebp)
  80327d:	e8 b5 18 00 00       	call   804b37 <free_block>
  803282:	83 c4 10             	add    $0x10,%esp
				LIST_INSERT_TAIL(&u_freelist,newfree);
  803285:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803289:	75 17                	jne    8032a2 <free+0x735>
  80328b:	83 ec 04             	sub    $0x4,%esp
  80328e:	68 2c 61 80 00       	push   $0x80612c
  803293:	68 37 01 00 00       	push   $0x137
  803298:	68 e0 60 80 00       	push   $0x8060e0
  80329d:	e8 de de ff ff       	call   801180 <_panic>
  8032a2:	8b 15 24 f1 81 00    	mov    0x81f124,%edx
  8032a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032ab:	89 50 0c             	mov    %edx,0xc(%eax)
  8032ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b4:	85 c0                	test   %eax,%eax
  8032b6:	74 0d                	je     8032c5 <free+0x758>
  8032b8:	a1 24 f1 81 00       	mov    0x81f124,%eax
  8032bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8032c0:	89 50 08             	mov    %edx,0x8(%eax)
  8032c3:	eb 08                	jmp    8032cd <free+0x760>
  8032c5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032c8:	a3 20 f1 81 00       	mov    %eax,0x81f120
  8032cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032d0:	a3 24 f1 81 00       	mov    %eax,0x81f124
  8032d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8032d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032df:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  8032e4:	40                   	inc    %eax
  8032e5:	a3 2c f1 81 00       	mov    %eax,0x81f12c
			}
		release_uspinlock(&ulock);
  8032ea:	83 ec 0c             	sub    $0xc,%esp
  8032ed:	68 40 f1 81 00       	push   $0x81f140
  8032f2:	e8 95 1d 00 00       	call   80508c <release_uspinlock>
  8032f7:	83 c4 10             	add    $0x10,%esp
		return;
  8032fa:	90                   	nop
}
  8032fb:	c9                   	leave  
  8032fc:	c3                   	ret    

008032fd <smalloc>:

//=================================
// [3] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8032fd:	55                   	push   %ebp
  8032fe:	89 e5                	mov    %esp,%ebp
  803300:	83 ec 48             	sub    $0x48,%esp
  803303:	8b 45 10             	mov    0x10(%ebp),%eax
  803306:	88 45 c4             	mov    %al,-0x3c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803309:	e8 2d f2 ff ff       	call   80253b <uheap_init>
	if (size == 0) return NULL;
  80330e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803312:	75 0a                	jne    80331e <smalloc+0x21>
  803314:	b8 00 00 00 00       	mov    $0x0,%eax
  803319:	e9 84 05 00 00       	jmp    8038a2 <smalloc+0x5a5>
	//==============================================================
	acquire_uspinlock(&ulock);
  80331e:	83 ec 0c             	sub    $0xc,%esp
  803321:	68 40 f1 81 00       	push   $0x81f140
  803326:	e8 09 1d 00 00       	call   805034 <acquire_uspinlock>
  80332b:	83 c4 10             	add    $0x10,%esp

	struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  80332e:	83 ec 0c             	sub    $0xc,%esp
  803331:	6a 10                	push   $0x10
  803333:	e8 63 13 00 00       	call   80469b <alloc_block>
  803338:	83 c4 10             	add    $0x10,%esp
  80333b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (allocblock == NULL){
  80333e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803342:	75 0a                	jne    80334e <smalloc+0x51>
				return NULL;
  803344:	b8 00 00 00 00       	mov    $0x0,%eax
  803349:	e9 54 05 00 00       	jmp    8038a2 <smalloc+0x5a5>
	}
		size = ROUNDUP(size,PAGE_SIZE);
  80334e:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  803355:	8b 55 0c             	mov    0xc(%ebp),%edx
  803358:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335b:	01 d0                	add    %edx,%eax
  80335d:	48                   	dec    %eax
  80335e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803361:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803364:	ba 00 00 00 00       	mov    $0x0,%edx
  803369:	f7 75 e8             	divl   -0x18(%ebp)
  80336c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80336f:	29 d0                	sub    %edx,%eax
  803371:	89 45 0c             	mov    %eax,0xc(%ebp)
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  803374:	a1 24 f1 81 00       	mov    0x81f124,%eax
  803379:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  80337c:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  803381:	85 c0                	test   %eax,%eax
  803383:	74 0f                	je     803394 <smalloc+0x97>
  803385:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803388:	8b 40 04             	mov    0x4(%eax),%eax
  80338b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80338e:	0f 83 25 01 00 00    	jae    8034b9 <smalloc+0x1bc>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  803394:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  803399:	2b 45 0c             	sub    0xc(%ebp),%eax
  80339c:	89 c2                	mov    %eax,%edx
  80339e:	a1 68 f0 81 00       	mov    0x81f068,%eax
  8033a3:	39 c2                	cmp    %eax,%edx
  8033a5:	0f 82 f4 00 00 00    	jb     80349f <smalloc+0x1a2>
						uint32 requestedblockva = uheapPageAllocBreak;
  8033ab:	a1 68 f0 81 00       	mov    0x81f068,%eax
  8033b0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
						uheapPageAllocBreak+=size;
  8033b3:	8b 15 68 f0 81 00    	mov    0x81f068,%edx
  8033b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033bc:	01 d0                	add    %edx,%eax
  8033be:	a3 68 f0 81 00       	mov    %eax,0x81f068
						allocblock->startva = requestedblockva;
  8033c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8033c9:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  8033cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033d1:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  8033d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033d8:	75 17                	jne    8033f1 <smalloc+0xf4>
  8033da:	83 ec 04             	sub    $0x4,%esp
  8033dd:	68 2c 61 80 00       	push   $0x80612c
  8033e2:	68 57 01 00 00       	push   $0x157
  8033e7:	68 e0 60 80 00       	push   $0x8060e0
  8033ec:	e8 8f dd ff ff       	call   801180 <_panic>
  8033f1:	8b 15 34 f1 81 00    	mov    0x81f134,%edx
  8033f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033fa:	89 50 0c             	mov    %edx,0xc(%eax)
  8033fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803400:	8b 40 0c             	mov    0xc(%eax),%eax
  803403:	85 c0                	test   %eax,%eax
  803405:	74 0d                	je     803414 <smalloc+0x117>
  803407:	a1 34 f1 81 00       	mov    0x81f134,%eax
  80340c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80340f:	89 50 08             	mov    %edx,0x8(%eax)
  803412:	eb 08                	jmp    80341c <smalloc+0x11f>
  803414:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803417:	a3 30 f1 81 00       	mov    %eax,0x81f130
  80341c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80341f:	a3 34 f1 81 00       	mov    %eax,0x81f134
  803424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803427:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80342e:	a1 3c f1 81 00       	mov    0x81f13c,%eax
  803433:	40                   	inc    %eax
  803434:	a3 3c f1 81 00       	mov    %eax,0x81f13c


						int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  803439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343c:	8b 00                	mov    (%eax),%eax
  80343e:	89 c2                	mov    %eax,%edx
  803440:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803444:	52                   	push   %edx
  803445:	50                   	push   %eax
  803446:	ff 75 0c             	pushl  0xc(%ebp)
  803449:	ff 75 08             	pushl  0x8(%ebp)
  80344c:	e8 48 0c 00 00       	call   804099 <sys_create_shared_object>
  803451:	83 c4 10             	add    $0x10,%esp
  803454:	89 45 d0             	mov    %eax,-0x30(%ebp)

						if(result <0){
  803457:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80345b:	79 28                	jns    803485 <smalloc+0x188>
							free_block(allocblock);
  80345d:	83 ec 0c             	sub    $0xc,%esp
  803460:	ff 75 ec             	pushl  -0x14(%ebp)
  803463:	e8 cf 16 00 00       	call   804b37 <free_block>
  803468:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  80346b:	83 ec 0c             	sub    $0xc,%esp
  80346e:	68 40 f1 81 00       	push   $0x81f140
  803473:	e8 14 1c 00 00       	call   80508c <release_uspinlock>
  803478:	83 c4 10             	add    $0x10,%esp
							return NULL;
  80347b:	b8 00 00 00 00       	mov    $0x0,%eax
  803480:	e9 1d 04 00 00       	jmp    8038a2 <smalloc+0x5a5>
						}
						release_uspinlock(&ulock);
  803485:	83 ec 0c             	sub    $0xc,%esp
  803488:	68 40 f1 81 00       	push   $0x81f140
  80348d:	e8 fa 1b 00 00       	call   80508c <release_uspinlock>
  803492:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  803495:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803498:	8b 00                	mov    (%eax),%eax
  80349a:	e9 03 04 00 00       	jmp    8038a2 <smalloc+0x5a5>
				}else{
						release_uspinlock(&ulock);
  80349f:	83 ec 0c             	sub    $0xc,%esp
  8034a2:	68 40 f1 81 00       	push   $0x81f140
  8034a7:	e8 e0 1b 00 00       	call   80508c <release_uspinlock>
  8034ac:	83 c4 10             	add    $0x10,%esp
						return NULL;
  8034af:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b4:	e9 e9 03 00 00       	jmp    8038a2 <smalloc+0x5a5>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  8034b9:	a1 20 f1 81 00       	mov    0x81f120,%eax
  8034be:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  8034c1:	e9 af 03 00 00       	jmp    803875 <smalloc+0x578>
				if(size<currentfreeelement->size){
  8034c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c9:	8b 40 04             	mov    0x4(%eax),%eax
  8034cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034cf:	0f 86 28 02 00 00    	jbe    8036fd <smalloc+0x400>
					allocblock->startva = lastfreeelement->startva;
  8034d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034d8:	8b 10                	mov    (%eax),%edx
  8034da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034dd:	89 10                	mov    %edx,(%eax)
	                allocblock->size = size;
  8034df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034e5:	89 50 04             	mov    %edx,0x4(%eax)
	                LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  8034e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034ec:	75 17                	jne    803505 <smalloc+0x208>
  8034ee:	83 ec 04             	sub    $0x4,%esp
  8034f1:	68 2c 61 80 00       	push   $0x80612c
  8034f6:	68 6f 01 00 00       	push   $0x16f
  8034fb:	68 e0 60 80 00       	push   $0x8060e0
  803500:	e8 7b dc ff ff       	call   801180 <_panic>
  803505:	8b 15 34 f1 81 00    	mov    0x81f134,%edx
  80350b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80350e:	89 50 0c             	mov    %edx,0xc(%eax)
  803511:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803514:	8b 40 0c             	mov    0xc(%eax),%eax
  803517:	85 c0                	test   %eax,%eax
  803519:	74 0d                	je     803528 <smalloc+0x22b>
  80351b:	a1 34 f1 81 00       	mov    0x81f134,%eax
  803520:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803523:	89 50 08             	mov    %edx,0x8(%eax)
  803526:	eb 08                	jmp    803530 <smalloc+0x233>
  803528:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80352b:	a3 30 f1 81 00       	mov    %eax,0x81f130
  803530:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803533:	a3 34 f1 81 00       	mov    %eax,0x81f134
  803538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80353b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803542:	a1 3c f1 81 00       	mov    0x81f13c,%eax
  803547:	40                   	inc    %eax
  803548:	a3 3c f1 81 00       	mov    %eax,0x81f13c
	                lastfreeelement->startva += size;
  80354d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803550:	8b 10                	mov    (%eax),%edx
  803552:	8b 45 0c             	mov    0xc(%ebp),%eax
  803555:	01 c2                	add    %eax,%edx
  803557:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80355a:	89 10                	mov    %edx,(%eax)
	                lastfreeelement->size -= size;
  80355c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80355f:	8b 40 04             	mov    0x4(%eax),%eax
  803562:	2b 45 0c             	sub    0xc(%ebp),%eax
  803565:	89 c2                	mov    %eax,%edx
  803567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80356a:	89 50 04             	mov    %edx,0x4(%eax)
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  80356d:	a1 20 f1 81 00       	mov    0x81f120,%eax
  803572:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                //check order of last element

	                while (currentfree2 != NULL){
  803575:	e9 13 01 00 00       	jmp    80368d <smalloc+0x390>
	                	if(lastfreeelement->size <currentfree2->size){
  80357a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80357d:	8b 50 04             	mov    0x4(%eax),%edx
  803580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803583:	8b 40 04             	mov    0x4(%eax),%eax
  803586:	39 c2                	cmp    %eax,%edx
  803588:	0f 83 f6 00 00 00    	jae    803684 <smalloc+0x387>
	                		LIST_REMOVE(&u_freelist ,lastfreeelement);
  80358e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803592:	75 17                	jne    8035ab <smalloc+0x2ae>
  803594:	83 ec 04             	sub    $0x4,%esp
  803597:	68 4f 61 80 00       	push   $0x80614f
  80359c:	68 77 01 00 00       	push   $0x177
  8035a1:	68 e0 60 80 00       	push   $0x8060e0
  8035a6:	e8 d5 db ff ff       	call   801180 <_panic>
  8035ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ae:	8b 40 08             	mov    0x8(%eax),%eax
  8035b1:	85 c0                	test   %eax,%eax
  8035b3:	74 11                	je     8035c6 <smalloc+0x2c9>
  8035b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035b8:	8b 40 08             	mov    0x8(%eax),%eax
  8035bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035be:	8b 52 0c             	mov    0xc(%edx),%edx
  8035c1:	89 50 0c             	mov    %edx,0xc(%eax)
  8035c4:	eb 0b                	jmp    8035d1 <smalloc+0x2d4>
  8035c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035cc:	a3 24 f1 81 00       	mov    %eax,0x81f124
  8035d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d7:	85 c0                	test   %eax,%eax
  8035d9:	74 11                	je     8035ec <smalloc+0x2ef>
  8035db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035de:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8035e4:	8b 52 08             	mov    0x8(%edx),%edx
  8035e7:	89 50 08             	mov    %edx,0x8(%eax)
  8035ea:	eb 0b                	jmp    8035f7 <smalloc+0x2fa>
  8035ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035ef:	8b 40 08             	mov    0x8(%eax),%eax
  8035f2:	a3 20 f1 81 00       	mov    %eax,0x81f120
  8035f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035fa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803601:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803604:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  80360b:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  803610:	48                   	dec    %eax
  803611:	a3 2c f1 81 00       	mov    %eax,0x81f12c
	                		LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803616:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80361a:	74 06                	je     803622 <smalloc+0x325>
  80361c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803620:	75 17                	jne    803639 <smalloc+0x33c>
  803622:	83 ec 04             	sub    $0x4,%esp
  803625:	68 70 61 80 00       	push   $0x806170
  80362a:	68 78 01 00 00       	push   $0x178
  80362f:	68 e0 60 80 00       	push   $0x8060e0
  803634:	e8 47 db ff ff       	call   801180 <_panic>
  803639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80363c:	8b 50 0c             	mov    0xc(%eax),%edx
  80363f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803642:	89 50 0c             	mov    %edx,0xc(%eax)
  803645:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803648:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80364b:	89 50 08             	mov    %edx,0x8(%eax)
  80364e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803651:	8b 40 0c             	mov    0xc(%eax),%eax
  803654:	85 c0                	test   %eax,%eax
  803656:	74 0e                	je     803666 <smalloc+0x369>
  803658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80365b:	8b 40 0c             	mov    0xc(%eax),%eax
  80365e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803661:	89 50 08             	mov    %edx,0x8(%eax)
  803664:	eb 08                	jmp    80366e <smalloc+0x371>
  803666:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803669:	a3 20 f1 81 00       	mov    %eax,0x81f120
  80366e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803671:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803674:	89 50 0c             	mov    %edx,0xc(%eax)
  803677:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  80367c:	40                   	inc    %eax
  80367d:	a3 2c f1 81 00       	mov    %eax,0x81f12c
	                		break;
  803682:	eb 13                	jmp    803697 <smalloc+0x39a>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
  803684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803687:	8b 40 08             	mov    0x8(%eax),%eax
  80368a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	                lastfreeelement->startva += size;
	                lastfreeelement->size -= size;
	                struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
	                //check order of last element

	                while (currentfree2 != NULL){
  80368d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803691:	0f 85 e3 fe ff ff    	jne    80357a <smalloc+0x27d>
	                	}
	                	currentfree2 = currentfree2->prev_next_info.le_next;
	                }


	                int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  803697:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80369a:	8b 00                	mov    (%eax),%eax
  80369c:	89 c2                	mov    %eax,%edx
  80369e:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  8036a2:	52                   	push   %edx
  8036a3:	50                   	push   %eax
  8036a4:	ff 75 0c             	pushl  0xc(%ebp)
  8036a7:	ff 75 08             	pushl  0x8(%ebp)
  8036aa:	e8 ea 09 00 00       	call   804099 <sys_create_shared_object>
  8036af:	83 c4 10             	add    $0x10,%esp
  8036b2:	89 45 d8             	mov    %eax,-0x28(%ebp)

	                if(result <0){
  8036b5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8036b9:	79 28                	jns    8036e3 <smalloc+0x3e6>
	                	free_block(allocblock);
  8036bb:	83 ec 0c             	sub    $0xc,%esp
  8036be:	ff 75 ec             	pushl  -0x14(%ebp)
  8036c1:	e8 71 14 00 00       	call   804b37 <free_block>
  8036c6:	83 c4 10             	add    $0x10,%esp
	                	release_uspinlock(&ulock);
  8036c9:	83 ec 0c             	sub    $0xc,%esp
  8036cc:	68 40 f1 81 00       	push   $0x81f140
  8036d1:	e8 b6 19 00 00       	call   80508c <release_uspinlock>
  8036d6:	83 c4 10             	add    $0x10,%esp
	                	return NULL;
  8036d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8036de:	e9 bf 01 00 00       	jmp    8038a2 <smalloc+0x5a5>
	                }
	                release_uspinlock(&ulock);
  8036e3:	83 ec 0c             	sub    $0xc,%esp
  8036e6:	68 40 f1 81 00       	push   $0x81f140
  8036eb:	e8 9c 19 00 00       	call   80508c <release_uspinlock>
  8036f0:	83 c4 10             	add    $0x10,%esp
	                return (void*)allocblock->startva;
  8036f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f6:	8b 00                	mov    (%eax),%eax
  8036f8:	e9 a5 01 00 00       	jmp    8038a2 <smalloc+0x5a5>
	                //exact fit
				}else if(size == currentfreeelement->size){
  8036fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803700:	8b 40 04             	mov    0x4(%eax),%eax
  803703:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803706:	0f 85 60 01 00 00    	jne    80386c <smalloc+0x56f>
					allocblock->startva = currentfreeelement->startva;
  80370c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370f:	8b 10                	mov    (%eax),%edx
  803711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803714:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803716:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80371c:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  80371f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803723:	75 17                	jne    80373c <smalloc+0x43f>
  803725:	83 ec 04             	sub    $0x4,%esp
  803728:	68 2c 61 80 00       	push   $0x80612c
  80372d:	68 8c 01 00 00       	push   $0x18c
  803732:	68 e0 60 80 00       	push   $0x8060e0
  803737:	e8 44 da ff ff       	call   801180 <_panic>
  80373c:	8b 15 34 f1 81 00    	mov    0x81f134,%edx
  803742:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803745:	89 50 0c             	mov    %edx,0xc(%eax)
  803748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80374b:	8b 40 0c             	mov    0xc(%eax),%eax
  80374e:	85 c0                	test   %eax,%eax
  803750:	74 0d                	je     80375f <smalloc+0x462>
  803752:	a1 34 f1 81 00       	mov    0x81f134,%eax
  803757:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80375a:	89 50 08             	mov    %edx,0x8(%eax)
  80375d:	eb 08                	jmp    803767 <smalloc+0x46a>
  80375f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803762:	a3 30 f1 81 00       	mov    %eax,0x81f130
  803767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80376a:	a3 34 f1 81 00       	mov    %eax,0x81f134
  80376f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803772:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803779:	a1 3c f1 81 00       	mov    0x81f13c,%eax
  80377e:	40                   	inc    %eax
  80377f:	a3 3c f1 81 00       	mov    %eax,0x81f13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803788:	75 17                	jne    8037a1 <smalloc+0x4a4>
  80378a:	83 ec 04             	sub    $0x4,%esp
  80378d:	68 4f 61 80 00       	push   $0x80614f
  803792:	68 8d 01 00 00       	push   $0x18d
  803797:	68 e0 60 80 00       	push   $0x8060e0
  80379c:	e8 df d9 ff ff       	call   801180 <_panic>
  8037a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a4:	8b 40 08             	mov    0x8(%eax),%eax
  8037a7:	85 c0                	test   %eax,%eax
  8037a9:	74 11                	je     8037bc <smalloc+0x4bf>
  8037ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ae:	8b 40 08             	mov    0x8(%eax),%eax
  8037b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037b4:	8b 52 0c             	mov    0xc(%edx),%edx
  8037b7:	89 50 0c             	mov    %edx,0xc(%eax)
  8037ba:	eb 0b                	jmp    8037c7 <smalloc+0x4ca>
  8037bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c2:	a3 24 f1 81 00       	mov    %eax,0x81f124
  8037c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8037cd:	85 c0                	test   %eax,%eax
  8037cf:	74 11                	je     8037e2 <smalloc+0x4e5>
  8037d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8037d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037da:	8b 52 08             	mov    0x8(%edx),%edx
  8037dd:	89 50 08             	mov    %edx,0x8(%eax)
  8037e0:	eb 0b                	jmp    8037ed <smalloc+0x4f0>
  8037e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e5:	8b 40 08             	mov    0x8(%eax),%eax
  8037e8:	a3 20 f1 81 00       	mov    %eax,0x81f120
  8037ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8037f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803801:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  803806:	48                   	dec    %eax
  803807:	a3 2c f1 81 00       	mov    %eax,0x81f12c
					int result = sys_create_shared_object(sharedVarName ,size ,isWritable ,(void*)allocblock->startva);
  80380c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380f:	8b 00                	mov    (%eax),%eax
  803811:	89 c2                	mov    %eax,%edx
  803813:	0f b6 45 c4          	movzbl -0x3c(%ebp),%eax
  803817:	52                   	push   %edx
  803818:	50                   	push   %eax
  803819:	ff 75 0c             	pushl  0xc(%ebp)
  80381c:	ff 75 08             	pushl  0x8(%ebp)
  80381f:	e8 75 08 00 00       	call   804099 <sys_create_shared_object>
  803824:	83 c4 10             	add    $0x10,%esp
  803827:	89 45 dc             	mov    %eax,-0x24(%ebp)

					if(result <0){
  80382a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80382e:	79 25                	jns    803855 <smalloc+0x558>
						free_block(allocblock);
  803830:	83 ec 0c             	sub    $0xc,%esp
  803833:	ff 75 ec             	pushl  -0x14(%ebp)
  803836:	e8 fc 12 00 00       	call   804b37 <free_block>
  80383b:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  80383e:	83 ec 0c             	sub    $0xc,%esp
  803841:	68 40 f1 81 00       	push   $0x81f140
  803846:	e8 41 18 00 00       	call   80508c <release_uspinlock>
  80384b:	83 c4 10             	add    $0x10,%esp
						return NULL;
  80384e:	b8 00 00 00 00       	mov    $0x0,%eax
  803853:	eb 4d                	jmp    8038a2 <smalloc+0x5a5>
					}
					release_uspinlock(&ulock);
  803855:	83 ec 0c             	sub    $0xc,%esp
  803858:	68 40 f1 81 00       	push   $0x81f140
  80385d:	e8 2a 18 00 00       	call   80508c <release_uspinlock>
  803862:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803865:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803868:	8b 00                	mov    (%eax),%eax
  80386a:	eb 36                	jmp    8038a2 <smalloc+0x5a5>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  80386c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386f:	8b 40 08             	mov    0x8(%eax),%eax
  803872:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  803875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803879:	0f 85 47 fc ff ff    	jne    8034c6 <smalloc+0x1c9>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  80387f:	83 ec 0c             	sub    $0xc,%esp
  803882:	ff 75 ec             	pushl  -0x14(%ebp)
  803885:	e8 ad 12 00 00       	call   804b37 <free_block>
  80388a:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  80388d:	83 ec 0c             	sub    $0xc,%esp
  803890:	68 40 f1 81 00       	push   $0x81f140
  803895:	e8 f2 17 00 00       	call   80508c <release_uspinlock>
  80389a:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80389d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8038a2:	c9                   	leave  
  8038a3:	c3                   	ret    

008038a4 <sget>:

//========================================
// [4] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8038a4:	55                   	push   %ebp
  8038a5:	89 e5                	mov    %esp,%ebp
  8038a7:	83 ec 38             	sub    $0x38,%esp


	 //==============================================================
	 // DON'T CHANGE THIS CODE
	    uheap_init();
  8038aa:	e8 8c ec ff ff       	call   80253b <uheap_init>
	 //==============================================================
	 // Get size of the shared variable from kernel
	acquire_uspinlock(&ulock);
  8038af:	83 ec 0c             	sub    $0xc,%esp
  8038b2:	68 40 f1 81 00       	push   $0x81f140
  8038b7:	e8 78 17 00 00       	call   805034 <acquire_uspinlock>
  8038bc:	83 c4 10             	add    $0x10,%esp


	int size = sys_size_of_shared_object(ownerEnvID ,sharedVarName);
  8038bf:	83 ec 08             	sub    $0x8,%esp
  8038c2:	ff 75 0c             	pushl  0xc(%ebp)
  8038c5:	ff 75 08             	pushl  0x8(%ebp)
  8038c8:	e8 f6 07 00 00       	call   8040c3 <sys_size_of_shared_object>
  8038cd:	83 c4 10             	add    $0x10,%esp
  8038d0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if ( size < 0 ){
  8038d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038d7:	79 1a                	jns    8038f3 <sget+0x4f>
			release_uspinlock(&ulock);
  8038d9:	83 ec 0c             	sub    $0xc,%esp
  8038dc:	68 40 f1 81 00       	push   $0x81f140
  8038e1:	e8 a6 17 00 00       	call   80508c <release_uspinlock>
  8038e6:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8038e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8038ee:	e9 6e 05 00 00       	jmp    803e61 <sget+0x5bd>
		}
		size = ROUNDUP(size,PAGE_SIZE);
  8038f3:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
  8038fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803900:	01 d0                	add    %edx,%eax
  803902:	48                   	dec    %eax
  803903:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  803906:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803909:	ba 00 00 00 00       	mov    $0x0,%edx
  80390e:	f7 75 e8             	divl   -0x18(%ebp)
  803911:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803914:	29 d0                	sub    %edx,%eax
  803916:	89 45 ec             	mov    %eax,-0x14(%ebp)

		struct UserHeapStruct* allocblock = (struct UserHeapStruct*) alloc_block(sizeof(struct UserHeapStruct));
  803919:	83 ec 0c             	sub    $0xc,%esp
  80391c:	6a 10                	push   $0x10
  80391e:	e8 78 0d 00 00       	call   80469b <alloc_block>
  803923:	83 c4 10             	add    $0x10,%esp
  803926:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if (allocblock == NULL){
  803929:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80392d:	75 0a                	jne    803939 <sget+0x95>
			return NULL;
  80392f:	b8 00 00 00 00       	mov    $0x0,%eax
  803934:	e9 28 05 00 00       	jmp    803e61 <sget+0x5bd>
		}
		struct UserHeapStruct* lastfreeelement = LIST_LAST(&u_freelist);
  803939:	a1 24 f1 81 00       	mov    0x81f124,%eax
  80393e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(LIST_SIZE(&u_freelist)==0 || size>lastfreeelement->size){
  803941:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  803946:	85 c0                	test   %eax,%eax
  803948:	74 11                	je     80395b <sget+0xb7>
  80394a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80394d:	8b 50 04             	mov    0x4(%eax),%edx
  803950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803953:	39 c2                	cmp    %eax,%edx
  803955:	0f 83 21 01 00 00    	jae    803a7c <sget+0x1d8>
				if(uheapPageAllocBreak <= USER_HEAP_MAX - size){
  80395b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80395e:	ba 00 00 00 a0       	mov    $0xa0000000,%edx
  803963:	29 c2                	sub    %eax,%edx
  803965:	a1 68 f0 81 00       	mov    0x81f068,%eax
  80396a:	39 c2                	cmp    %eax,%edx
  80396c:	0f 82 f0 00 00 00    	jb     803a62 <sget+0x1be>

						uint32 requestedblockva = uheapPageAllocBreak;
  803972:	a1 68 f0 81 00       	mov    0x81f068,%eax
  803977:	89 45 d0             	mov    %eax,-0x30(%ebp)
						uheapPageAllocBreak+=size;
  80397a:	8b 15 68 f0 81 00    	mov    0x81f068,%edx
  803980:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803983:	01 d0                	add    %edx,%eax
  803985:	a3 68 f0 81 00       	mov    %eax,0x81f068
						allocblock->startva = requestedblockva;
  80398a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80398d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  803990:	89 10                	mov    %edx,(%eax)
						allocblock->size = size;
  803992:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803995:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803998:	89 50 04             	mov    %edx,0x4(%eax)

						LIST_INSERT_TAIL(&u_allocatedlist, allocblock);
  80399b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80399f:	75 17                	jne    8039b8 <sget+0x114>
  8039a1:	83 ec 04             	sub    $0x4,%esp
  8039a4:	68 2c 61 80 00       	push   $0x80612c
  8039a9:	68 c8 01 00 00       	push   $0x1c8
  8039ae:	68 e0 60 80 00       	push   $0x8060e0
  8039b3:	e8 c8 d7 ff ff       	call   801180 <_panic>
  8039b8:	8b 15 34 f1 81 00    	mov    0x81f134,%edx
  8039be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039c1:	89 50 0c             	mov    %edx,0xc(%eax)
  8039c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8039ca:	85 c0                	test   %eax,%eax
  8039cc:	74 0d                	je     8039db <sget+0x137>
  8039ce:	a1 34 f1 81 00       	mov    0x81f134,%eax
  8039d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8039d6:	89 50 08             	mov    %edx,0x8(%eax)
  8039d9:	eb 08                	jmp    8039e3 <sget+0x13f>
  8039db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039de:	a3 30 f1 81 00       	mov    %eax,0x81f130
  8039e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039e6:	a3 34 f1 81 00       	mov    %eax,0x81f134
  8039eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8039ee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8039f5:	a1 3c f1 81 00       	mov    0x81f13c,%eax
  8039fa:	40                   	inc    %eax
  8039fb:	a3 3c f1 81 00       	mov    %eax,0x81f13c


						int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a03:	8b 00                	mov    (%eax),%eax
  803a05:	83 ec 04             	sub    $0x4,%esp
  803a08:	50                   	push   %eax
  803a09:	ff 75 0c             	pushl  0xc(%ebp)
  803a0c:	ff 75 08             	pushl  0x8(%ebp)
  803a0f:	e8 cc 06 00 00       	call   8040e0 <sys_get_shared_object>
  803a14:	83 c4 10             	add    $0x10,%esp
  803a17:	89 45 cc             	mov    %eax,-0x34(%ebp)

						if(result <0){
  803a1a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  803a1e:	79 28                	jns    803a48 <sget+0x1a4>
							free_block(allocblock);
  803a20:	83 ec 0c             	sub    $0xc,%esp
  803a23:	ff 75 e0             	pushl  -0x20(%ebp)
  803a26:	e8 0c 11 00 00       	call   804b37 <free_block>
  803a2b:	83 c4 10             	add    $0x10,%esp
							release_uspinlock(&ulock);
  803a2e:	83 ec 0c             	sub    $0xc,%esp
  803a31:	68 40 f1 81 00       	push   $0x81f140
  803a36:	e8 51 16 00 00       	call   80508c <release_uspinlock>
  803a3b:	83 c4 10             	add    $0x10,%esp
							return NULL;
  803a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  803a43:	e9 19 04 00 00       	jmp    803e61 <sget+0x5bd>
						}
						release_uspinlock(&ulock);
  803a48:	83 ec 0c             	sub    $0xc,%esp
  803a4b:	68 40 f1 81 00       	push   $0x81f140
  803a50:	e8 37 16 00 00       	call   80508c <release_uspinlock>
  803a55:	83 c4 10             	add    $0x10,%esp
						return (void*)allocblock -> startva;
  803a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a5b:	8b 00                	mov    (%eax),%eax
  803a5d:	e9 ff 03 00 00       	jmp    803e61 <sget+0x5bd>
				}else{
						release_uspinlock(&ulock);
  803a62:	83 ec 0c             	sub    $0xc,%esp
  803a65:	68 40 f1 81 00       	push   $0x81f140
  803a6a:	e8 1d 16 00 00       	call   80508c <release_uspinlock>
  803a6f:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803a72:	b8 00 00 00 00       	mov    $0x0,%eax
  803a77:	e9 e5 03 00 00       	jmp    803e61 <sget+0x5bd>
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
  803a7c:	a1 20 f1 81 00       	mov    0x81f120,%eax
  803a81:	89 45 f4             	mov    %eax,-0xc(%ebp)
			//worst fit
			while(currentfreeelement != NULL){
  803a84:	e9 ab 03 00 00       	jmp    803e34 <sget+0x590>
				if(size<currentfreeelement->size){
  803a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8c:	8b 50 04             	mov    0x4(%eax),%edx
  803a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a92:	39 c2                	cmp    %eax,%edx
  803a94:	0f 86 24 02 00 00    	jbe    803cbe <sget+0x41a>
					allocblock->startva = lastfreeelement->startva;
  803a9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803a9d:	8b 10                	mov    (%eax),%edx
  803a9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aa2:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803aa4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803aa7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aaa:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist,allocblock);
  803aad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803ab1:	75 17                	jne    803aca <sget+0x226>
  803ab3:	83 ec 04             	sub    $0x4,%esp
  803ab6:	68 2c 61 80 00       	push   $0x80612c
  803abb:	68 e0 01 00 00       	push   $0x1e0
  803ac0:	68 e0 60 80 00       	push   $0x8060e0
  803ac5:	e8 b6 d6 ff ff       	call   801180 <_panic>
  803aca:	8b 15 34 f1 81 00    	mov    0x81f134,%edx
  803ad0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ad3:	89 50 0c             	mov    %edx,0xc(%eax)
  803ad6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ad9:	8b 40 0c             	mov    0xc(%eax),%eax
  803adc:	85 c0                	test   %eax,%eax
  803ade:	74 0d                	je     803aed <sget+0x249>
  803ae0:	a1 34 f1 81 00       	mov    0x81f134,%eax
  803ae5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803ae8:	89 50 08             	mov    %edx,0x8(%eax)
  803aeb:	eb 08                	jmp    803af5 <sget+0x251>
  803aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803af0:	a3 30 f1 81 00       	mov    %eax,0x81f130
  803af5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803af8:	a3 34 f1 81 00       	mov    %eax,0x81f134
  803afd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803b07:	a1 3c f1 81 00       	mov    0x81f13c,%eax
  803b0c:	40                   	inc    %eax
  803b0d:	a3 3c f1 81 00       	mov    %eax,0x81f13c
					lastfreeelement->startva += size;
  803b12:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b15:	8b 10                	mov    (%eax),%edx
  803b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b1a:	01 c2                	add    %eax,%edx
  803b1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b1f:	89 10                	mov    %edx,(%eax)
					lastfreeelement->size -= size;
  803b21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b24:	8b 50 04             	mov    0x4(%eax),%edx
  803b27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b2a:	29 c2                	sub    %eax,%edx
  803b2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b2f:	89 50 04             	mov    %edx,0x4(%eax)
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
  803b32:	a1 20 f1 81 00       	mov    0x81f120,%eax
  803b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
					//check order of last element

					while (currentfree2 != NULL){
  803b3a:	e9 13 01 00 00       	jmp    803c52 <sget+0x3ae>
						if(lastfreeelement->size <currentfree2->size){
  803b3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b42:	8b 50 04             	mov    0x4(%eax),%edx
  803b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b48:	8b 40 04             	mov    0x4(%eax),%eax
  803b4b:	39 c2                	cmp    %eax,%edx
  803b4d:	0f 83 f6 00 00 00    	jae    803c49 <sget+0x3a5>
							LIST_REMOVE(&u_freelist ,lastfreeelement);
  803b53:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803b57:	75 17                	jne    803b70 <sget+0x2cc>
  803b59:	83 ec 04             	sub    $0x4,%esp
  803b5c:	68 4f 61 80 00       	push   $0x80614f
  803b61:	68 e8 01 00 00       	push   $0x1e8
  803b66:	68 e0 60 80 00       	push   $0x8060e0
  803b6b:	e8 10 d6 ff ff       	call   801180 <_panic>
  803b70:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b73:	8b 40 08             	mov    0x8(%eax),%eax
  803b76:	85 c0                	test   %eax,%eax
  803b78:	74 11                	je     803b8b <sget+0x2e7>
  803b7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b7d:	8b 40 08             	mov    0x8(%eax),%eax
  803b80:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803b83:	8b 52 0c             	mov    0xc(%edx),%edx
  803b86:	89 50 0c             	mov    %edx,0xc(%eax)
  803b89:	eb 0b                	jmp    803b96 <sget+0x2f2>
  803b8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b8e:	8b 40 0c             	mov    0xc(%eax),%eax
  803b91:	a3 24 f1 81 00       	mov    %eax,0x81f124
  803b96:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b99:	8b 40 0c             	mov    0xc(%eax),%eax
  803b9c:	85 c0                	test   %eax,%eax
  803b9e:	74 11                	je     803bb1 <sget+0x30d>
  803ba0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803ba3:	8b 40 0c             	mov    0xc(%eax),%eax
  803ba6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ba9:	8b 52 08             	mov    0x8(%edx),%edx
  803bac:	89 50 08             	mov    %edx,0x8(%eax)
  803baf:	eb 0b                	jmp    803bbc <sget+0x318>
  803bb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bb4:	8b 40 08             	mov    0x8(%eax),%eax
  803bb7:	a3 20 f1 81 00       	mov    %eax,0x81f120
  803bbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bbf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803bc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803bc9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803bd0:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  803bd5:	48                   	dec    %eax
  803bd6:	a3 2c f1 81 00       	mov    %eax,0x81f12c
							LIST_INSERT_BEFORE(&u_freelist ,currentfree2 ,lastfreeelement);
  803bdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803bdf:	74 06                	je     803be7 <sget+0x343>
  803be1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803be5:	75 17                	jne    803bfe <sget+0x35a>
  803be7:	83 ec 04             	sub    $0x4,%esp
  803bea:	68 70 61 80 00       	push   $0x806170
  803bef:	68 e9 01 00 00       	push   $0x1e9
  803bf4:	68 e0 60 80 00       	push   $0x8060e0
  803bf9:	e8 82 d5 ff ff       	call   801180 <_panic>
  803bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c01:	8b 50 0c             	mov    0xc(%eax),%edx
  803c04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c07:	89 50 0c             	mov    %edx,0xc(%eax)
  803c0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c10:	89 50 08             	mov    %edx,0x8(%eax)
  803c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c16:	8b 40 0c             	mov    0xc(%eax),%eax
  803c19:	85 c0                	test   %eax,%eax
  803c1b:	74 0e                	je     803c2b <sget+0x387>
  803c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c20:	8b 40 0c             	mov    0xc(%eax),%eax
  803c23:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c26:	89 50 08             	mov    %edx,0x8(%eax)
  803c29:	eb 08                	jmp    803c33 <sget+0x38f>
  803c2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803c2e:	a3 20 f1 81 00       	mov    %eax,0x81f120
  803c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c36:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803c39:	89 50 0c             	mov    %edx,0xc(%eax)
  803c3c:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  803c41:	40                   	inc    %eax
  803c42:	a3 2c f1 81 00       	mov    %eax,0x81f12c
							break;
  803c47:	eb 13                	jmp    803c5c <sget+0x3b8>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
  803c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c4c:	8b 40 08             	mov    0x8(%eax),%eax
  803c4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					lastfreeelement->startva += size;
					lastfreeelement->size -= size;
					struct UserHeapStruct* currentfree2 = LIST_FIRST(&u_freelist);
					//check order of last element

					while (currentfree2 != NULL){
  803c52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803c56:	0f 85 e3 fe ff ff    	jne    803b3f <sget+0x29b>
						}
						currentfree2 = currentfree2->prev_next_info.le_next;
					}


					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803c5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c5f:	8b 00                	mov    (%eax),%eax
  803c61:	83 ec 04             	sub    $0x4,%esp
  803c64:	50                   	push   %eax
  803c65:	ff 75 0c             	pushl  0xc(%ebp)
  803c68:	ff 75 08             	pushl  0x8(%ebp)
  803c6b:	e8 70 04 00 00       	call   8040e0 <sys_get_shared_object>
  803c70:	83 c4 10             	add    $0x10,%esp
  803c73:	89 45 d4             	mov    %eax,-0x2c(%ebp)

					if(result <0){
  803c76:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  803c7a:	79 28                	jns    803ca4 <sget+0x400>
						free_block(allocblock);
  803c7c:	83 ec 0c             	sub    $0xc,%esp
  803c7f:	ff 75 e0             	pushl  -0x20(%ebp)
  803c82:	e8 b0 0e 00 00       	call   804b37 <free_block>
  803c87:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803c8a:	83 ec 0c             	sub    $0xc,%esp
  803c8d:	68 40 f1 81 00       	push   $0x81f140
  803c92:	e8 f5 13 00 00       	call   80508c <release_uspinlock>
  803c97:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803c9a:	b8 00 00 00 00       	mov    $0x0,%eax
  803c9f:	e9 bd 01 00 00       	jmp    803e61 <sget+0x5bd>
					}
					release_uspinlock(&ulock);
  803ca4:	83 ec 0c             	sub    $0xc,%esp
  803ca7:	68 40 f1 81 00       	push   $0x81f140
  803cac:	e8 db 13 00 00       	call   80508c <release_uspinlock>
  803cb1:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803cb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cb7:	8b 00                	mov    (%eax),%eax
  803cb9:	e9 a3 01 00 00       	jmp    803e61 <sget+0x5bd>
					//exact fit
				}else if(size == currentfreeelement->size){
  803cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc1:	8b 50 04             	mov    0x4(%eax),%edx
  803cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803cc7:	39 c2                	cmp    %eax,%edx
  803cc9:	0f 85 5c 01 00 00    	jne    803e2b <sget+0x587>

					allocblock->startva = currentfreeelement->startva;
  803ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd2:	8b 10                	mov    (%eax),%edx
  803cd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cd7:	89 10                	mov    %edx,(%eax)
					allocblock->size = size;
  803cd9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803cdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803cdf:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_INSERT_TAIL(&u_allocatedlist ,allocblock);
  803ce2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803ce6:	75 17                	jne    803cff <sget+0x45b>
  803ce8:	83 ec 04             	sub    $0x4,%esp
  803ceb:	68 2c 61 80 00       	push   $0x80612c
  803cf0:	68 fe 01 00 00       	push   $0x1fe
  803cf5:	68 e0 60 80 00       	push   $0x8060e0
  803cfa:	e8 81 d4 ff ff       	call   801180 <_panic>
  803cff:	8b 15 34 f1 81 00    	mov    0x81f134,%edx
  803d05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d08:	89 50 0c             	mov    %edx,0xc(%eax)
  803d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d0e:	8b 40 0c             	mov    0xc(%eax),%eax
  803d11:	85 c0                	test   %eax,%eax
  803d13:	74 0d                	je     803d22 <sget+0x47e>
  803d15:	a1 34 f1 81 00       	mov    0x81f134,%eax
  803d1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d1d:	89 50 08             	mov    %edx,0x8(%eax)
  803d20:	eb 08                	jmp    803d2a <sget+0x486>
  803d22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d25:	a3 30 f1 81 00       	mov    %eax,0x81f130
  803d2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d2d:	a3 34 f1 81 00       	mov    %eax,0x81f134
  803d32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803d3c:	a1 3c f1 81 00       	mov    0x81f13c,%eax
  803d41:	40                   	inc    %eax
  803d42:	a3 3c f1 81 00       	mov    %eax,0x81f13c
					LIST_REMOVE(&u_freelist ,currentfreeelement);
  803d47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d4b:	75 17                	jne    803d64 <sget+0x4c0>
  803d4d:	83 ec 04             	sub    $0x4,%esp
  803d50:	68 4f 61 80 00       	push   $0x80614f
  803d55:	68 ff 01 00 00       	push   $0x1ff
  803d5a:	68 e0 60 80 00       	push   $0x8060e0
  803d5f:	e8 1c d4 ff ff       	call   801180 <_panic>
  803d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d67:	8b 40 08             	mov    0x8(%eax),%eax
  803d6a:	85 c0                	test   %eax,%eax
  803d6c:	74 11                	je     803d7f <sget+0x4db>
  803d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d71:	8b 40 08             	mov    0x8(%eax),%eax
  803d74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d77:	8b 52 0c             	mov    0xc(%edx),%edx
  803d7a:	89 50 0c             	mov    %edx,0xc(%eax)
  803d7d:	eb 0b                	jmp    803d8a <sget+0x4e6>
  803d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d82:	8b 40 0c             	mov    0xc(%eax),%eax
  803d85:	a3 24 f1 81 00       	mov    %eax,0x81f124
  803d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d8d:	8b 40 0c             	mov    0xc(%eax),%eax
  803d90:	85 c0                	test   %eax,%eax
  803d92:	74 11                	je     803da5 <sget+0x501>
  803d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d97:	8b 40 0c             	mov    0xc(%eax),%eax
  803d9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d9d:	8b 52 08             	mov    0x8(%edx),%edx
  803da0:	89 50 08             	mov    %edx,0x8(%eax)
  803da3:	eb 0b                	jmp    803db0 <sget+0x50c>
  803da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da8:	8b 40 08             	mov    0x8(%eax),%eax
  803dab:	a3 20 f1 81 00       	mov    %eax,0x81f120
  803db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803dbd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  803dc4:	a1 2c f1 81 00       	mov    0x81f12c,%eax
  803dc9:	48                   	dec    %eax
  803dca:	a3 2c f1 81 00       	mov    %eax,0x81f12c

					int result = sys_get_shared_object(ownerEnvID ,sharedVarName ,(void*)allocblock->startva);
  803dcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803dd2:	8b 00                	mov    (%eax),%eax
  803dd4:	83 ec 04             	sub    $0x4,%esp
  803dd7:	50                   	push   %eax
  803dd8:	ff 75 0c             	pushl  0xc(%ebp)
  803ddb:	ff 75 08             	pushl  0x8(%ebp)
  803dde:	e8 fd 02 00 00       	call   8040e0 <sys_get_shared_object>
  803de3:	83 c4 10             	add    $0x10,%esp
  803de6:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(result <0){
  803de9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803ded:	79 25                	jns    803e14 <sget+0x570>
						free_block(allocblock);
  803def:	83 ec 0c             	sub    $0xc,%esp
  803df2:	ff 75 e0             	pushl  -0x20(%ebp)
  803df5:	e8 3d 0d 00 00       	call   804b37 <free_block>
  803dfa:	83 c4 10             	add    $0x10,%esp
						release_uspinlock(&ulock);
  803dfd:	83 ec 0c             	sub    $0xc,%esp
  803e00:	68 40 f1 81 00       	push   $0x81f140
  803e05:	e8 82 12 00 00       	call   80508c <release_uspinlock>
  803e0a:	83 c4 10             	add    $0x10,%esp
						return NULL;
  803e0d:	b8 00 00 00 00       	mov    $0x0,%eax
  803e12:	eb 4d                	jmp    803e61 <sget+0x5bd>
					}

					release_uspinlock(&ulock);
  803e14:	83 ec 0c             	sub    $0xc,%esp
  803e17:	68 40 f1 81 00       	push   $0x81f140
  803e1c:	e8 6b 12 00 00       	call   80508c <release_uspinlock>
  803e21:	83 c4 10             	add    $0x10,%esp
					return (void*)allocblock->startva;
  803e24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803e27:	8b 00                	mov    (%eax),%eax
  803e29:	eb 36                	jmp    803e61 <sget+0x5bd>
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
  803e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e2e:	8b 40 08             	mov    0x8(%eax),%eax
  803e31:	89 45 f4             	mov    %eax,-0xc(%ebp)
					 }
		}else{
			//custom fit
			struct UserHeapStruct* currentfreeelement = LIST_FIRST(&u_freelist);
			//worst fit
			while(currentfreeelement != NULL){
  803e34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e38:	0f 85 4b fc ff ff    	jne    803a89 <sget+0x1e5>
					return (void*)allocblock->startva;
				}
				currentfreeelement = currentfreeelement->prev_next_info.le_next;
			}
		}
		free_block(allocblock);
  803e3e:	83 ec 0c             	sub    $0xc,%esp
  803e41:	ff 75 e0             	pushl  -0x20(%ebp)
  803e44:	e8 ee 0c 00 00       	call   804b37 <free_block>
  803e49:	83 c4 10             	add    $0x10,%esp
		release_uspinlock(&ulock);
  803e4c:	83 ec 0c             	sub    $0xc,%esp
  803e4f:	68 40 f1 81 00       	push   $0x81f140
  803e54:	e8 33 12 00 00       	call   80508c <release_uspinlock>
  803e59:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803e5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803e61:	c9                   	leave  
  803e62:	c3                   	ret    

00803e63 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  803e63:	55                   	push   %ebp
  803e64:	89 e5                	mov    %esp,%ebp
  803e66:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	uheap_init();
  803e69:	e8 cd e6 ff ff       	call   80253b <uheap_init>
	//==============================================================
	panic("realloc() is not implemented yet...!!");
  803e6e:	83 ec 04             	sub    $0x4,%esp
  803e71:	68 00 62 80 00       	push   $0x806200
  803e76:	68 2d 02 00 00       	push   $0x22d
  803e7b:	68 e0 60 80 00       	push   $0x8060e0
  803e80:	e8 fb d2 ff ff       	call   801180 <_panic>

00803e85 <sfree>:
//
//	use sys_delete_shared_object(...); which switches to the kernel mode,
//	calls delete_shared_object(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the delete_shared_object() function is empty, make sure to implement it.
void sfree(void* virtual_address)
{
  803e85:	55                   	push   %ebp
  803e86:	89 e5                	mov    %esp,%ebp
  803e88:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#5] EXIT #2 - sfree
	//Your code is here
	//Comment the following line
	panic("sfree() is not implemented yet...!!");
  803e8b:	83 ec 04             	sub    $0x4,%esp
  803e8e:	68 28 62 80 00       	push   $0x806228
  803e93:	68 40 02 00 00       	push   $0x240
  803e98:	68 e0 60 80 00       	push   $0x8060e0
  803e9d:	e8 de d2 ff ff       	call   801180 <_panic>

00803ea2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  803ea2:	55                   	push   %ebp
  803ea3:	89 e5                	mov    %esp,%ebp
  803ea5:	57                   	push   %edi
  803ea6:	56                   	push   %esi
  803ea7:	53                   	push   %ebx
  803ea8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803eab:	8b 45 08             	mov    0x8(%ebp),%eax
  803eae:	8b 55 0c             	mov    0xc(%ebp),%edx
  803eb1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803eb4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803eb7:	8b 7d 18             	mov    0x18(%ebp),%edi
  803eba:	8b 75 1c             	mov    0x1c(%ebp),%esi
  803ebd:	cd 30                	int    $0x30
  803ebf:	89 45 f0             	mov    %eax,-0x10(%ebp)
				"b" (a3),
				"D" (a4),
				"S" (a5)
				: "cc", "memory");

	return ret;
  803ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  803ec5:	83 c4 10             	add    $0x10,%esp
  803ec8:	5b                   	pop    %ebx
  803ec9:	5e                   	pop    %esi
  803eca:	5f                   	pop    %edi
  803ecb:	5d                   	pop    %ebp
  803ecc:	c3                   	ret    

00803ecd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName, int color)
{
  803ecd:	55                   	push   %ebp
  803ece:	89 e5                	mov    %esp,%ebp
  803ed0:	83 ec 04             	sub    $0x4,%esp
  803ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  803ed6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, color, 0);
  803ed9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803edc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  803ee3:	6a 00                	push   $0x0
  803ee5:	51                   	push   %ecx
  803ee6:	52                   	push   %edx
  803ee7:	ff 75 0c             	pushl  0xc(%ebp)
  803eea:	50                   	push   %eax
  803eeb:	6a 00                	push   $0x0
  803eed:	e8 b0 ff ff ff       	call   803ea2 <syscall>
  803ef2:	83 c4 18             	add    $0x18,%esp
}
  803ef5:	90                   	nop
  803ef6:	c9                   	leave  
  803ef7:	c3                   	ret    

00803ef8 <sys_cgetc>:

int
sys_cgetc(void)
{
  803ef8:	55                   	push   %ebp
  803ef9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  803efb:	6a 00                	push   $0x0
  803efd:	6a 00                	push   $0x0
  803eff:	6a 00                	push   $0x0
  803f01:	6a 00                	push   $0x0
  803f03:	6a 00                	push   $0x0
  803f05:	6a 02                	push   $0x2
  803f07:	e8 96 ff ff ff       	call   803ea2 <syscall>
  803f0c:	83 c4 18             	add    $0x18,%esp
}
  803f0f:	c9                   	leave  
  803f10:	c3                   	ret    

00803f11 <sys_lock_cons>:

void sys_lock_cons(void)
{
  803f11:	55                   	push   %ebp
  803f12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  803f14:	6a 00                	push   $0x0
  803f16:	6a 00                	push   $0x0
  803f18:	6a 00                	push   $0x0
  803f1a:	6a 00                	push   $0x0
  803f1c:	6a 00                	push   $0x0
  803f1e:	6a 03                	push   $0x3
  803f20:	e8 7d ff ff ff       	call   803ea2 <syscall>
  803f25:	83 c4 18             	add    $0x18,%esp
}
  803f28:	90                   	nop
  803f29:	c9                   	leave  
  803f2a:	c3                   	ret    

00803f2b <sys_unlock_cons>:
void sys_unlock_cons(void)
{
  803f2b:	55                   	push   %ebp
  803f2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  803f2e:	6a 00                	push   $0x0
  803f30:	6a 00                	push   $0x0
  803f32:	6a 00                	push   $0x0
  803f34:	6a 00                	push   $0x0
  803f36:	6a 00                	push   $0x0
  803f38:	6a 04                	push   $0x4
  803f3a:	e8 63 ff ff ff       	call   803ea2 <syscall>
  803f3f:	83 c4 18             	add    $0x18,%esp
}
  803f42:	90                   	nop
  803f43:	c9                   	leave  
  803f44:	c3                   	ret    

00803f45 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  803f45:	55                   	push   %ebp
  803f46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  803f48:	8b 55 0c             	mov    0xc(%ebp),%edx
  803f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4e:	6a 00                	push   $0x0
  803f50:	6a 00                	push   $0x0
  803f52:	6a 00                	push   $0x0
  803f54:	52                   	push   %edx
  803f55:	50                   	push   %eax
  803f56:	6a 08                	push   $0x8
  803f58:	e8 45 ff ff ff       	call   803ea2 <syscall>
  803f5d:	83 c4 18             	add    $0x18,%esp
}
  803f60:	c9                   	leave  
  803f61:	c3                   	ret    

00803f62 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  803f62:	55                   	push   %ebp
  803f63:	89 e5                	mov    %esp,%ebp
  803f65:	56                   	push   %esi
  803f66:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  803f67:	8b 75 18             	mov    0x18(%ebp),%esi
  803f6a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803f6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803f70:	8b 55 0c             	mov    0xc(%ebp),%edx
  803f73:	8b 45 08             	mov    0x8(%ebp),%eax
  803f76:	56                   	push   %esi
  803f77:	53                   	push   %ebx
  803f78:	51                   	push   %ecx
  803f79:	52                   	push   %edx
  803f7a:	50                   	push   %eax
  803f7b:	6a 09                	push   $0x9
  803f7d:	e8 20 ff ff ff       	call   803ea2 <syscall>
  803f82:	83 c4 18             	add    $0x18,%esp
}
  803f85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  803f88:	5b                   	pop    %ebx
  803f89:	5e                   	pop    %esi
  803f8a:	5d                   	pop    %ebp
  803f8b:	c3                   	ret    

00803f8c <__sys_unmap_frame>:

int __sys_unmap_frame(uint32 va)
{
  803f8c:	55                   	push   %ebp
  803f8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, va, 0, 0, 0, 0);
  803f8f:	6a 00                	push   $0x0
  803f91:	6a 00                	push   $0x0
  803f93:	6a 00                	push   $0x0
  803f95:	6a 00                	push   $0x0
  803f97:	ff 75 08             	pushl  0x8(%ebp)
  803f9a:	6a 0a                	push   $0xa
  803f9c:	e8 01 ff ff ff       	call   803ea2 <syscall>
  803fa1:	83 c4 18             	add    $0x18,%esp
}
  803fa4:	c9                   	leave  
  803fa5:	c3                   	ret    

00803fa6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  803fa6:	55                   	push   %ebp
  803fa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  803fa9:	6a 00                	push   $0x0
  803fab:	6a 00                	push   $0x0
  803fad:	6a 00                	push   $0x0
  803faf:	ff 75 0c             	pushl  0xc(%ebp)
  803fb2:	ff 75 08             	pushl  0x8(%ebp)
  803fb5:	6a 0b                	push   $0xb
  803fb7:	e8 e6 fe ff ff       	call   803ea2 <syscall>
  803fbc:	83 c4 18             	add    $0x18,%esp
}
  803fbf:	c9                   	leave  
  803fc0:	c3                   	ret    

00803fc1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  803fc1:	55                   	push   %ebp
  803fc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  803fc4:	6a 00                	push   $0x0
  803fc6:	6a 00                	push   $0x0
  803fc8:	6a 00                	push   $0x0
  803fca:	6a 00                	push   $0x0
  803fcc:	6a 00                	push   $0x0
  803fce:	6a 0c                	push   $0xc
  803fd0:	e8 cd fe ff ff       	call   803ea2 <syscall>
  803fd5:	83 c4 18             	add    $0x18,%esp
}
  803fd8:	c9                   	leave  
  803fd9:	c3                   	ret    

00803fda <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  803fda:	55                   	push   %ebp
  803fdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803fdd:	6a 00                	push   $0x0
  803fdf:	6a 00                	push   $0x0
  803fe1:	6a 00                	push   $0x0
  803fe3:	6a 00                	push   $0x0
  803fe5:	6a 00                	push   $0x0
  803fe7:	6a 0d                	push   $0xd
  803fe9:	e8 b4 fe ff ff       	call   803ea2 <syscall>
  803fee:	83 c4 18             	add    $0x18,%esp
}
  803ff1:	c9                   	leave  
  803ff2:	c3                   	ret    

00803ff3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  803ff3:	55                   	push   %ebp
  803ff4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803ff6:	6a 00                	push   $0x0
  803ff8:	6a 00                	push   $0x0
  803ffa:	6a 00                	push   $0x0
  803ffc:	6a 00                	push   $0x0
  803ffe:	6a 00                	push   $0x0
  804000:	6a 0e                	push   $0xe
  804002:	e8 9b fe ff ff       	call   803ea2 <syscall>
  804007:	83 c4 18             	add    $0x18,%esp
}
  80400a:	c9                   	leave  
  80400b:	c3                   	ret    

0080400c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80400c:	55                   	push   %ebp
  80400d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80400f:	6a 00                	push   $0x0
  804011:	6a 00                	push   $0x0
  804013:	6a 00                	push   $0x0
  804015:	6a 00                	push   $0x0
  804017:	6a 00                	push   $0x0
  804019:	6a 0f                	push   $0xf
  80401b:	e8 82 fe ff ff       	call   803ea2 <syscall>
  804020:	83 c4 18             	add    $0x18,%esp
}
  804023:	c9                   	leave  
  804024:	c3                   	ret    

00804025 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  804025:	55                   	push   %ebp
  804026:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  804028:	6a 00                	push   $0x0
  80402a:	6a 00                	push   $0x0
  80402c:	6a 00                	push   $0x0
  80402e:	6a 00                	push   $0x0
  804030:	ff 75 08             	pushl  0x8(%ebp)
  804033:	6a 10                	push   $0x10
  804035:	e8 68 fe ff ff       	call   803ea2 <syscall>
  80403a:	83 c4 18             	add    $0x18,%esp
}
  80403d:	c9                   	leave  
  80403e:	c3                   	ret    

0080403f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80403f:	55                   	push   %ebp
  804040:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  804042:	6a 00                	push   $0x0
  804044:	6a 00                	push   $0x0
  804046:	6a 00                	push   $0x0
  804048:	6a 00                	push   $0x0
  80404a:	6a 00                	push   $0x0
  80404c:	6a 11                	push   $0x11
  80404e:	e8 4f fe ff ff       	call   803ea2 <syscall>
  804053:	83 c4 18             	add    $0x18,%esp
}
  804056:	90                   	nop
  804057:	c9                   	leave  
  804058:	c3                   	ret    

00804059 <sys_cputc>:

void
sys_cputc(const char c)
{
  804059:	55                   	push   %ebp
  80405a:	89 e5                	mov    %esp,%ebp
  80405c:	83 ec 04             	sub    $0x4,%esp
  80405f:	8b 45 08             	mov    0x8(%ebp),%eax
  804062:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  804065:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  804069:	6a 00                	push   $0x0
  80406b:	6a 00                	push   $0x0
  80406d:	6a 00                	push   $0x0
  80406f:	6a 00                	push   $0x0
  804071:	50                   	push   %eax
  804072:	6a 01                	push   $0x1
  804074:	e8 29 fe ff ff       	call   803ea2 <syscall>
  804079:	83 c4 18             	add    $0x18,%esp
}
  80407c:	90                   	nop
  80407d:	c9                   	leave  
  80407e:	c3                   	ret    

0080407f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80407f:	55                   	push   %ebp
  804080:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  804082:	6a 00                	push   $0x0
  804084:	6a 00                	push   $0x0
  804086:	6a 00                	push   $0x0
  804088:	6a 00                	push   $0x0
  80408a:	6a 00                	push   $0x0
  80408c:	6a 14                	push   $0x14
  80408e:	e8 0f fe ff ff       	call   803ea2 <syscall>
  804093:	83 c4 18             	add    $0x18,%esp
}
  804096:	90                   	nop
  804097:	c9                   	leave  
  804098:	c3                   	ret    

00804099 <sys_create_shared_object>:

int sys_create_shared_object(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  804099:	55                   	push   %ebp
  80409a:	89 e5                	mov    %esp,%ebp
  80409c:	83 ec 04             	sub    $0x4,%esp
  80409f:	8b 45 10             	mov    0x10(%ebp),%eax
  8040a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8040a5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8040a8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8040ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8040af:	6a 00                	push   $0x0
  8040b1:	51                   	push   %ecx
  8040b2:	52                   	push   %edx
  8040b3:	ff 75 0c             	pushl  0xc(%ebp)
  8040b6:	50                   	push   %eax
  8040b7:	6a 15                	push   $0x15
  8040b9:	e8 e4 fd ff ff       	call   803ea2 <syscall>
  8040be:	83 c4 18             	add    $0x18,%esp
}
  8040c1:	c9                   	leave  
  8040c2:	c3                   	ret    

008040c3 <sys_size_of_shared_object>:

//2017:
int sys_size_of_shared_object(int32 ownerID, char* shareName)
{
  8040c3:	55                   	push   %ebp
  8040c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8040c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8040c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8040cc:	6a 00                	push   $0x0
  8040ce:	6a 00                	push   $0x0
  8040d0:	6a 00                	push   $0x0
  8040d2:	52                   	push   %edx
  8040d3:	50                   	push   %eax
  8040d4:	6a 16                	push   $0x16
  8040d6:	e8 c7 fd ff ff       	call   803ea2 <syscall>
  8040db:	83 c4 18             	add    $0x18,%esp
}
  8040de:	c9                   	leave  
  8040df:	c3                   	ret    

008040e0 <sys_get_shared_object>:
//==========

int sys_get_shared_object(int32 ownerID, char* shareName, void* virtual_address)
{
  8040e0:	55                   	push   %ebp
  8040e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8040e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8040e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8040e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ec:	6a 00                	push   $0x0
  8040ee:	6a 00                	push   $0x0
  8040f0:	51                   	push   %ecx
  8040f1:	52                   	push   %edx
  8040f2:	50                   	push   %eax
  8040f3:	6a 17                	push   $0x17
  8040f5:	e8 a8 fd ff ff       	call   803ea2 <syscall>
  8040fa:	83 c4 18             	add    $0x18,%esp
}
  8040fd:	c9                   	leave  
  8040fe:	c3                   	ret    

008040ff <sys_delete_shared_object>:

int sys_delete_shared_object(int32 sharedObjectID, void *startVA)
{
  8040ff:	55                   	push   %ebp
  804100:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  804102:	8b 55 0c             	mov    0xc(%ebp),%edx
  804105:	8b 45 08             	mov    0x8(%ebp),%eax
  804108:	6a 00                	push   $0x0
  80410a:	6a 00                	push   $0x0
  80410c:	6a 00                	push   $0x0
  80410e:	52                   	push   %edx
  80410f:	50                   	push   %eax
  804110:	6a 18                	push   $0x18
  804112:	e8 8b fd ff ff       	call   803ea2 <syscall>
  804117:	83 c4 18             	add    $0x18,%esp
}
  80411a:	c9                   	leave  
  80411b:	c3                   	ret    

0080411c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80411c:	55                   	push   %ebp
  80411d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80411f:	8b 45 08             	mov    0x8(%ebp),%eax
  804122:	6a 00                	push   $0x0
  804124:	ff 75 14             	pushl  0x14(%ebp)
  804127:	ff 75 10             	pushl  0x10(%ebp)
  80412a:	ff 75 0c             	pushl  0xc(%ebp)
  80412d:	50                   	push   %eax
  80412e:	6a 19                	push   $0x19
  804130:	e8 6d fd ff ff       	call   803ea2 <syscall>
  804135:	83 c4 18             	add    $0x18,%esp
}
  804138:	c9                   	leave  
  804139:	c3                   	ret    

0080413a <sys_run_env>:

void sys_run_env(int32 envId)
{
  80413a:	55                   	push   %ebp
  80413b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80413d:	8b 45 08             	mov    0x8(%ebp),%eax
  804140:	6a 00                	push   $0x0
  804142:	6a 00                	push   $0x0
  804144:	6a 00                	push   $0x0
  804146:	6a 00                	push   $0x0
  804148:	50                   	push   %eax
  804149:	6a 1a                	push   $0x1a
  80414b:	e8 52 fd ff ff       	call   803ea2 <syscall>
  804150:	83 c4 18             	add    $0x18,%esp
}
  804153:	90                   	nop
  804154:	c9                   	leave  
  804155:	c3                   	ret    

00804156 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  804156:	55                   	push   %ebp
  804157:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  804159:	8b 45 08             	mov    0x8(%ebp),%eax
  80415c:	6a 00                	push   $0x0
  80415e:	6a 00                	push   $0x0
  804160:	6a 00                	push   $0x0
  804162:	6a 00                	push   $0x0
  804164:	50                   	push   %eax
  804165:	6a 1b                	push   $0x1b
  804167:	e8 36 fd ff ff       	call   803ea2 <syscall>
  80416c:	83 c4 18             	add    $0x18,%esp
}
  80416f:	c9                   	leave  
  804170:	c3                   	ret    

00804171 <sys_getenvid>:

int32 sys_getenvid(void)
{
  804171:	55                   	push   %ebp
  804172:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  804174:	6a 00                	push   $0x0
  804176:	6a 00                	push   $0x0
  804178:	6a 00                	push   $0x0
  80417a:	6a 00                	push   $0x0
  80417c:	6a 00                	push   $0x0
  80417e:	6a 05                	push   $0x5
  804180:	e8 1d fd ff ff       	call   803ea2 <syscall>
  804185:	83 c4 18             	add    $0x18,%esp
}
  804188:	c9                   	leave  
  804189:	c3                   	ret    

0080418a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80418a:	55                   	push   %ebp
  80418b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80418d:	6a 00                	push   $0x0
  80418f:	6a 00                	push   $0x0
  804191:	6a 00                	push   $0x0
  804193:	6a 00                	push   $0x0
  804195:	6a 00                	push   $0x0
  804197:	6a 06                	push   $0x6
  804199:	e8 04 fd ff ff       	call   803ea2 <syscall>
  80419e:	83 c4 18             	add    $0x18,%esp
}
  8041a1:	c9                   	leave  
  8041a2:	c3                   	ret    

008041a3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8041a3:	55                   	push   %ebp
  8041a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8041a6:	6a 00                	push   $0x0
  8041a8:	6a 00                	push   $0x0
  8041aa:	6a 00                	push   $0x0
  8041ac:	6a 00                	push   $0x0
  8041ae:	6a 00                	push   $0x0
  8041b0:	6a 07                	push   $0x7
  8041b2:	e8 eb fc ff ff       	call   803ea2 <syscall>
  8041b7:	83 c4 18             	add    $0x18,%esp
}
  8041ba:	c9                   	leave  
  8041bb:	c3                   	ret    

008041bc <sys_exit_env>:


void sys_exit_env(void)
{
  8041bc:	55                   	push   %ebp
  8041bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8041bf:	6a 00                	push   $0x0
  8041c1:	6a 00                	push   $0x0
  8041c3:	6a 00                	push   $0x0
  8041c5:	6a 00                	push   $0x0
  8041c7:	6a 00                	push   $0x0
  8041c9:	6a 1c                	push   $0x1c
  8041cb:	e8 d2 fc ff ff       	call   803ea2 <syscall>
  8041d0:	83 c4 18             	add    $0x18,%esp
}
  8041d3:	90                   	nop
  8041d4:	c9                   	leave  
  8041d5:	c3                   	ret    

008041d6 <sys_get_virtual_time>:


struct uint64 sys_get_virtual_time()
{
  8041d6:	55                   	push   %ebp
  8041d7:	89 e5                	mov    %esp,%ebp
  8041d9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8041dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8041df:	8d 50 04             	lea    0x4(%eax),%edx
  8041e2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8041e5:	6a 00                	push   $0x0
  8041e7:	6a 00                	push   $0x0
  8041e9:	6a 00                	push   $0x0
  8041eb:	52                   	push   %edx
  8041ec:	50                   	push   %eax
  8041ed:	6a 1d                	push   $0x1d
  8041ef:	e8 ae fc ff ff       	call   803ea2 <syscall>
  8041f4:	83 c4 18             	add    $0x18,%esp
	return result;
  8041f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8041fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8041fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804200:	89 01                	mov    %eax,(%ecx)
  804202:	89 51 04             	mov    %edx,0x4(%ecx)
}
  804205:	8b 45 08             	mov    0x8(%ebp),%eax
  804208:	c9                   	leave  
  804209:	c2 04 00             	ret    $0x4

0080420c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80420c:	55                   	push   %ebp
  80420d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80420f:	6a 00                	push   $0x0
  804211:	6a 00                	push   $0x0
  804213:	ff 75 10             	pushl  0x10(%ebp)
  804216:	ff 75 0c             	pushl  0xc(%ebp)
  804219:	ff 75 08             	pushl  0x8(%ebp)
  80421c:	6a 13                	push   $0x13
  80421e:	e8 7f fc ff ff       	call   803ea2 <syscall>
  804223:	83 c4 18             	add    $0x18,%esp
	return ;
  804226:	90                   	nop
}
  804227:	c9                   	leave  
  804228:	c3                   	ret    

00804229 <sys_rcr2>:
uint32 sys_rcr2()
{
  804229:	55                   	push   %ebp
  80422a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80422c:	6a 00                	push   $0x0
  80422e:	6a 00                	push   $0x0
  804230:	6a 00                	push   $0x0
  804232:	6a 00                	push   $0x0
  804234:	6a 00                	push   $0x0
  804236:	6a 1e                	push   $0x1e
  804238:	e8 65 fc ff ff       	call   803ea2 <syscall>
  80423d:	83 c4 18             	add    $0x18,%esp
}
  804240:	c9                   	leave  
  804241:	c3                   	ret    

00804242 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength)
{
  804242:	55                   	push   %ebp
  804243:	89 e5                	mov    %esp,%ebp
  804245:	83 ec 04             	sub    $0x4,%esp
  804248:	8b 45 08             	mov    0x8(%ebp),%eax
  80424b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80424e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  804252:	6a 00                	push   $0x0
  804254:	6a 00                	push   $0x0
  804256:	6a 00                	push   $0x0
  804258:	6a 00                	push   $0x0
  80425a:	50                   	push   %eax
  80425b:	6a 1f                	push   $0x1f
  80425d:	e8 40 fc ff ff       	call   803ea2 <syscall>
  804262:	83 c4 18             	add    $0x18,%esp
	return ;
  804265:	90                   	nop
}
  804266:	c9                   	leave  
  804267:	c3                   	ret    

00804268 <rsttst>:
void rsttst()
{
  804268:	55                   	push   %ebp
  804269:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80426b:	6a 00                	push   $0x0
  80426d:	6a 00                	push   $0x0
  80426f:	6a 00                	push   $0x0
  804271:	6a 00                	push   $0x0
  804273:	6a 00                	push   $0x0
  804275:	6a 21                	push   $0x21
  804277:	e8 26 fc ff ff       	call   803ea2 <syscall>
  80427c:	83 c4 18             	add    $0x18,%esp
	return ;
  80427f:	90                   	nop
}
  804280:	c9                   	leave  
  804281:	c3                   	ret    

00804282 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  804282:	55                   	push   %ebp
  804283:	89 e5                	mov    %esp,%ebp
  804285:	83 ec 04             	sub    $0x4,%esp
  804288:	8b 45 14             	mov    0x14(%ebp),%eax
  80428b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80428e:	8b 55 18             	mov    0x18(%ebp),%edx
  804291:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  804295:	52                   	push   %edx
  804296:	50                   	push   %eax
  804297:	ff 75 10             	pushl  0x10(%ebp)
  80429a:	ff 75 0c             	pushl  0xc(%ebp)
  80429d:	ff 75 08             	pushl  0x8(%ebp)
  8042a0:	6a 20                	push   $0x20
  8042a2:	e8 fb fb ff ff       	call   803ea2 <syscall>
  8042a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8042aa:	90                   	nop
}
  8042ab:	c9                   	leave  
  8042ac:	c3                   	ret    

008042ad <chktst>:
void chktst(uint32 n)
{
  8042ad:	55                   	push   %ebp
  8042ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8042b0:	6a 00                	push   $0x0
  8042b2:	6a 00                	push   $0x0
  8042b4:	6a 00                	push   $0x0
  8042b6:	6a 00                	push   $0x0
  8042b8:	ff 75 08             	pushl  0x8(%ebp)
  8042bb:	6a 22                	push   $0x22
  8042bd:	e8 e0 fb ff ff       	call   803ea2 <syscall>
  8042c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8042c5:	90                   	nop
}
  8042c6:	c9                   	leave  
  8042c7:	c3                   	ret    

008042c8 <inctst>:

void inctst()
{
  8042c8:	55                   	push   %ebp
  8042c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8042cb:	6a 00                	push   $0x0
  8042cd:	6a 00                	push   $0x0
  8042cf:	6a 00                	push   $0x0
  8042d1:	6a 00                	push   $0x0
  8042d3:	6a 00                	push   $0x0
  8042d5:	6a 23                	push   $0x23
  8042d7:	e8 c6 fb ff ff       	call   803ea2 <syscall>
  8042dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8042df:	90                   	nop
}
  8042e0:	c9                   	leave  
  8042e1:	c3                   	ret    

008042e2 <gettst>:
uint32 gettst()
{
  8042e2:	55                   	push   %ebp
  8042e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8042e5:	6a 00                	push   $0x0
  8042e7:	6a 00                	push   $0x0
  8042e9:	6a 00                	push   $0x0
  8042eb:	6a 00                	push   $0x0
  8042ed:	6a 00                	push   $0x0
  8042ef:	6a 24                	push   $0x24
  8042f1:	e8 ac fb ff ff       	call   803ea2 <syscall>
  8042f6:	83 c4 18             	add    $0x18,%esp
}
  8042f9:	c9                   	leave  
  8042fa:	c3                   	ret    

008042fb <sys_get_uheap_strategy>:

/*2025*/
uint32 sys_get_uheap_strategy()
{
  8042fb:	55                   	push   %ebp
  8042fc:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8042fe:	6a 00                	push   $0x0
  804300:	6a 00                	push   $0x0
  804302:	6a 00                	push   $0x0
  804304:	6a 00                	push   $0x0
  804306:	6a 00                	push   $0x0
  804308:	6a 25                	push   $0x25
  80430a:	e8 93 fb ff ff       	call   803ea2 <syscall>
  80430f:	83 c4 18             	add    $0x18,%esp
  804312:	a3 60 f0 81 00       	mov    %eax,0x81f060
	return uheapPlaceStrategy ;
  804317:	a1 60 f0 81 00       	mov    0x81f060,%eax
}
  80431c:	c9                   	leave  
  80431d:	c3                   	ret    

0080431e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80431e:	55                   	push   %ebp
  80431f:	89 e5                	mov    %esp,%ebp
	uheapPlaceStrategy = heapStrategy;
  804321:	8b 45 08             	mov    0x8(%ebp),%eax
  804324:	a3 60 f0 81 00       	mov    %eax,0x81f060
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  804329:	6a 00                	push   $0x0
  80432b:	6a 00                	push   $0x0
  80432d:	6a 00                	push   $0x0
  80432f:	6a 00                	push   $0x0
  804331:	ff 75 08             	pushl  0x8(%ebp)
  804334:	6a 26                	push   $0x26
  804336:	e8 67 fb ff ff       	call   803ea2 <syscall>
  80433b:	83 c4 18             	add    $0x18,%esp
	return ;
  80433e:	90                   	nop
}
  80433f:	c9                   	leave  
  804340:	c3                   	ret    

00804341 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  804341:	55                   	push   %ebp
  804342:	89 e5                	mov    %esp,%ebp
  804344:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  804345:	8b 5d 14             	mov    0x14(%ebp),%ebx
  804348:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80434b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80434e:	8b 45 08             	mov    0x8(%ebp),%eax
  804351:	6a 00                	push   $0x0
  804353:	53                   	push   %ebx
  804354:	51                   	push   %ecx
  804355:	52                   	push   %edx
  804356:	50                   	push   %eax
  804357:	6a 27                	push   $0x27
  804359:	e8 44 fb ff ff       	call   803ea2 <syscall>
  80435e:	83 c4 18             	add    $0x18,%esp
}
  804361:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  804364:	c9                   	leave  
  804365:	c3                   	ret    

00804366 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  804366:	55                   	push   %ebp
  804367:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  804369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80436c:	8b 45 08             	mov    0x8(%ebp),%eax
  80436f:	6a 00                	push   $0x0
  804371:	6a 00                	push   $0x0
  804373:	6a 00                	push   $0x0
  804375:	52                   	push   %edx
  804376:	50                   	push   %eax
  804377:	6a 28                	push   $0x28
  804379:	e8 24 fb ff ff       	call   803ea2 <syscall>
  80437e:	83 c4 18             	add    $0x18,%esp
}
  804381:	c9                   	leave  
  804382:	c3                   	ret    

00804383 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size, uint32 last_WS_element_content, bool chk_in_order)
{
  804383:	55                   	push   %ebp
  804384:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32)WS_list_content, (uint32)actual_WS_list_size , last_WS_element_content, (uint32)chk_in_order, 0);
  804386:	8b 4d 14             	mov    0x14(%ebp),%ecx
  804389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80438c:	8b 45 08             	mov    0x8(%ebp),%eax
  80438f:	6a 00                	push   $0x0
  804391:	51                   	push   %ecx
  804392:	ff 75 10             	pushl  0x10(%ebp)
  804395:	52                   	push   %edx
  804396:	50                   	push   %eax
  804397:	6a 29                	push   $0x29
  804399:	e8 04 fb ff ff       	call   803ea2 <syscall>
  80439e:	83 c4 18             	add    $0x18,%esp
}
  8043a1:	c9                   	leave  
  8043a2:	c3                   	ret    

008043a3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8043a3:	55                   	push   %ebp
  8043a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8043a6:	6a 00                	push   $0x0
  8043a8:	6a 00                	push   $0x0
  8043aa:	ff 75 10             	pushl  0x10(%ebp)
  8043ad:	ff 75 0c             	pushl  0xc(%ebp)
  8043b0:	ff 75 08             	pushl  0x8(%ebp)
  8043b3:	6a 12                	push   $0x12
  8043b5:	e8 e8 fa ff ff       	call   803ea2 <syscall>
  8043ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8043bd:	90                   	nop
}
  8043be:	c9                   	leave  
  8043bf:	c3                   	ret    

008043c0 <sys_utilities>:
void sys_utilities(char* utilityName, int value)
{
  8043c0:	55                   	push   %ebp
  8043c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32)utilityName, value, 0, 0, 0);
  8043c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8043c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8043c9:	6a 00                	push   $0x0
  8043cb:	6a 00                	push   $0x0
  8043cd:	6a 00                	push   $0x0
  8043cf:	52                   	push   %edx
  8043d0:	50                   	push   %eax
  8043d1:	6a 2a                	push   $0x2a
  8043d3:	e8 ca fa ff ff       	call   803ea2 <syscall>
  8043d8:	83 c4 18             	add    $0x18,%esp
	return;
  8043db:	90                   	nop
}
  8043dc:	c9                   	leave  
  8043dd:	c3                   	ret    

008043de <sys_get_optimal_num_faults>:
/*2025*/
int sys_get_optimal_num_faults()
{
  8043de:	55                   	push   %ebp
  8043df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_optimal_num_faults, 0, 0, 0, 0, 0);
  8043e1:	6a 00                	push   $0x0
  8043e3:	6a 00                	push   $0x0
  8043e5:	6a 00                	push   $0x0
  8043e7:	6a 00                	push   $0x0
  8043e9:	6a 00                	push   $0x0
  8043eb:	6a 2b                	push   $0x2b
  8043ed:	e8 b0 fa ff ff       	call   803ea2 <syscall>
  8043f2:	83 c4 18             	add    $0x18,%esp
}
  8043f5:	c9                   	leave  
  8043f6:	c3                   	ret    

008043f7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8043f7:	55                   	push   %ebp
  8043f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8043fa:	6a 00                	push   $0x0
  8043fc:	6a 00                	push   $0x0
  8043fe:	6a 00                	push   $0x0
  804400:	ff 75 0c             	pushl  0xc(%ebp)
  804403:	ff 75 08             	pushl  0x8(%ebp)
  804406:	6a 2d                	push   $0x2d
  804408:	e8 95 fa ff ff       	call   803ea2 <syscall>
  80440d:	83 c4 18             	add    $0x18,%esp
	return;
  804410:	90                   	nop
}
  804411:	c9                   	leave  
  804412:	c3                   	ret    

00804413 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  804413:	55                   	push   %ebp
  804414:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  804416:	6a 00                	push   $0x0
  804418:	6a 00                	push   $0x0
  80441a:	6a 00                	push   $0x0
  80441c:	ff 75 0c             	pushl  0xc(%ebp)
  80441f:	ff 75 08             	pushl  0x8(%ebp)
  804422:	6a 2c                	push   $0x2c
  804424:	e8 79 fa ff ff       	call   803ea2 <syscall>
  804429:	83 c4 18             	add    $0x18,%esp
	return ;
  80442c:	90                   	nop
}
  80442d:	c9                   	leave  
  80442e:	c3                   	ret    

0080442f <sys_env_set_priority>:


void sys_env_set_priority(int32 envID, int priority)
{
  80442f:	55                   	push   %ebp
  804430:	89 e5                	mov    %esp,%ebp
	//TODO: [PROJECT'25.IM#4] CPU SCHEDULING - #1 System Calls - Add suitable code here
	//Your code is here
	//Comment the following line
	//panic("sys_env_set_priority() is not implemented yet...!!");
	syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  804432:	8b 55 0c             	mov    0xc(%ebp),%edx
  804435:	8b 45 08             	mov    0x8(%ebp),%eax
  804438:	6a 00                	push   $0x0
  80443a:	6a 00                	push   $0x0
  80443c:	6a 00                	push   $0x0
  80443e:	52                   	push   %edx
  80443f:	50                   	push   %eax
  804440:	6a 2e                	push   $0x2e
  804442:	e8 5b fa ff ff       	call   803ea2 <syscall>
  804447:	83 c4 18             	add    $0x18,%esp
	    return;
  80444a:	90                   	nop
}
  80444b:	c9                   	leave  
  80444c:	c3                   	ret    

0080444d <to_page_va>:
//==================================================================================//
//==================================
// [1] GET PAGE VA:
//==================================
__inline__ uint32 to_page_va(struct PageInfoElement *ptrPageInfo)
{
  80444d:	55                   	push   %ebp
  80444e:	89 e5                	mov    %esp,%ebp
  804450:	83 ec 10             	sub    $0x10,%esp
	//Get start VA of the page from the corresponding Page Info pointer
	int idxInPageInfoArr = (ptrPageInfo - pageBlockInfoArr);
  804453:	8b 45 08             	mov    0x8(%ebp),%eax
  804456:	ba 60 70 80 00       	mov    $0x807060,%edx
  80445b:	29 d0                	sub    %edx,%eax
  80445d:	c1 f8 02             	sar    $0x2,%eax
  804460:	89 c2                	mov    %eax,%edx
  804462:	89 d0                	mov    %edx,%eax
  804464:	c1 e0 02             	shl    $0x2,%eax
  804467:	01 d0                	add    %edx,%eax
  804469:	c1 e0 02             	shl    $0x2,%eax
  80446c:	01 d0                	add    %edx,%eax
  80446e:	c1 e0 02             	shl    $0x2,%eax
  804471:	01 d0                	add    %edx,%eax
  804473:	89 c1                	mov    %eax,%ecx
  804475:	c1 e1 08             	shl    $0x8,%ecx
  804478:	01 c8                	add    %ecx,%eax
  80447a:	89 c1                	mov    %eax,%ecx
  80447c:	c1 e1 10             	shl    $0x10,%ecx
  80447f:	01 c8                	add    %ecx,%eax
  804481:	01 c0                	add    %eax,%eax
  804483:	01 d0                	add    %edx,%eax
  804485:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return dynAllocStart + (idxInPageInfoArr << PGSHIFT);
  804488:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80448b:	c1 e0 0c             	shl    $0xc,%eax
  80448e:	89 c2                	mov    %eax,%edx
  804490:	a1 64 f0 81 00       	mov    0x81f064,%eax
  804495:	01 d0                	add    %edx,%eax
}
  804497:	c9                   	leave  
  804498:	c3                   	ret    

00804499 <log2>:

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
  804499:	55                   	push   %ebp
  80449a:	89 e5                	mov    %esp,%ebp
  80449c:	83 ec 10             	sub    $0x10,%esp
		int result = 0;
  80449f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
		while( n > 1){
  8044a6:	eb 06                	jmp    8044ae <log2+0x15>
			n >>=1;
  8044a8:	d1 6d 08             	shrl   0x8(%ebp)
			result++;
  8044ab:	ff 45 fc             	incl   -0x4(%ebp)
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
__inline__ int log2(uint32 n)
	{
		int result = 0;
		while( n > 1){
  8044ae:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8044b2:	77 f4                	ja     8044a8 <log2+0xf>
			n >>=1;
			result++;
		}
		return result;
  8044b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
	}
  8044b7:	c9                   	leave  
  8044b8:	c3                   	ret    

008044b9 <initialize_dynamic_allocator>:
//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
bool is_initialized = 0;
void initialize_dynamic_allocator(uint32 daStart, uint32 daEnd)
{
  8044b9:	55                   	push   %ebp
  8044ba:	89 e5                	mov    %esp,%ebp
  8044bc:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(daEnd <= daStart + DYN_ALLOC_MAX_SIZE);
  8044bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8044c2:	05 00 00 00 02       	add    $0x2000000,%eax
  8044c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8044ca:	73 16                	jae    8044e2 <initialize_dynamic_allocator+0x29>
  8044cc:	68 4c 62 80 00       	push   $0x80624c
  8044d1:	68 72 62 80 00       	push   $0x806272
  8044d6:	6a 2d                	push   $0x2d
  8044d8:	68 87 62 80 00       	push   $0x806287
  8044dd:	e8 9e cc ff ff       	call   801180 <_panic>
		is_initialized = 1;
  8044e2:	c7 05 24 70 80 00 01 	movl   $0x1,0x807024
  8044e9:	00 00 00 
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #1 initialize_dynamic_allocator
	//Your code is here


	dynAllocStart = daStart;
  8044ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8044ef:	a3 64 f0 81 00       	mov    %eax,0x81f064
	dynAllocEnd= daEnd;
  8044f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044f7:	a3 40 70 80 00       	mov    %eax,0x807040
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;
  8044fc:	8b 15 40 70 80 00    	mov    0x807040,%edx
  804502:	a1 64 f0 81 00       	mov    0x81f064,%eax
  804507:	29 c2                	sub    %eax,%edx
  804509:	89 d0                	mov    %edx,%eax
  80450b:	c1 e8 0c             	shr    $0xc,%eax
  80450e:	89 45 e8             	mov    %eax,-0x18(%ebp)


	for(int i=0; i< numOfPages; i++){
  804511:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  804518:	eb 2f                	jmp    804549 <initialize_dynamic_allocator+0x90>
	    pageBlockInfoArr[i].block_size=0;
  80451a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80451d:	89 d0                	mov    %edx,%eax
  80451f:	01 c0                	add    %eax,%eax
  804521:	01 d0                	add    %edx,%eax
  804523:	c1 e0 02             	shl    $0x2,%eax
  804526:	05 68 70 80 00       	add    $0x807068,%eax
  80452b:	66 c7 00 00 00       	movw   $0x0,(%eax)
	    pageBlockInfoArr[i].num_of_free_blocks=0;
  804530:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804533:	89 d0                	mov    %edx,%eax
  804535:	01 c0                	add    %eax,%eax
  804537:	01 d0                	add    %edx,%eax
  804539:	c1 e0 02             	shl    $0x2,%eax
  80453c:	05 6a 70 80 00       	add    $0x80706a,%eax
  804541:	66 c7 00 00 00       	movw   $0x0,(%eax)
	dynAllocStart = daStart;
	dynAllocEnd= daEnd;
	int numOfPages = (dynAllocEnd - dynAllocStart)/PAGE_SIZE;


	for(int i=0; i< numOfPages; i++){
  804546:	ff 45 f4             	incl   -0xc(%ebp)
  804549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80454c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80454f:	7c c9                	jl     80451a <initialize_dynamic_allocator+0x61>
	    pageBlockInfoArr[i].block_size=0;
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
  804551:	c7 05 48 70 80 00 00 	movl   $0x0,0x807048
  804558:	00 00 00 
  80455b:	c7 05 4c 70 80 00 00 	movl   $0x0,0x80704c
  804562:	00 00 00 
  804565:	c7 05 54 70 80 00 00 	movl   $0x0,0x807054
  80456c:	00 00 00 
	for(int i=0; i<numOfPages; i++){
  80456f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  804576:	e9 9c 00 00 00       	jmp    804617 <initialize_dynamic_allocator+0x15e>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
  80457b:	8b 15 4c 70 80 00    	mov    0x80704c,%edx
  804581:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804584:	89 c8                	mov    %ecx,%eax
  804586:	01 c0                	add    %eax,%eax
  804588:	01 c8                	add    %ecx,%eax
  80458a:	c1 e0 02             	shl    $0x2,%eax
  80458d:	05 64 70 80 00       	add    $0x807064,%eax
  804592:	89 10                	mov    %edx,(%eax)
  804594:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804597:	89 d0                	mov    %edx,%eax
  804599:	01 c0                	add    %eax,%eax
  80459b:	01 d0                	add    %edx,%eax
  80459d:	c1 e0 02             	shl    $0x2,%eax
  8045a0:	05 64 70 80 00       	add    $0x807064,%eax
  8045a5:	8b 00                	mov    (%eax),%eax
  8045a7:	85 c0                	test   %eax,%eax
  8045a9:	74 1b                	je     8045c6 <initialize_dynamic_allocator+0x10d>
  8045ab:	8b 15 4c 70 80 00    	mov    0x80704c,%edx
  8045b1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8045b4:	89 c8                	mov    %ecx,%eax
  8045b6:	01 c0                	add    %eax,%eax
  8045b8:	01 c8                	add    %ecx,%eax
  8045ba:	c1 e0 02             	shl    $0x2,%eax
  8045bd:	05 60 70 80 00       	add    $0x807060,%eax
  8045c2:	89 02                	mov    %eax,(%edx)
  8045c4:	eb 16                	jmp    8045dc <initialize_dynamic_allocator+0x123>
  8045c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8045c9:	89 d0                	mov    %edx,%eax
  8045cb:	01 c0                	add    %eax,%eax
  8045cd:	01 d0                	add    %edx,%eax
  8045cf:	c1 e0 02             	shl    $0x2,%eax
  8045d2:	05 60 70 80 00       	add    $0x807060,%eax
  8045d7:	a3 48 70 80 00       	mov    %eax,0x807048
  8045dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8045df:	89 d0                	mov    %edx,%eax
  8045e1:	01 c0                	add    %eax,%eax
  8045e3:	01 d0                	add    %edx,%eax
  8045e5:	c1 e0 02             	shl    $0x2,%eax
  8045e8:	05 60 70 80 00       	add    $0x807060,%eax
  8045ed:	a3 4c 70 80 00       	mov    %eax,0x80704c
  8045f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8045f5:	89 d0                	mov    %edx,%eax
  8045f7:	01 c0                	add    %eax,%eax
  8045f9:	01 d0                	add    %edx,%eax
  8045fb:	c1 e0 02             	shl    $0x2,%eax
  8045fe:	05 60 70 80 00       	add    $0x807060,%eax
  804603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804609:	a1 54 70 80 00       	mov    0x807054,%eax
  80460e:	40                   	inc    %eax
  80460f:	a3 54 70 80 00       	mov    %eax,0x807054
	    pageBlockInfoArr[i].num_of_free_blocks=0;
	}


	LIST_INIT(&freePagesList);
	for(int i=0; i<numOfPages; i++){
  804614:	ff 45 f0             	incl   -0x10(%ebp)
  804617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80461a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80461d:	0f 8c 58 ff ff ff    	jl     80457b <initialize_dynamic_allocator+0xc2>
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  804623:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  80462a:	eb 36                	jmp    804662 <initialize_dynamic_allocator+0x1a9>
	    LIST_INIT(&freeBlockLists[i]);
  80462c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80462f:	c1 e0 04             	shl    $0x4,%eax
  804632:	05 80 f0 81 00       	add    $0x81f080,%eax
  804637:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80463d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804640:	c1 e0 04             	shl    $0x4,%eax
  804643:	05 84 f0 81 00       	add    $0x81f084,%eax
  804648:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80464e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804651:	c1 e0 04             	shl    $0x4,%eax
  804654:	05 8c f0 81 00       	add    $0x81f08c,%eax
  804659:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		LIST_INSERT_TAIL(&freePagesList, &pageBlockInfoArr[i]);
	}



	for (int i = 0; i < LOG2_MAX_SIZE - LOG2_MIN_SIZE + 1; i++) {
  80465f:	ff 45 ec             	incl   -0x14(%ebp)
  804662:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804666:	7e c4                	jle    80462c <initialize_dynamic_allocator+0x173>


	//Comment the following line
	//panic("initialize_dynamic_allocator() Not implemented yet");

}
  804668:	90                   	nop
  804669:	c9                   	leave  
  80466a:	c3                   	ret    

0080466b <get_block_size>:
// [2] GET BLOCK SIZE:
//===========================


__inline__ uint32 get_block_size(void *va)
{
  80466b:	55                   	push   %ebp
  80466c:	89 e5                	mov    %esp,%ebp
  80466e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #2 get_block_size
	//Your code is here

	uint32 page_index = ((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804671:	8b 55 08             	mov    0x8(%ebp),%edx
  804674:	a1 64 f0 81 00       	mov    0x81f064,%eax
  804679:	29 c2                	sub    %eax,%edx
  80467b:	89 d0                	mov    %edx,%eax
  80467d:	c1 e8 0c             	shr    $0xc,%eax
  804680:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return pageBlockInfoArr[page_index].block_size;
  804683:	8b 55 fc             	mov    -0x4(%ebp),%edx
  804686:	89 d0                	mov    %edx,%eax
  804688:	01 c0                	add    %eax,%eax
  80468a:	01 d0                	add    %edx,%eax
  80468c:	c1 e0 02             	shl    $0x2,%eax
  80468f:	05 68 70 80 00       	add    $0x807068,%eax
  804694:	8b 00                	mov    (%eax),%eax
  804696:	0f b7 c0             	movzwl %ax,%eax
	//Comment the following line
	//panic("get_block_size() Not implemented yet");
}
  804699:	c9                   	leave  
  80469a:	c3                   	ret    

0080469b <alloc_block>:

//===========================
// 3) ALLOCATE BLOCK:
//===========================
void *alloc_block(uint32 size)
{
  80469b:	55                   	push   %ebp
  80469c:	89 e5                	mov    %esp,%ebp
  80469e:	83 ec 48             	sub    $0x48,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert(size <= DYN_ALLOC_MAX_BLOCK_SIZE);
  8046a1:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8046a8:	76 16                	jbe    8046c0 <alloc_block+0x25>
  8046aa:	68 a0 62 80 00       	push   $0x8062a0
  8046af:	68 72 62 80 00       	push   $0x806272
  8046b4:	6a 6c                	push   $0x6c
  8046b6:	68 87 62 80 00       	push   $0x806287
  8046bb:	e8 c0 ca ff ff       	call   801180 <_panic>
	//==================================================================================
	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #3 alloc_block
	//Your code is here


	if(size == 0){
  8046c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8046c4:	75 0a                	jne    8046d0 <alloc_block+0x35>
		return NULL;
  8046c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8046cb:	e9 65 04 00 00       	jmp    804b35 <alloc_block+0x49a>
	}
	else if(size<=8){
  8046d0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  8046d4:	77 09                	ja     8046df <alloc_block+0x44>
		size=8;
  8046d6:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
  8046dd:	eb 1f                	jmp    8046fe <alloc_block+0x63>
	}
	else{
		uint32 reqsize=8;
  8046df:	c7 45 f4 08 00 00 00 	movl   $0x8,-0xc(%ebp)
		while(reqsize < size){
  8046e6:	eb 08                	jmp    8046f0 <alloc_block+0x55>
			reqsize*=2;
  8046e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046eb:	01 c0                	add    %eax,%eax
  8046ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	else if(size<=8){
		size=8;
	}
	else{
		uint32 reqsize=8;
		while(reqsize < size){
  8046f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8046f6:	72 f0                	jb     8046e8 <alloc_block+0x4d>
			reqsize*=2;
		}
		size= reqsize;
  8046f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046fb:	89 45 08             	mov    %eax,0x8(%ebp)
	}

	int list_index = log2(size)- LOG2_MIN_SIZE;
  8046fe:	83 ec 0c             	sub    $0xc,%esp
  804701:	ff 75 08             	pushl  0x8(%ebp)
  804704:	e8 90 fd ff ff       	call   804499 <log2>
  804709:	83 c4 10             	add    $0x10,%esp
  80470c:	83 e8 03             	sub    $0x3,%eax
  80470f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	if(!LIST_EMPTY(&freeBlockLists[list_index])){
  804712:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804715:	c1 e0 04             	shl    $0x4,%eax
  804718:	05 80 f0 81 00       	add    $0x81f080,%eax
  80471d:	8b 00                	mov    (%eax),%eax
  80471f:	85 c0                	test   %eax,%eax
  804721:	0f 84 fb 00 00 00    	je     804822 <alloc_block+0x187>
		struct BlockElement *block = LIST_FIRST(&freeBlockLists[list_index]);
  804727:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80472a:	c1 e0 04             	shl    $0x4,%eax
  80472d:	05 80 f0 81 00       	add    $0x81f080,%eax
  804732:	8b 00                	mov    (%eax),%eax
  804734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&freeBlockLists[list_index], block);
  804737:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80473b:	75 17                	jne    804754 <alloc_block+0xb9>
  80473d:	83 ec 04             	sub    $0x4,%esp
  804740:	68 c1 62 80 00       	push   $0x8062c1
  804745:	68 86 00 00 00       	push   $0x86
  80474a:	68 87 62 80 00       	push   $0x806287
  80474f:	e8 2c ca ff ff       	call   801180 <_panic>
  804754:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804757:	8b 00                	mov    (%eax),%eax
  804759:	85 c0                	test   %eax,%eax
  80475b:	74 10                	je     80476d <alloc_block+0xd2>
  80475d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804760:	8b 00                	mov    (%eax),%eax
  804762:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804765:	8b 52 04             	mov    0x4(%edx),%edx
  804768:	89 50 04             	mov    %edx,0x4(%eax)
  80476b:	eb 14                	jmp    804781 <alloc_block+0xe6>
  80476d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804770:	8b 40 04             	mov    0x4(%eax),%eax
  804773:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804776:	c1 e2 04             	shl    $0x4,%edx
  804779:	81 c2 84 f0 81 00    	add    $0x81f084,%edx
  80477f:	89 02                	mov    %eax,(%edx)
  804781:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804784:	8b 40 04             	mov    0x4(%eax),%eax
  804787:	85 c0                	test   %eax,%eax
  804789:	74 0f                	je     80479a <alloc_block+0xff>
  80478b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80478e:	8b 40 04             	mov    0x4(%eax),%eax
  804791:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804794:	8b 12                	mov    (%edx),%edx
  804796:	89 10                	mov    %edx,(%eax)
  804798:	eb 13                	jmp    8047ad <alloc_block+0x112>
  80479a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80479d:	8b 00                	mov    (%eax),%eax
  80479f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8047a2:	c1 e2 04             	shl    $0x4,%edx
  8047a5:	81 c2 80 f0 81 00    	add    $0x81f080,%edx
  8047ab:	89 02                	mov    %eax,(%edx)
  8047ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8047b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8047b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8047c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047c3:	c1 e0 04             	shl    $0x4,%eax
  8047c6:	05 8c f0 81 00       	add    $0x81f08c,%eax
  8047cb:	8b 00                	mov    (%eax),%eax
  8047cd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8047d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8047d3:	c1 e0 04             	shl    $0x4,%eax
  8047d6:	05 8c f0 81 00       	add    $0x81f08c,%eax
  8047db:	89 10                	mov    %edx,(%eax)
		uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  8047dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8047e0:	a1 64 f0 81 00       	mov    0x81f064,%eax
  8047e5:	29 c2                	sub    %eax,%edx
  8047e7:	89 d0                	mov    %edx,%eax
  8047e9:	c1 e8 0c             	shr    $0xc,%eax
  8047ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks--;
  8047ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8047f2:	89 d0                	mov    %edx,%eax
  8047f4:	01 c0                	add    %eax,%eax
  8047f6:	01 d0                	add    %edx,%eax
  8047f8:	c1 e0 02             	shl    $0x2,%eax
  8047fb:	05 6a 70 80 00       	add    $0x80706a,%eax
  804800:	66 8b 00             	mov    (%eax),%ax
  804803:	8d 50 ff             	lea    -0x1(%eax),%edx
  804806:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  804809:	89 c8                	mov    %ecx,%eax
  80480b:	01 c0                	add    %eax,%eax
  80480d:	01 c8                	add    %ecx,%eax
  80480f:	c1 e0 02             	shl    $0x2,%eax
  804812:	05 6a 70 80 00       	add    $0x80706a,%eax
  804817:	66 89 10             	mov    %dx,(%eax)
		return (void*)block;
  80481a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80481d:	e9 13 03 00 00       	jmp    804b35 <alloc_block+0x49a>
	}

	if(!LIST_EMPTY(&freePagesList)){
  804822:	a1 48 70 80 00       	mov    0x807048,%eax
  804827:	85 c0                	test   %eax,%eax
  804829:	0f 84 c9 01 00 00    	je     8049f8 <alloc_block+0x35d>

		struct PageInfoElement *page_info = LIST_FIRST(&freePagesList);
  80482f:	a1 48 70 80 00       	mov    0x807048,%eax
  804834:	89 45 dc             	mov    %eax,-0x24(%ebp)
		LIST_REMOVE(&freePagesList, page_info);
  804837:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80483b:	75 17                	jne    804854 <alloc_block+0x1b9>
  80483d:	83 ec 04             	sub    $0x4,%esp
  804840:	68 c1 62 80 00       	push   $0x8062c1
  804845:	68 8f 00 00 00       	push   $0x8f
  80484a:	68 87 62 80 00       	push   $0x806287
  80484f:	e8 2c c9 ff ff       	call   801180 <_panic>
  804854:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804857:	8b 00                	mov    (%eax),%eax
  804859:	85 c0                	test   %eax,%eax
  80485b:	74 10                	je     80486d <alloc_block+0x1d2>
  80485d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804860:	8b 00                	mov    (%eax),%eax
  804862:	8b 55 dc             	mov    -0x24(%ebp),%edx
  804865:	8b 52 04             	mov    0x4(%edx),%edx
  804868:	89 50 04             	mov    %edx,0x4(%eax)
  80486b:	eb 0b                	jmp    804878 <alloc_block+0x1dd>
  80486d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804870:	8b 40 04             	mov    0x4(%eax),%eax
  804873:	a3 4c 70 80 00       	mov    %eax,0x80704c
  804878:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80487b:	8b 40 04             	mov    0x4(%eax),%eax
  80487e:	85 c0                	test   %eax,%eax
  804880:	74 0f                	je     804891 <alloc_block+0x1f6>
  804882:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804885:	8b 40 04             	mov    0x4(%eax),%eax
  804888:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80488b:	8b 12                	mov    (%edx),%edx
  80488d:	89 10                	mov    %edx,(%eax)
  80488f:	eb 0a                	jmp    80489b <alloc_block+0x200>
  804891:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804894:	8b 00                	mov    (%eax),%eax
  804896:	a3 48 70 80 00       	mov    %eax,0x807048
  80489b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80489e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8048a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8048a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8048ae:	a1 54 70 80 00       	mov    0x807054,%eax
  8048b3:	48                   	dec    %eax
  8048b4:	a3 54 70 80 00       	mov    %eax,0x807054
		uint32 page_va = to_page_va(page_info);
  8048b9:	83 ec 0c             	sub    $0xc,%esp
  8048bc:	ff 75 dc             	pushl  -0x24(%ebp)
  8048bf:	e8 89 fb ff ff       	call   80444d <to_page_va>
  8048c4:	83 c4 10             	add    $0x10,%esp
  8048c7:	89 45 d8             	mov    %eax,-0x28(%ebp)

		uint32 page_index = (page_va - dynAllocStart)/ PAGE_SIZE;
  8048ca:	a1 64 f0 81 00       	mov    0x81f064,%eax
  8048cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8048d2:	29 c2                	sub    %eax,%edx
  8048d4:	89 d0                	mov    %edx,%eax
  8048d6:	c1 e8 0c             	shr    $0xc,%eax
  8048d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		get_page((void*)page_va);
  8048dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8048df:	83 ec 0c             	sub    $0xc,%esp
  8048e2:	50                   	push   %eax
  8048e3:	e8 fe dc ff ff       	call   8025e6 <get_page>
  8048e8:	83 c4 10             	add    $0x10,%esp


		pageBlockInfoArr[page_index].block_size = size;
  8048eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8048ee:	89 c2                	mov    %eax,%edx
  8048f0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8048f3:	89 c8                	mov    %ecx,%eax
  8048f5:	01 c0                	add    %eax,%eax
  8048f7:	01 c8                	add    %ecx,%eax
  8048f9:	c1 e0 02             	shl    $0x2,%eax
  8048fc:	05 68 70 80 00       	add    $0x807068,%eax
  804901:	66 89 10             	mov    %dx,(%eax)
		int num_blocks = PAGE_SIZE / size ;
  804904:	b8 00 10 00 00       	mov    $0x1000,%eax
  804909:	ba 00 00 00 00       	mov    $0x0,%edx
  80490e:	f7 75 08             	divl   0x8(%ebp)
  804911:	89 45 d0             	mov    %eax,-0x30(%ebp)
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;
  804914:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804917:	8d 50 ff             	lea    -0x1(%eax),%edx
  80491a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80491d:	89 c8                	mov    %ecx,%eax
  80491f:	01 c0                	add    %eax,%eax
  804921:	01 c8                	add    %ecx,%eax
  804923:	c1 e0 02             	shl    $0x2,%eax
  804926:	05 6a 70 80 00       	add    $0x80706a,%eax
  80492b:	66 89 10             	mov    %dx,(%eax)

		for(int i=1; i< num_blocks; i++){
  80492e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  804935:	e9 aa 00 00 00       	jmp    8049e4 <alloc_block+0x349>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
  80493a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80493d:	0f af 45 08          	imul   0x8(%ebp),%eax
  804941:	89 c2                	mov    %eax,%edx
  804943:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804946:	01 d0                	add    %edx,%eax
  804948:	89 45 cc             	mov    %eax,-0x34(%ebp)
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
  80494b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  80494f:	75 17                	jne    804968 <alloc_block+0x2cd>
  804951:	83 ec 04             	sub    $0x4,%esp
  804954:	68 e0 62 80 00       	push   $0x8062e0
  804959:	68 9d 00 00 00       	push   $0x9d
  80495e:	68 87 62 80 00       	push   $0x806287
  804963:	e8 18 c8 ff ff       	call   801180 <_panic>
  804968:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80496b:	c1 e0 04             	shl    $0x4,%eax
  80496e:	05 84 f0 81 00       	add    $0x81f084,%eax
  804973:	8b 10                	mov    (%eax),%edx
  804975:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804978:	89 50 04             	mov    %edx,0x4(%eax)
  80497b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80497e:	8b 40 04             	mov    0x4(%eax),%eax
  804981:	85 c0                	test   %eax,%eax
  804983:	74 14                	je     804999 <alloc_block+0x2fe>
  804985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804988:	c1 e0 04             	shl    $0x4,%eax
  80498b:	05 84 f0 81 00       	add    $0x81f084,%eax
  804990:	8b 00                	mov    (%eax),%eax
  804992:	8b 55 cc             	mov    -0x34(%ebp),%edx
  804995:	89 10                	mov    %edx,(%eax)
  804997:	eb 11                	jmp    8049aa <alloc_block+0x30f>
  804999:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80499c:	c1 e0 04             	shl    $0x4,%eax
  80499f:	8d 90 80 f0 81 00    	lea    0x81f080(%eax),%edx
  8049a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8049a8:	89 02                	mov    %eax,(%edx)
  8049aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8049ad:	c1 e0 04             	shl    $0x4,%eax
  8049b0:	8d 90 84 f0 81 00    	lea    0x81f084(%eax),%edx
  8049b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8049b9:	89 02                	mov    %eax,(%edx)
  8049bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8049be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8049c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8049c7:	c1 e0 04             	shl    $0x4,%eax
  8049ca:	05 8c f0 81 00       	add    $0x81f08c,%eax
  8049cf:	8b 00                	mov    (%eax),%eax
  8049d1:	8d 50 01             	lea    0x1(%eax),%edx
  8049d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8049d7:	c1 e0 04             	shl    $0x4,%eax
  8049da:	05 8c f0 81 00       	add    $0x81f08c,%eax
  8049df:	89 10                	mov    %edx,(%eax)

		pageBlockInfoArr[page_index].block_size = size;
		int num_blocks = PAGE_SIZE / size ;
		pageBlockInfoArr[page_index].num_of_free_blocks= num_blocks - 1 ;

		for(int i=1; i< num_blocks; i++){
  8049e1:	ff 45 f0             	incl   -0x10(%ebp)
  8049e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8049e7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8049ea:	0f 8c 4a ff ff ff    	jl     80493a <alloc_block+0x29f>
			struct BlockElement *new_block = (struct BlockElement*)(page_va + i *size);
			LIST_INSERT_TAIL(&freeBlockLists[list_index], new_block);
		}
		return(void*)page_va;
  8049f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8049f3:	e9 3d 01 00 00       	jmp    804b35 <alloc_block+0x49a>
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  8049f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8049fb:	40                   	inc    %eax
  8049fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8049ff:	e9 10 01 00 00       	jmp    804b14 <alloc_block+0x479>

		if(!LIST_EMPTY(&freeBlockLists[i])){
  804a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804a07:	c1 e0 04             	shl    $0x4,%eax
  804a0a:	05 80 f0 81 00       	add    $0x81f080,%eax
  804a0f:	8b 00                	mov    (%eax),%eax
  804a11:	85 c0                	test   %eax,%eax
  804a13:	0f 84 f8 00 00 00    	je     804b11 <alloc_block+0x476>

			struct BlockElement *block = LIST_FIRST(&freeBlockLists[i]);
  804a19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804a1c:	c1 e0 04             	shl    $0x4,%eax
  804a1f:	05 80 f0 81 00       	add    $0x81f080,%eax
  804a24:	8b 00                	mov    (%eax),%eax
  804a26:	89 45 c8             	mov    %eax,-0x38(%ebp)
			LIST_REMOVE( &freeBlockLists[i], block);
  804a29:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  804a2d:	75 17                	jne    804a46 <alloc_block+0x3ab>
  804a2f:	83 ec 04             	sub    $0x4,%esp
  804a32:	68 c1 62 80 00       	push   $0x8062c1
  804a37:	68 a8 00 00 00       	push   $0xa8
  804a3c:	68 87 62 80 00       	push   $0x806287
  804a41:	e8 3a c7 ff ff       	call   801180 <_panic>
  804a46:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804a49:	8b 00                	mov    (%eax),%eax
  804a4b:	85 c0                	test   %eax,%eax
  804a4d:	74 10                	je     804a5f <alloc_block+0x3c4>
  804a4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804a52:	8b 00                	mov    (%eax),%eax
  804a54:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804a57:	8b 52 04             	mov    0x4(%edx),%edx
  804a5a:	89 50 04             	mov    %edx,0x4(%eax)
  804a5d:	eb 14                	jmp    804a73 <alloc_block+0x3d8>
  804a5f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804a62:	8b 40 04             	mov    0x4(%eax),%eax
  804a65:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804a68:	c1 e2 04             	shl    $0x4,%edx
  804a6b:	81 c2 84 f0 81 00    	add    $0x81f084,%edx
  804a71:	89 02                	mov    %eax,(%edx)
  804a73:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804a76:	8b 40 04             	mov    0x4(%eax),%eax
  804a79:	85 c0                	test   %eax,%eax
  804a7b:	74 0f                	je     804a8c <alloc_block+0x3f1>
  804a7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804a80:	8b 40 04             	mov    0x4(%eax),%eax
  804a83:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804a86:	8b 12                	mov    (%edx),%edx
  804a88:	89 10                	mov    %edx,(%eax)
  804a8a:	eb 13                	jmp    804a9f <alloc_block+0x404>
  804a8c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804a8f:	8b 00                	mov    (%eax),%eax
  804a91:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804a94:	c1 e2 04             	shl    $0x4,%edx
  804a97:	81 c2 80 f0 81 00    	add    $0x81f080,%edx
  804a9d:	89 02                	mov    %eax,(%edx)
  804a9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804aa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804aa8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804aab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804ab5:	c1 e0 04             	shl    $0x4,%eax
  804ab8:	05 8c f0 81 00       	add    $0x81f08c,%eax
  804abd:	8b 00                	mov    (%eax),%eax
  804abf:	8d 50 ff             	lea    -0x1(%eax),%edx
  804ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  804ac5:	c1 e0 04             	shl    $0x4,%eax
  804ac8:	05 8c f0 81 00       	add    $0x81f08c,%eax
  804acd:	89 10                	mov    %edx,(%eax)

			uint32 page_index = ((uint32)block - dynAllocStart)/ PAGE_SIZE;
  804acf:	8b 55 c8             	mov    -0x38(%ebp),%edx
  804ad2:	a1 64 f0 81 00       	mov    0x81f064,%eax
  804ad7:	29 c2                	sub    %eax,%edx
  804ad9:	89 d0                	mov    %edx,%eax
  804adb:	c1 e8 0c             	shr    $0xc,%eax
  804ade:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			pageBlockInfoArr[page_index].num_of_free_blocks-- ;
  804ae1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  804ae4:	89 d0                	mov    %edx,%eax
  804ae6:	01 c0                	add    %eax,%eax
  804ae8:	01 d0                	add    %edx,%eax
  804aea:	c1 e0 02             	shl    $0x2,%eax
  804aed:	05 6a 70 80 00       	add    $0x80706a,%eax
  804af2:	66 8b 00             	mov    (%eax),%ax
  804af5:	8d 50 ff             	lea    -0x1(%eax),%edx
  804af8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  804afb:	89 c8                	mov    %ecx,%eax
  804afd:	01 c0                	add    %eax,%eax
  804aff:	01 c8                	add    %ecx,%eax
  804b01:	c1 e0 02             	shl    $0x2,%eax
  804b04:	05 6a 70 80 00       	add    $0x80706a,%eax
  804b09:	66 89 10             	mov    %dx,(%eax)

			return (void*)block;
  804b0c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  804b0f:	eb 24                	jmp    804b35 <alloc_block+0x49a>
		}
		return(void*)page_va;
	}


	for(int i =list_index+1; i<= LOG2_MAX_SIZE - LOG2_MIN_SIZE; i++){
  804b11:	ff 45 ec             	incl   -0x14(%ebp)
  804b14:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  804b18:	0f 8e e6 fe ff ff    	jle    804a04 <alloc_block+0x369>

			return (void*)block;
		}
	}

	panic("alloc_block: out of memory! ");
  804b1e:	83 ec 04             	sub    $0x4,%esp
  804b21:	68 03 63 80 00       	push   $0x806303
  804b26:	68 b1 00 00 00       	push   $0xb1
  804b2b:	68 87 62 80 00       	push   $0x806287
  804b30:	e8 4b c6 ff ff       	call   801180 <_panic>

	//Comment the following line
	//panic("alloc_block() Not implemented yet");

	//TODO: [PROJECT'25.BONUS#1] DYNAMIC ALLOCATOR - block if no free block
}
  804b35:	c9                   	leave  
  804b36:	c3                   	ret    

00804b37 <free_block>:

//===========================
// [4] FREE BLOCK:
//===========================
void free_block(void *va)
{
  804b37:	55                   	push   %ebp
  804b38:	89 e5                	mov    %esp,%ebp
  804b3a:	83 ec 38             	sub    $0x38,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		assert((uint32)va >= dynAllocStart && (uint32)va < dynAllocEnd);
  804b3d:	8b 55 08             	mov    0x8(%ebp),%edx
  804b40:	a1 64 f0 81 00       	mov    0x81f064,%eax
  804b45:	39 c2                	cmp    %eax,%edx
  804b47:	72 0c                	jb     804b55 <free_block+0x1e>
  804b49:	8b 55 08             	mov    0x8(%ebp),%edx
  804b4c:	a1 40 70 80 00       	mov    0x807040,%eax
  804b51:	39 c2                	cmp    %eax,%edx
  804b53:	72 19                	jb     804b6e <free_block+0x37>
  804b55:	68 20 63 80 00       	push   $0x806320
  804b5a:	68 72 62 80 00       	push   $0x806272
  804b5f:	68 c3 00 00 00       	push   $0xc3
  804b64:	68 87 62 80 00       	push   $0x806287
  804b69:	e8 12 c6 ff ff       	call   801180 <_panic>
	//==================================================================================

	//TODO: [PROJECT'25.GM#1] DYNAMIC ALLOCATOR - #4 free_block
	//Your code is here

	uint32 page_index=((uint32)va - dynAllocStart)/ PAGE_SIZE;
  804b6e:	8b 55 08             	mov    0x8(%ebp),%edx
  804b71:	a1 64 f0 81 00       	mov    0x81f064,%eax
  804b76:	29 c2                	sub    %eax,%edx
  804b78:	89 d0                	mov    %edx,%eax
  804b7a:	c1 e8 0c             	shr    $0xc,%eax
  804b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 block_size = pageBlockInfoArr[page_index].block_size;
  804b80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804b83:	89 d0                	mov    %edx,%eax
  804b85:	01 c0                	add    %eax,%eax
  804b87:	01 d0                	add    %edx,%eax
  804b89:	c1 e0 02             	shl    $0x2,%eax
  804b8c:	05 68 70 80 00       	add    $0x807068,%eax
  804b91:	8b 00                	mov    (%eax),%eax
  804b93:	0f b7 c0             	movzwl %ax,%eax
  804b96:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if(block_size == 0){
  804b99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804b9d:	75 17                	jne    804bb6 <free_block+0x7f>
		panic("page is empty(already not allocated)");
  804b9f:	83 ec 04             	sub    $0x4,%esp
  804ba2:	68 58 63 80 00       	push   $0x806358
  804ba7:	68 cf 00 00 00       	push   $0xcf
  804bac:	68 87 62 80 00       	push   $0x806287
  804bb1:	e8 ca c5 ff ff       	call   801180 <_panic>
	}

	int list_index = log2(block_size) - LOG2_MIN_SIZE;
  804bb6:	83 ec 0c             	sub    $0xc,%esp
  804bb9:	ff 75 ec             	pushl  -0x14(%ebp)
  804bbc:	e8 d8 f8 ff ff       	call   804499 <log2>
  804bc1:	83 c4 10             	add    $0x10,%esp
  804bc4:	83 e8 03             	sub    $0x3,%eax
  804bc7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// mn va l block "elta7weel mn virtual l phy hna"
	struct BlockElement *block = (struct BlockElement *)va;
  804bca:	8b 45 08             	mov    0x8(%ebp),%eax
  804bcd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	LIST_INSERT_TAIL(&freeBlockLists[list_index], block);
  804bd0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804bd4:	75 17                	jne    804bed <free_block+0xb6>
  804bd6:	83 ec 04             	sub    $0x4,%esp
  804bd9:	68 e0 62 80 00       	push   $0x8062e0
  804bde:	68 d5 00 00 00       	push   $0xd5
  804be3:	68 87 62 80 00       	push   $0x806287
  804be8:	e8 93 c5 ff ff       	call   801180 <_panic>
  804bed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804bf0:	c1 e0 04             	shl    $0x4,%eax
  804bf3:	05 84 f0 81 00       	add    $0x81f084,%eax
  804bf8:	8b 10                	mov    (%eax),%edx
  804bfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804bfd:	89 50 04             	mov    %edx,0x4(%eax)
  804c00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c03:	8b 40 04             	mov    0x4(%eax),%eax
  804c06:	85 c0                	test   %eax,%eax
  804c08:	74 14                	je     804c1e <free_block+0xe7>
  804c0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c0d:	c1 e0 04             	shl    $0x4,%eax
  804c10:	05 84 f0 81 00       	add    $0x81f084,%eax
  804c15:	8b 00                	mov    (%eax),%eax
  804c17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804c1a:	89 10                	mov    %edx,(%eax)
  804c1c:	eb 11                	jmp    804c2f <free_block+0xf8>
  804c1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c21:	c1 e0 04             	shl    $0x4,%eax
  804c24:	8d 90 80 f0 81 00    	lea    0x81f080(%eax),%edx
  804c2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c2d:	89 02                	mov    %eax,(%edx)
  804c2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c32:	c1 e0 04             	shl    $0x4,%eax
  804c35:	8d 90 84 f0 81 00    	lea    0x81f084(%eax),%edx
  804c3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c3e:	89 02                	mov    %eax,(%edx)
  804c40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804c43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804c49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c4c:	c1 e0 04             	shl    $0x4,%eax
  804c4f:	05 8c f0 81 00       	add    $0x81f08c,%eax
  804c54:	8b 00                	mov    (%eax),%eax
  804c56:	8d 50 01             	lea    0x1(%eax),%edx
  804c59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804c5c:	c1 e0 04             	shl    $0x4,%eax
  804c5f:	05 8c f0 81 00       	add    $0x81f08c,%eax
  804c64:	89 10                	mov    %edx,(%eax)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
  804c66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804c69:	89 d0                	mov    %edx,%eax
  804c6b:	01 c0                	add    %eax,%eax
  804c6d:	01 d0                	add    %edx,%eax
  804c6f:	c1 e0 02             	shl    $0x2,%eax
  804c72:	05 6a 70 80 00       	add    $0x80706a,%eax
  804c77:	66 8b 00             	mov    (%eax),%ax
  804c7a:	8d 50 01             	lea    0x1(%eax),%edx
  804c7d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804c80:	89 c8                	mov    %ecx,%eax
  804c82:	01 c0                	add    %eax,%eax
  804c84:	01 c8                	add    %ecx,%eax
  804c86:	c1 e0 02             	shl    $0x2,%eax
  804c89:	05 6a 70 80 00       	add    $0x80706a,%eax
  804c8e:	66 89 10             	mov    %dx,(%eax)
	int blocks_number = PAGE_SIZE / block_size;
  804c91:	b8 00 10 00 00       	mov    $0x1000,%eax
  804c96:	ba 00 00 00 00       	mov    $0x0,%edx
  804c9b:	f7 75 ec             	divl   -0x14(%ebp)
  804c9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
  804ca1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804ca4:	89 d0                	mov    %edx,%eax
  804ca6:	01 c0                	add    %eax,%eax
  804ca8:	01 d0                	add    %edx,%eax
  804caa:	c1 e0 02             	shl    $0x2,%eax
  804cad:	05 6a 70 80 00       	add    $0x80706a,%eax
  804cb2:	66 8b 00             	mov    (%eax),%ax
  804cb5:	0f b7 c0             	movzwl %ax,%eax
  804cb8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  804cbb:	0f 85 d3 01 00 00    	jne    804e94 <free_block+0x35d>
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
  804cc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804cc4:	c1 e0 04             	shl    $0x4,%eax
  804cc7:	05 80 f0 81 00       	add    $0x81f080,%eax
  804ccc:	8b 00                	mov    (%eax),%eax
  804cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		while(itr != NULL){
  804cd1:	e9 f1 00 00 00       	jmp    804dc7 <free_block+0x290>
			//lw ms7to el pointer mydy34 ->
			struct BlockElement *next = LIST_NEXT(itr);
  804cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804cd9:	8b 00                	mov    (%eax),%eax
  804cdb:	89 45 dc             	mov    %eax,-0x24(%ebp)
			uint32 page_beginning_address= dynAllocStart + page_index * PAGE_SIZE;
  804cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804ce1:	c1 e0 0c             	shl    $0xc,%eax
  804ce4:	89 c2                	mov    %eax,%edx
  804ce6:	a1 64 f0 81 00       	mov    0x81f064,%eax
  804ceb:	01 d0                	add    %edx,%eax
  804ced:	89 45 d8             	mov    %eax,-0x28(%ebp)
			uint32 page_end_address = dynAllocStart + (page_index +1 )* PAGE_SIZE;
  804cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804cf3:	40                   	inc    %eax
  804cf4:	c1 e0 0c             	shl    $0xc,%eax
  804cf7:	89 c2                	mov    %eax,%edx
  804cf9:	a1 64 f0 81 00       	mov    0x81f064,%eax
  804cfe:	01 d0                	add    %edx,%eax
  804d00:	89 45 d4             	mov    %eax,-0x2c(%ebp)

			if((uint32)itr >= page_beginning_address && (uint32)itr < page_end_address){
  804d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d06:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  804d09:	0f 82 b8 00 00 00    	jb     804dc7 <free_block+0x290>
  804d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d12:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  804d15:	0f 83 ac 00 00 00    	jae    804dc7 <free_block+0x290>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
  804d1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804d1f:	75 17                	jne    804d38 <free_block+0x201>
  804d21:	83 ec 04             	sub    $0x4,%esp
  804d24:	68 c1 62 80 00       	push   $0x8062c1
  804d29:	68 e2 00 00 00       	push   $0xe2
  804d2e:	68 87 62 80 00       	push   $0x806287
  804d33:	e8 48 c4 ff ff       	call   801180 <_panic>
  804d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d3b:	8b 00                	mov    (%eax),%eax
  804d3d:	85 c0                	test   %eax,%eax
  804d3f:	74 10                	je     804d51 <free_block+0x21a>
  804d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d44:	8b 00                	mov    (%eax),%eax
  804d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804d49:	8b 52 04             	mov    0x4(%edx),%edx
  804d4c:	89 50 04             	mov    %edx,0x4(%eax)
  804d4f:	eb 14                	jmp    804d65 <free_block+0x22e>
  804d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d54:	8b 40 04             	mov    0x4(%eax),%eax
  804d57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804d5a:	c1 e2 04             	shl    $0x4,%edx
  804d5d:	81 c2 84 f0 81 00    	add    $0x81f084,%edx
  804d63:	89 02                	mov    %eax,(%edx)
  804d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d68:	8b 40 04             	mov    0x4(%eax),%eax
  804d6b:	85 c0                	test   %eax,%eax
  804d6d:	74 0f                	je     804d7e <free_block+0x247>
  804d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d72:	8b 40 04             	mov    0x4(%eax),%eax
  804d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804d78:	8b 12                	mov    (%edx),%edx
  804d7a:	89 10                	mov    %edx,(%eax)
  804d7c:	eb 13                	jmp    804d91 <free_block+0x25a>
  804d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d81:	8b 00                	mov    (%eax),%eax
  804d83:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804d86:	c1 e2 04             	shl    $0x4,%edx
  804d89:	81 c2 80 f0 81 00    	add    $0x81f080,%edx
  804d8f:	89 02                	mov    %eax,(%edx)
  804d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804d9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804da4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804da7:	c1 e0 04             	shl    $0x4,%eax
  804daa:	05 8c f0 81 00       	add    $0x81f08c,%eax
  804daf:	8b 00                	mov    (%eax),%eax
  804db1:	8d 50 ff             	lea    -0x1(%eax),%edx
  804db4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804db7:	c1 e0 04             	shl    $0x4,%eax
  804dba:	05 8c f0 81 00       	add    $0x81f08c,%eax
  804dbf:	89 10                	mov    %edx,(%eax)
				//y5o4 3la elly b3do
				itr = next;
  804dc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  804dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// b3d ma wdytha fy el freeBlockLists hzwed elfree elly fy el array 1
	pageBlockInfoArr[page_index].num_of_free_blocks++;
	int blocks_number = PAGE_SIZE / block_size;
	if(pageBlockInfoArr[page_index].num_of_free_blocks == blocks_number){
		struct BlockElement *itr = LIST_FIRST(&freeBlockLists[list_index]);
		while(itr != NULL){
  804dc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804dcb:	0f 85 05 ff ff ff    	jne    804cd6 <free_block+0x19f>
				LIST_REMOVE(&freeBlockLists[list_index], itr);
				//y5o4 3la elly b3do
				itr = next;
			}
		}
		pageBlockInfoArr[page_index].block_size=0;
  804dd1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804dd4:	89 d0                	mov    %edx,%eax
  804dd6:	01 c0                	add    %eax,%eax
  804dd8:	01 d0                	add    %edx,%eax
  804dda:	c1 e0 02             	shl    $0x2,%eax
  804ddd:	05 68 70 80 00       	add    $0x807068,%eax
  804de2:	66 c7 00 00 00       	movw   $0x0,(%eax)
		pageBlockInfoArr[page_index].num_of_free_blocks=0;
  804de7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804dea:	89 d0                	mov    %edx,%eax
  804dec:	01 c0                	add    %eax,%eax
  804dee:	01 d0                	add    %edx,%eax
  804df0:	c1 e0 02             	shl    $0x2,%eax
  804df3:	05 6a 70 80 00       	add    $0x80706a,%eax
  804df8:	66 c7 00 00 00       	movw   $0x0,(%eax)

		struct PageInfoElement *page_info = &pageBlockInfoArr[page_index];
  804dfd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804e00:	89 d0                	mov    %edx,%eax
  804e02:	01 c0                	add    %eax,%eax
  804e04:	01 d0                	add    %edx,%eax
  804e06:	c1 e0 02             	shl    $0x2,%eax
  804e09:	05 60 70 80 00       	add    $0x807060,%eax
  804e0e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		LIST_INSERT_TAIL(&freePagesList, page_info);
  804e11:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  804e15:	75 17                	jne    804e2e <free_block+0x2f7>
  804e17:	83 ec 04             	sub    $0x4,%esp
  804e1a:	68 e0 62 80 00       	push   $0x8062e0
  804e1f:	68 eb 00 00 00       	push   $0xeb
  804e24:	68 87 62 80 00       	push   $0x806287
  804e29:	e8 52 c3 ff ff       	call   801180 <_panic>
  804e2e:	8b 15 4c 70 80 00    	mov    0x80704c,%edx
  804e34:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804e37:	89 50 04             	mov    %edx,0x4(%eax)
  804e3a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804e3d:	8b 40 04             	mov    0x4(%eax),%eax
  804e40:	85 c0                	test   %eax,%eax
  804e42:	74 0c                	je     804e50 <free_block+0x319>
  804e44:	a1 4c 70 80 00       	mov    0x80704c,%eax
  804e49:	8b 55 d0             	mov    -0x30(%ebp),%edx
  804e4c:	89 10                	mov    %edx,(%eax)
  804e4e:	eb 08                	jmp    804e58 <free_block+0x321>
  804e50:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804e53:	a3 48 70 80 00       	mov    %eax,0x807048
  804e58:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804e5b:	a3 4c 70 80 00       	mov    %eax,0x80704c
  804e60:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804e63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804e69:	a1 54 70 80 00       	mov    0x807054,%eax
  804e6e:	40                   	inc    %eax
  804e6f:	a3 54 70 80 00       	mov    %eax,0x807054
		uint32 page_va = to_page_va(page_info);
  804e74:	83 ec 0c             	sub    $0xc,%esp
  804e77:	ff 75 d0             	pushl  -0x30(%ebp)
  804e7a:	e8 ce f5 ff ff       	call   80444d <to_page_va>
  804e7f:	83 c4 10             	add    $0x10,%esp
  804e82:	89 45 cc             	mov    %eax,-0x34(%ebp)
		return_page((void *)page_va);
  804e85:	8b 45 cc             	mov    -0x34(%ebp),%eax
  804e88:	83 ec 0c             	sub    $0xc,%esp
  804e8b:	50                   	push   %eax
  804e8c:	e8 9e d7 ff ff       	call   80262f <return_page>
  804e91:	83 c4 10             	add    $0x10,%esp
	}


	//Comment the following line
	//panic("free_block() Not implemented yet");
}
  804e94:	90                   	nop
  804e95:	c9                   	leave  
  804e96:	c3                   	ret    

00804e97 <realloc_block>:

//===========================
// [1] REALLOCATE BLOCK:
//===========================
void *realloc_block(void* va, uint32 new_size)
{
  804e97:	55                   	push   %ebp
  804e98:	89 e5                	mov    %esp,%ebp
  804e9a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT'25.BONUS#2] KERNEL REALLOC - realloc_block
	//Your code is here
	//Comment the following line
	panic("realloc_block() Not implemented yet");
  804e9d:	83 ec 04             	sub    $0x4,%esp
  804ea0:	68 80 63 80 00       	push   $0x806380
  804ea5:	68 01 01 00 00       	push   $0x101
  804eaa:	68 87 62 80 00       	push   $0x806287
  804eaf:	e8 cc c2 ff ff       	call   801180 <_panic>

00804eb4 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  804eb4:	55                   	push   %ebp
  804eb5:	89 e5                	mov    %esp,%ebp
  804eb7:	83 ec 08             	sub    $0x8,%esp
	panic("create_semaphore() is not implemented yet...!!");
  804eba:	83 ec 04             	sub    $0x4,%esp
  804ebd:	68 a4 63 80 00       	push   $0x8063a4
  804ec2:	6a 07                	push   $0x7
  804ec4:	68 d3 63 80 00       	push   $0x8063d3
  804ec9:	e8 b2 c2 ff ff       	call   801180 <_panic>

00804ece <get_semaphore>:
}
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  804ece:	55                   	push   %ebp
  804ecf:	89 e5                	mov    %esp,%ebp
  804ed1:	83 ec 08             	sub    $0x8,%esp
	panic("get_semaphore() is not implemented yet...!!");
  804ed4:	83 ec 04             	sub    $0x4,%esp
  804ed7:	68 e4 63 80 00       	push   $0x8063e4
  804edc:	6a 0b                	push   $0xb
  804ede:	68 d3 63 80 00       	push   $0x8063d3
  804ee3:	e8 98 c2 ff ff       	call   801180 <_panic>

00804ee8 <wait_semaphore>:
}

void wait_semaphore(struct semaphore sem)
{
  804ee8:	55                   	push   %ebp
  804ee9:	89 e5                	mov    %esp,%ebp
  804eeb:	83 ec 08             	sub    $0x8,%esp
	panic("wait_semaphore() is not implemented yet...!!");
  804eee:	83 ec 04             	sub    $0x4,%esp
  804ef1:	68 10 64 80 00       	push   $0x806410
  804ef6:	6a 10                	push   $0x10
  804ef8:	68 d3 63 80 00       	push   $0x8063d3
  804efd:	e8 7e c2 ff ff       	call   801180 <_panic>

00804f02 <signal_semaphore>:
}

void signal_semaphore(struct semaphore sem)
{
  804f02:	55                   	push   %ebp
  804f03:	89 e5                	mov    %esp,%ebp
  804f05:	83 ec 08             	sub    $0x8,%esp
	panic("signal_semaphore() is not implemented yet...!!");
  804f08:	83 ec 04             	sub    $0x4,%esp
  804f0b:	68 40 64 80 00       	push   $0x806440
  804f10:	6a 15                	push   $0x15
  804f12:	68 d3 63 80 00       	push   $0x8063d3
  804f17:	e8 64 c2 ff ff       	call   801180 <_panic>

00804f1c <semaphore_count>:
}

int semaphore_count(struct semaphore sem)
{
  804f1c:	55                   	push   %ebp
  804f1d:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  804f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  804f22:	8b 40 10             	mov    0x10(%eax),%eax
}
  804f25:	5d                   	pop    %ebp
  804f26:	c3                   	ret    

00804f27 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804f27:	55                   	push   %ebp
  804f28:	89 e5                	mov    %esp,%ebp
  804f2a:	83 ec 30             	sub    $0x30,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  804f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  804f30:	89 d0                	mov    %edx,%eax
  804f32:	c1 e0 02             	shl    $0x2,%eax
  804f35:	01 d0                	add    %edx,%eax
  804f37:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804f3e:	01 d0                	add    %edx,%eax
  804f40:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804f47:	01 d0                	add    %edx,%eax
  804f49:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804f50:	01 d0                	add    %edx,%eax
  804f52:	c1 e0 04             	shl    $0x4,%eax
  804f55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	uint32 cycles_counter =0;
  804f58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  804f5f:	0f 31                	rdtsc  
  804f61:	89 45 e8             	mov    %eax,-0x18(%ebp)
  804f64:	89 55 ec             	mov    %edx,-0x14(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  804f67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  804f6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  804f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  804f70:	89 55 f4             	mov    %edx,-0xc(%ebp)

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  804f73:	eb 46                	jmp    804fbb <env_sleep+0x94>

static inline __attribute__((always_inline)) struct uint64 get_virtual_time_user()
{
	struct uint64 result;

	__asm __volatile("rdtsc\n"
  804f75:	0f 31                	rdtsc  
  804f77:	89 45 d0             	mov    %eax,-0x30(%ebp)
  804f7a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	: "=a" (result.low), "=d" (result.hi)
	);

	return result;
  804f7d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  804f80:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  804f83:	89 45 e0             	mov    %eax,-0x20(%ebp)
  804f86:	89 55 e4             	mov    %edx,-0x1c(%ebp)

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  804f89:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804f8f:	29 c2                	sub    %eax,%edx
  804f91:	89 d0                	mov    %edx,%eax
  804f93:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  804f96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804f9c:	89 d1                	mov    %edx,%ecx
  804f9e:	29 c1                	sub    %eax,%ecx
  804fa0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804fa3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804fa6:	39 c2                	cmp    %eax,%edx
  804fa8:	0f 97 c0             	seta   %al
  804fab:	0f b6 c0             	movzbl %al,%eax
  804fae:	29 c1                	sub    %eax,%ecx
  804fb0:	89 c8                	mov    %ecx,%eax
  804fb2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  804fb5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804fb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	uint32 cycles_counter =0;

	/*2024*/ //USE A USER-SIDE VERSION OF THIS FUNCTION TO AVOID SLOW-DOWN THE PERFORMANCE DUE SYS_CALL (el7 :))
	//struct uint64 baseTime = sys_get_virtual_time() ;
	struct uint64 baseTime = get_virtual_time_user() ;
	while(cycles_counter<time_in_cycles)
  804fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804fbe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  804fc1:	72 b2                	jb     804f75 <env_sleep+0x4e>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  804fc3:	90                   	nop
  804fc4:	c9                   	leave  
  804fc5:	c3                   	ret    

00804fc6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  804fc6:	55                   	push   %ebp
  804fc7:	89 e5                	mov    %esp,%ebp
  804fc9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  804fcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  804fd3:	eb 03                	jmp    804fd8 <busy_wait+0x12>
  804fd5:	ff 45 fc             	incl   -0x4(%ebp)
  804fd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  804fdb:	3b 45 08             	cmp    0x8(%ebp),%eax
  804fde:	72 f5                	jb     804fd5 <busy_wait+0xf>
	return i;
  804fe0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  804fe3:	c9                   	leave  
  804fe4:	c3                   	ret    

00804fe5 <init_uspinlock>:
#include "inc/uspinlock.h"

extern volatile struct Env *myEnv;

void init_uspinlock(struct uspinlock *lk, char *name, bool isOpened)
{
  804fe5:	55                   	push   %ebp
  804fe6:	89 e5                	mov    %esp,%ebp
  804fe8:	83 ec 08             	sub    $0x8,%esp
	assert(isOpened == 0 || isOpened == 1);
  804feb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  804fef:	74 1c                	je     80500d <init_uspinlock+0x28>
  804ff1:	83 7d 10 01          	cmpl   $0x1,0x10(%ebp)
  804ff5:	74 16                	je     80500d <init_uspinlock+0x28>
  804ff7:	68 70 64 80 00       	push   $0x806470
  804ffc:	68 8f 64 80 00       	push   $0x80648f
  805001:	6a 10                	push   $0x10
  805003:	68 a4 64 80 00       	push   $0x8064a4
  805008:	e8 73 c1 ff ff       	call   801180 <_panic>
	strcpy(lk->name, name);
  80500d:	8b 45 08             	mov    0x8(%ebp),%eax
  805010:	83 c0 04             	add    $0x4,%eax
  805013:	83 ec 08             	sub    $0x8,%esp
  805016:	ff 75 0c             	pushl  0xc(%ebp)
  805019:	50                   	push   %eax
  80501a:	e8 5f cd ff ff       	call   801d7e <strcpy>
  80501f:	83 c4 10             	add    $0x10,%esp
	lk->locked = (1 - isOpened);
  805022:	b8 01 00 00 00       	mov    $0x1,%eax
  805027:	2b 45 10             	sub    0x10(%ebp),%eax
  80502a:	89 c2                	mov    %eax,%edx
  80502c:	8b 45 08             	mov    0x8(%ebp),%eax
  80502f:	89 10                	mov    %edx,(%eax)
}
  805031:	90                   	nop
  805032:	c9                   	leave  
  805033:	c3                   	ret    

00805034 <acquire_uspinlock>:
// Acquire the lock.
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void acquire_uspinlock(struct uspinlock *lk)
{
  805034:	55                   	push   %ebp
  805035:	89 e5                	mov    %esp,%ebp
  805037:	83 ec 18             	sub    $0x18,%esp
	// The xchg is atomic.
	while(xchg(&lk->locked, 1) != 0) ;
  80503a:	90                   	nop
  80503b:	8b 45 08             	mov    0x8(%ebp),%eax
  80503e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  805041:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  805048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80504b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80504e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  805051:	f0 87 02             	lock xchg %eax,(%edx)
  805054:	89 45 ec             	mov    %eax,-0x14(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
  805057:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80505a:	85 c0                	test   %eax,%eax
  80505c:	75 dd                	jne    80503b <acquire_uspinlock+0x7>

	cprintf("[%d: %s] ACQUIRED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  80505e:	8b 45 08             	mov    0x8(%ebp),%eax
  805061:	8d 48 04             	lea    0x4(%eax),%ecx
  805064:	a1 20 70 80 00       	mov    0x807020,%eax
  805069:	8d 50 20             	lea    0x20(%eax),%edx
  80506c:	a1 20 70 80 00       	mov    0x807020,%eax
  805071:	8b 40 10             	mov    0x10(%eax),%eax
  805074:	51                   	push   %ecx
  805075:	52                   	push   %edx
  805076:	50                   	push   %eax
  805077:	68 b4 64 80 00       	push   $0x8064b4
  80507c:	e8 cd c3 ff ff       	call   80144e <cprintf>
  805081:	83 c4 10             	add    $0x10,%esp

	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that the critical section's memory
	// references happen after the lock is acquired.
	__sync_synchronize();
  805084:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
}
  805089:	90                   	nop
  80508a:	c9                   	leave  
  80508b:	c3                   	ret    

0080508c <release_uspinlock>:

// Release the lock.
void release_uspinlock(struct uspinlock *lk)
{
  80508c:	55                   	push   %ebp
  80508d:	89 e5                	mov    %esp,%ebp
  80508f:	83 ec 08             	sub    $0x8,%esp
	if(!(lk->locked))
  805092:	8b 45 08             	mov    0x8(%ebp),%eax
  805095:	8b 00                	mov    (%eax),%eax
  805097:	85 c0                	test   %eax,%eax
  805099:	75 18                	jne    8050b3 <release_uspinlock+0x27>
	{
		panic("release: lock \"%s\" is not held!", lk->name);
  80509b:	8b 45 08             	mov    0x8(%ebp),%eax
  80509e:	83 c0 04             	add    $0x4,%eax
  8050a1:	50                   	push   %eax
  8050a2:	68 d8 64 80 00       	push   $0x8064d8
  8050a7:	6a 2b                	push   $0x2b
  8050a9:	68 a4 64 80 00       	push   $0x8064a4
  8050ae:	e8 cd c0 ff ff       	call   801180 <_panic>
	// Tell the C compiler and the processor to not move loads or stores
	// past this point, to ensure that all the stores in the critical
	// section are visible to other cores before the lock is released.
	// Both the C compiler and the hardware may re-order loads and
	// stores; __sync_synchronize() tells them both not to.
	__sync_synchronize();
  8050b3:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

	// Release the lock, equivalent to lk->locked = 0.
	// This code can't use a C assignment, since it might
	// not be atomic. A real OS would use C atomics here.
	asm volatile("movl $0, %0" : "+m" (lk->locked) : );
  8050b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8050bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8050be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("[%d: %s] RELEASED spinlock [%s]\n", myEnv->env_id, myEnv->prog_name, lk->name);
  8050c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8050c7:	8d 48 04             	lea    0x4(%eax),%ecx
  8050ca:	a1 20 70 80 00       	mov    0x807020,%eax
  8050cf:	8d 50 20             	lea    0x20(%eax),%edx
  8050d2:	a1 20 70 80 00       	mov    0x807020,%eax
  8050d7:	8b 40 10             	mov    0x10(%eax),%eax
  8050da:	51                   	push   %ecx
  8050db:	52                   	push   %edx
  8050dc:	50                   	push   %eax
  8050dd:	68 f8 64 80 00       	push   $0x8064f8
  8050e2:	e8 67 c3 ff ff       	call   80144e <cprintf>
  8050e7:	83 c4 10             	add    $0x10,%esp
}
  8050ea:	90                   	nop
  8050eb:	c9                   	leave  
  8050ec:	c3                   	ret    
  8050ed:	66 90                	xchg   %ax,%ax
  8050ef:	90                   	nop

008050f0 <__udivdi3>:
  8050f0:	55                   	push   %ebp
  8050f1:	57                   	push   %edi
  8050f2:	56                   	push   %esi
  8050f3:	53                   	push   %ebx
  8050f4:	83 ec 1c             	sub    $0x1c,%esp
  8050f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8050fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8050ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  805103:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  805107:	89 ca                	mov    %ecx,%edx
  805109:	89 f8                	mov    %edi,%eax
  80510b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80510f:	85 f6                	test   %esi,%esi
  805111:	75 2d                	jne    805140 <__udivdi3+0x50>
  805113:	39 cf                	cmp    %ecx,%edi
  805115:	77 65                	ja     80517c <__udivdi3+0x8c>
  805117:	89 fd                	mov    %edi,%ebp
  805119:	85 ff                	test   %edi,%edi
  80511b:	75 0b                	jne    805128 <__udivdi3+0x38>
  80511d:	b8 01 00 00 00       	mov    $0x1,%eax
  805122:	31 d2                	xor    %edx,%edx
  805124:	f7 f7                	div    %edi
  805126:	89 c5                	mov    %eax,%ebp
  805128:	31 d2                	xor    %edx,%edx
  80512a:	89 c8                	mov    %ecx,%eax
  80512c:	f7 f5                	div    %ebp
  80512e:	89 c1                	mov    %eax,%ecx
  805130:	89 d8                	mov    %ebx,%eax
  805132:	f7 f5                	div    %ebp
  805134:	89 cf                	mov    %ecx,%edi
  805136:	89 fa                	mov    %edi,%edx
  805138:	83 c4 1c             	add    $0x1c,%esp
  80513b:	5b                   	pop    %ebx
  80513c:	5e                   	pop    %esi
  80513d:	5f                   	pop    %edi
  80513e:	5d                   	pop    %ebp
  80513f:	c3                   	ret    
  805140:	39 ce                	cmp    %ecx,%esi
  805142:	77 28                	ja     80516c <__udivdi3+0x7c>
  805144:	0f bd fe             	bsr    %esi,%edi
  805147:	83 f7 1f             	xor    $0x1f,%edi
  80514a:	75 40                	jne    80518c <__udivdi3+0x9c>
  80514c:	39 ce                	cmp    %ecx,%esi
  80514e:	72 0a                	jb     80515a <__udivdi3+0x6a>
  805150:	3b 44 24 08          	cmp    0x8(%esp),%eax
  805154:	0f 87 9e 00 00 00    	ja     8051f8 <__udivdi3+0x108>
  80515a:	b8 01 00 00 00       	mov    $0x1,%eax
  80515f:	89 fa                	mov    %edi,%edx
  805161:	83 c4 1c             	add    $0x1c,%esp
  805164:	5b                   	pop    %ebx
  805165:	5e                   	pop    %esi
  805166:	5f                   	pop    %edi
  805167:	5d                   	pop    %ebp
  805168:	c3                   	ret    
  805169:	8d 76 00             	lea    0x0(%esi),%esi
  80516c:	31 ff                	xor    %edi,%edi
  80516e:	31 c0                	xor    %eax,%eax
  805170:	89 fa                	mov    %edi,%edx
  805172:	83 c4 1c             	add    $0x1c,%esp
  805175:	5b                   	pop    %ebx
  805176:	5e                   	pop    %esi
  805177:	5f                   	pop    %edi
  805178:	5d                   	pop    %ebp
  805179:	c3                   	ret    
  80517a:	66 90                	xchg   %ax,%ax
  80517c:	89 d8                	mov    %ebx,%eax
  80517e:	f7 f7                	div    %edi
  805180:	31 ff                	xor    %edi,%edi
  805182:	89 fa                	mov    %edi,%edx
  805184:	83 c4 1c             	add    $0x1c,%esp
  805187:	5b                   	pop    %ebx
  805188:	5e                   	pop    %esi
  805189:	5f                   	pop    %edi
  80518a:	5d                   	pop    %ebp
  80518b:	c3                   	ret    
  80518c:	bd 20 00 00 00       	mov    $0x20,%ebp
  805191:	89 eb                	mov    %ebp,%ebx
  805193:	29 fb                	sub    %edi,%ebx
  805195:	89 f9                	mov    %edi,%ecx
  805197:	d3 e6                	shl    %cl,%esi
  805199:	89 c5                	mov    %eax,%ebp
  80519b:	88 d9                	mov    %bl,%cl
  80519d:	d3 ed                	shr    %cl,%ebp
  80519f:	89 e9                	mov    %ebp,%ecx
  8051a1:	09 f1                	or     %esi,%ecx
  8051a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8051a7:	89 f9                	mov    %edi,%ecx
  8051a9:	d3 e0                	shl    %cl,%eax
  8051ab:	89 c5                	mov    %eax,%ebp
  8051ad:	89 d6                	mov    %edx,%esi
  8051af:	88 d9                	mov    %bl,%cl
  8051b1:	d3 ee                	shr    %cl,%esi
  8051b3:	89 f9                	mov    %edi,%ecx
  8051b5:	d3 e2                	shl    %cl,%edx
  8051b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8051bb:	88 d9                	mov    %bl,%cl
  8051bd:	d3 e8                	shr    %cl,%eax
  8051bf:	09 c2                	or     %eax,%edx
  8051c1:	89 d0                	mov    %edx,%eax
  8051c3:	89 f2                	mov    %esi,%edx
  8051c5:	f7 74 24 0c          	divl   0xc(%esp)
  8051c9:	89 d6                	mov    %edx,%esi
  8051cb:	89 c3                	mov    %eax,%ebx
  8051cd:	f7 e5                	mul    %ebp
  8051cf:	39 d6                	cmp    %edx,%esi
  8051d1:	72 19                	jb     8051ec <__udivdi3+0xfc>
  8051d3:	74 0b                	je     8051e0 <__udivdi3+0xf0>
  8051d5:	89 d8                	mov    %ebx,%eax
  8051d7:	31 ff                	xor    %edi,%edi
  8051d9:	e9 58 ff ff ff       	jmp    805136 <__udivdi3+0x46>
  8051de:	66 90                	xchg   %ax,%ax
  8051e0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8051e4:	89 f9                	mov    %edi,%ecx
  8051e6:	d3 e2                	shl    %cl,%edx
  8051e8:	39 c2                	cmp    %eax,%edx
  8051ea:	73 e9                	jae    8051d5 <__udivdi3+0xe5>
  8051ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8051ef:	31 ff                	xor    %edi,%edi
  8051f1:	e9 40 ff ff ff       	jmp    805136 <__udivdi3+0x46>
  8051f6:	66 90                	xchg   %ax,%ax
  8051f8:	31 c0                	xor    %eax,%eax
  8051fa:	e9 37 ff ff ff       	jmp    805136 <__udivdi3+0x46>
  8051ff:	90                   	nop

00805200 <__umoddi3>:
  805200:	55                   	push   %ebp
  805201:	57                   	push   %edi
  805202:	56                   	push   %esi
  805203:	53                   	push   %ebx
  805204:	83 ec 1c             	sub    $0x1c,%esp
  805207:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80520b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80520f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  805213:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  805217:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80521b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80521f:	89 f3                	mov    %esi,%ebx
  805221:	89 fa                	mov    %edi,%edx
  805223:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  805227:	89 34 24             	mov    %esi,(%esp)
  80522a:	85 c0                	test   %eax,%eax
  80522c:	75 1a                	jne    805248 <__umoddi3+0x48>
  80522e:	39 f7                	cmp    %esi,%edi
  805230:	0f 86 a2 00 00 00    	jbe    8052d8 <__umoddi3+0xd8>
  805236:	89 c8                	mov    %ecx,%eax
  805238:	89 f2                	mov    %esi,%edx
  80523a:	f7 f7                	div    %edi
  80523c:	89 d0                	mov    %edx,%eax
  80523e:	31 d2                	xor    %edx,%edx
  805240:	83 c4 1c             	add    $0x1c,%esp
  805243:	5b                   	pop    %ebx
  805244:	5e                   	pop    %esi
  805245:	5f                   	pop    %edi
  805246:	5d                   	pop    %ebp
  805247:	c3                   	ret    
  805248:	39 f0                	cmp    %esi,%eax
  80524a:	0f 87 ac 00 00 00    	ja     8052fc <__umoddi3+0xfc>
  805250:	0f bd e8             	bsr    %eax,%ebp
  805253:	83 f5 1f             	xor    $0x1f,%ebp
  805256:	0f 84 ac 00 00 00    	je     805308 <__umoddi3+0x108>
  80525c:	bf 20 00 00 00       	mov    $0x20,%edi
  805261:	29 ef                	sub    %ebp,%edi
  805263:	89 fe                	mov    %edi,%esi
  805265:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  805269:	89 e9                	mov    %ebp,%ecx
  80526b:	d3 e0                	shl    %cl,%eax
  80526d:	89 d7                	mov    %edx,%edi
  80526f:	89 f1                	mov    %esi,%ecx
  805271:	d3 ef                	shr    %cl,%edi
  805273:	09 c7                	or     %eax,%edi
  805275:	89 e9                	mov    %ebp,%ecx
  805277:	d3 e2                	shl    %cl,%edx
  805279:	89 14 24             	mov    %edx,(%esp)
  80527c:	89 d8                	mov    %ebx,%eax
  80527e:	d3 e0                	shl    %cl,%eax
  805280:	89 c2                	mov    %eax,%edx
  805282:	8b 44 24 08          	mov    0x8(%esp),%eax
  805286:	d3 e0                	shl    %cl,%eax
  805288:	89 44 24 04          	mov    %eax,0x4(%esp)
  80528c:	8b 44 24 08          	mov    0x8(%esp),%eax
  805290:	89 f1                	mov    %esi,%ecx
  805292:	d3 e8                	shr    %cl,%eax
  805294:	09 d0                	or     %edx,%eax
  805296:	d3 eb                	shr    %cl,%ebx
  805298:	89 da                	mov    %ebx,%edx
  80529a:	f7 f7                	div    %edi
  80529c:	89 d3                	mov    %edx,%ebx
  80529e:	f7 24 24             	mull   (%esp)
  8052a1:	89 c6                	mov    %eax,%esi
  8052a3:	89 d1                	mov    %edx,%ecx
  8052a5:	39 d3                	cmp    %edx,%ebx
  8052a7:	0f 82 87 00 00 00    	jb     805334 <__umoddi3+0x134>
  8052ad:	0f 84 91 00 00 00    	je     805344 <__umoddi3+0x144>
  8052b3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8052b7:	29 f2                	sub    %esi,%edx
  8052b9:	19 cb                	sbb    %ecx,%ebx
  8052bb:	89 d8                	mov    %ebx,%eax
  8052bd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8052c1:	d3 e0                	shl    %cl,%eax
  8052c3:	89 e9                	mov    %ebp,%ecx
  8052c5:	d3 ea                	shr    %cl,%edx
  8052c7:	09 d0                	or     %edx,%eax
  8052c9:	89 e9                	mov    %ebp,%ecx
  8052cb:	d3 eb                	shr    %cl,%ebx
  8052cd:	89 da                	mov    %ebx,%edx
  8052cf:	83 c4 1c             	add    $0x1c,%esp
  8052d2:	5b                   	pop    %ebx
  8052d3:	5e                   	pop    %esi
  8052d4:	5f                   	pop    %edi
  8052d5:	5d                   	pop    %ebp
  8052d6:	c3                   	ret    
  8052d7:	90                   	nop
  8052d8:	89 fd                	mov    %edi,%ebp
  8052da:	85 ff                	test   %edi,%edi
  8052dc:	75 0b                	jne    8052e9 <__umoddi3+0xe9>
  8052de:	b8 01 00 00 00       	mov    $0x1,%eax
  8052e3:	31 d2                	xor    %edx,%edx
  8052e5:	f7 f7                	div    %edi
  8052e7:	89 c5                	mov    %eax,%ebp
  8052e9:	89 f0                	mov    %esi,%eax
  8052eb:	31 d2                	xor    %edx,%edx
  8052ed:	f7 f5                	div    %ebp
  8052ef:	89 c8                	mov    %ecx,%eax
  8052f1:	f7 f5                	div    %ebp
  8052f3:	89 d0                	mov    %edx,%eax
  8052f5:	e9 44 ff ff ff       	jmp    80523e <__umoddi3+0x3e>
  8052fa:	66 90                	xchg   %ax,%ax
  8052fc:	89 c8                	mov    %ecx,%eax
  8052fe:	89 f2                	mov    %esi,%edx
  805300:	83 c4 1c             	add    $0x1c,%esp
  805303:	5b                   	pop    %ebx
  805304:	5e                   	pop    %esi
  805305:	5f                   	pop    %edi
  805306:	5d                   	pop    %ebp
  805307:	c3                   	ret    
  805308:	3b 04 24             	cmp    (%esp),%eax
  80530b:	72 06                	jb     805313 <__umoddi3+0x113>
  80530d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  805311:	77 0f                	ja     805322 <__umoddi3+0x122>
  805313:	89 f2                	mov    %esi,%edx
  805315:	29 f9                	sub    %edi,%ecx
  805317:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80531b:	89 14 24             	mov    %edx,(%esp)
  80531e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  805322:	8b 44 24 04          	mov    0x4(%esp),%eax
  805326:	8b 14 24             	mov    (%esp),%edx
  805329:	83 c4 1c             	add    $0x1c,%esp
  80532c:	5b                   	pop    %ebx
  80532d:	5e                   	pop    %esi
  80532e:	5f                   	pop    %edi
  80532f:	5d                   	pop    %ebp
  805330:	c3                   	ret    
  805331:	8d 76 00             	lea    0x0(%esi),%esi
  805334:	2b 04 24             	sub    (%esp),%eax
  805337:	19 fa                	sbb    %edi,%edx
  805339:	89 d1                	mov    %edx,%ecx
  80533b:	89 c6                	mov    %eax,%esi
  80533d:	e9 71 ff ff ff       	jmp    8052b3 <__umoddi3+0xb3>
  805342:	66 90                	xchg   %ax,%ax
  805344:	39 44 24 04          	cmp    %eax,0x4(%esp)
  805348:	72 ea                	jb     805334 <__umoddi3+0x134>
  80534a:	89 d9                	mov    %ebx,%ecx
  80534c:	e9 62 ff ff ff       	jmp    8052b3 <__umoddi3+0xb3>
