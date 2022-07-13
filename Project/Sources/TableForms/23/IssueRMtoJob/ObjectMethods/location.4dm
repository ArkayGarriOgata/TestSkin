// _______
// Method: [Raw_Materials_Transactions].IssueRMtoJob.location   ( ) ->
// By: Mel Bohince @ 06/23/21, 08:35:59
// Description
// 
// ----------------------------------------------------

C_OBJECT:C1216($verify_es)

$verify_es:=Form:C1466.inventory_es.query("Location = :1"; Form:C1466.location)
If ($verify_es.length=0)
	uConfirm("There is no "+Form:C1466.rawMatlCode+" at "+Form:C1466.location+".")
	Form:C1466.location:=""
	GOTO OBJECT:C206(*; "location")
End if 