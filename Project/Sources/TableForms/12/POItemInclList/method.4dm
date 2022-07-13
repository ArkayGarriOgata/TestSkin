// ----------------------------------------------------
// Form Method: [Purchase_Orders_Items].POItemInclList
// SetObjectProperties, Mark Zinke (5/17/13)
// ----------------------------------------------------

$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		If ([Purchase_Orders_Items:12]Canceled:44)
			SetObjectProperties("tcancelled"; -><>NULL; True:C214)
			SetObjectProperties("tNot@"; -><>NULL; False:C215)
			
		Else 
			SetObjectProperties("tcancelled"; -><>NULL; False:C215)
			SetObjectProperties("tNot@"; -><>NULL; True:C214)
			
		End if 
		
	: ($e=On Selection Change:K2:29)
		SET TIMER:C645(10)
		
	: ($e=On Double Clicked:K2:5)
		
End case 