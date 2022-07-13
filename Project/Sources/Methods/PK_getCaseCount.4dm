//%attributes = {}
// Method: PK_getCaseCount ([Finished_Goods]OutLine_Num) ->
//e.g. PK_getCaseCount(FG_getOutline(CPN))  
// ----------------------------------------------------
// by: mel: 06/14/05, 17:20:39
// ----------------------------------------------------
// see also PK_getCaseCountByCPN

C_LONGINT:C283($0)

READ ONLY:C145([Finished_Goods_PackingSpecs:91])
SET QUERY LIMIT:C395(1)
QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=$1)
SET QUERY LIMIT:C395(0)

If (Records in selection:C76([Finished_Goods_PackingSpecs:91])>0)
	$0:=[Finished_Goods_PackingSpecs:91]CaseCount:2
Else 
	$0:=0
End if 

