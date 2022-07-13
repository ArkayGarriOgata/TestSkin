// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.showLaunch   ( ) ->
// By: Mel Bohince @ 07/18/20, 17:38:50
// Description
// 
// ----------------------------------------------------

$showLaunch:=OBJECT Get pointer:C1124(Object named:K67:5; "showLaunch")

If ($showLaunch->=1)
	showLaunchDetails:=True:C214
Else 
	showLaunchDetails:=False:C215
End if 
