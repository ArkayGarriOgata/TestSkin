//•120998  MLB Y2K Remediation 
C_LONGINT:C283($err; $i)
$err:=sDateLimitor(Self:C308; 365)
If ([Job_Forms_Master_Schedule:67]PressDate:25=!00-00-00!)
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]PressDate:25; -(14+(256*12)))  //grey
Else 
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]PressDate:25; -(15+(256*12)))  //  
End if 


