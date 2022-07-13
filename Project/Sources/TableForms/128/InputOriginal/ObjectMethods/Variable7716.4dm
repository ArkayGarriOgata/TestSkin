$picked:=RM_BuildStockList("pick"; ->[Finished_Goods_Color_SpecMaster:128]stockType:5; ->[Finished_Goods_Color_SpecMaster:128]stockCaliper:6)
If ([Finished_Goods_Color_SpecMaster:128]stockCaliper:6=0)
	GOTO OBJECT:C206([Finished_Goods_Color_SpecMaster:128]stockCaliper:6)
End if 