//OM: tText() -> 
//@author mlb - 7/19/01  12:14
If (tText="Print Button")
	GET LIST ITEM:C378(iJMLTabs; lastTab; $itemRef; $itemText)
	tText:="Selected by '"+$itemText+"'"+Char:C90(13)
	
	Case of 
		: (b1=1)
			tText:=tText+"Sorted by CostCenter"
		: (b2=1)
			tText:=tText+"Sorted by Reason"
		: (b3=1)
			tText:=tText+"Sorted by Customer"
		: (b4=1)
			tText:=tText+"Sorted by CAR#"
		: (b5=1)
			tText:=tText+"Sorted by Location"
		: (b6=1)
			tText:=tText+"Sorted by Plant"
	End case 
	
	//Else 
	//tText:=tMessage  `"User defined query and sort"
End if 

