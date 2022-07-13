//6/19/97 cs attempt to speed reaction of this function
//broke search into 2 parts &  do not do second part if not needed
QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=[Purchase_Orders:11]PONo:1+"@")

If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
	
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Return"; *)  // upr 1297
	QUERY SELECTION:C341([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")  // upr 1297
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
	
	ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4; >)
End if 
//