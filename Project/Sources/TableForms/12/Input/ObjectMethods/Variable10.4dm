// ----------------------------------------------------
// Object Method: [Purchase_Orders_Items].Input.Variable10
// ----------------------------------------------------

Case of 
	: ([Purchase_Orders_Items:12]ExpenseCode:47="0000") | ([Purchase_Orders_Items:12]ExpenseCode:47="") | (Position:C15("_"; [Purchase_Orders_Items:12]ExpenseCode:47)>0)  //do not allow 0000 department code
		uConfirm("You MUST enter an Expense/Charge Code code for this item."; "OK"; "Help")
		SetObjectProperties("exp@"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/17/13)
		GOTO OBJECT:C206([Purchase_Orders_Items:12]ExpenseCode:47)
		REJECT:C38
		
	: (fNewRm) & ([Purchase_Orders_Items:12]Flex5:35="") & ([Purchase_Orders_Items:12]CommodityCode:16=2)
		uConfirm("The new Material you have just entered is an INK, all inks require a Color."+Char:C90(13)+"Please enter an Ink Color."; "OK"; "Help")
		GOTO OBJECT:C206([Purchase_Orders_Items:12]Flex5:35)
		REJECT:C38
		
	: (POImanditoryJob)
		REJECT:C38
		
End case 