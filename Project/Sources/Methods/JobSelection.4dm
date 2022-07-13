//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/21/13, 14:16:50
// ----------------------------------------------------
// Method: JobSelection
// ----------------------------------------------------

//correct bug last release 03-28-2019 

QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=atJobID{abJobLinesLB})
CREATE SET:C116([Job_Forms:42]; "clickedIncludeRecord")


If (Form event code:C388=On Double Clicked:K2:5)
	app_OpenDoubleClickedRecord(->[Job_Forms:42]; iMode)
End if 