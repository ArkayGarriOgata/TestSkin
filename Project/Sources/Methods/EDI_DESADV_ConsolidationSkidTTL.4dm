//%attributes = {}
// _______
// Method: EDI_DESADV_ConsolidationSkidTTL   ( ) -> num pallets per user's input
// By: Mel Bohince @ 04/13/21, 16:32:19
// Description
// calculate total skids in consolidation by grouping
// similar cases/skid together, then round up to a whole
// skid, yields a conservative count because it doesn't
// assume that different sized cases will be mixed on
// a skid, eventho in practice they will be, so user can
// override this calc
// ----------------------------------------------------

C_OBJECT:C1216($form_o; $po)
$form_o:=New object:C1471
$form_o.shipments:=consolidation_o.purchaseOrders_c.orderBy("caseSpaces")
$form_o.totalPallets:=0  //this will be the user's number of pallets

C_LONGINT:C283($ttlSkids; $ttlCases; $currentPalletPack; $skids; $0)
$ttlSkids:=0
$ttlCases:=0
$currentPalletPack:=$form_o.shipments[0].caseSpaces


//summarize the number of skids at each pallet std case spaces in a listbox
C_COLLECTION:C1488($calcSummary_c)
$calcSummary_c:=New collection:C1472

For each ($po; $form_o.shipments)
	If ($po.caseSpaces=$currentPalletPack)
		$ttlCases:=$ttlCases+$po.numCases
	Else 
		$skids:=Int:C8($ttlCases\$currentPalletPack)  //skids with this casecount
		If (($ttlCases%$currentPalletPack)>0)  //round up
			$skids:=$skids+1
		End if 
		$ttlSkids:=$ttlSkids+$skids
		
		//add this detail to summary listbox
		$calcSummary_c.push(New object:C1471("palletSpaces"; $currentPalletPack; "countCases"; $ttlCases; "countPallets"; Round:C94($ttlCases/$currentPalletPack; 2)))
		
		//set up for next case/pallet
		$currentPalletPack:=$po.caseSpaces
		$ttlCases:=$po.numCases
	End if 
End for each 

$skids:=Int:C8($ttlCases\$currentPalletPack)  //skids with this casecount
If (($ttlCases%$currentPalletPack)>0)  //round up
	$skids:=$skids+1
End if 
$ttlSkids:=$ttlSkids+$skids

//add this detail to summary listbox
$calcSummary_c.push(New object:C1471("palletSpaces"; $currentPalletPack; "countCases"; $ttlCases; "countPallets"; Round:C94($ttlCases/$currentPalletPack; 2)))

$form_o.totalPallets:=$ttlSkids  //suggested number of pallets
$form_o.calcSummary_c:=$calcSummary_c
$form_o.consolidationID:=consolidation_o.id

$winRef:=Open form window:C675([Customers_ReleaseSchedules:46]; "ShipMgmtConsolidation")
DIALOG:C40([Customers_ReleaseSchedules:46]; "ShipMgmtConsolidation"; $form_o)
CLOSE WINDOW:C154($winRef)

$0:=$form_o.totalPallets  //user's number of pallets
