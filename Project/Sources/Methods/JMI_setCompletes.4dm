//%attributes = {}
// Method: JMI_setCompletes () -> 
// ----------------------------------------------------
// by: mel: 05/20/05, 16:33:13
// ----------------------------------------------------
// Description:
// fix completed jmi's if jml is complete, first used in 0version052105
// ----------------------------------------------------
// Modified by: Mel Bohince (2/7/14) to assist the gluing schedule ween old jobs, set jmi complete if want qty met

C_LONGINT:C283($jmi; $jf; $i; $numRecs)  //count the changes
C_BOOLEAN:C305($break)

$jmi:=0
$jf:=0

READ ONLY:C145([Job_Forms_Master_Schedule:67])
READ WRITE:C146([Job_Forms_Items:44])
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)

$break:=False:C215
$numRecs:=Records in selection:C76([Job_Forms_Items:44])

uThermoInit($numRecs; "Updating JMI Records")
For ($i; 1; $numRecs)
	If ($break)
		$i:=$i+$numRecs
	End if 
	
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms_Items:44]JobForm:1; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15#!00-00-00!)
	
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
		[Job_Forms_Items:44]Completed:39:=[Job_Forms_Master_Schedule:67]DateComplete:15
		[Job_Forms_Items:44]CompletedTimeStamp:56:=TSTimeStamp([Job_Forms_Master_Schedule:67]DateComplete:15; Current time:C178)
		SAVE RECORD:C53([Job_Forms_Items:44])
		$jmi:=$jmi+1
		
	Else   // Modified by: Mel Bohince (2/7/14) to assist the gluing schedule ween old jobs
		// Modified by: Mel Bohince (2/25/14) now also in jmi trigger
		If ([Job_Forms_Items:44]Qty_Actual:11>=([Job_Forms_Items:44]Qty_Want:24*0.85))
			[Job_Forms_Items:44]Completed:39:=4D_Current_date
			SAVE RECORD:C53([Job_Forms_Items:44])
			$jmi:=$jmi+1
		End if 
	End if 
	
	NEXT RECORD:C51([Job_Forms_Items:44])
	uThermoUpdate($i)
End for 
uThermoClose

REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)

READ WRITE:C146([Job_Forms:42])
QUERY:C277([Job_Forms:42]; [Job_Forms:42]Completed:18=!00-00-00!)

$break:=False:C215
$numRecs:=Records in selection:C76([Job_Forms:42])

uThermoInit($numRecs; "Updating JMI Records")
For ($i; 1; $numRecs)
	If ($break)
		$i:=$i+$numRecs
	End if 
	
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Job_Forms:42]JobFormID:5; *)
	QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15#!00-00-00!)
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
		[Job_Forms:42]Completed:18:=[Job_Forms_Master_Schedule:67]DateComplete:15
		SAVE RECORD:C53([Job_Forms:42])
		$jf:=$jf+1
	End if 
	NEXT RECORD:C51([Job_Forms:42])
	uThermoUpdate($i)
End for 
uThermoClose

REDUCE SELECTION:C351([Job_Forms:42]; 0)
REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)

BEEP:C151
zwStatusMsg("DONE"; String:C10($jmi)+" jmi "+String:C10($jf)+" jf")