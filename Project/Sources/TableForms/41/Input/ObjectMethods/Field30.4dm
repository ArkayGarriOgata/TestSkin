//(s) [orderline]classification [orderline]input
// Modified by: Mel Bohince (11/13/15) 
pendingChange:=pendingChange+"Classification Changed from "+String:C10(Old:C35([Customers_Order_Lines:41]Classification:29))+" to "+String:C10([Customers_Order_Lines:41]Classification:29)+Char:C90(Carriage return:K15:38)

QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Customers_Order_Lines:41]Classification:29)

If (Records in selection:C76([Finished_Goods_Classifications:45])=1)
	
	READ WRITE:C146([Finished_Goods:26])
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Customers_Order_Lines:41]CustID:4+":"+[Customers_Order_Lines:41]ProductCode:5)
	
	If (Records in selection:C76([Finished_Goods:26])=1)  //note: stop if there is no fg record    
		If ([Finished_Goods:26]ClassOrType:28#[Customers_Order_Lines:41]Classification:29)
			[Finished_Goods:26]ClassOrType:28:=[Customers_Order_Lines:41]Classification:29
			[Finished_Goods:26]GL_Income_Code:22:=[Finished_Goods_Classifications:45]GL_income_code:3
			[Finished_Goods:26]ModFlag:31:=True:C214
			SAVE RECORD:C53([Finished_Goods:26])
		End if 
	End if 
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
	
Else 
	uConfirm("Invalid Classification."; "OK"; "Help")
	[Customers_Order_Lines:41]Classification:29:=Old:C35([Customers_Order_Lines:41]Classification:29)
	GOTO OBJECT:C206([Customers_Order_Lines:41]Classification:29)
End if 