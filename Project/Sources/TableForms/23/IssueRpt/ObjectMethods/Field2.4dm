If ([Purchase_Orders_Items:12]POItemKey:1#[Raw_Materials_Transactions:23]POItemKey:4)
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=[Raw_Materials_Transactions:23]POItemKey:4)
End if 
//If ([PO_ITEMS]PONo#[PURCHASE_ORDER]PONo)
//  RELATE ONE([PO_ITEMS]PONo)
//End if 
//If ([VENDOR]ID#[PURCHASE_ORDER]VendorID)
// RELATE ONE([PURCHASE_ORDER]VendorID)
//End if 
//RELATE MANY([PO_ITEMS]POItemKey)  `for a job number
//