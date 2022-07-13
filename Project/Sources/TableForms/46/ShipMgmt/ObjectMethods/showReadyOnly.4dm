// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.showReadyOnly   ( ) ->
// By: Mel Bohince @ 10/12/20, 11:49:25
// Description
// 
// ----------------------------------------------------

$showReady:=OBJECT Get pointer:C1124(Object named:K67:5; "showReadyOnly")

If ($showReady->=1)
	showReadyOnly:=True:C214
Else 
	showReadyOnly:=False:C215
End if 
