//OM: bNeedPlated() -> 
//@author mlb - 6/27/02  15:33

If (bNeedPlated=1)
	app_Log_Usage("log"; "PS NeedPlates"; "")
	PSFilterReleased(0)  // Added by: Mark Zinke (6/11/13)
	cbFilter:=0  // Added by: Mark Zinke (6/11/13)
	pressBackLog:=PS_qryReadyToPlate(sCriterion1)
	
Else 
	pressBackLog:=PS_qryCurrentBackLog(sCriterion1)
End if 