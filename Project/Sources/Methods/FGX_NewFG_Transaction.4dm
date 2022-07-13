//%attributes = {}
// Method: FGX_NewFG_Transaction ({type};{date};{modwho}) -> int:xfer#
// ----------------------------------------------------
// by: mel: 10/13/04, 15:24:57
// ----------------------------------------------------
// Description:
// constructor for FG_Transaction
C_TEXT:C284($0; $1; $3)
C_DATE:C307($2)
C_TIME:C306($4)

CREATE RECORD:C68([Finished_Goods_Transactions:33])
[Finished_Goods_Transactions:33]XactionNum:24:=app_GetPrimaryKey  //app_AutoIncrement (->[Finished_Goods_Transactions])
[Finished_Goods_Transactions:33]zCount:10:=1
[Finished_Goods_Transactions:33]ModDate:17:=4D_Current_date
[Finished_Goods_Transactions:33]XactionType:2:=$1
[Finished_Goods_Transactions:33]XactionDate:3:=$2
[Finished_Goods_Transactions:33]ModWho:18:=$3
If (Count parameters:C259>3)
	[Finished_Goods_Transactions:33]XactionTime:13:=$4
Else 
	[Finished_Goods_Transactions:33]XactionTime:13:=4d_Current_time
End if 

[Finished_Goods_Transactions:33]Reason:26:=""  //subject for reason-used in reporting, sorting, very uniform
[Finished_Goods_Transactions:33]ReasonNotes:28:=""  //indicates specific percentages, special notes...
[Finished_Goods_Transactions:33]ActionTaken:27:=""

[Finished_Goods_Transactions:33]LocationFromRecNo:23:=No current record:K29:2
[Finished_Goods_Transactions:33]TransactionFailed:25:=False:C215  //optimistic, will set to true if records were locked
[Finished_Goods_Transactions:33]SkipTrigger:14:=False:C215

$0:=[Finished_Goods_Transactions:33]XactionNum:24
