If (bSave=1)
	vDoc:=Create document:C266("")  //MonthEndSuite_"+String(dDateBegin)+"-"+String(dDateEnd))
	
	If (ok=1)
		fSave:=True:C214
	Else 
		vDoc:=?00:00:00?
		fSave:=False:C215
		document:=""
		bSave:=0
	End if 
	
Else 
	vDoc:=?00:00:00?
	fSave:=False:C215
	document:=""
End if 

PDF_onOff
