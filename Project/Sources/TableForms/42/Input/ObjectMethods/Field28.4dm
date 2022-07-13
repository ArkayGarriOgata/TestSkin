//•120998  MLB Y2K Remediation 
C_LONGINT:C283($err)
$err:=sDateLimitor(Self:C308; 365)
If ([Job_Forms:42]ClosedDate:11#!00-00-00!)
	If ([Job_Forms:42]Status:6="Complete")
		[Job_Forms:42]Status:6:="Closed"
	End if 
	
End if 