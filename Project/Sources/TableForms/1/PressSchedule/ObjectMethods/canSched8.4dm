BEEP:C151
CONFIRM:C162("Update the Press dates on the JobMasterLog to match the Press Schedule?"; "Update"; "Cancel")
If (ok=1)
	If (False:C215)
		JML_BeforeAfterBulletin("before")
	End if 
	JML_setPressDatefromSched
	//JML_BeforeAfterBulletin ("after")
	BEEP:C151
End if 