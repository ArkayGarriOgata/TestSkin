
$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		
	: ($e=On Selection Change:K2:29)
		SET TIMER:C645(10)
		
	: ($e=On Double Clicked:K2:5)
		util_openTheSelectRecordInList(->[Customers_Addresses:31]CustAddrID:2; ->[Addresses:30]ID:1)
		
End case 
