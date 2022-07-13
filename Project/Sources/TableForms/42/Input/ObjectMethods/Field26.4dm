//•120998  MLB Y2K Remediation 
C_LONGINT:C283($err)
$err:=sDateLimitor(Self:C308; 365)
If ([Job_Forms:42]StartDate:10#!00-00-00!)
	If ([Job_Forms:42]Status:6#"c@")
		[Job_Forms:42]Status:6:="WIP"
	End if 
End if 