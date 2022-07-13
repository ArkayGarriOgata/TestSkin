// _______
// Method: [Raw_Materials_Locations].Input.POItemKeyField   ( ) ->
// By: MelvinBohince @ 04/05/22, 15:04:24
// Description
// validate the poitem entered
//also, take filter off the entry field and give it a context menu
// ----------------------------------------------------

C_OBJECT:C1216($po_e)

$po_e:=ds:C1482.Purchase_Orders_Items.query("POItemKey = :1 and Raw_Matl_Code = :2"; [Raw_Materials_Locations:25]POItemKey:19; [Raw_Materials_Locations:25]Raw_Matl_Code:1).first()

If ($po_e=Null:C1517)
	uConfirm([Raw_Materials_Locations:25]POItemKey:19+" is not valid."; "Try again"; "What?")
	[Raw_Materials_Locations:25]POItemKey:19:=Old:C35([Raw_Materials_Locations:25]POItemKey:19)
End if 
