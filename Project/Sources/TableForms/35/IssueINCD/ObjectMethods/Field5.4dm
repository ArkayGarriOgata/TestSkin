[Finished_Goods_Locations:35]Qty_TEMP:23:=[Finished_Goods_Locations:35]Cases:24*[Finished_Goods_Locations:35]Pack_TEMP:25
If ([Finished_Goods_Locations:35]Qty_TEMP:23>[Finished_Goods_Locations:35]QtyOH:9)
	uConfirm("This number of cases will cause a negative inventory."+Char:C90(13)+"Please check your numbers."; "OK"; "Help")
	[Finished_Goods_Locations:35]Pack_TEMP:25:=0
	[Finished_Goods_Locations:35]Qty_TEMP:23:=[Finished_Goods_Locations:35]Cases:24*[Finished_Goods_Locations:35]Pack_TEMP:25
End if 

iQty:=Sum:C1([Finished_Goods_Locations:35]Qty_TEMP:23)