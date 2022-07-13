//(LP)[FG_Transactions].ItemsScrapped
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		
		If (t10="COST")
			If (([Job_Forms_Items:44]JobForm:1#[Finished_Goods_Transactions:33]JobForm:5) | ([Job_Forms_Items:44]ProductCode:3#[Finished_Goods_Transactions:33]ProductCode:1))
				QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=[Finished_Goods_Transactions:33]JobForm:5; *)
				QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]ProductCode:3=[Finished_Goods_Transactions:33]ProductCode:1)
			End if 
			
			If (Records in selection:C76([Job_Forms_Items:44])>0)
				r1:=[Job_Forms_Items:44]PldCostTotal:21*([Finished_Goods_Transactions:33]Qty:6/1000)
			Else 
				r1:=0
			End if 
			
		Else 
			If ([Finished_Goods:26]FG_KEY:47#([Finished_Goods_Transactions:33]CustID:12+":"+[Finished_Goods_Transactions:33]ProductCode:1))
				QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=([Finished_Goods_Transactions:33]CustID:12+":"+[Finished_Goods_Transactions:33]ProductCode:1))  //11/18/94
			End if 
			
			If (Records in selection:C76([Finished_Goods:26])>0)
				r1:=[Finished_Goods:26]LastPrice:27*([Finished_Goods_Transactions:33]Qty:6/1000)
			Else 
				r1:=0
			End if 
		End if 
		
	: (Form event code:C388=On Header:K2:17)
		If (Level:C101=1)
			QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods_Transactions:33]CustID:12)
		End if 
		
	: (Form event code:C388=On Printing Break:K2:19)
		Case of 
			: (Level:C101=1)
				r2:=Subtotal:C97([Finished_Goods_Transactions:33]Qty:6)
				r3:=Round:C94(Subtotal:C97(r1); 0)
			: (Level:C101=0)
				r2:=Subtotal:C97([Finished_Goods_Transactions:33]Qty:6)
				r3:=Round:C94(Subtotal:C97(r1); 0)
				
		End case 
		
End case 
//