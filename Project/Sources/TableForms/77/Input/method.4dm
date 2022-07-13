If (Form event code:C388=On Load:K2:1)
	C_DATE:C307(dDateBegin)
	C_TIME:C306(tTimeBegin)
	TS2DateTime([z_batch_run_dates:77]LastRun:1; ->dDateBegin; ->tTimeBegin)
End if 