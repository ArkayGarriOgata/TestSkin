// _______
// Method: [Raw_Materials_Transactions].IssueRMtoJob.purchaseOrder   ( ) ->
// By: Mel Bohince @ 06/23/21, 08:39:02
// Description
// 
// ----------------------------------------------------

C_OBJECT:C1216($verify_es)

$verify_es:=Form:C1466.inventory_es.query("POItemKey = :1 and Location = :2"; Form:C1466.purchaseOrder; Form:C1466.location)
If ($verify_es.length=0)
	uConfirm("PO "+Form:C1466.purchaseOrder+" does not exist at "+Form:C1466.location+".")
	Form:C1466.purchaseOrder:=""
	GOTO OBJECT:C206(*; "purchaseOrder")
End if 