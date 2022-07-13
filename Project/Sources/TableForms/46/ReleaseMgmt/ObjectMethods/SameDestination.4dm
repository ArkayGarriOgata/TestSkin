// ----------------------------------------------------
// Object Method: [Customers_ReleaseSchedules].ReleaseMgmt.Variable3
// ----------------------------------------------------
// Modified by: Mel Bohince (11/12/19) option for mode/edc
// and change the 4D-PS local array, initialSelectionToRestore,  to process array to persist scope
// Modified by: Mel Bohince (11/13/19) offer to enter shipto or edc if nothing selected

C_LONGINT:C283($numRels)



If (ShipToButtonText="Same ShipTo")
	
	If (Records in set:C195("UserSet")#0)  //bSelect button from selectionList layout  
		
		REL_ShiptoSame
		
	Else   //no change to selection
		
		REL_ShiptoFind
		
	End if 
	
Else   //restore prior selection
	
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		USE NAMED SELECTION:C332("getKeyFromListing")
		ShipToButtonText:="Same ShipTo"
		CLEAR NAMED SELECTION:C333("getKeyFromListing")
		
	Else 
		
		ShipToButtonText:="Same ShipTo"  // get back to starting state
		
		If (Size of array:C274(initialSelectionToRestore)>0)  //then restore
			CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; initialSelectionToRestore)
		Else 
			BEEP:C151
		End if 
		
		
	End if   // END 4D Professional Services : January 2019 
	
End if 

SetObjectProperties("SameDestination"; -><>NULL; True:C214; ShipToButtonText)  // Modified by: Mark Zinke (5/15/13) fixed by mlb on 9/23/15
SET WINDOW TITLE:C213(String:C10(Records in selection:C76([Customers_ReleaseSchedules:46]))+" "+windowPhrase)