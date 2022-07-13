//%attributes = {}
// _______
// Method: PK_getCaseDimensionsText   ( ) -> text
// By: Mel Bohince @ 04/30/20, 07:58:42
// Description
// see also PK_getCaseDimensions
// ----------------------------------------------------

//[Finished_Goods]OutLine_Num is the main authority of the packing spec, [Finished_Goods]PackingSpecification was 
//created so that a relation to packing spec table could be made, while outlineNum is related to the S&S table


C_TEXT:C284($cpn; $1; $0; $dimensions)
C_OBJECT:C1216($fgEntSel)

$cpn:=$1
$dimensions:="n/a"
$fgEntSel:=ds:C1482.Finished_Goods.query("ProductCode = :1"; $cpn)
If ($fgEntSel.length>0)
	If ($fgEntSel[0].PACKING_SPEC#Null:C1517)
		$dimensions:=$fgEntSel[0].PACKING_SPEC.CaseSizeLWH
	End if 
End if 

$0:=$dimensions
