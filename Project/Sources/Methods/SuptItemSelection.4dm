//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/25/13, 21:14:58
// ----------------------------------------------------
// Method: SuptItemSelection
// ----------------------------------------------------

C_TEXT:C284($tWhichOne; $1)

$tWhichOne:=$1

If ($tWhichOne="Top")
	
	//correct bug last release 03-28-2019
	QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]ID:1=atID{abSuptItemTopLB})
	CREATE SET:C116([JPSI_Job_Physical_Support_Items:111]; "clickedIncludeRecord")
	
	
	If (Form event code:C388=On Double Clicked:K2:5)
		app_OpenDoubleClickedRecord(->[JPSI_Job_Physical_Support_Items:111]; iMode)
	End if 
	
Else 
	SET QUERY DESTINATION:C396(Into set:K19:2; "clickedIncludeRecord")
	QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]Jobform:3=atJobForm{abSuptItemBottomLB})
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	If (Form event code:C388=On Double Clicked:K2:5)
		app_OpenDoubleClickedRecord(->[JTB_Job_Transfer_Bags:112]; iMode)
	End if 
End if 