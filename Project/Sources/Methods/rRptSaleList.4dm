//%attributes = {"publishedWeb":true}
//(P) uRptSaleList: Salesman Listing

zDefFilePtr:=->[Salesmen:32]
If (OK=1)
	util_PAGE_SETUP(->[Salesmen:32]; "Rept")
	PRINT SETTINGS:C106
	If (OK=1)
		If (uNowOrDelay)
			FORM SET OUTPUT:C54([Salesmen:32]; "Rept")
			dAsof:=4D_Current_date
			PRINT SELECTION:C60([Salesmen:32]; *)
		End if 
	End if 
End if 