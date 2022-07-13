//%attributes = {}
// _______
// Method: PS_HaveClosingInJML   (weeks ) ->
// By: Mel Bohince @ 04/10/21, 09:16:58
// Description
// DateClosingMet or GateWayDeadLine
// ----------------------------------------------------

C_LONGINT:C283($horizonWeeks; $1; $horizonDays)

If (Count parameters:C259>0)
	$horizonWeeks:=$1
Else 
	$horizonWeeks:=3
End if 
$horizonDays:=$horizonWeeks*7

C_DATE:C307($from_d; $to_d)
$from_d:=Add to date:C393(4D_Current_date; -1; 0; 0)  //these tend to fall into the past
$to_d:=Add to date:C393(4D_Current_date; 0; 0; $horizonDays)  //!2021-03-14!

If (False:C215)  //testing:
	//REDUCE SELECTION([ProductionSchedules];0)
	//QUERY([ProductionSchedules];[ProductionSchedules]CostCenter="418")
End if 

QUERY SELECTION BY FORMULA:C207([ProductionSchedules:110]; \
([Job_Forms_Master_Schedule:67]GateWayDeadLine:42>=$from_d)\
 & ([Job_Forms_Master_Schedule:67]GateWayDeadLine:42<=$to_d)\
 & ([Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)\
 & ([Job_Forms:42]PlnnerReleased:59=!00-00-00!)\
)

