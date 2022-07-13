//%attributes = {}
// -------
// Method: RML_ScanLabel   ( ) ->
// By: Mel Bohince @ 01/09/18, 16:19:05
// Description
// 
// ----------------------------------------------------



$numPOI:=Records in selection:C76([Raw_Materials_Locations:25])

If ($numPOI>0)
	FIRST RECORD:C50([Raw_Materials_Locations:25])
	
	util_PAGE_SETUP(->[Purchase_Orders_Items:12]; "ScanableReceiver")
	PRINT SETTINGS:C106
	PDF_setUp("reciever"+".pdf")
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($row; 1; $numPOI)
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=[Raw_Materials_Locations:25]POItemKey:19)
			Print form:C5([Purchase_Orders_Items:12]; "ScanableReceiver")
			NEXT RECORD:C51([Raw_Materials_Locations:25])
		End for 
		
		
	Else 
		// Ps 4d i verified  ScanableReceiver but Mel check if the don't use [Raw_Materials_Locations]
		
		ARRAY TEXT:C222($_POItemKey; 0)
		SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]POItemKey:19; $_POItemKey)
		
		For ($row; 1; Size of array:C274($_POItemKey); 1)
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=$_POItemKey{$row})
			$h:=Print form:C5([Purchase_Orders_Items:12]; "ScanableReceiver")
			
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 
	PAGE BREAK:C6
	
Else   //check for semi-finished bin
	uConfirm("No Items found.")
End if 