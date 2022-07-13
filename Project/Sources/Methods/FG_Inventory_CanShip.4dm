//%attributes = {}
// _______
// Method: FG_Inventory_CanShip   ( fgkey ) -> qty
// By: Mel Bohince @ 03/03/20, 15:05:49
// Description
// return the qty of an fg that is considered shippable
// ----------------------------------------------------
C_TEXT:C284($fgKey; $1; $avoidTheseLocations)
C_LONGINT:C283($0; $shipableQty)
C_OBJECT:C1216($fgEntSel)

If (Count parameters:C259=1)
	$fgKey:=$1
Else   //test
	$fgKey:="00074:2235252000"
End if 

$avoidTheseLocations:="@ship@"  // because they may already be committed

$fgEntSel:=ds:C1482.Finished_Goods_Locations.query("FG_Key = :1 and KillStatus = 0 and Location # :2"; $fgKey; $avoidTheseLocations)
If ($fgEntSel.length>0)  // 
	$shipableQty:=$fgEntSel.sum("QtyOH")
Else 
	$shipableQty:=0
End if 

$0:=$shipableQty