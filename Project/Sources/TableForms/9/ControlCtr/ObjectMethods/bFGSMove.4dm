// ----------------------------------------------------
// Object Method: [Customers_Projects].ControlCtr.bFGSMove
// ----------------------------------------------------

QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]Jobform:3=atJobForm{abSuptItemBottomLB})  // Added by: Mark Zinke (3/26/13)
Pjt_setReferId(pjtId)
$tablePtr:=->[JTB_Job_Transfer_Bags:112]
If (Records in set:C195("clickedIncludeRecord")>0)
	UNLOAD RECORD:C212($tablePtr->)
	CUT NAMED SELECTION:C334($tablePtr->; "hold")
	USE SET:C118("clickedIncludeRecord")
	
	
	$location:=JTB_setLocation
	$id:=[JTB_Job_Transfer_Bags:112]ID:1
	CONFIRM:C162("Move "+[JTB_Job_Transfer_Bags:112]ID:1+" to "+$location)
	If (ok=1)
		
		READ WRITE:C146([JTB_Job_Transfer_Bags:112])
		QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]ID:1=$id)
		If (fLockNLoad(->[JTB_Job_Transfer_Bags:112]))
			[JTB_Job_Transfer_Bags:112]Location:4:=$location
			SAVE RECORD:C53([JTB_Job_Transfer_Bags:112])
		Else 
			BEEP:C151
			ALERT:C41([JTB_Job_Transfer_Bags:112]ID:1+"'s record is in use, try again later.")
		End if 
		
		REDUCE SELECTION:C351([JTB_Job_Transfer_Bags:112]; 0)
		READ ONLY:C145([JTB_Job_Transfer_Bags:112])
		
		
		JTB_LogJTB($bagId; "Moved to "+$location)
	End if 
	FORM GOTO PAGE:C247(ppHome)
	SELECT LIST ITEMS BY POSITION:C381(tc_PjtControlCtr; 1)
	
	USE NAMED SELECTION:C332("hold")
	
Else 
	uConfirm("Please select a "+Table name:C256($tablePtr)+" record(s) to update."; "OK"; "Help")
End if 