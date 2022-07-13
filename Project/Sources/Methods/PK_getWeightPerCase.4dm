//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/13/07, 14:00:33
// ----------------------------------------------------
// Method: PK_getWeightPerCase()  --> 
// ----------------------------------------------------

READ ONLY:C145([Finished_Goods_PackingSpecs:91])
SET QUERY LIMIT:C395(1)
QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=$1)
SET QUERY LIMIT:C395(0)

If (Records in selection:C76([Finished_Goods_PackingSpecs:91])>0)
	$0:=[Finished_Goods_PackingSpecs:91]WeightPerCase:40
Else 
	$0:=30
End if 