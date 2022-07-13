// ----------------------------------------------------
// Form Method: [Customers_Order_Lines].edi_compare
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Display Detail:K2:22) | (Form event code:C388=On Printing Detail:K2:18)
		$change_color:=-(3+(256*0))
		$same_color:=-(15+(256*0))
		utl_Trace
		If ([Customers_Order_Lines:41]Quantity:6#[Customers_Order_Lines:41]edi_quantity:65)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_quantity:65; $change_color)
		Else 
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_quantity:65; $same_color)
		End if 
		
		If ([Customers_Order_Lines:41]NeedDate:14#[Customers_Order_Lines:41]edi_dock_date:64)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_dock_date:64; $change_color)
		Else 
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_dock_date:64; $same_color)
		End if 
		
		If ([Customers_Order_Lines:41]defaultShipTo:17#[Customers_Order_Lines:41]edi_shipto:63)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_shipto:63; $change_color)
		Else 
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_shipto:63; $same_color)
		End if 
		
		If ([Customers_Order_Lines:41]Price_Per_M:8#[Customers_Order_Lines:41]edi_price:66)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_price:66; $change_color)
		Else 
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_price:66; $same_color)
		End if 
		
		If ([Customers_Order_Lines:41]edi_line_status:55="Reviewed")
			bReviewed:=1
		Else 
			bReviewed:=0
		End if 
		
		If ([Customers_Order_Lines:41]edi_omit_flag:69="CANCEL")
			SetObjectProperties(""; ->[Customers_Order_Lines:41]edi_omit_flag:69; True:C214)
			SetObjectProperties(""; ->[Customers_Order_Lines:41]edi_quantity:65; False:C215)
		Else 
			SetObjectProperties(""; ->[Customers_Order_Lines:41]edi_omit_flag:69; False:C215)
			SetObjectProperties(""; ->[Customers_Order_Lines:41]edi_quantity:65; True:C214)
		End if 
		
End case 