// _______
// Method: [MaintRepairSupply_Bins].ControlCenter.Use   ( ) ->
// By: Mel Bohince @ 06/05/19, 10:03:17
// Description
// relieve quantity and apply to work order
// ----------------------------------------------------

C_OBJECT:C1216($bin_e; $status_o)
$bin_e:=New object:C1471
$bin_e:=Form:C1466.clickedBin  //Form.bins.currItem
$bin_e.Quantity:=Form:C1466.bins.currItem.Quantity
C_LONGINT:C283($used)
$used:=Num:C11(Request:C163("How many "+$bin_e.PartNumber+" are being used?"; String:C10($bin_e.Quantity); "Ok"; "Cancel"))
If (ok=1)
	$bin_e.Quantity:=$bin_e.Quantity-$used
	$status_o:=$bin_e.save()
	
	Form:C1466.bins:=Form:C1466.bins
	
	BEEP:C151
	ALERT:C41("underconstruction Apply "+String:C10($used)+" to selected department.")
End if 
