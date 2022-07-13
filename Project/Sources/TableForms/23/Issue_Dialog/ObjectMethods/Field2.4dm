If ([Raw_Materials_Transactions:23]Qty:6<=0)  // Modified by: Mel Bohince (3/8/18) 
	uConfirm("Please enter a number greater than 0."; "Ok"; "Cancel")
	[Raw_Materials_Transactions:23]Qty:6:=0
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]Qty:6)
Else 
	tText:=""
	[Raw_Materials_Transactions:23]ActExtCost:10:=[Raw_Materials_Transactions:23]ActCost:9*[Raw_Materials_Transactions:23]Qty:6
	
	If ([Raw_Materials_Transactions:23]Qty:6<1000)
		uConfirm("If the roll is now empty, please return the label to accounting."; "Ok"; "Soon")
	End if 
End if 
