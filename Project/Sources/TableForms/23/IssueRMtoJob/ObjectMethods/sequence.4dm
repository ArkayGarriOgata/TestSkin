// _______
// Method: [Raw_Materials_Transactions].IssueRMtoJob.sequence   ( ) ->
// By: Mel Bohince @ 06/23/21, 08:16:15
// Description
// 
// ----------------------------------------------------
C_OBJECT:C1216($verify_es)

$verify_es:=Form:C1466.billOfMaterial_es.query("Sequence = :1"; Form:C1466.sequence)
If ($verify_es.length>0)
	Form:C1466.inventory_es:=ds:C1482.Raw_Materials_Locations.query("Raw_Matl_Code = :1"; $verify_es.first().Raw_Matl_Code).orderBy("POItemKey")
	If (Form:C1466.inventory_es.length>0)
		Form:C1466.rawMatlCode:=Form:C1466.inventory_es.first().Raw_Matl_Code
		Form:C1466.location:=Form:C1466.inventory_es.first().Location
		Form:C1466.purchaseOrder:=Form:C1466.inventory_es.first().POItemKey
		Form:C1466.unitCost:=Form:C1466.inventory_es.first().ActCost
		GOTO OBJECT:C206(*; "quantity")
		
	Else 
		Form:C1466.rawMatlCode:=""
		GOTO OBJECT:C206(*; "rawMatlCode")
	End if 
	
	
Else 
	
	uConfirm("Sequence "+String:C10(Form:C1466.sequence)+" is not budgeted."; "Try Again"; "Create")
	If (ok=1)
		Form:C1466.sequence:=""
		GOTO OBJECT:C206(*; "sequence")
		
	Else   //create a budget item
		GOTO OBJECT:C206(*; "rawMatlCode")
	End if 
	
End if 