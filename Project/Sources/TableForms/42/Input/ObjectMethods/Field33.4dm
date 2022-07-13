//•120998  MLB Y2K Remediation 
C_LONGINT:C283($err)
$err:=sDateLimitor(Self:C308; 365)
If ($err=0)
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)
		SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
	End if 
End if 