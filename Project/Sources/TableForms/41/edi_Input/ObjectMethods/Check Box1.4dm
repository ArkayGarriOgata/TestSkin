If (bReviewed=1)
	[Customers_Order_Lines:41]edi_line_status:55:="Reviewed"
Else 
	[Customers_Order_Lines:41]edi_line_status:55:=[Customers_Order_Lines:41]edi_orig_line_status:61
End if 