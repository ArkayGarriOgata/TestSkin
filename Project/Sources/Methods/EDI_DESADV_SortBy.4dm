//%attributes = {}
// _______
// Method: EDI_DESADV_SortBy   ( ) ->
// By: Mel Bohince @ 01/26/21, 08:43:37
// Description
// can some multi level sorts
// ----------------------------------------------------
// called by: [Customers_ReleaseSchedules].ShipMgmt.sortList


Case of 
	: (Form event code:C388=On Load:K2:1)
		ARRAY TEXT:C222(asSortTypes; 0)
		INSERT IN ARRAY:C227(asSortTypes; 1; 7)
		asSortTypes{1}:="ShipTo asc, EPD asc"
		asSortTypes{2}:="ShipTo asc, Promise asc"
		asSortTypes{3}:="ShipTo asc, TMC_EPD asc"
		asSortTypes{4}:="ProductCode asc, PO asc"
		asSortTypes{5}:="Mode asc, PO asc"
		asSortTypes{6}:="Expedite asc, PO asc"
		asSortTypes{7}:="ShipTo asc, Qty asc"  // Modified by: Mel Bohince (7/18/20) add search for last 7 days
		asSortTypes{0}:="Multi sort..."
		
	: (Form event code:C388=On Data Change:K2:15)
		$choice:=asSortTypes
		
		Case of 
			: ($choice=1)
				$multiSort:="Shipto asc, user_date_2 asc"
				
			: ($choice=2)
				$multiSort:="Shipto asc, Promise_Date asc"
				
			: ($choice=3)
				$multiSort:="Shipto asc, user_date_1 asc"
				
			: ($choice=4)
				$multiSort:="ProductCode asc, CustomerRefer asc"
				
			: ($choice=5)
				$multiSort:="Mode asc, CustomerRefer asc"
				
			: ($choice=6)
				$multiSort:="Expedite asc, CustomerRefer asc"
				
			: ($choice=7)
				$multiSort:="Shipto asc, Sched_Qty asc"
				
			Else 
				$multiSort:=Form:C1466.defaultOrderBy  //"Shipto asc, Sched_Date asc"
		End case 
		
		Form:C1466.listBoxEntities:=Form:C1466.listBoxEntities.orderBy($multiSort)
		zwStatusMsg("MultiSort"; $multiSort)
		
		Form:C1466.message:="PO's "+asSortTypes{$choice}
		asSortTypes:=0
End case 
