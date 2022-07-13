//%attributes = {}
// Method: JTB_JobFormComplete () -> 
// ----------------------------------------------------
// by: mel: 12/15/04, 21:26:02
// ----------------------------------------------------
// Description:
// remove jtb and related records
// ----------------------------------------------------

C_TEXT:C284($1)

READ WRITE:C146([JTB_Job_Transfer_Bags:112])
READ WRITE:C146([JTB_Logs:114])
READ WRITE:C146([JTB_Contents:113])

QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]ID:1=$1)
If (Records in selection:C76([JTB_Job_Transfer_Bags:112])>0)
	util_DeleteSelection(->[JTB_Job_Transfer_Bags:112])
	QUERY:C277([JTB_Contents:113]; [JTB_Contents:113]BagID:1=$1)
	util_DeleteSelection(->[JTB_Contents:113])
	QUERY:C277([JTB_Logs:114]; [JTB_Logs:114]JTBid:1=$1)
	util_DeleteSelection(->[JTB_Logs:114])
End if 