// _______
// Method: [Raw_Materials_Transactions].IssueRMtoJob.rawMatlCode   ( ) ->
// By: Mel Bohince @ 06/23/21, 08:10:22
// Description
// 
// ----------------------------------------------------

Form:C1466.inventory_es:=ds:C1482.Raw_Materials_Locations.query("Raw_Matl_Code = :1"; Form:C1466.rawMatlCode).orderBy("POItemKey")
If (Form:C1466.inventory_es.length=0)
	uConfirm(Form:C1466.rawMatlCode+" has no inventory to issue."; "Ok"; "Shucks")
	Form:C1466.rawMatlCode:=""
	GOTO OBJECT:C206(*; "rawMatlCode")
End if 
