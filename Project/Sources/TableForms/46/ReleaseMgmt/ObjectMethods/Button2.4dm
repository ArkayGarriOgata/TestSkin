// • mel (4/2/04, 12:02:50) changed to internal view

ERASE WINDOW:C160  //$winRef:=Open form window([CONTROL];"DateRange2";8)  `;"wCloseOption")

dDateBegin:=(4D_Current_date-7)
dDateEnd:=4D_Current_date-0
distributionList:=""
DIALOG:C40([zz_control:1]; "DateRange2")
ERASE WINDOW:C160  //CLOSE WINDOW($winRef)

If (ok=1)
	If (bSearch=1)
		zwStatusMsg("ON TIME"; "From "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1))
	Else 
		zwStatusMsg("ON TIME"; "From "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1))
	End if 
	
	REL_OntimeReport(dDateBegin; dDateEnd; "@"; 3; distributionList)
	
	If (False:C215)
		REL_OntimeReportCustomerView(dDateBegin; dDateEnd; "@"; 3; distributionList)
	End if 
	
	SET WINDOW TITLE:C213(fNameWindow(->[Customers_ReleaseSchedules:46]))
End if 
