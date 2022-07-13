tText:="Print Button"
CONFIRM:C162("Pick a report style"; "Disposition"; "RGA")
If (ok=1)
	util_PAGE_SETUP(->[QA_Corrective_Actions:105]; "ComplaintListing")
	FORM SET OUTPUT:C54([QA_Corrective_Actions:105]; "ComplaintListing")
Else 
	util_PAGE_SETUP(->[QA_Corrective_Actions:105]; "CAR Report Listing")
	FORM SET OUTPUT:C54([QA_Corrective_Actions:105]; "CAR Report Listing")
End if 
PRINT SELECTION:C60([QA_Corrective_Actions:105])
FORM SET OUTPUT:C54([QA_Corrective_Actions:105]; "Output")
//