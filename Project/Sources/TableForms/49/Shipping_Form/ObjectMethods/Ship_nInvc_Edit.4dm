// _______
// Method: [Customers_Bills_of_Lading].Shipping_Form.BillNow   ( ) ->
// By: Mel Bohince @ 10/31/19, 14:07:51
// Description
// 
// ----------------------------------------------------


If (Not:C34([Customers_Bills_of_Lading:49]WasBilled:29))
	If (Not:C34(BOL_find_locked_bin))
		
		uConfirm("Billing will lock down the BOL."; "Bill"; "Cancel")
		If (ok=1)
			
			[Customers_Bills_of_Lading:49]CanBill:35:=True:C214
			SAVE RECORD:C53([Customers_Bills_of_Lading:49])  // this will now fire of the BOL_ExecuteShipment method in the trigger
			//BOL_PrintBillOfLading 
			release_number:=0
			$numLocations:=BOL_PickRelease(release_number)  //reset listbox
			
			OBJECT SET TITLE:C194(*; "BillNow"; "Billed")
			OBJECT SET TITLE:C194(*; "noChgAddToBOL"; "Billed")
			OBJECT SET ENTERABLE:C238(*; "noChg@"; False:C215)
			
			OBJECT SET ENABLED:C1123(bCancel; False:C215)  // it was  saved already anyway
			
			
			QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]BillOfLadingNumber:3=[Customers_Bills_of_Lading:49]ShippersNo:1)
			ORDER BY:C49([Customers_Invoices:88]; [Customers_Invoices:88]InvoiceNumber:1; >)
			
		End if 
		
	End if   //no locked location records
	
Else 
	BEEP:C151
End if 