$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Customers_Order_Lines:41]; "clickedIncludeRecord")
		
	: ($e=On Double Clicked:K2:5)
		GET HIGHLIGHTED RECORDS:C902([Customers_Order_Lines:41]; "clickedIncludeRecord")
		
End case 
