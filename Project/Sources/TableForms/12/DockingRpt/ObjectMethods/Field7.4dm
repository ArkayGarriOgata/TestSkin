If ([Purchase_Orders_Items:12]PONo:2#[Purchase_Orders:11]PONo:1)
	RELATE ONE:C42([Purchase_Orders_Items:12]PONo:2)
End if 
If ([Vendors:7]ID:1#[Purchase_Orders:11]VendorID:2)
	RELATE ONE:C42([Purchase_Orders:11]VendorID:2)
End if 
//RELATE MANY([PO_Items]POItemKey)  `for a job number
//sRMflexFields ([PO_Items]CommodityCode;1)
//