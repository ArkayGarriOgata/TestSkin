// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/07/06, 17:07:56
//PO iTabControl
// ----------------------------------------------------
C_LONGINT:C283($itemRef)
C_TEXT:C284($targetPage)
GET LIST ITEM:C378(iTabControl; *; $itemRef; $targetPage)
Case of 
	: ($targetPage="Purchase Order Header")
		
	: ($targetPage="PO Items")
		//QUERY([PO_Items];[PO_Items]PONo=[PURCHASE_ORDER]PONo)
		//ORDER BY([Purchase_Orders_Items];[Purchase_Orders_Items]POItemKey;>)
		//QUERY([Purchase_Orders_Chg_Orders];[Purchase_Orders_Chg_Orders]PONo=[Purchase_Orders]PONo)
		//ORDER BY([Purchase_Orders_Chg_Orders];[Purchase_Orders_Chg_Orders]POCOKey;>)
		
	: ($targetPage="History & Notes")
		//ORDER SUBRECORDS BY([Purchase_Orders]PO_Clauses;[Purchase_Orders]PO_Clauses'SeqNo)
		
End case 

