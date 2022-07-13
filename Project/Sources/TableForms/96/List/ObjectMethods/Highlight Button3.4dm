$jobit:=Request:C163("Enter jobit:"; [WMS_SerializedShippingLabels:96]Jobit:3; "Continue..."; "Cancel")
If (ok=1)
	Case of 
		: (Length:C16($jobit)=11)
			$qty:=Num:C11(Request:C163("Enter Good Quantity of cartons:"; String:C10([WMS_SerializedShippingLabels:96]Quantity:4); "OK"; "Cancel"))
			If (ok=1)
				WIP_comesBack("F/G"; $jobit; $qty)
			End if 
		: (Length:C16($jobit)=8)
			$qty:=Num:C11(Request:C163("Enter Good Quantity of sheets:"; String:C10([WMS_SerializedShippingLabels:96]Quantity:4); "OK"; "Cancel"))
			If (ok=1)
				WIP_comesBack("F/G"; $jobit; $qty)
			End if 
	End case 
	
	
End if 
