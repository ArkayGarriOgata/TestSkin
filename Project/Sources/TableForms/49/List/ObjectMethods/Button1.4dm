uConfirm("Print current selection or search by date range?"; "Current Selection"; "Date Range")
If (ok=0)
	$numBOL:=qryByDateRange(->[Customers_Bills_of_Lading:49]ShipDate:20; "Enter the Ship Date Range")
	ORDER BY:C49([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippersNo:1; >)
Else 
	$numBOL:=Records in selection:C76([Customers_Bills_of_Lading:49])
End if 

If ($numBOL>0)
	// Added by: Mark Zinke (11/27/12) Replaced code below with new print layout.
	If (True:C214)
		ShippingPrintList
	Else 
		SET WINDOW TITLE:C213("Printing "+String:C10($numBOL)+" Bills of Lading")
		
		util_PAGE_SETUP(->[Customers_Bills_of_Lading:49]; "Summary_Report")
		PRINT SETTINGS:C106
		FORM SET OUTPUT:C54([Customers_Bills_of_Lading:49]; "Summary_Report")
		ON EVENT CALL:C190("eCancelProc")
		PRINT SELECTION:C60([Customers_Bills_of_Lading:49]; *)
		ON EVENT CALL:C190("")
		FORM SET OUTPUT:C54([Customers_Bills_of_Lading:49]; "List")
	End if 
Else 
	uConfirm("Sorry, no BOL's were found."; "Try Again"; "Help")
End if 