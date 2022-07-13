// _______
// Method: [Customers_Invoices].Input.invoiceTabControl   ( ) ->
// By: MelvinBohince @ 05/18/22, 08:22:01
// Description
// 
// ----------------------------------------------------

If (Not:C34(showCoGScalc))
	INV_openActualsPage  //do the first call
	
	showCoGScalc:=True:C214  //set so doing next record button will display
End if 
