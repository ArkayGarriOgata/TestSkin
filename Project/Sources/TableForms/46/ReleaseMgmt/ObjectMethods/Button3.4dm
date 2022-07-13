//$winRef:=Open form window([CONTROL];"DateRange2";8)  `;"wCloseOption")

ERASE WINDOW:C160
dDateBegin:=(4D_Current_date-12)
dDateEnd:=4D_Current_date-5
distributionList:=""
DIALOG:C40([zz_control:1]; "DateRange2")
ERASE WINDOW:C160  //CLOSE WINDOW($winRef)

If (ok=1)
	If (bSearch=1)
		zwStatusMsg("ON TIME"; "From "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1))
	Else 
		zwStatusMsg("ON TIME"; "From "+String:C10(dDateBegin; System date short:K1:1)+" to "+String:C10(dDateEnd; System date short:K1:1))
	End if 
	REL_OntimeScheduledLate(dDateBegin; dDateEnd; "@"; 3; distributionList)
	SET WINDOW TITLE:C213(fNameWindow(->[Customers_ReleaseSchedules:46]))
End if 
