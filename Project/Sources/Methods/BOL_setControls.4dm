//%attributes = {}
// _______
// Method: BOL_setControls   ( ) ->
// By: Mel Bohince @ 11/01/19, 07:49:50
// Description
// button and input management based on state of printed and billed
// ----------------------------------------------------
// Modified by: Mel Bohince (7/20/20) re-enable old asn
// Modified by: Garri Ogata (4/16/21) Changed re Print to Reprint

If (Not:C34(Current user:C182="Designer")) | (True:C214)  //they changed their minds about printing separate from billing
	
	OBJECT SET VISIBLE:C603(*; "PrintNow"; False:C215)
	OBJECT SET VISIBLE:C603(*; "noChgBillNow"; False:C215)
	
	If ([Customers_Bills_of_Lading:49]WasBilled:29)
		OBJECT SET ENTERABLE:C238(*; "noChg@"; False:C215)
		OBJECT SET ENABLED:C1123(*; "noChg@"; False:C215)
		OBJECT SET TITLE:C194(*; "noChgBillNow"; "Billed")
		OBJECT SET TITLE:C194(*; "noChgAddToBOL"; "Billed")
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		OBJECT SET TITLE:C194(*; "Print"; "Reprint")
		
		If (User in group:C338(Current user:C182; "ASN_sender"))
			OBJECT SET ENABLED:C1123(*; "ASN"; True:C214)  // Modified by: Mel Bohince (7/15/20) this is the old ASN method
		Else 
			OBJECT SET ENABLED:C1123(*; "ASN"; False:C215)
		End if 
		
	Else 
		OBJECT SET ENABLED:C1123(*; "ASN"; False:C215)
	End if 
	
Else   //separate the billing from the printing
	
	OBJECT SET VISIBLE:C603(*; "ASN"; False:C215)  // Modified by: Mel Bohince (7/15/20) this is the old ASN method
	
	If ([Customers_Bills_of_Lading:49]WasBilled:29)
		OBJECT SET ENTERABLE:C238(*; "noChg@"; False:C215)
		OBJECT SET ENABLED:C1123(*; "noChg@"; False:C215)
		OBJECT SET TITLE:C194(*; "noChgBillNow"; "Billed")
		OBJECT SET TITLE:C194(*; "noChgAddToBOL"; "Billed")
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		OBJECT SET TITLE:C194(*; "PrintNow"; "Reprint")
		
	Else 
		OBJECT SET ENTERABLE:C238(*; "noChg@"; True:C214)
		OBJECT SET ENABLED:C1123(bDelete; True:C214)  //im really unsure about this, the delete does just mark as void
		
		If (Size of array:C274(aReleases)>0)
			OBJECT SET ENABLED:C1123(*; "noChgRemove"; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(*; "noChgRemove"; False:C215)
		End if 
	End if 
	
	If ([Customers_Bills_of_Lading:49]WasPrinted:8)
		OBJECT SET TITLE:C194(*; "PrintNow"; "Reprint")
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		If (Not:C34([Customers_Bills_of_Lading:49]WasBilled:29))
			OBJECT SET ENABLED:C1123(*; "noChgBillNow"; True:C214)
		End if 
		
	Else 
		OBJECT SET ENABLED:C1123(*; "noChgBillNow"; False:C215)
	End if 
End if 
