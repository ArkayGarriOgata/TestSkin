//%attributes = {"publishedWeb":true}
//(P) uRptVendPerf: Vendor Performance Ratings

zDefFilePtr:=->[Vendors:7]
If (OK=1)
	util_PAGE_SETUP(->[Vendors:7]; "PerfRpt")
	PRINT SETTINGS:C106
	If (OK=1)
		If (uNowOrDelay)
			FORM SET OUTPUT:C54([Vendors:7]; "PerfRpt")
			dAsof:=Current date:C33
			PRINT SELECTION:C60([Vendors:7]; *)
		End if 
	End if 
End if 