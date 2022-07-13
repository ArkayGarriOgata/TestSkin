Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		If ([Finished_Goods_Locations:35]PercentYield:17#0)
			Li1:=[Finished_Goods_Locations:35]QtyOH:9*[Finished_Goods_Locations:35]PercentYield:17/100
		Else 
			Li1:=0
		End if 
		
	: (Form event code:C388=On Header:K2:17)
		If (Level:C101=1)
			QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods_Locations:35]CustID:16)
			xCustName:=[Customers:16]Name:2
		End if 
End case 
//