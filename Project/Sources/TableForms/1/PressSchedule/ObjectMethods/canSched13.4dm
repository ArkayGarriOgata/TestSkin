//OM: bLoad() -> 
//@author mlb - 12/4/01  14:09

If (Length:C16(sCriterion1)=3)
	//C_LONGINT($x;$y;$state)
	//GET MOUSE($x;$y;$state;*)
	app_Log_Usage("log"; "PS New"; sCriterion1)
	$winRef:=OpenSheetWindow(->[ProductionSchedules:110]; "NewJobSeq")  //;0;$x;$y-200)
	DIALOG:C40([ProductionSchedules:110]; "NewJobSeq")
	CLOSE WINDOW:C154  //($winRef)
	
	pressBackLog:=PS_qryCurrentBackLog(sCriterion1)
	
Else 
	BEEP:C151
	ALERT:C41("ERROR: Close, then reopen this window.")
End if 
