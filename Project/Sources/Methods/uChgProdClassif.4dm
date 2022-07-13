//%attributes = {"publishedWeb":true}
//uChgProdClassif  11/8/94 code simplifiactions
//1/25/95 trap for blank g/l income codes before api
Case of 
	: ([Finished_Goods:26]FG_KEY:47#([Customers_Order_Change_Orders:34]CustID:2+":"+[Customers_Order_Lines:41]ProductCode:5)) & (Not:C34([Customers_Order_Lines:41]SpecialBilling:37))
		qryFinishedGood([Customers_Order_Change_Orders:34]CustID:2; [Customers_Order_Lines:41]ProductCode:5)
		
	: ([Finished_Goods:26]FG_KEY:47#[Customers_Order_Lines:41]ProductCode:5) & ([Customers_Order_Lines:41]SpecialBilling:37)
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Customers_Order_Lines:41]ProductCode:5)
End case 
QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Customers_Order_Lines:41]Classification:29)

If (Records in selection:C76([Finished_Goods_Classifications:45])=1)
	[Finished_Goods:26]ClassOrType:28:=[Customers_Order_Lines:41]Classification:29
	
	If ([Finished_Goods:26]GL_Income_Code:22#[Finished_Goods_Classifications:45]GL_income_code:3)
		
		If ([Finished_Goods:26]GL_Income_Code:22="")  //1/25/95
			[Finished_Goods:26]GL_Income_Code:22:=[Finished_Goods_Classifications:45]GL_income_code:3
		Else 
			uConfirm("Update the G/L Income Code to "+[Finished_Goods_Classifications:45]GL_income_code:3+"?")
			
			If (ok=1)
				[Finished_Goods:26]GL_Income_Code:22:=[Finished_Goods_Classifications:45]GL_income_code:3
			End if 
		End if 
		
	End if 
	[Finished_Goods:26]ModFlag:31:=True:C214
	SAVE RECORD:C53([Finished_Goods:26])
	//API_FGTrans ("MOD")
Else 
	BEEP:C151
	ALERT:C41("Invalid Classification.")
	[Customers_Order_Lines:41]Classification:29:=[Customers_Order_Changed_Items:176]OldClassificati:34
	SAVE RECORD:C53([Customers_Order_Lines:41])
End if 
//