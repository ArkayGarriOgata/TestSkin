//[control]linkrleated  bCancel script
Case of 
	: (sLinkWhat="Contact-Vend")
		QUERY:C277([Vendors_Contacts:53]; [Vendors_Contacts:53]ContactID:2=[Contacts:51]ContactID:1)
	: (sLinkWhat="Vend-Contact")
		QUERY:C277([Vendors_Contacts:53]; [Vendors_Contacts:53]VendorID:1=[Vendors:7]ID:1)
		
	: (sLinkWhat="Contact-Cust")
		QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]ContactID:2=[Contacts:51]ContactID:1)
	: (sLinkWhat="Cust-Contact")
		QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]CustID:1=[Customers:16]ID:1)
		
	: (sLinkWhat="Cust-Address")
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers:16]ID:1)
		
	: (sLinkWhat="Address-Cust")
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustAddrID:2=[Addresses:30]ID:1)
		
End case 

