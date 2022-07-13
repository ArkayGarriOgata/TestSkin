//%attributes = {}
// _______
// Method: PK_getSpecByCPN   ( ) ->
// By: Mel Bohince @ 03/18/20, 12:06:40
// Description
// like PK_getCaseCount
// ----------------------------------------------------

//[Finished_Goods]OutLine_Num is the main authority of the packing spec, [Finished_Goods]PackingSpecification was 
//created so that a relation to packing spec table could be made, while outlineNum is related to the S&S table


C_TEXT:C284($cpn; $1)
C_OBJECT:C1216($fgEntSel)
C_LONGINT:C283($hit; $pkSpec; $0)

If (Count parameters:C259=0)  //init
	ARRAY LONGINT:C221(aPK_Info_Cache; 0)
	ARRAY TEXT:C222(aPK_fg_Cache; 0)
	$pkSpec:=0
	
Else 
	$pkSpec:=-1
	$cpn:=$1
	$hit:=Find in array:C230(aPK_fg_Cache; $cpn)  //check the cache
	If ($hit>-1)
		$pkSpec:=aPK_Info_Cache{$hit}
		
	Else   //ask the server
		$fgEntSel:=ds:C1482.Finished_Goods.query("ProductCode = :1"; $cpn)
		If ($fgEntSel.length>0)
			If ($fgEntSel[0].PACKING_SPEC#Null:C1517)
				$pkSpec:=$fgEntSel[0].PACKING_SPEC.CasesPerSkid  //+" by "+string($fgEntSel[0].PACKING_SPEC.CasesPerLayer)
				APPEND TO ARRAY:C911(aPK_fg_Cache; $cpn)
				APPEND TO ARRAY:C911(aPK_Info_Cache; $pkSpec)
				
			End if 
		End if 
		
	End if   //using cache
End if   //params

$0:=$pkSpec
//