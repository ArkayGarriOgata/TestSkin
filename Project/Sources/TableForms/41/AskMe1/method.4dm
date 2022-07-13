
$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		i1:=(1+([Customers_Order_Lines:41]OverRun:25/100))*[Customers_Order_Lines:41]Quantity:6
		If ([Customers_Order_Lines:41]Qty_Open:11>0)
			i2:=(([Customers_Order_Lines:41]OverRun:25/100)*[Customers_Order_Lines:41]Quantity:6)+[Customers_Order_Lines:41]Qty_Open:11
		Else 
			i2:=0
		End if 
		If ([Customers_Order_Lines:41]Qty_Returned:35>0)
			iRtn:=1
		Else 
			iRtn:=0
		End if 
		
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Customers_Order_Lines:41]; "Customers_Order_Line")
		
		
End case 
