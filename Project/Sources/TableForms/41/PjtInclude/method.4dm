//[generic];"include"

Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		util_alternateBackground
		
End case 

app_SelectIncludedRecords(->[Customers_Order_Lines:41]OrderLine:3; 3)
