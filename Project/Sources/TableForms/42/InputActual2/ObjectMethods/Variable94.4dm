//(S) bSearchItem
//upr 162 1/9/95
//• 10/21/97 cs partial rewrite - find all items not for loc etc

C_LONGINT:C283($item)

$item:=Num:C11(Request:C163("Enter Item Number: "; "1"))

If (ok=1) & ($item>0)
	$jobit:=JMI_makeJobIt([Job_Forms:42]JobFormID:5; $item)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$jobit)  //•052196  MLB 
	
	If (Records in selection:C76([Finished_Goods_Transactions:33])=0)
		uConfirm("FG Transfer records do not exist for item "+$jobit; "OK"; "Help")
		rTotXfer:=0
	Else 
		ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9; >; [Finished_Goods_Transactions:33]XactionDate:3; >)
		rTotXfer:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	End if 
End if 