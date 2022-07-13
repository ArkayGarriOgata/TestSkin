//(s) [vendor]name 
//include vendor name on report
If ([Purchase_Orders:11]PONo:1#Substring:C12([Raw_Materials_Locations:25]POItemKey:19; 1; 7))
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=Substring:C12([Raw_Materials_Locations:25]POItemKey:19; 1; 7))
End if 

If ([Vendors:7]ID:1#[Purchase_Orders:11]VendorID:2)
	QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Purchase_Orders:11]VendorID:2)
End if 
//