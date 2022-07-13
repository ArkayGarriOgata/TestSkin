uConfirm("Mark this job as No Printing?"; "No Printing"; "Cancel")
If (ok=1)
	[Job_Forms_Master_Schedule:67]PressDate:25:=!2001-01-01!
	[Job_Forms_Master_Schedule:67]Printed:32:=!2001-01-01!
	[Job_Forms_Master_Schedule:67]Comment:22:="NO PRINTING "+[Job_Forms_Master_Schedule:67]Comment:22
End if 
