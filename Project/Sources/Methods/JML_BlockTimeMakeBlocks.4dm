//%attributes = {}
// Method: JML_BlockTimeMakeBlocks () -> 
// ----------------------------------------------------
// by: mel: 01/28/05, 09:35:25
// ----------------------------------------------------
// Description:
// create job, jobform, jobmasterlog, and productionSchedule records per blocking pattern.
//Updates:
// • mel (1/28/05, 15:54:25) add comments, HRD,
// ----------------------------------------------------

C_LONGINT:C283($job; $jobNumber; $row; $secondsLag; $adjustedStart; $secondsDuration; $duration; $end)
C_TEXT:C284($jobform; $cc; $jobformSeq)
C_POINTER:C301($ptrCC; $ptrHrs; $ptrLag)

READ WRITE:C146([Jobs:15])
READ WRITE:C146([Job_Forms:42])
READ WRITE:C146([Job_Forms_Master_Schedule:67])
READ WRITE:C146([ProductionSchedules:110])
READ ONLY:C145([Cost_Centers:27])

uThermoInit([ProductionSchedules_BlockTimes:136]NumberOfTimes:6; "Blocking out time for "+[ProductionSchedules_BlockTimes:136]BlockId:1)
For ($job; 1; [ProductionSchedules_BlockTimes:136]NumberOfTimes:6)
	uThermoUpdate($job)
	$jobform:=[ProductionSchedules_BlockTimes:136]BlockId:1+"."+String:C10($job; "00")
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$jobform)
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])=0)
		CREATE RECORD:C68([Job_Forms_Master_Schedule:67])
		[Job_Forms_Master_Schedule:67]JobForm:4:=$jobform
		[Job_Forms_Master_Schedule:67]Customer:2:=[Customers_Projects:9]CustomerName:4
		[Job_Forms_Master_Schedule:67]ProjectNumber:26:=[ProductionSchedules_BlockTimes:136]ProjectNumber:2
		[Job_Forms_Master_Schedule:67]JobType:31:="BLOCK"
	End if 
	[Job_Forms_Master_Schedule:67]PressDate:25:=dDateBegin
	[Job_Forms_Master_Schedule:67]GateWayDeadLine:42:=dDateBegin-iDays
	[Job_Forms_Master_Schedule:67]OrigRevDate:20:=[Job_Forms_Master_Schedule:67]MAD:21
	[Job_Forms_Master_Schedule:67]MAD:21:=dDateBegin+(7*iHRDweeks)
	[Job_Forms_Master_Schedule:67]WeekNumber:38:=util_weekNumber([Job_Forms_Master_Schedule:67]PressDate:25)
	
	[Job_Forms_Master_Schedule:67]Line:5:=[ProductionSchedules_BlockTimes:136]LineSpecificationID:4
	[Job_Forms_Master_Schedule:67]Operations:36:=""
	For ($row; 1; 9)
		$ptrCC:=Get pointer:C304("r"+String:C10($row))
		If ($ptrCC->>0)
			[Job_Forms_Master_Schedule:67]Operations:36:=[Job_Forms_Master_Schedule:67]Operations:36+" "+String:C10($ptrCC->)
		End if 
	End for 
	
	[Job_Forms_Master_Schedule:67]Comment:22:=sComment
	[Job_Forms_Master_Schedule:67]SheetQty:6:=iSheets
	[Job_Forms_Master_Schedule:67]S_Number:7:=sRMcode
	
	SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
	
	$jobNumber:=Num:C11(Substring:C12($jobform; 1; 5))
	QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=$jobNumber)
	If (Records in selection:C76([Jobs:15])=0)
		CREATE RECORD:C68([Jobs:15])
		[Jobs:15]JobNo:1:=$jobNumber
		[Jobs:15]ProjectNumber:18:=[ProductionSchedules_BlockTimes:136]ProjectNumber:2
		[Jobs:15]zCount:10:=1
		[Jobs:15]CustID:2:=[Customers_Projects:9]Customerid:3
		[Jobs:15]CustomerName:5:=[Customers_Projects:9]CustomerName:4
		[Jobs:15]Status:4:="BLOCK"
	End if 
	[Jobs:15]Line:3:=[ProductionSchedules_BlockTimes:136]LineSpecificationID:4
	[Jobs:15]ModDate:8:=4D_Current_date
	[Jobs:15]ModWho:9:=<>zResp
	[Jobs:15]ProcessSpec:14:=[ProductionSchedules_BlockTimes:136]LineSpecificationID:4
	[Jobs:15]ChangeLog:19:=sComment
	SAVE RECORD:C53([Jobs:15])
	
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)
	If (Records in selection:C76([Job_Forms:42])=0)
		CREATE RECORD:C68([Job_Forms:42])
		[Job_Forms:42]JobNo:2:=$jobNumber
		[Job_Forms:42]JobFormID:5:=$jobform
		[Job_Forms:42]FormNumber:3:=$job
		[Job_Forms:42]ProjectNumber:56:=[ProductionSchedules_BlockTimes:136]ProjectNumber:2
		[Job_Forms:42]Status:6:="BLOCK"
		[Job_Forms:42]JobType:33:="BLOCK"
		[Job_Forms:42]cust_id:82:=[Jobs:15]CustID:2
	End if 
	[Job_Forms:42]CustomerLine:62:=[ProductionSchedules_BlockTimes:136]LineSpecificationID:4
	[Job_Forms:42]EstGrossSheets:27:=iSheets
	
	[Job_Forms:42]ModDate:7:=4D_Current_date
	[Job_Forms:42]ModWho:8:=<>zResp
	[Job_Forms:42]NeedDate:1:=dDateBegin
	[Job_Forms:42]NumberUp:26:=iUp
	[Job_Forms:42]ProcessSpec:46:=[ProductionSchedules_BlockTimes:136]LineSpecificationID:4
	[Job_Forms:42]QtyWant:22:=iSheets*iUp
	[Job_Forms:42]Notes:32:=sComment
	SAVE RECORD:C53([Job_Forms:42])
	
	dDate:=dDateBegin
	tTime:=?07:30:00?  //primer for the first operation
	
	$sequenceNum:=0
	For ($seq; 1; 9)
		$ptrCC:=Get pointer:C304("r"+String:C10($seq))
		If ($ptrCC->>0)
			$sequenceNum:=$sequenceNum+10
			$cc:=String:C10($ptrCC->)
			$ptrHrs:=Get pointer:C304("r2"+String:C10($seq))
			$ptrLag:=Get pointer:C304("r3"+String:C10($seq))
			
			$jobformSeq:=$jobform+"."+String:C10($sequenceNum; "000")
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=$jobformSeq)
			If (Records in selection:C76([ProductionSchedules:110])=0)
				CREATE RECORD:C68([ProductionSchedules:110])
				[ProductionSchedules:110]JobSequence:8:=$jobformSeq
			End if 
			
			[ProductionSchedules:110]CostCenter:1:=$cc
			QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$cc)
			[ProductionSchedules:110]Name:2:=[Cost_Centers:27]Description:3
			
			[ProductionSchedules:110]Line:10:=[Job_Forms_Master_Schedule:67]Line:5
			[ProductionSchedules:110]Customer:11:=[Customers_Projects:9]CustomerName:4
			
			[ProductionSchedules:110]FixedStart:12:=True:C214
			[ProductionSchedules:110]Priority:3:=0
			
			$secondsLag:=$ptrLag->*3600
			$adjustedStart:=TSTimeStamp(dDate; tTime)+$secondsLag
			TS2DateTime($adjustedStart; ->[ProductionSchedules:110]StartDate:4; ->[ProductionSchedules:110]StartTime:5)
			
			$secondsDuration:=$ptrHrs->*3600
			[ProductionSchedules:110]DurationSeconds:9:=Time:C179(Time string:C180($secondsDuration))
			
			$duration:=[ProductionSchedules:110]DurationSeconds:9*1
			$end:=$adjustedStart+$duration
			TS2DateTime($end; ->dDate; ->tTime)
			[ProductionSchedules:110]EndDate:6:=dDate
			[ProductionSchedules:110]EndTime:7:=tTime
			
			[ProductionSchedules:110]AllOperations:14:=[Job_Forms_Master_Schedule:67]Operations:36
			[ProductionSchedules:110]NumSubForms:16:=0
			[ProductionSchedules:110]Comment:22:=sComment
			SAVE RECORD:C53([ProductionSchedules:110])
			
		End if 
		
	End for 
	
	//set up for next blocking
	Case of 
		: (rb1=1)
			dDateBegin:=dDateBegin
		: (rb2=1)
			dDateBegin:=Add to date:C393(dDateBegin; 0; 0; 7)
		: (rb3=1)
			dDateBegin:=Add to date:C393(dDateBegin; 0; 1; 0)
		: (rb4=1)
			dDateBegin:=Add to date:C393(dDateBegin; 0; 3; 0)
		: (rb5=1)
			dDateBegin:=Add to date:C393(dDateBegin; 0; 0; 14)
		: (rb6=1)
			dDateBegin:=Add to date:C393(dDateBegin; 0; 2; 0)
	End case 
End for 
uThermoClose
REDUCE SELECTION:C351([Jobs:15]; 0)
REDUCE SELECTION:C351([Job_Forms:42]; 0)
REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
REDUCE SELECTION:C351([Cost_Centers:27]; 0)