// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt   ( ) ->
// By: Mel Bohince @ 06/10/20, 07:57:20
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (10/18/20) specific options to ShipMgmt not in common app_form_Mgmt method
// Removed by: Mel Bohince (10/29/20) moved win title to app_form_Mgmt
// Modified by: MelvinBohince (5/19/22) chg /Skid column to #Skids,
//     from PK_getSpecByCPN(This.ProductCode) to Round(This.NumberOfCases/PK_getSpecByCPN (This.ProductCode);2)

app_form_Mgmt

Case of 
	: (Form event code:C388=On Load:K2:1)
		utl_LogIt(Timestamp:C1445+"\t Form's OnLoad"; 0)
		LIST TO ARRAY:C288("ShippingMode"; aMode)
		Form:C1466.message:="Use Quick search popup"
		
		$showLaunch:=OBJECT Get pointer:C1124(Object named:K67:5; "showLaunch")
		$showLaunch->:=0
		
	: (Form event code:C388=On Close Box:K2:21)
		HIDE PROCESS:C324(Current process:C322)
		
End case 