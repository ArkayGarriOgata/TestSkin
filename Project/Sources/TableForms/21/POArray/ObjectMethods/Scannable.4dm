// -------
// Method: RM_ScanLabel   ( ) ->
// By: Mel Bohince @ 02/15/17, 14:55:32
// Description
// print barcoded labels for inventory
// ----------------------------------------------------


$numPOI:=Records in selection:C76([Purchase_Orders_Items:12])

If ($numPOI>0)
	ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; >)
	
	util_PAGE_SETUP(->[Purchase_Orders_Items:12]; "ScanableReceiver")
	PRINT SETTINGS:C106
	PDF_setUp("reciever"+".pdf")
	
	For ($row; 1; $numPOI)
		Print form:C5([Purchase_Orders_Items:12]; "ScanableReceiver")
		NEXT RECORD:C51([Purchase_Orders_Items:12])
	End for 
	PAGE BREAK:C6
	
Else   //check for semi-finished bin
	uConfirm("No Items found.")
End if 
