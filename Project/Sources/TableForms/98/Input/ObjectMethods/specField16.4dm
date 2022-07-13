QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]id:1=[Finished_Goods_Specifications:98]ColorSpecMaster:70)
If (Records in selection:C76([Finished_Goods_Color_SpecMaster:128])>0)
	If (Length:C16([Finished_Goods_Specifications:98]StockType:21)=0)
		[Finished_Goods_Specifications:98]StockType:21:=[Finished_Goods_Color_SpecMaster:128]stockType:5
	End if 
	If ([Finished_Goods_Specifications:98]StockCaliper:23=0)
		[Finished_Goods_Specifications:98]StockCaliper:23:=[Finished_Goods_Color_SpecMaster:128]stockCaliper:6
	End if 
	
Else 
	uConfirm("WARNING: "+"[Finished_Goods_Color_SpecMaster]id="+[Finished_Goods_Specifications:98]ColorSpecMaster:70+" was not found.")
	[Finished_Goods_Specifications:98]ColorSpecMaster:70:=""
	GOTO OBJECT:C206([Finished_Goods_Specifications:98]ColorSpecMaster:70)
End if 