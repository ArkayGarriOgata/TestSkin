//(S) [PURCHASE_ORDER]Requisitionform'sName
If ([Purchase_Orders:11]NewVendor:45)
	//ReqGetNewVendor ([Purchase_Orders]ReqVendorID)
Else 
	RELATE ONE:C42([Purchase_Orders:11]VendorID:2)
	sName:=[Vendors:7]Name:2
	sAddress1:=[Vendors:7]Address1:4
	sAddress2:=[Vendors:7]Address2:5
	sCity:=[Vendors:7]City:7
	sState:=[Vendors:7]State:8
	sZip:=[Vendors:7]Zip:9
	sPhone:=[Vendors:7]Phone:11
	sFaxVend:=[Vendors:7]Fax:12
End if 
//