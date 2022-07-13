//%attributes = {"publishedWeb":true}
//uLinkRelated()   -jml 7/2/93
//•081595  MLB 
//•052799  mlb  UPR 236 GPD invoicing
//This procedure allows user to link records from a related file to the current
//record displayed in the input layout.  
//In certain permissible instances, this interface can also allow user
//to not only link related records, but to create them as well.  For example,
//When in the Customer input, the user can create new Contact records as well
//as linking existing contact records.

C_TEXT:C284(sLinkWhat; $1)  //parameter passed to layout to indicate what 2 files are being linked(& direction

sLinkWhat:=$1
//sLinkWhat:  "Contact-Cust"  "Cust-Contact"  "Cust-Address"  "Address-Cust"
//                  "Vend-Contact"    "Contact-Vend"
$winRef:=Open form window:C675([zz_control:1]; "LinkRelated"; Sheet form window:K39:12)
//uCenterWindow (360;280;1;"")  `•081595  MLB  
DIALOG:C40([zz_control:1]; "LinkRelated")
CLOSE WINDOW:C154($winRef)

If (bNewRelRec=1)  //user wishes to create new record & edit it
	Case of 
		: (sLinkWhat="Cust-Address")
			CREATE RECORD:C68([Customers_Addresses:31])
			[Customers_Addresses:31]CustID:1:=[Customers:16]ID:1
			CREATE RECORD:C68([Addresses:30])
			//beforeCadd 
			SAVE RECORD:C53([Addresses:30])
			[Customers_Addresses:31]CustAddrID:2:=[Addresses:30]ID:1
			SAVE RECORD:C53([Customers_Addresses:31])
			MODIFY RECORD:C57([Customers_Addresses:31]; *)
			If ([Customers_Addresses:31]AddressType:3="Bill To")  //•052799  mlb  UPR 236
				[Customers_Addresses:31]UpdateDynamics:5:=TSTimeStamp
				SAVE RECORD:C53([Customers_Addresses:31])
			End if 
			If (haCadd=1)
				[Customers:16]ModAddress:35:=4D_Current_date
				[Customers:16]ModFlag:37:=True:C214
				[Customers:16]ModDate:22:=4D_Current_date
				[Customers:16]ModWho:23:=<>zResp
				SAVE RECORD:C53([Customers:16])
			Else 
				//delete contact record and CustAddressLink record because user canceled
				DELETE RECORD:C58([Addresses:30])
				DELETE RECORD:C58([Customers_Addresses:31])
			End if 
			QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers:16]ID:1)
			
		: (sLinkWhat="Cust-Contact")
			CREATE RECORD:C68([Customers_Contacts:52])
			[Customers_Contacts:52]CustID:1:=[Customers:16]ID:1
			[Customers_Contacts:52]SalesmanId:4:=[Customers:16]SalesmanID:3
			CREATE RECORD:C68([Contacts:51])
			//beforeCContact 
			SAVE RECORD:C53([Contacts:51])
			[Customers:16]ModFlag:37:=True:C214
			[Customers:16]ModDate:22:=4D_Current_date
			[Customers:16]ModWho:23:=<>zResp
			SAVE RECORD:C53([Customers:16])
			[Customers_Contacts:52]ContactID:2:=[Contacts:51]ContactID:1
			SAVE RECORD:C53([Customers_Contacts:52])
			MODIFY RECORD:C57([Customers_Contacts:52]; *)
			If (haCadd=1)
				[Customers:16]ModFlag:37:=True:C214
				[Customers:16]ModDate:22:=4D_Current_date
				[Customers:16]ModWho:23:=<>zResp
				SAVE RECORD:C53([Customers:16])
			Else 
				//delete contact record and CustAddressLink record because user canceled
				DELETE RECORD:C58([Contacts:51])
				DELETE RECORD:C58([Customers_Contacts:52])
			End if 
			QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]CustID:1=[Customers:16]ID:1)
			
		: (sLinkWhat="Vend-Contact")
			CREATE RECORD:C68([Vendors_Contacts:53])
			[Vendors_Contacts:53]VendorID:1:=[Vendors:7]ID:1
			CREATE RECORD:C68([Contacts:51])
			//beforeCContact 
			SAVE RECORD:C53([Contacts:51])
			[Vendors:7]ModDate:22:=4D_Current_date
			[Vendors:7]ModWho:23:=<>zResp
			[Vendors:7]ModFlag:21:=True:C214
			SAVE RECORD:C53([Vendors:7])
			[Vendors_Contacts:53]ContactID:2:=[Contacts:51]ContactID:1
			SAVE RECORD:C53([Vendors_Contacts:53])
			MODIFY RECORD:C57([Vendors_Contacts:53]; *)
			If (haCadd=1)
				[Customers:16]ModFlag:37:=True:C214
				[Customers:16]ModDate:22:=4D_Current_date
				[Customers:16]ModWho:23:=<>zResp
				SAVE RECORD:C53([Customers:16])
			Else 
				//delete contact record and CustAddressLink record because user canceled
				DELETE RECORD:C58([Contacts:51])
				DELETE RECORD:C58([Vendors_Contacts:53])
			End if 
			QUERY:C277([Vendors_Contacts:53]; [Vendors_Contacts:53]VendorID:1=[Vendors:7]ID:1)
			
	End case 
	
Else 
	If (sLinkWhat="Cust-Address")
		[Customers:16]ModAddress:35:=4D_Current_date
		[Customers:16]ModFlag:37:=True:C214
		[Customers:16]ModDate:22:=4D_Current_date
		[Customers:16]ModWho:23:=<>zResp
		SAVE RECORD:C53([Customers:16])
	End if 
End if 