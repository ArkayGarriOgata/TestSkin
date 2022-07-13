//%attributes = {}
// _______
// Method: PK_getCasesPerLayer   ( ) ->
// By: Mel Bohince @ 05/30/20, 09:42:52
// Description
// 
// Modified by: Garri Ogata (6/16/21) Changed $fg_es:=ds.FINISHED_GOOD to $fg_es:=ds.Finished_Goods
// ----------------------------------------------------
C_LONGINT:C283($0)
C_TEXT:C284($1)
C_OBJECT:C1216($fg_es; $fg_e)

$fg_es:=ds:C1482.Finished_Goods.query("ProductCode = :1"; $1)

If ($fg_es.length>0)
	$fg_e:=$fg_es.first()
	If ($fg_e.PACKING_SPEC#Null:C1517)
		$0:=$fg_e.PACKING_SPEC.CasesPerLayer
	Else 
		$0:=0
	End if 
Else 
	$0:=0
End if 

//READ ONLY([Finished_Goods_PackingSpecs])
//SET QUERY LIMIT(1)
//QUERY([Finished_Goods_PackingSpecs];[Finished_Goods_PackingSpecs]FileOutlineNum=$1)
//SET QUERY LIMIT(0)

//If (Records in selection([Finished_Goods_PackingSpecs])>0)
//$0:=[Finished_Goods_PackingSpecs]CasesPerLayer
//Else 
//$0:=0
//End if 