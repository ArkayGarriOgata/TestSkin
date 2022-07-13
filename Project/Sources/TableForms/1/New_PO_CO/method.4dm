//FM: New_PO_CO() -> 
//@author mlb - 2/20/02  09:35

Case of 
	: (Form event code:C388=On Load:K2:1)
		ARRAY TEXT:C222(aToFind; 0)
		LIST TO ARRAY:C288("POchgOrdReasons"; aToFind)
		aToFind:=0
		zwStatusMsg("PO CHG ORD"; "Enter a reason/description for this modification")
		
	: (Form event code:C388=On Unload:K2:2)
		ARRAY TEXT:C222(aToFind; 0)
		zwStatusMsg("PO CHG ORD"; "Thank you")
End case 