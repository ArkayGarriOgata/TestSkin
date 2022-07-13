If (Form event code:C388=On Load:K2:1)
	If ([Purchase_Orders_Items:12]POItemKey:1#[Purchase_Orders_Releases:79]POitemKey:1)
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=[Purchase_Orders_Releases:79]POitemKey:1)
	End if 
	
	If ([Purchase_Orders:11]PONo:1#[Purchase_Orders_Items:12]PONo:2)
		QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=[Purchase_Orders_Items:12]PONo:2)
	End if 
	
	If ([Vendors:7]ID:1#[Purchase_Orders_Items:12]VendorID:39)
		QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Purchase_Orders_Items:12]VendorID:39)
	End if 
	
	
End if 
//