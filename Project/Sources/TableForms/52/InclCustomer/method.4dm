$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		
	: ($e=On Selection Change:K2:29)
		SET TIMER:C645(10)
		
	: ($e=On Double Clicked:K2:5)
		util_openTheSelectRecordInList(->[Customers_Contacts:52]ContactID:2; ->[Contacts:51]ContactID:1)
		
End case 
