// [FG_Trans];"FGWhatTrans"   -JML  7/15/93
//allows user to specify contents of the F/G transfer report
If (Form event code:C388=On Load:K2:1)
	C_DATE:C307(dDateBegin; dDateEnd)
	If (dDateEnd=!00-00-00!)
		dDateEnd:=4D_Current_date
	End if 
End if 