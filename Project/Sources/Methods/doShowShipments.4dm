//%attributes = {"publishedWeb":true}
// _______
// Method: doShowShipments   ( ) ->
// Description
// 
// ----------------------------------------------------


SET MENU BAR:C67(<>DefaultMenu)
READ ONLY:C145([Customers_ReleaseSchedules:46])
READ ONLY:C145([Customers_Order_Lines:41])
$winRef:=Open form window:C675("4D_Shipments")
DIALOG:C40("4D_Shipments")
CLOSE WINDOW:C154($winRef)