[Finished_Goods_Specifications:98]ProductCode:3:=fStripSpace("B"; [Finished_Goods_Specifications:98]ProductCode:3)

READ WRITE:C146([Finished_Goods:26])
$numFG:=qryFinishedGood(Substring:C12([Finished_Goods_Specifications:98]FG_Key:1; 1; 5); [Finished_Goods_Specifications:98]ProductCode:3)
If ($numFG>0)
	[Finished_Goods_Specifications:98]FG_Key:1:=Substring:C12([Finished_Goods_Specifications:98]FG_Key:1; 1; 5)+":"+[Finished_Goods_Specifications:98]ProductCode:3
	
Else 
	BEEP:C151
	ALERT:C41("You must create the FinishedGood record first.")
	[Finished_Goods_Specifications:98]ProductCode:3:=Old:C35([Finished_Goods_Specifications:98]ProductCode:3)
End if 
//
