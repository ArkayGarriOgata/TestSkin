//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 11/09/07, 16:32:50
// ----------------------------------------------------
// Method: Chanel_delforPreparation
// Description:
// Clear out forecast releases before bringing new ones
// ----------------------------------------------------

BEEP:C151
CONFIRM:C162("Delete all the Chanel forecasts?"; "Delete"; "Cancel")
If (OK=1)
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12="00045"; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3="<@")
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
		util_DeleteSelection(->[Customers_ReleaseSchedules:46])
	Else 
		BEEP:C151
		ALERT:C41("No Chanel forecasts found.")
	End if 
End if 