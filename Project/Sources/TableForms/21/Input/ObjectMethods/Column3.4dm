If (Length:C16([Raw_Materials_Suggest_Vendors:173]VendorID:1)=5)
	READ ONLY:C145([Vendors:7])
	QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Raw_Materials_Suggest_Vendors:173]VendorID:1)
	If (Records in selection:C76([Vendors:7])=1)
		[Raw_Materials_Suggest_Vendors:173]Name:4:=[Vendors:7]Name:2
	Else 
		uConfirm([Raw_Materials_Suggest_Vendors:173]VendorID:1+" is not a valid VendorID."; "OK"; "Help")
		[Raw_Materials_Suggest_Vendors:173]VendorID:1:=""
	End if 
End if 