If (Current user:C182#"Designer")  // Modified by: Mel Bohince (4/27/20) 
	[Customers_Order_Lines:41]edi_line_status:55:="SENT"
	
Else   //offer to toggle
	If ([Customers_Order_Lines:41]edi_line_status:55="SENT")
		[Customers_Order_Lines:41]edi_line_status:55:=[Customers_Order_Lines:41]edi_orig_line_status:61
	Else 
		[Customers_Order_Lines:41]edi_line_status:55:="SENT"
	End if 
End if 
