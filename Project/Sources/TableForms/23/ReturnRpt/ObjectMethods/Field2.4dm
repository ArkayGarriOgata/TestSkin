If ([Purchase_Orders_Items:12]POItemKey:1#[Raw_Materials_Transactions:23]POItemKey:4)
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=[Raw_Materials_Transactions:23]POItemKey:4)
End if 
If ([Purchase_Orders_Items:12]PONo:2#[Purchase_Orders:11]PONo:1)
	RELATE ONE:C42([Purchase_Orders_Items:12]PONo:2)
End if 
If ([Vendors:7]ID:1#[Purchase_Orders:11]VendorID:2)
	RELATE ONE:C42([Purchase_Orders:11]VendorID:2)
End if 
//•042299  MLB  get rid of relate amny
QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1=[Purchase_Orders_Items:12]POItemKey:1)  //for a job number
//