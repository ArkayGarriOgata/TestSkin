//%attributes = {"publishedWeb":true}
//(P) uRptPOList: Purchase Order Listing

zDefFilePtr:=->[Purchase_Orders:11]
If (OK=1)
	util_PAGE_SETUP(->[Purchase_Orders:11]; "ListRept")
	PRINT SETTINGS:C106
	If (OK=1)
		If (uNowOrDelay)
			FORM SET OUTPUT:C54([Purchase_Orders:11]; "ListRept")
			dAsof:=Current date:C33
			PRINT SELECTION:C60([Purchase_Orders:11]; *)
		End if 
	End if 
End if 