// _______
// Method: [Finished_Goods_Locations].aMsWMS_Comparison.selectsubset1   ( ) ->
// By: Mel Bohince @ 11/12/20, 06:52:55
// Description
// 
// ----------------------------------------------------


Form:C1466.listBoxEntities:=Form:C1466.selected.orderBy(Form:C1466.defaultOrderBy)

Form:C1466.message:="Subset of prior rows"

OBJECT SET ENABLED:C1123(*; "select@"; False:C215)

If (Form:C1466.listBoxEntities#Null:C1517)
	footerCount:=Form:C1466.listBoxEntities.length
	footerQty:=Form:C1466.listBoxEntities.sum("QtyOH")
	footerCases:=Form:C1466.listBoxEntities.sum("WMSqty")
End if 

