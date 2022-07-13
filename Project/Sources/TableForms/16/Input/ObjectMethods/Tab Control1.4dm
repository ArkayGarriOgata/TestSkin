// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/07/06, 17:08:32
// ----------------------------------------------------
// Method: Customer iTabControl
// ----------------------------------------------------
C_LONGINT:C283($itemRef)
C_TEXT:C284($targetPage)
GET LIST ITEM:C378(iTabControl; *; $itemRef; $targetPage)
Case of 
	: ($targetPage="Brand/Lines")
		QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=[Customers:16]ID:1)
		ORDER BY:C49([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]LineNameOrBrand:2; >)
		
	: ($targetPage="Addresses")
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers:16]ID:1)
		ORDER BY:C49([Customers_Addresses:31]; [Customers_Addresses:31]AddressType:3; >; [Customers_Addresses:31]CustAddrID:2; >)
		
	: ($targetPage="Contacts")
		QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]CustID:1=[Customers:16]ID:1)
		ORDER BY:C49([Customers_Contacts:52]; [Customers_Contacts:52]ContactID:2; >)
		
End case 

