//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/04/12, 15:15:21
// ----------------------------------------------------
// Method: Rama_populate_ap
// Description
// use in apply formula to refit issue transactions based on shipments from rama
// ----------------------------------------------------

If (Position:C15("RAMA"; [Finished_Goods_Transactions:33]viaLocation:11)>0)  //shipped from a Rama warehouse
	Rama_IssueCostToJob("freight"; [Finished_Goods_Transactions:33]ProductCode:1; [Finished_Goods_Transactions:33]Qty:6; [Finished_Goods_Transactions:33]viaLocation:11; [Finished_Goods_Transactions:33]Skid_number:29; [Finished_Goods_Transactions:33]JobForm:5; [Finished_Goods_Transactions:33]XactionDate:3; [Finished_Goods_Transactions:33]ActionTaken:27)
	
	If (Position:C15("GLUED"; [Finished_Goods_Transactions:33]viaLocation:11)>0)  //glued by rama, ours would just have the bol#
		Rama_IssueCostToJob("gluing"; [Finished_Goods_Transactions:33]ProductCode:1; [Finished_Goods_Transactions:33]Qty:6; [Finished_Goods_Transactions:33]viaLocation:11; [Finished_Goods_Transactions:33]Skid_number:29; [Finished_Goods_Transactions:33]JobForm:5; [Finished_Goods_Transactions:33]XactionDate:3; [Finished_Goods_Transactions:33]ActionTaken:27)
	End if 
End if 

[Finished_Goods_Transactions:33]z_SYNC_ID:35:="retrofit"