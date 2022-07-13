//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/11/07, 11:50:59
// ----------------------------------------------------
// Method: PK_getCasesPerSkid(FG_getOutline(cpn))  --> 
// ----------------------------------------------------

READ ONLY:C145([Finished_Goods_PackingSpecs:91])
SET QUERY LIMIT:C395(1)
QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=$1)
SET QUERY LIMIT:C395(0)

If (Records in selection:C76([Finished_Goods_PackingSpecs:91])>0)
	$0:=[Finished_Goods_PackingSpecs:91]CasesPerSkid:29
Else 
	$0:=0
End if 
