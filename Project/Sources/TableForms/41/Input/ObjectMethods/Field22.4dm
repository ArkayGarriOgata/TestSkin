// ----------------------------------------------------
// Object Method: [Customers_Order_Lines].Input.Field22
// SetObjectProperties, Mark Zinke (5/16/13)
// ----------------------------------------------------

If ([Customers_Order_Lines:41]Status:9="Accepted")
	uConfirm("This order has been booked. Change to Spl Billing?"; "Special Billing"; "Cancel")
	If (ok=1)
		$continue:=True:C214
	Else 
		$continue:=False:C215
	End if 
Else 
	$continue:=True:C214
End if 

If ($continue)
	C_OBJECT:C1216($dollar_o)  // Modified by: Mel Bohince (11/17/21) 
	$dollar_o:=OL_ExtendPriceAndCost
	If (Abs:C99($dollar_o.extendedPrice)>500000) | (Abs:C99($dollar_o.extendedCost)>500000)
		uConfirm("Price="+String:C10($dollar_o.extendedPrice)+" and cost="+String:C10($dollar_o.extendedCost)+" exceed limit of +/-$500k!"; "Fix"; "Allow")
		If (ok=1)
			[Customers_Order_Lines:41]SpecialBilling:37:=Old:C35([Customers_Order_Lines:41]SpecialBilling:37)
			GOTO OBJECT:C206([Customers_Order_Lines:41]SpecialBilling:37)
		End if 
	End if 
	
	If ([Customers_Order_Lines:41]SpecialBilling:37)  //•060995  MLB  UPR 1641
		SetObjectProperties("invoice@"; -><>NULL; True:C214)
		SetObjectProperties("rel@"; -><>NULL; False:C215)
	Else 
		SetObjectProperties("invoice@"; -><>NULL; False:C215)
		SetObjectProperties("rel@"; -><>NULL; True:C214)
	End if 
Else 
	[Customers_Order_Lines:41]SpecialBilling:37:=Old:C35([Customers_Order_Lines:41]SpecialBilling:37)
End if 