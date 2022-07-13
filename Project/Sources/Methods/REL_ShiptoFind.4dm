//%attributes = {}
// _______
// Method: REL_ShiptoFind   ( ) ->
// By: Mel Bohince @ 11/13/19, 10:04:42
// Description
// offer to find by either mode or shipto
// ----------------------------------------------------

$target:=""
ARRAY LONGINT:C221(initialSelectionToRestore; 0)
LONGINT ARRAY FROM SELECTION:C647([Customers_ReleaseSchedules:46]; initialSelectionToRestore)  //save the initial selection

uConfirm("Search by Shipto or Mode/SEDC?"; "ShipTo"; "Mode-EDC")  // Modified by: Mel Bohince (11/12/19) option for mode/edc
If (ok=1)
	$target:=Request:C163("Enter the ship-to#:"; ""; "Find"; "Cancel")
	If (ok=1)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10=("@"+$target+"@"))
	Else 
		BEEP:C151
	End if 
	
Else 
	
	$target:=Request:C163("Enter the mode or SEDC#:"; ""; "Find"; "Cancel")
	If (ok=1)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Mode:56=("@"+$target+"@"))
	Else 
		BEEP:C151
	End if 
	
End if 

// ******* Verified  - 4D PS - January 2019 (end) *********

ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
ShipToButtonText:="Restore Search"
