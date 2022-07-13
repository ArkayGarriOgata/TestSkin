Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Record number:C243([Purchase_Order_TradeIns:72])=New record:K29:1)
			[Purchase_Order_TradeIns:72]DateReturned:3:=4D_Current_date
		End if 
		
End case 