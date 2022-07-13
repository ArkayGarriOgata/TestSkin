//%attributes = {"publishedWeb":true}
//(P) beforeFGRC: before phase processing for [FG_RECEIPTS]
//(P) beforeRMRC: before phase processing for [RM_BINS]

Case of 
	: (<>fgXferInquire)
		//just display
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		//OBJECT SET ENABLED(bValidate;False)
		uSetEntStatus(->[Finished_Goods_Transactions:33]; False:C215)
		
	: (Is new record:C668([Finished_Goods_Transactions:33]))
		uSetEntStatus(->[Finished_Goods_Transactions:33]; True:C214)
		[Finished_Goods_Transactions:33]XactionNum:24:=app_GetPrimaryKey  //app_AutoIncrement (->[Finished_Goods_Transactions])
		[Finished_Goods_Transactions:33]XactionDate:3:=4D_Current_date
		[Finished_Goods_Transactions:33]XactionTime:13:=4d_Current_time
		[Finished_Goods_Transactions:33]ModDate:17:=4D_Current_date
		[Finished_Goods_Transactions:33]ModWho:18:=<>zResp
		[Finished_Goods_Transactions:33]zCount:10:=1
		[Finished_Goods_Transactions:33]Reason:26:="Created by Accounting"
		OBJECT SET ENABLED:C1123(bDelete; False:C215)
		OBJECT SET ENABLED:C1123(bValidate; True:C214)
		
	Else 
		uSetEntStatus(->[Finished_Goods_Transactions:33]; True:C214)
		OBJECT SET ENABLED:C1123(bDelete; True:C214)
		OBJECT SET ENABLED:C1123(bValidate; True:C214)
End case 

SetObjectProperties(""; ->[Finished_Goods_Transactions:33]XactionNum:24; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Finished_Goods_Transactions:33]ModWho:18; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)
SetObjectProperties(""; ->[Finished_Goods_Transactions:33]ModDate:17; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/6/13)