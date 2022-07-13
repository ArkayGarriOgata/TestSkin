//(s) ◊aReqRptpop
//Located [control]deptEvent

If (Self:C308->#0)
	Case of 
		: (Self:C308->=1)
			ViewSetter(96; ->[y_accounting_departments:4])
		: (Self:C308->=2)
			ViewSetter(97; ->[y_accounting_departments:4])
	End case 
End if 
//