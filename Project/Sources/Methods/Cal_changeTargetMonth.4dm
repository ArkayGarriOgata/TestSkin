//%attributes = {"publishedWeb":true}
C_LONGINT:C283($1; $offset)

$offset:=$1

If (Abs:C99($offset)=12)
	//one year step  
	If ($offset>0)
		vl_currentYear:=vl_currentYear+1
	Else 
		vl_currentYear:=vl_currentYear-1
	End if 
Else 
	If ($offset>0)
		If (vl_currentMonth=12)
			vl_currentMonth:=1
			vl_currentYear:=vl_currentYear+1
		Else 
			vl_currentMonth:=vl_currentMonth+$1
		End if 
	Else 
		If (vl_currentMonth=1)
			vl_currentMonth:=12
			vl_currentYear:=vl_currentYear-1
		Else 
			vl_currentMonth:=vl_currentMonth+$1
		End if 
	End if 
End if 

//redraw the calendar
Cal_draw