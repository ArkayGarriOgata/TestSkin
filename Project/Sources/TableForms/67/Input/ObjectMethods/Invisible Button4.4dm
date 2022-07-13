If ([Job_Forms_Master_Schedule:67]GlueReady:28#!00-00-00!)
	Cal_getDate(->[Job_Forms_Master_Schedule:67]GlueReady:28; Month of:C24([Job_Forms_Master_Schedule:67]GlueReady:28); Year of:C25([Job_Forms_Master_Schedule:67]GlueReady:28))
Else 
	Cal_getDate(->[Job_Forms_Master_Schedule:67]GlueReady:28)
End if 
//
//•120998  MLB Y2K Remediation 
C_LONGINT:C283($err)
$err:=sDateLimitor(->[Job_Forms_Master_Schedule:67]GlueReady:28; 7)
If ([Job_Forms_Master_Schedule:67]GlueReady:28=!00-00-00!)
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]GlueReady:28; -(14+(256*12)))  //grey
Else 
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]GlueReady:28; -(15+(256*12)))  //
End if 
//