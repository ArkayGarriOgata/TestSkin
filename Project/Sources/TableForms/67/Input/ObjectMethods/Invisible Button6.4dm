If ([Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!)
	Cal_getDate(->[Job_Forms_Master_Schedule:67]PressDate:25; Month of:C24([Job_Forms_Master_Schedule:67]PressDate:25); Year of:C25([Job_Forms_Master_Schedule:67]PressDate:25))
Else 
	Cal_getDate(->[Job_Forms_Master_Schedule:67]PressDate:25)
End if 
//
//•120998  MLB Y2K Remediation 
C_LONGINT:C283($err)
$err:=sDateLimitor(->[Job_Forms_Master_Schedule:67]PressDate:25; 365)
If ([Job_Forms_Master_Schedule:67]PressDate:25=!00-00-00!)
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]PressDate:25; -(14+(256*12)))  //grey
Else 
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]PressDate:25; -(15+(256*12)))  //  
End if 