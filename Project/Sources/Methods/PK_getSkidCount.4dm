//%attributes = {}
// Method: PK_getSkidCount ([Finished_Goods]OutLine_Num) -> 
// ----------------------------------------------------
// by: mel: 06/14/05, 17:21:03
// ----------------------------------------------------

READ ONLY:C145([Finished_Goods_PackingSpecs:91])
SET QUERY LIMIT:C395(1)
QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=$1)
SET QUERY LIMIT:C395(0)

If (Records in selection:C76([Finished_Goods_PackingSpecs:91])>0)
	$0:=[Finished_Goods_PackingSpecs:91]UnitsPerSkid:30
Else 
	$0:=0
End if 