If (Length:C16([Raw_Materials_Suggest_Vendors:173]Name:4)>0)
	READ ONLY:C145([Vendors:7])
	QUERY:C277([Vendors:7]; [Vendors:7]Name:2="@"+[Raw_Materials_Suggest_Vendors:173]Name:4+"@")
	If (Records in selection:C76([Vendors:7])=1)
		[Raw_Materials_Suggest_Vendors:173]VendorID:1:=[Vendors:7]ID:1
		[Raw_Materials_Suggest_Vendors:173]Name:4:=[Vendors:7]Name:2
	Else 
		uConfirm([Raw_Materials_Suggest_Vendors:173]Name:4+" is was not a unique vendor name."; "OK"; "Help")
		//[Raw_Materials_Suggest_Vendors]Name:=""
	End if 
End if 