//%attributes = {}
// Method: CSM_countColors () -> 
// ----------------------------------------------------
// by: mel: 10/25/03, 10:55:08
// ----------------------------------------------------

C_LONGINT:C283($numColors)
C_TEXT:C284($0)

READ ONLY:C145([Finished_Goods_Color_SpecSolids:129])
$numColors:=0  // Modified by: Mel Bohince (6/9/21) 
SET QUERY DESTINATION:C396(Into variable:K19:4; $numColors)
QUERY:C277([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecSolids:129]masterSet:3=[Finished_Goods_Color_SpecMaster:128]id:1; *)
QUERY:C277([Finished_Goods_Color_SpecSolids:129];  & ; [Finished_Goods_Color_SpecSolids:129]colorName:10#"")
SET QUERY DESTINATION:C396(Into current selection:K19:1)
REDUCE SELECTION:C351([Finished_Goods_Color_SpecSolids:129]; 0)

$0:=String:C10($numColors)+"/c; "