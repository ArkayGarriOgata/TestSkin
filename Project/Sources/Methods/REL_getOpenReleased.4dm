//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/18/10, 11:44:17
// ----------------------------------------------------
// Method: REL_getOpenReleased
// ----------------------------------------------------

C_TEXT:C284($1; $2)  //cpn
C_LONGINT:C283($0)

$0:=0

READ ONLY:C145([Customers_ReleaseSchedules:46])

If (Count parameters:C259>1)  //firm and forecast
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$1; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
	
Else   //only firm
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$1; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"))
End if 

If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	$0:=Sum:C1([Customers_ReleaseSchedules:46]OpenQty:16)
End if 