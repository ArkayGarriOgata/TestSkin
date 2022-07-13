//%attributes = {"publishedWeb":true}
//(P) uRptVendList: Vendor Listing

zDefFilePtr:=->[Vendors:7]
If (OK=1)
	util_PAGE_SETUP(->[Vendors:7]; "ListRpt")
	PRINT SETTINGS:C106
	If (OK=1)
		If (uNowOrDelay)
			FORM SET OUTPUT:C54([Vendors:7]; "ListRpt")
			dAsof:=4D_Current_date
			PRINT SELECTION:C60([Vendors:7]; *)
		End if 
	End if 
End if 