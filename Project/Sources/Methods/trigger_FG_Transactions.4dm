//%attributes = {}
// Method: trigger_FG_Transactions()  --> 
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 12/05/06, 16:50:15
// ----------------------------------------------------
// Modified by: Mel Bohince (5/4/21) option to skip trigger, renamed the obsolete costlessExcess field to SKipTriggger

$0:=0

Case of 
		
	: ([Finished_Goods_Transactions:33]SkipTrigger:14)
		//pass
		
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Finished_Goods_Transactions:33]Jobit:31:=JMI_makeJobIt([Finished_Goods_Transactions:33]JobForm:5; [Finished_Goods_Transactions:33]JobFormItem:30)
		[Finished_Goods_Transactions:33]CoGS_M:7:=NaNtoZero([Finished_Goods_Transactions:33]CoGS_M:7)
		[Finished_Goods_Transactions:33]CoGSExtended:8:=NaNtoZero([Finished_Goods_Transactions:33]CoGSExtended:8)
		[Finished_Goods_Transactions:33]CoGSextendedMatl:32:=NaNtoZero([Finished_Goods_Transactions:33]CoGSextendedMatl:32)
		[Finished_Goods_Transactions:33]CoGSextendedLabor:33:=NaNtoZero([Finished_Goods_Transactions:33]CoGSextendedLabor:33)
		[Finished_Goods_Transactions:33]CoGSextendedBurden:34:=NaNtoZero([Finished_Goods_Transactions:33]CoGSextendedBurden:34)
		[Finished_Goods_Transactions:33]transactionDateTime:40:=TS_ISO_String_TimeStamp([Finished_Goods_Transactions:33]XactionDate:3; [Finished_Goods_Transactions:33]XactionTime:13)
		
		If ([Finished_Goods_Transactions:33]LocationFromRecNo:23>No current record:K29:2)
			$0:=FGL_UpdateBinByTransaction
		End if 
		
		If ([Finished_Goods_Transactions:33]XactionType:2="Ship")
			C_BOOLEAN:C305($notCritical)
			$notCritical:=FG_inventoryShipped([Finished_Goods_Transactions:33]CustID:12+":"+[Finished_Goods_Transactions:33]ProductCode:1; [Finished_Goods_Transactions:33]XactionDate:3)
		End if 
End case 