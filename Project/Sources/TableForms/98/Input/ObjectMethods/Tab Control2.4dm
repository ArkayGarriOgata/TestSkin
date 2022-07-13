lastTab:=Selected list items:C379(iServiceTabs)
GET LIST ITEM:C378(iServiceTabs; lastTab; $itemRef; $itemText)

Case of 
	: (lastTab=7)
		USE SET:C118("allPrepCharges")
		
	: (lastTab#0)
		USE SET:C118("allPrepCharges")
		
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Prep_Charges:103]; [Prep_Charges:103]RequestSeries:13=lastTab)
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
		
	Else 
		BEEP:C151
		lastTab:=7
		SELECT LIST ITEMS BY POSITION:C381(iServiceTabs; lastTab)
		USE SET:C118("allPrepCharges")
		$itemText:="default"
End case 

zwStatusMsg("PREP CHARGES"; String:C10(lastTab)+" "+$itemText)
ORDER BY:C49([Prep_Charges:103]; [Prep_Charges:103]SortOrder:12; >)