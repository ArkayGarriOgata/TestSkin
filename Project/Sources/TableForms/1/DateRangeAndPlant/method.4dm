//FM:  DateRangeAndPlant  052899  mlb
//used by CoGs via FG palette
If (Form event code:C388=On Load:K2:1)
	C_DATE:C307(dDateEnd; dDateBegin)
	If (dDateEnd=!00-00-00!)
		dDateEnd:=4D_Current_date
	End if 
	If (dDateBegin=!00-00-00!)
		dDateBegin:=4D_Current_date-(Day of:C23(4D_Current_date)-1)
	End if 
	rb1:=1  //all
	rb2:=0  //haup
	rb3:=0  //roan
	rb4:=0  //payuse
	//◊PHYSICAL_INVENORY_IN_PROGRESS:=True
	If (<>PHYSICAL_INVENORY_IN_PROGRESS)
		OBJECT SET ENABLED:C1123(rb1; False:C215)
		OBJECT SET ENABLED:C1123(rb2; False:C215)
		OBJECT SET ENABLED:C1123(rb3; False:C215)
		OBJECT SET ENABLED:C1123(rb4; False:C215)
	End if 
	
End if 