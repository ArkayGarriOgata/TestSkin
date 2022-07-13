//%attributes = {"publishedWeb":true}
//gQtyChangedMFG: Specific to which quantity changed in [FG_BINS]

Case of 
		//: ([FG_Transactions]___="On Hand")
		//   rQtyOHM:=[FG_Transactions]Qty
		//   rTotQtyOH:=rTotQtyOH-[FG_Transactions]Qty
	: (Not:C34([Finished_Goods_Transactions:33]SkipTrigger:14))
		rQtyOOM:=[Finished_Goods_Transactions:33]Qty:6
		rTotQtyOO:=rTotQtyOO-[Finished_Goods_Transactions:33]Qty:6
	: ([Finished_Goods_Transactions:33]SkipTrigger:14)
		rQtyBOM:=[Finished_Goods_Transactions:33]Qty:6
		rTotQtyBO:=rTotQtyBO-[Finished_Goods_Transactions:33]Qty:6
End case 