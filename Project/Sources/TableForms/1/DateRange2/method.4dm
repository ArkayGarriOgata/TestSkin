//[control];"DateRange2"  -- JML  7/15/93
//This is ued by doFGRptRecords().
//variables definitions used here are shared by the uLinkRelated() interface.

If (Form event code:C388=On Load:K2:1)
	C_DATE:C307(dDateEnd; dDateBegin)
	If (dDateEnd=!00-00-00!)
		dDateEnd:=4D_Current_date
	End if 
End if 