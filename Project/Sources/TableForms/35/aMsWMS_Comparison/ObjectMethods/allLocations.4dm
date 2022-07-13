// _______
// Method: [Finished_Goods_Locations].aMsWMS_Comparison.allLocations   ( ) ->
// By: Mel Bohince @ 11/12/20, 06:36:47
// Description
// 
// ----------------------------------------------------



Form:C1466.listBoxEntities:=Form:C1466.fg_locations_c


Form:C1466.message:="All Locations "

OBJECT SET ENABLED:C1123(*; "select@"; False:C215)

If (Form:C1466.listBoxEntities#Null:C1517)
	footerCount:=Form:C1466.listBoxEntities.length
	footerQty:=Form:C1466.listBoxEntities.sum("QtyOH")
	footerCases:=Form:C1466.listBoxEntities.sum("WMSqty")
End if 

