// ----------------------------------------------------
// User name (OS): mlb
// Date and time: 2/1/02  15:05
// ----------------------------------------------------
// Object Method:[Customers_Projects].ControlCtr.projectSelected12
// ----------------------------------------------------

QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]ID:1=atID{abSuptItemTopLB})  // Added by: Mark Zinke (3/26/13)
Pjt_setReferId(pjtId)
$pjt:=[JPSI_Job_Physical_Support_Items:111]PjtNumber:3
If ($pjt=pjtId)
	$location:=JTB_setLocation
	$id:=[JPSI_Job_Physical_Support_Items:111]ID:1
	If (Substring:C12([JPSI_Job_Physical_Support_Items:111]Location:5; 1; 6)#"Inside")
		CONFIRM:C162("Move "+[JPSI_Job_Physical_Support_Items:111]ID:1+", "+[JPSI_Job_Physical_Support_Items:111]ItemType:2+", to "+$location)
		If (ok=1)
			CUT NAMED SELECTION:C334([JPSI_Job_Physical_Support_Items:111]; "hold")
			READ WRITE:C146([JPSI_Job_Physical_Support_Items:111])
			QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]ID:1=$id)
			[JPSI_Job_Physical_Support_Items:111]Location:5:=$location
			SAVE RECORD:C53([JPSI_Job_Physical_Support_Items:111])
			REDUCE SELECTION:C351([JPSI_Job_Physical_Support_Items:111]; 0)
			READ ONLY:C145([JPSI_Job_Physical_Support_Items:111])
			USE NAMED SELECTION:C332("hold")
			
			JTB_LogJPSI($id; "Moved to "+$location)
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("This item needs to be Check-Out of Bag "+Substring:C12([JPSI_Job_Physical_Support_Items:111]Location:5; 8)+" before it can be Moved.")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Please select a JobPhysSuptItem to Move.")
End if 