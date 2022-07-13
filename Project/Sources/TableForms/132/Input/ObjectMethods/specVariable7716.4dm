$picked:=RM_BuildStockList("pick"; ->[Finished_Goods_SizeAndStyles:132]StockType:20; ->[Finished_Goods_SizeAndStyles:132]StockCaliper:21)
If ([Finished_Goods_SizeAndStyles:132]StockCaliper:21=0)
	GOTO OBJECT:C206([Finished_Goods_SizeAndStyles:132]StockCaliper:21)
End if 