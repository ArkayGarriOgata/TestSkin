//%attributes = {"publishedWeb":true}
//INV_testCommission

C_REAL:C285($0)

Case of 
	: ($1="cost")
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=([Customers_Invoices:88]OrderLine:4+"/"+String:C10([Customers_Invoices:88]ReleaseNumber:5)))  //[Bills_of_Lading]Manifest'Arkay_Release)))
		If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
			$0:=Round:C94(Sum:C1([Finished_Goods_Transactions:33]CoGSExtended:8); 2)
		Else 
			$0:=-0.02
		End if 
		
	: ($1="PV")
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=([Customers_Invoices:88]OrderLine:4+"/"+String:C10([Customers_Invoices:88]ReleaseNumber:5)))  //[Bills_of_Lading]Manifest'Arkay_Release)))
		If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
			$cost:=Round:C94(Sum:C1([Finished_Goods_Transactions:33]CoGSExtended:8); 2)
			$0:=Round:C94(fProfitVariable("PV"; $cost; [Customers_Invoices:88]ExtendedPrice:19; $pv); 2)
		Else 
			$0:=-0.02
		End if 
		
	: ($1="contract")
		If ([Customers_Orders:40]OrderNumber:1#(Num:C11(Substring:C12([Customers_Invoices:88]OrderLine:4; 1; 5))))
			QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=(Num:C11(Substring:C12([Customers_Invoices:88]OrderLine:4; 1; 5))))
		End if 
		If (Records in selection:C76([Customers_Orders:40])>0)
			$0:=Num:C11([Customers_Orders:40]IsContract:52)
		Else 
			$0:=-0.02
		End if 
		
	Else 
		$0:=-0.02
End case 