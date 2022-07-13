// _______
// Method: [Estimates_Materials].Input.CommodityKey   ( ) ->
// By: Mel Bohince @ 12/10/20, 19:39:56
// Description
// 
// ----------------------------------------------------

If (RMG_is_CommodityKey_Valid([Estimates_Materials:29]Commodity_Key:6))
	[Estimates_Materials:29]UOM:8:=[Raw_Materials_Groups:22]UOM:8
Else 
	uConfirm([Estimates_Materials:29]Commodity_Key:6+" is not a valid Commodity Key."; "Try Again"; "Help")
	[Estimates_Materials:29]Commodity_Key:6:=""
	[Estimates_Materials:29]UOM:8:=""
End if 
sSetMatlEstFlex
