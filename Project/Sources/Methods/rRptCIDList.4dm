//%attributes = {"publishedWeb":true}
//(P) uRptCIDList: PO Clause Listing

zDefFilePtr:=->[Purchase_Orders_Clauses:14]
If (OK=1)
	util_PAGE_SETUP(->[Purchase_Orders_Clauses:14]; "ListRept")
	PRINT SETTINGS:C106
	If (OK=1)
		If (uNowOrDelay)
			FORM SET OUTPUT:C54([Purchase_Orders_Clauses:14]; "ListRept")
			dAsof:=Current date:C33
			PRINT SELECTION:C60([Purchase_Orders_Clauses:14]; *)
		End if 
	End if 
End if 