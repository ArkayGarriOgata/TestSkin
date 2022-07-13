//%attributes = {}
// _______
// Method: FG_Inventory_InCert   ( fgkey ) -> qtyInCert
// By: Mel Bohince @ 03/03/20, 15:19:32
// Description
// return the qty of an fg that is considered to be in customer certification or recertification
// ----------------------------------------------------

C_TEXT:C284($fgKey; $1; $avoidTheseLocations)
C_LONGINT:C283($0; $certificationQty)
C_OBJECT:C1216($fgEntSel)

If (Count parameters:C259=1)
	$fgKey:=$1
Else   //test
	$fgKey:="00199:90998121SS"
End if 

$avoidTheseLocations:="FG@"  // CC or XC or something totally weird

$fgEntSel:=ds:C1482.Finished_Goods_Locations.query("FG_Key = :1 and KillStatus = 0 and Location # :2"; $fgKey; $avoidTheseLocations)

If ($fgEntSel.length>0)  // 
	$certificationQty:=$fgEntSel.sum("QtyOH")
Else 
	$certificationQty:=0
End if 

$0:=$certificationQty