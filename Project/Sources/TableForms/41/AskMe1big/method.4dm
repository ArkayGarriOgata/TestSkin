
$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		
		i1:=(1+([Customers_Order_Lines:41]OverRun:25/100))*[Customers_Order_Lines:41]Quantity:6
		i2:=i1-([Customers_Order_Lines:41]Qty_Shipped:10-[Customers_Order_Lines:41]Qty_Returned:35)
		
		If ([Customers_Order_Lines:41]NeedDate:14=!00-00-00!)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]NeedDate:14; -Light grey:K11:13; True:C214)
		Else 
			Core_ObjectSetColor(->[Customers_Order_Lines:41]NeedDate:14; -Black:K11:16; True:C214)
		End if 
		
		If ([Customers_Order_Lines:41]Status:9="c@")
			Core_ObjectSetColor("*"; "c@"; -Grey:K11:15; True:C214)
			If (i2>0)
				Core_ObjectSetColor(->i2; -Light blue:K11:8; True:C214)
			Else 
				Core_ObjectSetColor(->i2; -Light grey:K11:13; True:C214)
			End if 
		Else 
			Core_ObjectSetColor("*"; "c@"; -Black:K11:16; True:C214)
		End if 
		
		
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Customers_Order_Lines:41]; "Customers_Order_Line")
		
	: ($e=On Double Clicked:K2:5)
		GET HIGHLIGHTED RECORDS:C902([Customers_Order_Lines:41]; "Customers_Order_Line")
		CUT NAMED SELECTION:C334([Customers_Order_Lines:41]; "holdOL")
		USE SET:C118("Customers_Order_Line")
		pattern_PassThru(->[Customers_Order_Lines:41])
		ViewSetter(2; ->[Customers_Order_Lines:41])
		USE NAMED SELECTION:C332("holdOL")
End case 
