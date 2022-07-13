//OM: Jobform() -> 
//@author mlb - 2/5/02  12:02

READ ONLY:C145([Job_Forms:42])
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[JTB_Job_Transfer_Bags:112]Jobform:3)
If (Records in selection:C76([Job_Forms:42])#1)
	[JTB_Job_Transfer_Bags:112]Jobform:3:=""
	BEEP:C151
	ALERT:C41("Jobform "+$jobform+" was not found.")
	GOTO OBJECT:C206([JTB_Job_Transfer_Bags:112]Jobform:3)
End if 

If ([Job_Forms:42]ProjectNumber:56#[JTB_Job_Transfer_Bags:112]PjtNumber:2)
	ALERT:C41("Jobform: "+$jobform+" doesn't belong to Project Nº:"+pjtID+Char:C90(13)+"Use the 'Add to Project...' button on the Jobs tab."; "Soon as I get time")
End if 

REDUCE SELECTION:C351([Job_Forms:42]; 0)