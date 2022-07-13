CONFIRM:C162("Print before applying the changes?"; "Print"; "No")
If (ok=1)
	HR_printStatusReport
End if 

CONFIRM:C162("Apply Proposed Changes?"; "Apply"; "Cancel")
If (ok=1)
	HR_setCurrentStatus
End if 


