//%attributes = {"publishedWeb":true}
//(P) uRptPOStat: Purchase Order Status Report

zDefFilePtr:=->[Purchase_Orders:11]
If (OK=1)
	util_PAGE_SETUP(->[Purchase_Orders:11]; "StatusRept")
	PRINT SETTINGS:C106
	If (ok=1)
		If (uNowOrDelay)
			FORM SET OUTPUT:C54([Purchase_Orders:11]; "StatusRept")
			dAsof:=Current date:C33
			PRINT SELECTION:C60([Purchase_Orders:11]; *)
		End if 
	End if 
End if 