// _______
// Method: [Finished_Goods_Locations].aMsWMS_Comparison.selecthidesubset   ( ) ->
// By: Mel Bohince @ 11/12/20, 06:23:17
// Description
// 
// ----------------------------------------------------
C_COLLECTION:C1488($reducedCollection; $hits)
$reducedCollection:=New collection:C1472
C_OBJECT:C1216($row)
C_LONGINT:C283($subtract)
$subtract:=Form:C1466.selected.length

For each ($row; Form:C1466.listBoxEntities)
	$hits:=Form:C1466.selected.query("key = :1"; $row.key)
	If ($hits.length=0)
		$reducedCollection.push($row)
	End if 
End for each 
Form:C1466.listBoxEntities:=$reducedCollection.orderBy(Form:C1466.defaultOrderBy)


Form:C1466.message:="Removed "+String:C10($subtract)+" rows from prior selection"

OBJECT SET ENABLED:C1123(*; "select@"; False:C215)

If (Form:C1466.listBoxEntities#Null:C1517)
	footerCount:=Form:C1466.listBoxEntities.length
	footerQty:=Form:C1466.listBoxEntities.sum("QtyOH")
	footerCases:=Form:C1466.listBoxEntities.sum("WMSqty")
End if 

