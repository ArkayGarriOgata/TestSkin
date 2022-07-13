// _______
// Method: [Job_PlatingMaterialUsage].List.showInventory   ( ) ->
// By: Mel Bohince @ 01/28/20, 11:32:36
// Description
// show the inventory and consignment count for hte active plate RM's
// ----------------------------------------------------

ARRAY TEXT:C222($aRM; 0)
ARRAY TEXT:C222($aPO; 0)
ARRAY LONGINT:C221($aQty; 0)
ARRAY LONGINT:C221($aConsign; 0)
//select Raw_Matl_Code, POItemKey, QtyOH, ConsignmentQty from Raw_Materials_Locati
//('33-15/16x 43-1/4', 'OZK7D000', 'PH77144')

Begin SQL
	select Raw_Matl_Code, POItemKey, QtyOH, ConsignmentQty from Raw_Materials_Locations
	where Raw_Matl_Code in 
	(select Raw_Matl_Code from Raw_Materials where UsedBy in('XL', 'Large', 'Cyrel'))
	order by Raw_Matl_Code, POItemKey
	into :$aRM, :$aPO, :$aQty, :$aConsign
End SQL

//$list:=""
$delim:="  "
$lastRM:=""  //for a line break between
//txt_Pad(what;with;1;18)
utl_LogIt("init")

For ($i; 1; Size of array:C274($aRM))
	If ($lastRM#$aRM{$i})
		//$list:=$list+"\r"
		utl_LogIt(" ")
		$lastRM:=$aRM{$i}
	End if 
	utl_LogIt(txt_Pad($aRM{$i}; " "; 1; 18)+$delim+"PO#: "+$aPO{$i}+$delim+String:C10($aQty{$i}; "##,##0;-;")+String:C10($aConsign{$i}; "##,##0;-;"))
	//$list:=$list+$aRM{$i}+$delim+"PO#: "+$aPO{$i}+$delim+String($aQty{$i};"##,##0;-;")+String($aConsign{$i};"##,##0;-;")+"\r"
End for 
//util_FloatingAlert ($list)
utl_LogIt("show")

utl_LogIt("init")