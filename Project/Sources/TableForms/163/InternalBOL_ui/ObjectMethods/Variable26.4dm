// _______
// Method: [WMS_InternalBOLs].InternalBOL_ui.Variable26   ( ) ->
// By: Mel Bohince @ 11/05/20, 09:15:53
// Description
// 
// ----------------------------------------------------

If (Length:C16([WMS_SerializedShippingLabels:96]CPN:2)>0)
	<>AskMeFG:=[WMS_SerializedShippingLabels:96]CPN:2
	<>AskMeCust:=""  //[CustomerOrder]CustID
	displayAskMe("New")
Else 
	uConfirm("Please select a skid first."; "Ok"; "Help")
End if 
