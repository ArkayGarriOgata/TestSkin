//%attributes = {"publishedWeb":true}
//Procedure: uChgFGqty()  010296  MLB
//•010296  MLB  UPR 1802
//see fgadjust screen
C_LONGINT:C283($1; $chgQty; $2)  //$1either -1 or +1
If (Count parameters:C259=2)
	$chgQty:=$1*$2
Else 
	$chgQty:=$1*rReal1
End if 
[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+$chgQty
If (([Finished_Goods_Locations:35]QtyOH:9=0) & (Not:C34([Finished_Goods_Locations:35]PiDoNotDelete:29)))  // & ($1<0)`•010296  MLB  UPR 1802
	DELETE RECORD:C58([Finished_Goods_Locations:35])
End if 
//