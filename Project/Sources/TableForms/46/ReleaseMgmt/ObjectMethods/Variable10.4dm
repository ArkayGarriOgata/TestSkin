// ----------------------------------------------------
// Object Method: [Customers_ReleaseSchedules].ReleaseMgmt.Variable10
// ----------------------------------------------------

ERASE WINDOW:C160

DIALOG:C40([zz_control:1]; "DateRange2")
If (ok=1)
	ShipToButtonText:="Same ShipTo"
	SetObjectProperties(""; ->bShipTos; True:C214; ShipToButtonText)  // Modified by: Mark Zinke (5/15/13)
	
	If (bSearch=0)
		ERASE WINDOW:C160
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5<=dDateEnd; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=dDateBegin; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0)
			If (cbFcst=0)
				QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@")
			End if 
			
			
		Else 
			
			If (cbFcst=0)
				QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
			End if 
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5<=dDateEnd; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5>=dDateBegin; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
			
		End if   // END 4D Professional Services : January 2019 query selection
		$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
		windowPhrase:=" Open F/G Releases from: "+String:C10(dDateBegin; 1)+" to "+String:C10(dDateEnd; 1)
		windowTitle:=String:C10($numRels)+windowPhrase
		
	Else 
		QUERY:C277([Customers_ReleaseSchedules:46])
		If (cbFcst=0)
			// ******* Verified  - 4D PS - January  2019 ********
			
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@")
			
			
			// ******* Verified  - 4D PS - January 2019 (end) *********
		End if 
		$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
		windowPhrase:=" F/G Releases (Custom Search)"
		windowTitle:=String:C10($numRels)+windowPhrase
	End if 
End if 