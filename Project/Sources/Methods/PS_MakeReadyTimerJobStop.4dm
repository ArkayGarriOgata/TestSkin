//%attributes = {"publishedWeb":true}
//PS_MakeReadyTimerJobStop

PS_MakeReadyTimer(1)
$elapseTime:=PS_MakeReadyTimerStop
If ($elapseTime#?00:00:00?)
	If ($elapseTime<?00:01:00?)
		$elapseTime:=?00:01:00?
	End if 
	READ WRITE:C146([ProductionSchedules_MakeReady:126])
	QUERY:C277([ProductionSchedules_MakeReady:126]; [ProductionSchedules_MakeReady:126]JobSequence:1=makingReadyOn)
	If (Records in selection:C76([ProductionSchedules_MakeReady:126])=0)
		PS_CreateTargetMRrecord
	End if 
	[ProductionSchedules_MakeReady:126]MRtarget:2:=[ProductionSchedules:110]MRtarget:31
	[ProductionSchedules_MakeReady:126]MRactual:3:=$elapseTime
	tText:=Request:C163("Any comments about this MakeReady?"; ""; "Save"; "Cancel")
	If (ok=1)
		util_textNoGremlins(->tText)
		If (Length:C16(tText)>0)
			[ProductionSchedules_MakeReady:126]Comment:4:=[ProductionSchedules_MakeReady:126]Comment:4+tText
		End if 
	End if 
	SAVE RECORD:C53([ProductionSchedules_MakeReady:126])
End if 