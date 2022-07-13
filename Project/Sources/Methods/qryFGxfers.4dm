//%attributes = {"publishedWeb":true}
//Procedure: qryFGxfers()  091198  MLB
//get transaction records

C_LONGINT:C283($0)
C_TEXT:C284($1)  //cpn or form
C_TEXT:C284($2)  //custid
C_LONGINT:C283($3; $option)  //jobit

$option:=Count parameters:C259

Case of 
	: ($option=1)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=$1)
	: ($option=2)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=$1; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]CustID:12=$2)
	: ($option=3)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]JobForm:5=$1; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]JobFormItem:30=$3)
	Else 
		REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
End case 

$0:=Records in selection:C76([Finished_Goods_Transactions:33])