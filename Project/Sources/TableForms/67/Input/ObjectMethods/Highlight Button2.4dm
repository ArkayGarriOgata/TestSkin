If ([Job_Forms_Master_Schedule:67]MAD:21#!00-00-00!)
	Cal_getDate(->[Job_Forms_Master_Schedule:67]MAD:21; Month of:C24([Job_Forms_Master_Schedule:67]MAD:21); Year of:C25([Job_Forms_Master_Schedule:67]MAD:21))
Else 
	Cal_getDate(->[Job_Forms_Master_Schedule:67]MAD:21)
End if 
//
//•120998  MLB Y2K Remediation 
//• mlb - 3/4/03  12:15 subform fix
C_LONGINT:C283($err)
$err:=sDateLimitor(->[Job_Forms_Master_Schedule:67]MAD:21; 565)
If ($err=0)
	If ([Job_Forms_Master_Schedule:67]MAD:21=!00-00-00!)
		Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]MAD:21; -(14+(256*12)))  //grey
	Else 
		Core_ObjectSetColor(->[Job_Forms_Master_Schedule:67]MAD:21; -(15+(256*12)))
	End if 
	JML_SetItemsHRD
	
Else 
	[Job_Forms_Master_Schedule:67]MAD:21:=Old:C35([Job_Forms_Master_Schedule:67]MAD:21)
End if 