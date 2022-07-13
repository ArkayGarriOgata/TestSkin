//%attributes = {}
// -------
// Method: FG_getAssemblyInventory   ( ) ->
// By: Mel Bohince @ 03/07/17, 14:23:41
// Description
// 
// ----------------------------------------------------

<>USE_SUBCOMPONENT:=True:C214


ARRAY TEXT:C222($aCPNs; 0)
C_BLOB:C604($blob)
SET BLOB SIZE:C606($blob; 0)

$blob:=FG_getAssemblyParents

BLOB TO VARIABLE:C533($blob; $aCPNs)

QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]ProductCode:1; $aCPNs)

$rec:=Records in selection:C76([Finished_Goods_Locations:35])

