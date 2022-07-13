//%attributes = {"publishedWeb":true}
//(P) uRptCCList: Cost Center Listing

zDefFilePtr:=->[Cost_Centers:27]
If (OK=1)
	util_PAGE_SETUP(->[Cost_Centers:27]; "Rept")
	PRINT SETTINGS:C106
	If (OK=1)
		If (uNowOrDelay)
			FORM SET OUTPUT:C54([Cost_Centers:27]; "Rept")
			dAsof:=4D_Current_date
			PRINT SELECTION:C60([Cost_Centers:27]; *)
		End if 
	End if 
End if 