//•120998  MLB Y2K Remediation 
C_LONGINT:C283($err)
$err:=sDateLimitor(Self:C308; 365)
If ([Job_Forms:42]Completed:18#!00-00-00!)
	If ([Job_Forms:42]Status:6="In Process") | ([Job_Forms:42]Status:6="WIP")
		[Job_Forms:42]Status:6:="Complete"
	End if 
	
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)
		[Job_Forms_Master_Schedule:67]DateComplete:15:=[Job_Forms:42]Completed:18
		SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
		
	End if 
End if 