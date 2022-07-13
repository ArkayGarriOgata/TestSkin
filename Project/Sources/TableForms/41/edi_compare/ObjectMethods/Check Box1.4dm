If (bReviewed=1)  //we're not going to change anything in ams, just notifying them in the response if there are differences
	[Customers_Order_Lines:41]edi_line_status:55:="Reviewed"
	
	If ([Customers_Order_Lines:41]Quantity:6#[Customers_Order_Lines:41]edi_quantity:65)
		[Customers_Order_Lines:41]edi_response_code:62:=6
	End if 
	
	If ([Customers_Order_Lines:41]NeedDate:14#[Customers_Order_Lines:41]edi_dock_date:64)
		[Customers_Order_Lines:41]edi_response_code:62:=6
	End if 
	
	If ([Customers_Order_Lines:41]defaultShipTo:17#[Customers_Order_Lines:41]edi_shipto:63)
		[Customers_Order_Lines:41]edi_response_code:62:=6
	End if 
	
	If ([Customers_Order_Lines:41]Price_Per_M:8#[Customers_Order_Lines:41]edi_price:66)
		[Customers_Order_Lines:41]edi_response_code:62:=6
	End if 
	
	If ([Customers_Order_Lines:41]edi_response_code:62=6)
		[Customers_Order_Lines:41]edi_FreeText1:58:="ACCEPT WITH AMENDMENT"
	Else 
		[Customers_Order_Lines:41]edi_FreeText1:58:="ACCEPT WITHOUT AMENDMENT"
	End if 
	
	
Else 
	[Customers_Order_Lines:41]edi_line_status:55:=[Customers_Order_Lines:41]edi_orig_line_status:61
End if 