//•120998  MLB Y2K Remediation 
C_LONGINT:C283($err)
$err:=sDateLimitor(Self:C308; 30; 3)
If ($err=0)
	Job_StatusReleaseJobBag([Job_Forms:42]JobFormID:5; [Job_Forms:42]PlnnerReleased:59)
End if 