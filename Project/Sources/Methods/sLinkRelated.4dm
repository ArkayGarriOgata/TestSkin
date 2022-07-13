//%attributes = {"publishedWeb":true}
//(s) LinkRelated
//called from [control]LinkRElated bSelectRec
//moved code here for layout effeciency
//• 7/13/98 cs created
//•052799  mlb  UPR 236 gpd invoincing
If (asTacID#0)
	Case of 
		: (sLinkWhat="Contact-Vend")
			QUERY:C277([Vendors_Contacts:53]; [Vendors_Contacts:53]ContactID:2=[Contacts:51]ContactID:1; *)
			QUERY:C277([Vendors_Contacts:53];  & ; [Vendors_Contacts:53]VendorID:1=asTacID{asTacID})
			If (Records in selection:C76([Vendors_Contacts:53])#0)
				ALERT:C41("Sorry, but that Vendor record has already been linked to this Contact.")
			Else 
				CREATE RECORD:C68([Vendors_Contacts:53])
				[Vendors_Contacts:53]VendorID:1:=asTacID{asTacID}
				[Vendors_Contacts:53]ContactID:2:=[Contacts:51]ContactID:1
				SAVE RECORD:C53([Vendors_Contacts:53])
				ALERT:C41("Vendor has been successfully linked to Contact.")
			End if 
			QUERY:C277([Vendors_Contacts:53]; [Vendors_Contacts:53]ContactID:2=[Contacts:51]ContactID:1)
			
			
		: (sLinkWhat="Contact-Cust")
			QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]ContactID:2=[Contacts:51]ContactID:1; *)
			QUERY:C277([Customers_Contacts:52];  & ; [Customers_Contacts:52]CustID:1=asTacID{asTacID})
			If (Records in selection:C76([Customers_Contacts:52])#0)
				ALERT:C41("Sorry, but that Customer record has already been linked to this Contact.")
			Else 
				CREATE RECORD:C68([Customers_Contacts:52])
				[Customers_Contacts:52]CustID:1:=asTacID{asTacID}
				[Customers_Contacts:52]ContactID:2:=[Contacts:51]ContactID:1
				
				If ([Customers:16]ID:1#asTacID{asTacID})
					READ ONLY:C145([Customers:16])
					QUERY:C277([Customers:16]; [Customers:16]ID:1=asTacID{asTacID})
				End if 
				[Customers_Contacts:52]SalesmanId:4:=[Customers:16]SalesmanID:3
				
				SAVE RECORD:C53([Customers_Contacts:52])
				[Contacts:51]ModDate:19:=4D_Current_date
				[Contacts:51]ModWho:20:=<>zResp
				SAVE RECORD:C53([Contacts:51])
				ALERT:C41("Customer has been successfully linked to Contact.")
			End if 
			QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]ContactID:2=[Contacts:51]ContactID:1)
			
			
		: (sLinkWhat="Cust-Contact")
			QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]ContactID:2=asTacID{asTacID}; *)
			QUERY:C277([Customers_Contacts:52];  & ; [Customers_Contacts:52]CustID:1=[Customers:16]ID:1)
			If (Records in selection:C76([Customers_Contacts:52])#0)
				ALERT:C41("Sorry, but that Contact record has already been linked to this Customer.")
			Else 
				CREATE RECORD:C68([Customers_Contacts:52])
				[Customers_Contacts:52]CustID:1:=[Customers:16]ID:1
				[Customers_Contacts:52]ContactID:2:=asTACID{asTACID}
				[Customers_Contacts:52]SalesmanId:4:=[Customers:16]SalesmanID:3
				SAVE RECORD:C53([Customers_Contacts:52])
				[Customers:16]ModFlag:37:=True:C214
				[Customers:16]ModDate:22:=4D_Current_date
				[Customers:16]ModWho:23:=<>zResp
				SAVE RECORD:C53([Customers:16])
				ALERT:C41("Contact has been successfully linked to Customer.")
			End if 
			QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]CustID:1=[Customers:16]ID:1)
			
		: (sLinkWhat="Vend-Contact")
			QUERY:C277([Vendors_Contacts:53]; [Vendors_Contacts:53]ContactID:2=asTacID{asTacID}; *)
			QUERY:C277([Vendors_Contacts:53];  & ; [Vendors_Contacts:53]VendorID:1=[Vendors:7]ID:1)
			If (Records in selection:C76([Vendors_Contacts:53])#0)
				ALERT:C41("Sorry, but that Contact record has already been linked to this Vendor.")
			Else 
				CREATE RECORD:C68([Vendors_Contacts:53])
				[Vendors_Contacts:53]VendorID:1:=[Vendors:7]ID:1
				[Vendors_Contacts:53]ContactID:2:=asTACID{asTACID}
				SAVE RECORD:C53([Vendors_Contacts:53])
				[Vendors:7]ModFlag:21:=True:C214
				[Vendors:7]ModDate:22:=4D_Current_date
				[Vendors:7]ModWho:23:=<>zResp
				SAVE RECORD:C53([Vendors:7])
				ALERT:C41("Contact has been successfully linked to Vendor.")
			End if 
			QUERY:C277([Vendors_Contacts:53]; [Vendors_Contacts:53]VendorID:1=[Vendors:7]ID:1)
			
		: (sLinkWhat="Cust-Address")
			$Addr:=gSetAddrType
			If ($Addr#"")
				QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustAddrID:2=asTacID{asTacID}; *)
				QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]CustID:1=[Customers:16]ID:1; *)
				QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3=$addr)
				If (Records in selection:C76([Customers_Addresses:31])#0)
					ALERT:C41("Sorry, but that combination of Address & Type has already been linked to this "+"Customer.")
				Else 
					CREATE RECORD:C68([Customers_Addresses:31])
					[Customers_Addresses:31]CustID:1:=[Customers:16]ID:1
					[Customers_Addresses:31]CustAddrID:2:=asTACID{asTACID}
					[Customers_Addresses:31]AddressType:3:=$Addr
					If ([Customers_Addresses:31]AddressType:3="Bill To")
						[Customers_Addresses:31]UpdateDynamics:5:=TSTimeStamp  //•052799  mlb  UPR 236
					End if 
					SAVE RECORD:C53([Customers_Addresses:31])
					[Customers:16]ModFlag:37:=True:C214
					[Customers:16]ModDate:22:=4D_Current_date
					[Customers:16]ModWho:23:=<>zResp
					SAVE RECORD:C53([Customers:16])
					ALERT:C41("Address has been successfully linked to Customer.")
				End if 
				QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers:16]ID:1)
			End if 
			
		: (sLinkWhat="Address-Cust")
			$Addr:=gSetAddrType
			If ($Addr#"")
				QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustAddrID:2=[Addresses:30]ID:1; *)
				QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]CustID:1=asTacID{asTacID}; *)
				QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3=$addr)
				If (Records in selection:C76([Customers_Addresses:31])#0)
					ALERT:C41("Sorry, but that combination of Customer & Type has already been"+" linked to this Address.")
				Else 
					CREATE RECORD:C68([Customers_Addresses:31])
					[Customers_Addresses:31]CustID:1:=asTacID{asTacID}
					[Customers_Addresses:31]CustAddrID:2:=[Addresses:30]ID:1
					[Customers_Addresses:31]AddressType:3:=$addr
					[Addresses:30]ModDate:19:=4D_Current_date
					[Addresses:30]ModWho:20:=<>zResp
					If ([Customers_Addresses:31]AddressType:3="Bill To")
						[Addresses:30]ModFlag:32:=True:C214
						[Customers_Addresses:31]UpdateDynamics:5:=TSTimeStamp  //•052799  mlb  UPR 236
					End if 
					SAVE RECORD:C53([Customers_Addresses:31])  //•052799  mlb  UPR 236, moved down
					SAVE RECORD:C53([Addresses:30])
					sCustAction:="MOD"
					
					ALERT:C41("Customer has been successfully linked to Address.")
				End if 
				QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustAddrID:2=[Addresses:30]ID:1)
			End if 
			
	End case 
End if 
If (sABCTABID#"")
	GOTO OBJECT:C206(sABCTABID)
	HIGHLIGHT TEXT:C210(sABCTABID; 1; 20)
Else 
	GOTO OBJECT:C206(sABCTABName)
	HIGHLIGHT TEXT:C210(sABCTABName; 1; 20)
End if 
//