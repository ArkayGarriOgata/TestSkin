//%attributes = {"publishedWeb":true}
//PS_MakeReadyTimerNextStart

$recNo:=Selected record number:C246([ProductionSchedules:110])
If ($recNo>0)
	GOTO SELECTED RECORD:C245([ProductionSchedules:110]; ($recNo+1))
	makingReadyOn:=PS_MakeReadyTimerJobStart
	CUT NAMED SELECTION:C334([ProductionSchedules:110]; "redraw")
	USE NAMED SELECTION:C332("redraw")
	OBJECT SET ENABLED:C1123(bStop; True:C214)
	OBJECT SET ENABLED:C1123(bStart; False:C215)
End if 