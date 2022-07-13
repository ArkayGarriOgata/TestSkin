//%attributes = {}
// _______
// Method: PK_getCaseCountByCPN   ( ) ->
// By: Mel Bohince @ 03/18/20, 12:06:40
// Description
// like PK_getCaseCount
// ----------------------------------------------------

//[Finished_Goods]OutLine_Num is the main authority of the packing spec, [Finished_Goods]PackingSpecification was 
//created so that a relation to packing spec table could be made, while outlineNum is related to the S&S table


C_TEXT:C284($cpn; $1)
C_OBJECT:C1216($fgEntSel)
C_LONGINT:C283($0; $caseCount)
$cpn:=$1
$caseCount:=-1
$fgEntSel:=ds:C1482.Finished_Goods.query("ProductCode = :1"; $cpn)
If ($fgEntSel.length>0)
	If ($fgEntSel[0].PACKING_SPEC#Null:C1517)
		$caseCount:=$fgEntSel[0].PACKING_SPEC.CaseCount
	End if 
End if 

$0:=$caseCount
