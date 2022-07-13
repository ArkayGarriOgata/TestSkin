//%attributes = {}
// Method: PSFilterReleased
// User name (OS): Mark Zinke
// Date and time: 06/11/13, 13:15:51
// Description:
// Filters the listing to show only jobs for the next
//  two weeks that haven't been released.
// ----------------------------------------------------
// Modified by: Mel Bohince (6/20/13) move date search before filtering by status
// Modified by: Mel Bohince (10/8/15)  show Hold status also
// Modified by: Mel Bohince (2/5/16) change 2 weeks to 3

C_LONGINT:C283($i; $iDoIt; $1)
C_DATE:C307($dTwoWeeks)
ARRAY TEXT:C222($atJobSeq; 0)
ARRAY TEXT:C222($atJobForm; 0)

$iDoIt:=$1

If ($iDoIt=1)
	PS_HaveClosingInJML(3)
	
	
	Case of 
		: (b4=1)  //Priority
			ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; >)
		: (b8=1)  //Start
			ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4; >; [ProductionSchedules:110]StartTime:5; >)
		: (b7=1)  //Job
			ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8; >)
		: (b6=1)  //Line
			ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Line:10; >; [ProductionSchedules:110]Priority:3; >)
	End case 
	
End if 