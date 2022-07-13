//%attributes = {}
// _______
// Method: JML_HaveClosingNotReleased   ( ) ->
// By: Mel Bohince @ 04/12/21, 14:43:22
// Description
// list jobs which have their Closing (gatewaydeadline) set
// and have not been released by the planner to production
// so tasks leading up to production meeting can be checked
// ----------------------------------------------------


C_LONGINT:C283($horizonWeeks; $1; $horizonDays; $onlyNotMet; $2)

If (Count parameters:C259>0)
	$horizonWeeks:=$1
Else 
	$horizonWeeks:=3
End if 
$horizonDays:=$horizonWeeks*7

C_DATE:C307($from_d; $to_d)
$from_d:=Add to date:C393(4D_Current_date; -1; 0; 0)  //these tend to fall into the past
$to_d:=Add to date:C393(4D_Current_date; 0; 0; $horizonDays)  //!2021-03-14!

C_OBJECT:C1216($jml_es; $formObj)
If (Count parameters:C259<2)
	zwStatusMsg("Closing"; "Not Complete, Not Plnr Released, Closing in past year and less than 3 weeks from now")
	$jml_es:=ds:C1482.Job_Forms_Master_Schedule.query("DateComplete = :1 and GateWayDeadLine > :2"+\
		" and GateWayDeadLine <= :3 and JOB_FORM.PlnnerReleased = :4"; \
		!00-00-00!; $from_d; $to_d; !00-00-00!)
	
Else 
	$onlyNotMet:=$2  //([Job_Forms_Master_Schedule]DateClosingMet=!00-00-00!)
	zwStatusMsg("Closing"; "Not Complete, Not Plnr Released, Closing in past year and less than 2 weeks from now,not met")
	$jml_es:=ds:C1482.Job_Forms_Master_Schedule.query("DateComplete = :1 and GateWayDeadLine > :2"+\
		" and GateWayDeadLine <= :3 and JOB_FORM.PlnnerReleased = :4 and DateClosingMet = :5"; \
		!00-00-00!; $from_d; $to_d; !00-00-00!; !00-00-00!)
End if 

USE ENTITY SELECTION:C1513($jml_es)

CREATE SET:C116([Job_Forms_Master_Schedule:67]; "◊LastSelection"+String:C10(fileNum))
CREATE SET:C116([Job_Forms_Master_Schedule:67]; "CurrentSet")
SET WINDOW TITLE:C213(fNameWindow(->[Job_Forms_Master_Schedule:67]))

