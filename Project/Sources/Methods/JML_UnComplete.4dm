//%attributes = {}
// Method: JML_UnComplete () -> 
// ----------------------------------------------------
// by: mel: 08/09/05, 18:21:51
// ----------------------------------------------------
// Description:
// called from JML input
// ----------------------------------------------------
// • mel (3/2/04, 17:20:18) set jmi act back to 0 if at 1

READ WRITE:C146([Job_Forms:42])
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Master_Schedule:67]JobForm:4)
If (Records in selection:C76([Job_Forms:42])=1)
	If (fLockNLoad(->[Job_Forms:42]))
		If ([Job_Forms:42]Status:6#"Closed")
			CONFIRM:C162("Change the status of this form from Complete to WIP?"; "WIP"; [Job_Forms:42]Status:6)
			If (OK=1)
				<>jobform:=[Job_Forms:42]JobFormID:5
				[Job_Forms:42]Status:6:="WIP"
				[Job_Forms:42]Completed:18:=!00-00-00!
				[Job_Forms:42]NoticeGiven:67:=0
				SAVE RECORD:C53([Job_Forms:42])
				
				[Job_Forms_Master_Schedule:67]DateComplete:15:=!00-00-00!
				SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
				
				CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "items")
				QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4)
				If (Records in selection:C76([Job_Forms_Items:44])>0)
					APPLY TO SELECTION:C70([Job_Forms_Items:44]; JML_UnCompleteItems)
					//APPLY TO SELECTION([Job_Forms_Items];[Job_Forms_Items]Qty_Actual:=0)
					//APPLY TO SELECTION([Job_Forms_Items];[Job_Forms_Items]Completed:=!00/00/0000!)
					//APPLY TO SELECTION([Job_Forms_Items];[Job_Forms_Items]CompletedTimeStamp:=0)
				End if 
				USE NAMED SELECTION:C332("items")
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41("Job is Closed, get Cost Accounting to re-open.")
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("Jobform record is locked.")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Jobform record is  missing.")
End if 