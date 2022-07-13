If (dDateBegin#!00-00-00!)
	Cal_getDate(->dDateBegin; Month of:C24(dDateBegin); Year of:C25(dDateBegin))
Else 
	Cal_getDate(->dDateBegin)
End if 
