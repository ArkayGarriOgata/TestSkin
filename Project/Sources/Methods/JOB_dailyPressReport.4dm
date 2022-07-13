//%attributes = {"publishedWeb":true}
//PM: JOB_dailyPressReport() -> 
//@author mlb - 8/23/01  14:59
//• mlb - 9/7/01  14:11 watch for CC change on same job
//• mlb - 3/11/02  15:45 added 481 482 483 487
// • mel (4/22/05, 11:09:24) use the IP variables for presses & gluers

C_DATE:C307($day; $1)
C_TEXT:C284($lastCC; $lastJob; $interesting; $gluers)
C_LONGINT:C283($i)
C_TEXT:C284($t; $cr)

$interesting:=<>PRESSES  //" 412 413 414 415 416 "
$gluers:=<>GLUERS  //" 476 477 478 479 480 481 482 483 487"
$interesting:=$interesting+$gluers  //• mlb - 9/4/01  10:03 add the gluing department

READ ONLY:C145([Jobs:15])
READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])
READ ONLY:C145([Cost_Centers:27])

$t:=Char:C90(9)
$cr:=Char:C90(13)

If (Count parameters:C259=0)
	$day:=Date:C102(Request:C163("Report which day?"; String:C10(4D_Current_date-1; System date short:K1:1); "Continue"; "Cancel"))
Else 
	$day:=$1
	oK:=1
End if 

If (OK=1)
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5=$day; *)
	QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]CostCenterID:2>"411")
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >; [Job_Forms_Machine_Tickets:61]JobForm:1; >)
		FIRST RECORD:C50([Job_Forms_Machine_Tickets:61])
		
		
	Else 
		
		ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >; [Job_Forms_Machine_Tickets:61]JobForm:1; >)
		
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	$lastCC:=""  //[MachineTicket]CostCenterID
	$lastJob:=""
	ARRAY REAL:C219($wcData; 0; 0)
	ARRAY REAL:C219($jobData; 0; 0)
	xTitle:="Press Room Operating Statistics for reporting period of "+String:C10($day; System date short:K1:1)
	xText:="Customer"+$t+"Line"+$t+"Job"+$t+"JobType"+$t
	xText:=xText+"3rdQty"+$t+"3rdMR"+$t+"3rdRun"+$t+"3rdNP"+$t+"3rdRate"+$t+$t
	xText:=xText+"1stQty"+$t+"1stMR"+$t+"1stRun"+$t+"1stNP"+$t+"1stRate"+$t+$t
	xText:=xText+"2ndQty"+$t+"2ndMR"+$t+"2ndRun"+$t+"2ndNP"+$t+"2ndRate"+$t+$t
	xText:=xText+"TotQty"+$t+"TotMR"+$t+"TotRun"+$t+"TotNP"+$t+"TotRate"+$cr
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($i; 1; Records in selection:C76([Job_Forms_Machine_Tickets:61]))
			If (Position:C15([Job_Forms_Machine_Tickets:61]CostCenterID:2; $interesting)>0)
				
				If (Position:C15([Job_Forms_Machine_Tickets:61]CostCenterID:2; $gluers)>0)
					$currentJob:=[Job_Forms_Machine_Tickets:61]JobForm:1+"."+String:C10([Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; "00")
				Else 
					$currentJob:=[Job_Forms_Machine_Tickets:61]JobForm:1
				End if 
				
				If ($currentJob#$lastJob) | ([Job_Forms_Machine_Tickets:61]CostCenterID:2#$lastCC)  //• mlb - 9/7/01  14:11 watch for CC change on same job
					If (Size of array:C274($jobData)>0)
						xText:=xText+$cust+$t+$line+$t+$lastJob+$t+$jobType+$t
						xText:=xText+String:C10($jobData{3}{1})+$t+String:C10($jobData{3}{2})+$t+String:C10($jobData{3}{3})+$t+String:C10($jobData{3}{4})+$t+String:C10($jobData{3}{5})+$t+$t
						xText:=xText+String:C10($jobData{1}{1})+$t+String:C10($jobData{1}{2})+$t+String:C10($jobData{1}{3})+$t+String:C10($jobData{1}{4})+$t+String:C10($jobData{1}{5})+$t+$t
						xText:=xText+String:C10($jobData{2}{1})+$t+String:C10($jobData{2}{2})+$t+String:C10($jobData{2}{3})+$t+String:C10($jobData{2}{4})+$t+String:C10($jobData{2}{5})+$t+$t
						$jobData{0}{1}:=$jobData{3}{1}+$jobData{1}{1}+$jobData{2}{1}
						$jobData{0}{2}:=$jobData{3}{2}+$jobData{1}{2}+$jobData{2}{2}
						$jobData{0}{3}:=$jobData{3}{3}+$jobData{1}{3}+$jobData{2}{3}
						$jobData{0}{4}:=$jobData{3}{4}+$jobData{1}{4}+$jobData{2}{4}
						$jobData{0}{5}:=$jobData{3}{5}+$jobData{1}{5}+$jobData{2}{5}
						xText:=xText+String:C10($jobData{0}{1})+$t+String:C10($jobData{0}{2})+$t+String:C10($jobData{0}{3})+$t+String:C10($jobData{0}{4})+$t+String:C10($jobData{0}{5})+$cr
					End if 
					
					If (Position:C15([Job_Forms_Machine_Tickets:61]CostCenterID:2; $gluers)>0)
						$lastJob:=[Job_Forms_Machine_Tickets:61]JobForm:1+"."+String:C10([Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; "00")
					Else 
						$lastJob:=[Job_Forms_Machine_Tickets:61]JobForm:1
					End if 
					
					QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12($lastJob; 1; 5))))
					$cust:=[Jobs:15]CustomerName:5
					$line:=[Jobs:15]Line:3
					QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=(Substring:C12($lastJob; 1; 8)))
					$jobType:=[Job_Forms:42]JobType:33
					ARRAY REAL:C219($jobData; 0; 0)
					ARRAY REAL:C219($jobData; 3; 5)
				End if 
				
				If ([Job_Forms_Machine_Tickets:61]CostCenterID:2#$lastCC)
					If (Size of array:C274($wcData)>0)  //start a new section
						xText:=xText+$cr+""+$t+"Daily"+$t+"Total"+$t+$t
						xText:=xText+String:C10($wcData{3}{1})+$t+String:C10($wcData{3}{2})+$t+String:C10($wcData{3}{3})+$t+String:C10($wcData{3}{4})+$t+String:C10($wcData{3}{5})+$t+$t
						xText:=xText+String:C10($wcData{1}{1})+$t+String:C10($wcData{1}{2})+$t+String:C10($wcData{1}{3})+$t+String:C10($wcData{1}{4})+$t+String:C10($wcData{1}{5})+$t+$t
						xText:=xText+String:C10($wcData{2}{1})+$t+String:C10($wcData{2}{2})+$t+String:C10($wcData{2}{3})+$t+String:C10($wcData{2}{4})+$t+String:C10($wcData{2}{5})+$t+$t
						$wcData{0}{1}:=$wcData{3}{1}+$wcData{1}{1}+$wcData{2}{1}
						$wcData{0}{2}:=$wcData{3}{2}+$wcData{1}{2}+$wcData{2}{2}
						$wcData{0}{3}:=$wcData{3}{3}+$wcData{1}{3}+$wcData{2}{3}
						$wcData{0}{4}:=$wcData{3}{4}+$wcData{1}{4}+$wcData{2}{4}
						$wcData{0}{5}:=$wcData{3}{5}+$wcData{1}{5}+$wcData{2}{5}
						xText:=xText+String:C10($wcData{0}{1})+$t+String:C10($wcData{0}{2})+$t+String:C10($wcData{0}{3})+$t+String:C10($wcData{0}{4})+$t+String:C10($wcData{0}{5})+$cr+$cr
					End if 
					
					$lastCC:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
					QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$lastCC)
					$workCtr:=[Cost_Centers:27]Description:3
					xText:=xText+$workCtr+$cr
					ARRAY REAL:C219($wcData; 0; 0)
					ARRAY REAL:C219($wcData; 3; 5)
				End if 
				
				$shift:=[Job_Forms_Machine_Tickets:61]Shift:18
				Case of   //• mlb - 3/18/03  09:38 handle mill shifts
					: (($shift>9) & ($shift<20))  //10 - 19
						$shift:=1
					: (($shift>19) & ($shift<30))  //20 - 29
						$shift:=2
					: (($shift>29) & ($shift<40))  //30 - 39
						$shift:=3
					: (($shift<1) | ($shift>3))  //• mlb - 11/21/01  10:40
						$shift:=1
					Else 
						//don't change          
				End case 
				
				$jobData{$shift}{1}:=$jobData{$shift}{1}+[Job_Forms_Machine_Tickets:61]Good_Units:8
				$jobData{$shift}{2}:=$jobData{$shift}{2}+[Job_Forms_Machine_Tickets:61]MR_Act:6
				$jobData{$shift}{3}:=$jobData{$shift}{3}+[Job_Forms_Machine_Tickets:61]Run_Act:7
				$jobData{$shift}{4}:=$jobData{$shift}{4}+[Job_Forms_Machine_Tickets:61]DownHrs:11
				$jobData{$shift}{5}:=Round:C94(($jobData{$shift}{1}/($jobData{$shift}{2}+$jobData{$shift}{3})); 0)
				
				$wcData{$shift}{1}:=$wcData{$shift}{1}+[Job_Forms_Machine_Tickets:61]Good_Units:8
				$wcData{$shift}{2}:=$wcData{$shift}{2}+[Job_Forms_Machine_Tickets:61]MR_Act:6
				$wcData{$shift}{3}:=$wcData{$shift}{3}+[Job_Forms_Machine_Tickets:61]Run_Act:7
				$wcData{$shift}{4}:=$wcData{$shift}{4}+[Job_Forms_Machine_Tickets:61]DownHrs:11
				$wcData{$shift}{5}:=Round:C94(($wcData{$shift}{1}/($wcData{$shift}{2}+$wcData{$shift}{3})); 0)
				
			End if 
			NEXT RECORD:C51([Job_Forms_Machine_Tickets:61])
		End for 
		
	Else 
		
		ARRAY TEXT:C222($_CostCenterID; 0)
		ARRAY TEXT:C222($_JobForm; 0)
		ARRAY INTEGER:C220($_GlueMachItemNo; 0)
		ARRAY LONGINT:C221($_Shift; 0)
		ARRAY LONGINT:C221($_Good_Units; 0)
		ARRAY REAL:C219($_MR_Act; 0)
		ARRAY REAL:C219($_Run_Act; 0)
		ARRAY REAL:C219($_DownHrs; 0)
		
		SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]CostCenterID:2; $_CostCenterID; \
			[Job_Forms_Machine_Tickets:61]JobForm:1; $_JobForm; \
			[Job_Forms_Machine_Tickets:61]GlueMachItemNo:4; $_GlueMachItemNo; \
			[Job_Forms_Machine_Tickets:61]Shift:18; $_Shift; \
			[Job_Forms_Machine_Tickets:61]Good_Units:8; $_Good_Units; \
			[Job_Forms_Machine_Tickets:61]MR_Act:6; $_MR_Act; \
			[Job_Forms_Machine_Tickets:61]Run_Act:7; $_Run_Act; \
			[Job_Forms_Machine_Tickets:61]DownHrs:11; $_DownHrs)
		
		
		For ($i; 1; Size of array:C274($_JobForm); 1)
			
			If (Position:C15($_CostCenterID{$i}; $interesting)>0)
				
				If (Position:C15($_CostCenterID{$i}; $gluers)>0)
					$currentJob:=$_JobForm{$i}+"."+String:C10($_GlueMachItemNo{$i}; "00")
				Else 
					$currentJob:=$_JobForm{$i}
				End if 
				
				If ($currentJob#$lastJob) | ($_CostCenterID{$i}#$lastCC)  //• mlb - 9/7/01  14:11 watch for CC change on same job
					If (Size of array:C274($jobData)>0)
						xText:=xText+$cust+$t+$line+$t+$lastJob+$t+$jobType+$t
						xText:=xText+String:C10($jobData{3}{1})+$t+String:C10($jobData{3}{2})+$t+String:C10($jobData{3}{3})+$t+String:C10($jobData{3}{4})+$t+String:C10($jobData{3}{5})+$t+$t
						xText:=xText+String:C10($jobData{1}{1})+$t+String:C10($jobData{1}{2})+$t+String:C10($jobData{1}{3})+$t+String:C10($jobData{1}{4})+$t+String:C10($jobData{1}{5})+$t+$t
						xText:=xText+String:C10($jobData{2}{1})+$t+String:C10($jobData{2}{2})+$t+String:C10($jobData{2}{3})+$t+String:C10($jobData{2}{4})+$t+String:C10($jobData{2}{5})+$t+$t
						$jobData{0}{1}:=$jobData{3}{1}+$jobData{1}{1}+$jobData{2}{1}
						$jobData{0}{2}:=$jobData{3}{2}+$jobData{1}{2}+$jobData{2}{2}
						$jobData{0}{3}:=$jobData{3}{3}+$jobData{1}{3}+$jobData{2}{3}
						$jobData{0}{4}:=$jobData{3}{4}+$jobData{1}{4}+$jobData{2}{4}
						$jobData{0}{5}:=$jobData{3}{5}+$jobData{1}{5}+$jobData{2}{5}
						xText:=xText+String:C10($jobData{0}{1})+$t+String:C10($jobData{0}{2})+$t+String:C10($jobData{0}{3})+$t+String:C10($jobData{0}{4})+$t+String:C10($jobData{0}{5})+$cr
					End if 
					
					If (Position:C15($_CostCenterID{$i}; $gluers)>0)
						$lastJob:=$_JobForm{$i}+"."+String:C10($_GlueMachItemNo{$i}; "00")
					Else 
						$lastJob:=$_JobForm{$i}
					End if 
					
					QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12($lastJob; 1; 5))))
					$cust:=[Jobs:15]CustomerName:5
					$line:=[Jobs:15]Line:3
					QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=(Substring:C12($lastJob; 1; 8)))
					$jobType:=[Job_Forms:42]JobType:33
					ARRAY REAL:C219($jobData; 0; 0)
					ARRAY REAL:C219($jobData; 3; 5)
				End if 
				
				If ($_CostCenterID{$i}#$lastCC)
					If (Size of array:C274($wcData)>0)  //start a new section
						xText:=xText+$cr+""+$t+"Daily"+$t+"Total"+$t+$t
						xText:=xText+String:C10($wcData{3}{1})+$t+String:C10($wcData{3}{2})+$t+String:C10($wcData{3}{3})+$t+String:C10($wcData{3}{4})+$t+String:C10($wcData{3}{5})+$t+$t
						xText:=xText+String:C10($wcData{1}{1})+$t+String:C10($wcData{1}{2})+$t+String:C10($wcData{1}{3})+$t+String:C10($wcData{1}{4})+$t+String:C10($wcData{1}{5})+$t+$t
						xText:=xText+String:C10($wcData{2}{1})+$t+String:C10($wcData{2}{2})+$t+String:C10($wcData{2}{3})+$t+String:C10($wcData{2}{4})+$t+String:C10($wcData{2}{5})+$t+$t
						$wcData{0}{1}:=$wcData{3}{1}+$wcData{1}{1}+$wcData{2}{1}
						$wcData{0}{2}:=$wcData{3}{2}+$wcData{1}{2}+$wcData{2}{2}
						$wcData{0}{3}:=$wcData{3}{3}+$wcData{1}{3}+$wcData{2}{3}
						$wcData{0}{4}:=$wcData{3}{4}+$wcData{1}{4}+$wcData{2}{4}
						$wcData{0}{5}:=$wcData{3}{5}+$wcData{1}{5}+$wcData{2}{5}
						xText:=xText+String:C10($wcData{0}{1})+$t+String:C10($wcData{0}{2})+$t+String:C10($wcData{0}{3})+$t+String:C10($wcData{0}{4})+$t+String:C10($wcData{0}{5})+$cr+$cr
					End if 
					
					$lastCC:=$_CostCenterID{$i}
					QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$lastCC)
					$workCtr:=[Cost_Centers:27]Description:3
					xText:=xText+$workCtr+$cr
					ARRAY REAL:C219($wcData; 0; 0)
					ARRAY REAL:C219($wcData; 3; 5)
				End if 
				
				$shift:=$_Shift{$i}
				Case of   //• mlb - 3/18/03  09:38 handle mill shifts
					: (($shift>9) & ($shift<20))  //10 - 19
						$shift:=1
					: (($shift>19) & ($shift<30))  //20 - 29
						$shift:=2
					: (($shift>29) & ($shift<40))  //30 - 39
						$shift:=3
					: (($shift<1) | ($shift>3))  //• mlb - 11/21/01  10:40
						$shift:=1
					Else 
						//don't change          
				End case 
				
				$jobData{$shift}{1}:=$jobData{$shift}{1}+$_Good_Units{$i}
				$jobData{$shift}{2}:=$jobData{$shift}{2}+$_MR_Act{$i}
				$jobData{$shift}{3}:=$jobData{$shift}{3}+$_Run_Act{$i}
				$jobData{$shift}{4}:=$jobData{$shift}{4}+$_DownHrs{$i}
				$jobData{$shift}{5}:=Round:C94(($jobData{$shift}{1}/($jobData{$shift}{2}+$jobData{$shift}{3})); 0)
				
				$wcData{$shift}{1}:=$wcData{$shift}{1}+$_Good_Units{$i}
				$wcData{$shift}{2}:=$wcData{$shift}{2}+$_MR_Act{$i}
				$wcData{$shift}{3}:=$wcData{$shift}{3}+$_Run_Act{$i}
				$wcData{$shift}{4}:=$wcData{$shift}{4}+$_DownHrs{$i}
				$wcData{$shift}{5}:=Round:C94(($wcData{$shift}{1}/($wcData{$shift}{2}+$wcData{$shift}{3})); 0)
				
			End if 
		End for 
		
	End if   // END 4D Professional Services : January 2019 
	
	If (Size of array:C274($jobData)>0)
		xText:=xText+$cust+$t+$line+$t+$lastJob+$t+$jobType+$t
		xText:=xText+String:C10($jobData{3}{1})+$t+String:C10($jobData{3}{2})+$t+String:C10($jobData{3}{3})+$t+String:C10($jobData{3}{4})+$t+String:C10($jobData{3}{5})+$t+$t
		xText:=xText+String:C10($jobData{1}{1})+$t+String:C10($jobData{1}{2})+$t+String:C10($jobData{1}{3})+$t+String:C10($jobData{1}{4})+$t+String:C10($jobData{1}{5})+$t+$t
		xText:=xText+String:C10($jobData{2}{1})+$t+String:C10($jobData{2}{2})+$t+String:C10($jobData{2}{3})+$t+String:C10($jobData{2}{4})+$t+String:C10($jobData{2}{5})+$t+$t
		$jobData{0}{1}:=$jobData{3}{1}+$jobData{1}{1}+$jobData{2}{1}
		$jobData{0}{2}:=$jobData{3}{2}+$jobData{1}{2}+$jobData{2}{2}
		$jobData{0}{3}:=$jobData{3}{3}+$jobData{1}{3}+$jobData{2}{3}
		$jobData{0}{4}:=$jobData{3}{4}+$jobData{1}{4}+$jobData{2}{4}
		$jobData{0}{5}:=$jobData{3}{5}+$jobData{1}{5}+$jobData{2}{5}
		xText:=xText+String:C10($jobData{0}{1})+$t+String:C10($jobData{0}{2})+$t+String:C10($jobData{0}{3})+$t+String:C10($jobData{0}{4})+$t+String:C10($jobData{0}{5})+$cr
	End if 
	
	If (Size of array:C274($wcData)>0)  //start a new section
		xText:=xText+$cr+""+$t+"Daily"+$t+"Total"+$t+$t
		xText:=xText+String:C10($wcData{3}{1})+$t+String:C10($wcData{3}{2})+$t+String:C10($wcData{3}{3})+$t+String:C10($wcData{3}{4})+$t+String:C10($wcData{3}{5})+$t+$t
		xText:=xText+String:C10($wcData{1}{1})+$t+String:C10($wcData{1}{2})+$t+String:C10($wcData{1}{3})+$t+String:C10($wcData{1}{4})+$t+String:C10($wcData{1}{5})+$t+$t
		xText:=xText+String:C10($wcData{2}{1})+$t+String:C10($wcData{2}{2})+$t+String:C10($wcData{2}{3})+$t+String:C10($wcData{2}{4})+$t+String:C10($wcData{2}{5})+$t+$t
		$wcData{0}{1}:=$wcData{3}{1}+$wcData{1}{1}+$wcData{2}{1}
		$wcData{0}{2}:=$wcData{3}{2}+$wcData{1}{2}+$wcData{2}{2}
		$wcData{0}{3}:=$wcData{3}{3}+$wcData{1}{3}+$wcData{2}{3}
		$wcData{0}{4}:=$wcData{3}{4}+$wcData{1}{4}+$wcData{2}{4}
		$wcData{0}{5}:=$wcData{3}{5}+$wcData{1}{5}+$wcData{2}{5}
		xText:=xText+String:C10($wcData{0}{1})+$t+String:C10($wcData{0}{2})+$t+String:C10($wcData{0}{3})+$t+String:C10($wcData{0}{4})+$t+String:C10($wcData{0}{5})+$cr+$cr
	End if 
	
	
	docName:="PressRoomStats_"+String:C10(TSTimeStamp)+".xls"
	$docRef:=util_putFileName(->docName)
	SEND PACKET:C103($docRef; xTitle+$cr+$cr)
	
	SEND PACKET:C103($docRef; xText)
	SEND PACKET:C103($docRef; $cr+$cr+"------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)
	$err:=util_Launch_External_App(docName)
	
	xTitle:=""
	xText:=""
	
	REDUCE SELECTION:C351([Jobs:15]; 0)
	REDUCE SELECTION:C351([Job_Forms:42]; 0)
	REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
	REDUCE SELECTION:C351([Cost_Centers:27]; 0)
End if 
//