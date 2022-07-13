//%attributes = {"publishedWeb":true}
//gQtyChangedFG: Specific to which quantity changed in [RM_BINS]

Case of 
		//: ([FG_Transactions]___="On Hand")
		// rQtyOH:=[FG_Transactions]Qty
		// rTotQtyOH:=rTotQtyOH+[FG_Transactions]Qty
	: (Not:C34([Finished_Goods_Transactions:33]SkipTrigger:14))
		rQtyOO:=[Finished_Goods_Transactions:33]Qty:6
		rTotQtyOO:=rTotQtyOO+[Finished_Goods_Transactions:33]Qty:6
	: ([Finished_Goods_Transactions:33]SkipTrigger:14)
		rQtyBO:=[Finished_Goods_Transactions:33]Qty:6
		rTotQtyBO:=[Finished_Goods_Transactions:33]Qty:6
End case 