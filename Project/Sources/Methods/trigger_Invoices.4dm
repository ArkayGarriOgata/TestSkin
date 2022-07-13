//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/16/07, 17:57:25
// ----------------------------------------------------
// Method: trigger_Invoices
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Customers_Invoices:88]CoGS:27:=NaNtoZero([Customers_Invoices:88]CoGS:27)
		[Customers_Invoices:88]CoGS_FiFo:38:=NaNtoZero([Customers_Invoices:88]CoGS_FiFo:38)
		[Customers_Invoices:88]ExtendedPrice:19:=NaNtoZero([Customers_Invoices:88]ExtendedPrice:19)
		[Customers_Invoices:88]PricePerUnit:16:=NaNtoZero([Customers_Invoices:88]PricePerUnit:16)
		If ([Customers_Invoices:88]ExtendedPrice:19>0)  // Modified by: Mel Bohince (12/23/19) 
			[Customers_Invoices:88]InvType:13:="Debit"  //mark this record as a credit/return for Dynamics
		Else 
			[Customers_Invoices:88]InvType:13:="Credit"  //mark this record as a credit/return for Dynamics
		End if 
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Customers_Invoices:88]CoGS:27:=NaNtoZero([Customers_Invoices:88]CoGS:27)
		[Customers_Invoices:88]CoGS_FiFo:38:=NaNtoZero([Customers_Invoices:88]CoGS_FiFo:38)
		[Customers_Invoices:88]ExtendedPrice:19:=NaNtoZero([Customers_Invoices:88]ExtendedPrice:19)
		[Customers_Invoices:88]PricePerUnit:16:=NaNtoZero([Customers_Invoices:88]PricePerUnit:16)
		If ([Customers_Invoices:88]ExtendedPrice:19>0)  // Modified by: Mel Bohince (12/23/19) 
			[Customers_Invoices:88]InvType:13:="Debit"  //mark this record as a credit/return for Dynamics
		Else 
			[Customers_Invoices:88]InvType:13:="Credit"  //mark this record as a credit/return for Dynamics
		End if 
End case 