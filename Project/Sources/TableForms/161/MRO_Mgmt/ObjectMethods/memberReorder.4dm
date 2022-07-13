// _______
// Method: [MaintRepairSupply_Bins].ControlCenter.Reorder   ( ) ->
// By: Mel Bohince @ 06/05/19, 10:20:03
// Description
// 
// ----------------------------------------------------

C_OBJECT:C1216($rm_e)
C_TEXT:C284($partNum)
C_LONGINT:C283($ordered)
$partNum:=Form:C1466.clickedBin.PartNumber
$rm_e:=ds:C1482.Raw_Materials.query("Raw_Matl_Code = :1"; $partNum).first()
C_LONGINT:C283($used)
$ordered:=Num:C11(Request:C163("How many "+$partNum+" need to be requisitioned?"; String:C10($rm_e.ReorderMin); "Ok"; "Cancel"))
If (ok=1)
	BEEP:C151
	ALERT:C41("underconstruction Requistion "+String:C10($ordered))
	//$bin_e.Quantity:=$bin_e.Quantity-$used
	//$status_o:=$bin_e.save()
	
	//Form.bins.data:=Form.bins.data
End if 