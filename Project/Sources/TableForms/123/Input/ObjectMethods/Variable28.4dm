//(s) THC
util_underConstruction

ZebraTestDriver("init")
//
CONFIRM:C162("Try to print 15 labels?")
If (ok=1)
	
	For ($i; 1; 15)
		util_PAGE_SETUP(->[WMS_ItemMasters:123]; "CaseLabel_Laser_1up")
		Print form:C5([WMS_ItemMasters:123]; "test")
		PAGE BREAK:C6(>)
	End for 
	PAGE BREAK:C6
	
End if 