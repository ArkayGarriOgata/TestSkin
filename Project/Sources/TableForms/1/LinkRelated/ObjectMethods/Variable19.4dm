sABCTABID:=""
Case of 
	: ((sLinkWhat="Contact-Cust") | (sLinkWhat="Address-Cust"))
		READ ONLY:C145([Customers:16])  //••    
		QUERY:C277([Customers:16]; [Customers:16]Name:2=sABCTABname+"@")
		SELECTION TO ARRAY:C260([Customers:16]ID:1; asTACID; [Customers:16]Name:2; asTacLast; [Customers:16]SalesmanID:3; asTacFirst)
		READ WRITE:C146([Customers:16])  //••
		
	: ((sLinkWhat="Cust-Contact") | (sLinkWhat="Vend-Contact"))
		QUERY:C277([Contacts:51]; [Contacts:51]LastName:26=sABCTABname+"@")
		SELECTION TO ARRAY:C260([Contacts:51]ContactID:1; asTACID; [Contacts:51]LastName:26; asTacLast; [Contacts:51]FirstName:27; asTacFirst)
		
	: (sLinkWhat="Cust-Address")
		QUERY:C277([Addresses:30]; [Addresses:30]Name:2=sABCTABname+"@")
		SELECTION TO ARRAY:C260([Addresses:30]ID:1; asTACID; [Addresses:30]Name:2; asTacLast; [Addresses:30]City:6; asTacFirst)
		
	: (sLinkWhat="Contact-Vend")
		QUERY:C277([Vendors:7]; [Vendors:7]Name:2=sABCTABname+"@")
		SELECTION TO ARRAY:C260([Vendors:7]ID:1; asTACID; [Vendors:7]Name:2; asTacLast; [Vendors:7]VendorType:3; asTacFirst)
		
End case 
asTacID:=0
asTacFirst:=0
asTacLast:=0
GOTO OBJECT:C206(sABCTABName)
HIGHLIGHT TEXT:C210(sABCTABName; 1; 20)
