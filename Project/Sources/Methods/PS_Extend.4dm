//%attributes = {"publishedWeb":true}
//PM: PS_Extend() -> 
//@author mlb - 12/4/01  15:49
//• mlb - 2/22/02  make this shopCalendar aware
//• mlb - 4/12/02 resolve conflicts of fixed dates
//• mlb - 6/26/02  14:14 protection for locked records
// • mel (9/23/04, 15:44:39) nothing special for sheeting
// Modified by: MelvinBohince (1/18/22) method leaving [Cost_Centers] record locked
// Modified by: MelvinBohince (3/1/22) log use on server

READ ONLY:C145([Cost_Centers:27])  // Modified by: MelvinBohince (1/18/22) method leaving [Cost_Centers] record locked, see at end also

C_LONGINT:C283($seq; $now; $planned; $start; $end; $priority)
C_BOOLEAN:C305(<>fContinue)  //set to false and cancel transaction if locked record is encountered
app_Log_Usage("log"; "PS Extend"; sCriterion1)
<>fContinue:=True:C214
If (False:C215)  // (Position(sCriterion1;◊SHEETERS)>0)
	BEEP:C151
	PS_ExtendSheeting
	
Else 
	
	//utl_LogfileServer (<>zResp;"SCHD EXTEND--"+sCriterion1)
	$err:=Shuttle_Register("schedule"; sCriterion1)
	
	$settings:=PS_Settings("set"; sCriterion1)
	//v1.0.0-PJK (12/23/15) no longer needed    
	SF_ShopCalendar("recall"; sCriterion1)
	$eff:=rReal1/100
	//*Build Set of All records for this w/c
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=sCriterion1; *)  //
		QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]Completed:23=0; *)  // • mel (10/14/04, 10:46:36)
		QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]Priority:3>0)  //0=notschd,
		CREATE SET:C116([ProductionSchedules:110]; "allJobSeq")
		
		//*Build Set of fixed starts for this w/c
		//temp duration to work out conflicts of fixed dates, 
		//it is added to the previous seq  
		
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=sCriterion1; *)
		QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]Completed:23=0; *)  // • mel (10/14/04, 10:46:36)
		QUERY:C277([ProductionSchedules:110];  & [ProductionSchedules:110]FixedStart:12=True:C214)
		CREATE SET:C116([ProductionSchedules:110]; "fixed")
		//*Build Set of floating starts for this w/c
		DIFFERENCE:C122("allJobSeq"; "fixed"; "floating")
		
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "floating")
		QUERY BY FORMULA:C48([ProductionSchedules:110]; \
			(\
			([ProductionSchedules:110]CostCenter:1=sCriterion1)\
			 & ([ProductionSchedules:110]Completed:23=0)\
			 & ([ProductionSchedules:110]Priority:3>0)\
			)\
			 & \
			(\
			([ProductionSchedules:110]CostCenter:1#sCriterion1)\
			 | ([ProductionSchedules:110]Completed:23#0)\
			 | ([ProductionSchedules:110]FixedStart:12=False:C215)\
			)\
			)
		
		
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		
	End if   // END 4D Professional Services : January 2019 
	//*--
	//*Extend floaters
	
	If (Records in set:C195("floating")>0)
		USE SET:C118("floating")
		ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; >)
		ARRAY LONGINT:C221($aPriority; Records in selection:C76([ProductionSchedules:110]))
		ARRAY LONGINT:C221($aStartTS; Size of array:C274($aPriority))
		
		
		START TRANSACTION:C239  //a locked record will set fContinue false and cancel transaction
		If (fLockNLoad(->[ProductionSchedules:110]))
			If ([ProductionSchedules:110]StartDate:4=!00-00-00!)  // (Not([PressSchedule]FixedStart))  `*.    Adjust Startdate if necessary
				$now:=TSTimeStamp
				$planned:=TSTimeStamp([ProductionSchedules:110]StartDate:4; [ProductionSchedules:110]StartTime:5)
				If ($planned<$now)
					TS2DateTime($now; ->[ProductionSchedules:110]StartDate:4; ->[ProductionSchedules:110]StartTime:5)
				End if 
				[ProductionSchedules:110]StartDate:4:=SF_ASAP([ProductionSchedules:110]StartDate:4; sCriterion1)  //v1.0.0-PJK (12/23/15) added second parameter for dept
			End if 
			
			$start:=TSTimeStamp([ProductionSchedules:110]StartDate:4; [ProductionSchedules:110]StartTime:5)
			$seq:=1
			$aPriority{$seq}:=[ProductionSchedules:110]Priority:3
			$aStartTS{$seq}:=$start
			$duration:=([ProductionSchedules:110]DurationSeconds:9*1)/$eff  //reduce by effiency factor
			zwStatusMsg("EXTENDING"; "Priority: "+String:C10([ProductionSchedules:110]Priority:3))
			$end:=SF_calcElapseTime($start; $duration; sCriterion1)  //v1.0.0-PJK (12/23/15) added second parameter for dept
			TS2DateTime($end; ->[ProductionSchedules:110]EndDate:6; ->[ProductionSchedules:110]EndTime:7)
			[ProductionSchedules:110]DurationTemp:17:=0
			SAVE RECORD:C53([ProductionSchedules:110])
		End if 
		
		NEXT RECORD:C51([ProductionSchedules:110])
		
		While (Not:C34(End selection:C36([ProductionSchedules:110]))) & (<>fContinue)
			If (fLockNLoad(->[ProductionSchedules:110]))
				zwStatusMsg("EXTENDING"; "Priority: "+String:C10([ProductionSchedules:110]Priority:3))
				If (Not:C34([ProductionSchedules:110]FixedStart:12))
					$start:=$end
					TS2DateTime($start; ->[ProductionSchedules:110]StartDate:4; ->[ProductionSchedules:110]StartTime:5)
				Else 
					$start:=TSTimeStamp([ProductionSchedules:110]StartDate:4; [ProductionSchedules:110]StartTime:5)
				End if 
				
				$seq:=$seq+1
				$aPriority{$seq}:=[ProductionSchedules:110]Priority:3
				$aStartTS{$seq}:=$start
				$duration:=([ProductionSchedules:110]DurationSeconds:9*1)/$eff  //reduce by effiency factor
				$end:=SF_calcElapseTime($start; $duration; sCriterion1)  //v1.0.0-PJK (12/23/15) added second parameter for dept
				TS2DateTime($end; ->[ProductionSchedules:110]EndDate:6; ->[ProductionSchedules:110]EndTime:7)
				[ProductionSchedules:110]DurationTemp:17:=0
				SAVE RECORD:C53([ProductionSchedules:110])
			End if 
			NEXT RECORD:C51([ProductionSchedules:110])
		End while 
		
	Else 
		ARRAY LONGINT:C221($aPriority; 0)
		ARRAY LONGINT:C221($aStartTS; 0)
	End if   // floaters
	
	//*Set Priority of the fixed and store their duration in prior seq
	//add the duration of the fixed time to the prior job to avoid overlap contention
	ARRAY LONGINT:C221($aTempDuration; Size of array:C274($aPriority))
	
	//determine priority of fixed jobs by
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		USE SET:C118("fixed")
		
		
	Else 
		
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=sCriterion1; *)
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]Completed:23=0; *)  // • mel (10/14/04, 10:46:36)
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]FixedStart:12=True:C214)
		
		
	End if   // END 4D Professional Services : January 2019 
	ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4; >; [ProductionSchedules:110]StartTime:5; >)
	$lastPriority:=0
	While (Not:C34(End selection:C36([ProductionSchedules:110]))) & (<>fContinue)
		If (fLockNLoad(->[ProductionSchedules:110]))
			$start:=TSTimeStamp([ProductionSchedules:110]StartDate:4; [ProductionSchedules:110]StartTime:5)
			$priority:=0
			
			For ($seq; 1; Size of array:C274($aPriority))
				If ($aStartTS{$seq}>$start)
					$priority:=$aPriority{$seq}-1
					If ($seq>1)  //bounds check
						$aTempDuration{$seq-1}:=[ProductionSchedules:110]DurationSeconds:9*1  //this will be added in on the second pass
					End if 
					
					$seq:=$seq+Size of array:C274($aPriority)  //break
					
				Else 
					$priority:=$aPriority{$seq}+1
					If ($priority<$lastPriority)
						$priority:=$lastPriority+1
						$lastPriority:=$priority
					Else 
						$lastPriority:=$priority+1
					End if 
				End if 
				
			End for 
			[ProductionSchedules:110]Priority:3:=$priority
			[ProductionSchedules:110]DurationTemp:17:=0
			SAVE RECORD:C53([ProductionSchedules:110])
		End if   //locked
		NEXT RECORD:C51([ProductionSchedules:110])
	End while 
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		CLEAR SET:C117("floating")
		CLEAR SET:C117("fixed")
		USE SET:C118("allJobSeq")
		CLEAR SET:C117("allJobSeq")
		
	Else 
		CLEAR SET:C117("floating")
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=sCriterion1; *)  //
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]Completed:23=0; *)  // • mel (10/14/04, 10:46:36)
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3>0)  //0=notschd,
		
	End if   // END 4D Professional Services : January 2019 
	
	//*Extend combined fixed and floaters
	ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; >)
	If (fLockNLoad(->[ProductionSchedules:110]))
		$start:=TSTimeStamp([ProductionSchedules:110]StartDate:4; [ProductionSchedules:110]StartTime:5)
		$duration:=([ProductionSchedules:110]DurationSeconds:9*1)/$eff  //reduce by effiency factor
		$hit:=Find in array:C230($aPriority; [ProductionSchedules:110]Priority:3)
		If ($hit>-1)
			$duration:=$duration+$aTempDuration{$hit}
		End if 
		zwStatusMsg("EXTENDING"; "Priority: "+String:C10([ProductionSchedules:110]Priority:3))
		$end:=SF_calcElapseTime($start; $duration; sCriterion1)  //v1.0.0-PJK (12/23/15) added second parameter for dept
		TS2DateTime($end; ->[ProductionSchedules:110]EndDate:6; ->[ProductionSchedules:110]EndTime:7)
		SAVE RECORD:C53([ProductionSchedules:110])
	End if   //locked
	NEXT RECORD:C51([ProductionSchedules:110])
	$highEnd:=$end
	While (Not:C34(End selection:C36([ProductionSchedules:110]))) & (<>fContinue)
		If (fLockNLoad(->[ProductionSchedules:110]))
			zwStatusMsg("EXTENDING"; "Priority: "+String:C10([ProductionSchedules:110]Priority:3))
			If (Not:C34([ProductionSchedules:110]FixedStart:12))
				$start:=$end
				TS2DateTime($start; ->[ProductionSchedules:110]StartDate:4; ->[ProductionSchedules:110]StartTime:5)
				
			Else   //fixed
				$start:=TSTimeStamp([ProductionSchedules:110]StartDate:4; [ProductionSchedules:110]StartTime:5)
			End if 
			$duration:=([ProductionSchedules:110]DurationSeconds:9*1)/$eff  //reduce by effiency factor
			$hit:=Find in array:C230($aPriority; [ProductionSchedules:110]Priority:3)
			If ($hit>-1)
				$duration:=$duration+$aTempDuration{$hit}
			End if 
			$end:=SF_calcElapseTime($start; $duration; sCriterion1)  //v1.0.0-PJK (12/23/15) added second parameter for dept
			TS2DateTime($end; ->[ProductionSchedules:110]EndDate:6; ->[ProductionSchedules:110]EndTime:7)
			SAVE RECORD:C53([ProductionSchedules:110])
			If ($end>$highEnd)
				$highEnd:=$end
			Else 
				$end:=$highEnd
			End if 
		End if   //locked      
		NEXT RECORD:C51([ProductionSchedules:110])
	End while 
	
	If (<>fContinue)
		VALIDATE TRANSACTION:C240
		utl_LogfileServer("PSEX"; sCriterion1+" extended "; "press_schedule.log")  // Modified by: MelvinBohince (3/1/22) log use on server
		
	Else   //locked record encountered
		CANCEL TRANSACTION:C241
		BEEP:C151
		ALERT:C41("A Locked record prevented the Schedule from being Extended")
	End if 
	
End if   //sheeter    

If (<>fContinue)
	BEEP:C151
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4; >; [ProductionSchedules:110]StartTime:5; >)
		START TRANSACTION:C239
		FIRST RECORD:C50([ProductionSchedules:110])
		
		
	Else 
		
		ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4; >; [ProductionSchedules:110]StartTime:5; >)
		START TRANSACTION:C239
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	SELECTION TO ARRAY:C260([ProductionSchedules:110]Priority:3; $aPriority)
	$numSeq:=Size of array:C274($aPriority)
	If ($numSeq>0)
		uConfirm("Change Priorties to multiples of 10?"; "by 10's"; "Don't Change")
		If (ok=1)
			For ($i; 1; $numSeq)
				$aPriority{$i}:=$i*10
			End for 
			
		Else 
			$lastPriority:=0
			For ($i; 1; $numSeq)
				If ($aPriority{$i}<$lastPriority)
					$aPriority{$i-1}:=$aPriority{$i}-1
				End if 
				$lastPriority:=$aPriority{$i}
			End for 
		End if 
		ARRAY TO SELECTION:C261($aPriority; [ProductionSchedules:110]Priority:3)
		If (Records in set:C195("LockedSet")=0)
			VALIDATE TRANSACTION:C240
		Else 
			CANCEL TRANSACTION:C241
			uConfirm(String:C10(Records in set:C195("LockedSet"))+" records were locked, Priorites haven't been changed."; "Try Later"; "Help")
		End if 
	End if 
End if 

BEEP:C151
zwStatusMsg("SCHD"; "Finished Extending dates")
FIRST RECORD:C50([ProductionSchedules:110])
UNLOAD RECORD:C212([ProductionSchedules:110])
REDUCE SELECTION:C351([Cost_Centers:27]; 0)  // Modified by: MelvinBohince (1/18/22) method leaving [Cost_Centers] record locked
