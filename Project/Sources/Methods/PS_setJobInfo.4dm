//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 04/29/08, 10:56:32
// ----------------------------------------------------
// Method: PS_setJobInfo(jobform)->[ProductionSchedules]JobInfo
// Description
// using a text var on output listing wasn't giving reliable display info
// ----------------------------------------------------
// Modified by: Mel Bohince (3/11/16) `whether or not to change JFM selection

C_TEXT:C284($jobInfo; $launch; $finishAtPlant; $firstRel; $1; $jobform; $emboss)
C_LONGINT:C283($caliper; $2)

$jobInfo:="  "+$jobInfo+" not found"
$caliper:=0
$launch:=" "
$finishAtPlant:="??"
$firstRel:="??/??/????"
$mad:="??/??/????"
$emboss:=""

If ((Position:C15([ProductionSchedules:110]CostCenter:1; <>EMBOSSERS)>0) | (Position:C15([ProductionSchedules:110]CostCenter:1; <>STAMPERS)>0))
	If (Count parameters:C259<2)  // Modified by: Mel Bohince (3/11/16) `whether or not to change JFM selection
		READ ONLY:C145([Job_Forms_Machines:43])
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobSequence:8=[ProductionSchedules:110]JobSequence:8)
	End if   // params
	$embossUnits:=[Job_Forms_Machines:43]Flex_field1:6
	If ($embossUnits>0)
		$emboss:=" Emboss"
	End if 
End if 

If (Count parameters:C259=1)
	$jobform:=Substring:C12($1; 1; 8)
Else 
	$jobform:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
End if 

If (Length:C16($jobform)>7)
	[ProductionSchedules:110]Info:13:=String:C10(Round:C94([ProductionSchedules:110]Planned_MR:52; 0))+"+"+String:C10(Round:C94([ProductionSchedules:110]Planned_Run:53; 0))
	
	SET QUERY LIMIT:C395(1)
	If ([Job_Forms_Master_Schedule:67]JobForm:4#$jobform)
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$jobform)
		$queriedJML:=True:C214
	Else 
		$queriedJML:=False:C215
	End if 
	
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
		$caliper:=Round:C94([Job_Forms_Master_Schedule:67]caliper:63*1000; 0)
		$launch:=Substring:C12([Job_Forms_Master_Schedule:67]Launch:64; 1; 1)
		If (Length:C16($launch)<1)
			$launch:=" "
		End if 
		[ProductionSchedules:110]FirstRelease:59:=[Job_Forms_Master_Schedule:67]FirstReleaseDat:13
		If ([ProductionSchedules:110]Completed:23=0)
			[ProductionSchedules:110]AllOperations:14:=[Job_Forms_Master_Schedule:67]Operations:36
		End if 
		$firstRel:=Substring:C12(String:C10([ProductionSchedules:110]FirstRelease:59; Internal date short:K1:7); 1; 5)
		[ProductionSchedules:110]HRD:60:=[Job_Forms_Master_Schedule:67]MAD:21
		$mad:=Substring:C12(String:C10([ProductionSchedules:110]HRD:60; Internal date short:K1:7); 1; 5)
		
		$finishAtPlant:=[Job_Forms_Master_Schedule:67]LocationOfMfg:30
		Case of 
			: ($finishAtPlant="VA")
				$finishAtPlant:="VA"
				
			: ($finishAtPlant="Roanoke")
				$finishAtPlant:="VA"
				
			: ($finishAtPlant="VA/PR")
				$finishAtPlant:="VA"
				
			: ($finishAtPlant="NY/VA")
				$finishAtPlant:="VA"
				
			: ($finishAtPlant="VA/NY")
				$finishAtPlant:="VA"
				
			: ($finishAtPlant="OS")
				$finishAtPlant:="OS"
				
			: ($finishAtPlant="O/S")
				$finishAtPlant:="OS"
				
			: ($finishAtPlant="Hauppauge")
				$finishAtPlant:="VA"
				
			: ($finishAtPlant="NY/PR")
				$finishAtPlant:="VA"
				
			Else 
				$slash:=Position:C15("/"; $finishAtPlant)
				If ($slash=0)
					$finishAtPlant:="??"
				Else 
					$finishAtPlant:=Substring:C12($finishAtPlant; ($slash+1))
				End if 
		End case 
	End if 
	
	If ($queriedJML)
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
	End if 
	
	If ([Job_Forms:42]JobFormID:5#$jobform)
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)
		$queriedJF:=True:C214
	Else 
		$queriedJF:=False:C215
	End if 
	
	If (Records in selection:C76([Job_Forms:42])>0)
		Case of 
			: ([Job_Forms:42]Status:6="Hold")
				$jobInfo:="ON HOLD, CALL PLANNER ["+[Job_Forms:42]ModWho:8+"]"
				
			: ([Job_Forms:42]Status:6="Kill")
				$jobInfo:="JOB KILLED, CALL PLANNER ["+[Job_Forms:42]ModWho:8+"]"
				
			: ([Job_Forms:42]Status:6="Closed")
				$jobInfo:="JOB CLOSED, CALL PLANNER ["+[Job_Forms:42]ModWho:8+"]"
				
			Else 
				$jobInfo:=String:C10(Round:C94([Job_Forms:42]Width:23; 1); "^^.0")+"x"+String:C10(Round:C94([Job_Forms:42]Lenth:24; 1); "^^.0")+" "+String:C10($caliper; "^^")+"pt "+String:C10(Round:C94([Job_Forms:42]EstGrossSheets:27/1000; 0); "^^^")+"M "+$launch+" "+$firstRel+" "+$mad+" "+$finishAtPlant
		End case 
	End if 
	
	SET QUERY LIMIT:C395(0)
	If ($queriedJF)
		REDUCE SELECTION:C351([Job_Forms:42]; 0)
	End if 
End if 
[ProductionSchedules:110]JobInfo:58:=$jobInfo+$emboss