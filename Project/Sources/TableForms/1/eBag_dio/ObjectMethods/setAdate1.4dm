//(S) [ReleaseSchedule]'List'bPriority
If (True:C214)
	JML_SetDate(Substring:C12(sCriterion1; 1; 8))
Else   //new process will find the record locked, do it in-process
	$pid:=New process:C317("JML_SetDate"; <>lMinMemPart; "Set-A-Date"; Substring:C12(sCriterion1; 1; 8))
	If (False:C215)
		JML_SetDate
	End if 
	zwStatusMsg("REMINDER"; "Choose Update Job Info under the Press menu to see recently entered dates.")
End if 
