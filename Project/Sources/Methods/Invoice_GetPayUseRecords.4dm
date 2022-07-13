//%attributes = {"publishedWeb":true}
//PM:  Invoice_GetPayUseRecords  4/15/99  MLB
//bring into memory all the related records required
//to create an invoice
//•4/15/99  MLB  tweak cust id
C_TEXT:C284($1; $orderLine)
$orderLine:=$1
C_TEXT:C284($exception; $0)
$exception:=""

//REDUCE SELECTION([Bills_of_Lading];0)`• mlb - 8/7/02  11:02

SET QUERY LIMIT:C395(1)
//*Load related records
If ([Customers_Order_Lines:41]OrderLine:3#$orderLine)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$orderLine)
	If (Records in selection:C76([Customers_Order_Lines:41])=0)
		$exception:=$exception+" [OrderLines] record not found: "+$orderLine+Char:C90(13)
	End if 
End if 

If ([Customers_Orders:40]OrderNumber:1#[Customers_Order_Lines:41]OrderNumber:1)
	QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Customers_Order_Lines:41]OrderNumber:1)
	If (Records in selection:C76([Customers_Orders:40])=0)
		$exception:=$exception+" [CustomerOrder] record not found: "+String:C10([Customers_Order_Lines:41]OrderNumber:1)+Char:C90(13)
	End if 
End if 

If ([Customers:16]ID:1#[Customers_Order_Lines:41]CustID:4)
	READ ONLY:C145([Customers:16])
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_Order_Lines:41]CustID:4)
	If (Records in selection:C76([Customers:16])=0)
		$exception:=$exception+" [CUSTOMER] record not found: "+[Customers_Order_Lines:41]CustID:4+Char:C90(13)
	End if 
End if 

If ([Finished_Goods_Classifications:45]Class:1#[Customers_Order_Lines:41]Classification:29)
	QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Customers_Order_Lines:41]Classification:29)
	If (Records in selection:C76([Finished_Goods_Classifications:45])=0)
		$exception:=$exception+" [FG_Class_n_Acct] record not found: "+[Customers_Order_Lines:41]Classification:29+Char:C90(13)
	End if 
End if 

If ([Finished_Goods:26]ProductCode:1#[Customers_Order_Lines:41]ProductCode:5)
	qryFinishedGood("#CPN"; [Customers_Order_Lines:41]ProductCode:5)  //•4/15/99  MLB 
	If (Records in selection:C76([Finished_Goods:26])=0)
		$exception:=$exception+" [Finished_Goods] record not found: "+[Customers_Order_Lines:41]CustID:4+":"+[Customers_Order_Lines:41]ProductCode:5+Char:C90(13)
	End if 
End if 


SET QUERY LIMIT:C395(0)
$0:=$exception
//