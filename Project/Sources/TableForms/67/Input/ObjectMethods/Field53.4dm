//•120998  MLB Y2K Remediation 
C_LONGINT:C283($err)
$err:=sDateLimitor(Self:C308; 7)
If ([Job_Forms_Master_Schedule:67]GlueReady:28=!00-00-00!)
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]GlueReady:28; -(14+(256*12)))  //grey
Else 
	Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]GlueReady:28; -(15+(256*12)))  //
End if 
//