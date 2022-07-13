RELATE ONE:C42([Raw_Materials_Locations:25]POItemKey:19)
If ([Vendors:7]ID:1#[Purchase_Orders_Items:12]VendorID:39)
	RELATE ONE:C42([Purchase_Orders_Items:12]VendorID:39)
End if 

QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=[Raw_Materials_Locations:25]POItemKey:19; *)
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3; <)