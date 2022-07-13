// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/07/06, 17:08:32
// ----------------------------------------------------
// Method: Customer iTabControl
// ----------------------------------------------------
C_LONGINT:C283($itemRef)
C_TEXT:C284($targetPage)
GET LIST ITEM:C378(iTabControlSub; *; $itemRef; $targetPage)
Case of 
	: ($targetPage="Milestones")
		C_BOOLEAN:C305($setDate)
		$setDate:=False:C215
		If ($setDate)
			If (Records in selection:C76([To_Do_Tasks:100])>0)
				
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([To_Do_Tasks:100]; [To_Do_Tasks:100]Done:4=False:C215)
				
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				
				If (Records in selection:C76([To_Do_Tasks:100])=0)
					$setDate:=True:C214
				End if 
			End if 
			
			If ($setDate) & (False:C215)  // • mel (11/9/04, 16:03:47)disabled
				If ([Job_Forms_Master_Schedule:67]DateFinalToolApproved:18=!00-00-00!)
					[Job_Forms_Master_Schedule:67]DateFinalToolApproved:18:=4D_Current_date
				End if 
				If ([Job_Forms_Master_Schedule:67]DateClosingMet:23=!00-00-00!)
					[Job_Forms_Master_Schedule:67]DateClosingMet:23:=JML_getGateWayMet([Job_Forms_Master_Schedule:67]JobForm:4)
				End if 
			End if 
		End if 
		
	: ($targetPage="Production Meeting")
		READ WRITE:C146([To_Do_Tasks:100])
		QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Jobform:1=([Job_Forms_Master_Schedule:67]JobForm:4+"@"))
		ORDER BY:C49([To_Do_Tasks:100]; [To_Do_Tasks:100]Category:2; >; [To_Do_Tasks:100]Task:3; >)
		
	: ($targetPage="Help")
		
End case 

