Case of 
	: (dDateEnd=!00-00-00!)
		dDateEnd:=dDateBegin
		
	: (dDateEnd<dDateBegin)
		dDateEnd:=dDateBegin
End case 