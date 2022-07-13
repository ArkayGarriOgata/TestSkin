//%attributes = {"publishedWeb":true}
//(P) uRptCustDet: Customer Detail

zDefFilePtr:=->[Customers:16]
If (OK=1)
	util_PAGE_SETUP(->[Customers:16]; "Rept")
	PRINT SETTINGS:C106
	
	READ ONLY:C145([Customers:16])
	FORM SET OUTPUT:C54([Customers:16]; "Rept")
	dAsof:=4D_Current_date
	PRINT SELECTION:C60([Customers:16]; *)
	READ WRITE:C146([Customers:16])
End if 