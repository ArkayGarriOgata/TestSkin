//%attributes = {}
// _______
// Method: REL_ShiptoSame   ( ) ->
// By: Mel Bohince @ 11/13/19, 09:57:59
// Description
// given that a record has been selected, offer to find similar shipto or mode
// ----------------------------------------------------

//$target:=util_getKeyFromListing (->[Customers_ReleaseSchedules]Shipto)
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	COPY NAMED SELECTION:C331([Customers_ReleaseSchedules:46]; "getKeyFromListing")
	
Else 
	
	ARRAY LONGINT:C221(initialSelectionToRestore; 0)
	LONGINT ARRAY FROM SELECTION:C647([Customers_ReleaseSchedules:46]; initialSelectionToRestore)  //save the initial selection
	
End if   // END 4D Professional Services : January 2019 

$target:=""
$mode:=""  // Modified by: Mel Bohince (11/12/19) option for mode/edc

USE SET:C118("UserSet")
ONE RECORD SELECT:C189([Customers_ReleaseSchedules:46])

$target:=[Customers_ReleaseSchedules:46]Shipto:10
$mode:=[Customers_ReleaseSchedules:46]Mode:56

If (Length:C16($target)=5)  //have a record selected
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		USE NAMED SELECTION:C332("getKeyFromListing")
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; initialSelectionToRestore)  //so we can query it
		
	End if   // END 4D Professional Services : January 2019 
	
	// ******* Verified  - 4D PS - January  2019 ********
	uConfirm("Search by Shipto or Mode/EDC: '"+$mode+"'?"; "ShipTo"; "Mode-EDC")  // Modified by: Mel Bohince (11/12/19) option for mode/edc
	If (ok=1)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10=$target)
	Else 
		If (Length:C16($mode)>0)
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Mode:56=$mode)
		Else 
			uConfirm("The selected record did not have a mode/EDC."; "Ok"; "Cancel")
		End if 
	End if 
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
	
	ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
	ShipToButtonText:="Restore Search"
	
Else   //start over
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		USE NAMED SELECTION:C332("getKeyFromListing")
		
		
	Else 
		CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; initialSelectionToRestore)
		
	End if   // END 4D Professional Services : January 2019 
	ShipToButtonText:="Same ShipTo"
	
End if 
