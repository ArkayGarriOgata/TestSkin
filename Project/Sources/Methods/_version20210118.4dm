//%attributes = {}
// _______
// Method: _version20210118   ( ) ->
// By: Mel Bohince @ 01/18/21, 20:58:41
// Description
// put the LPD from TMC into user date 3 to display on shipmgmt screen
// ----------------------------------------------------
C_OBJECT:C1216($es; $e; $status_o)
//$es:=ds.Customers_ReleaseSchedules.query("Actual_Date = 00/00/00 and ediASNmsgID=-1 and Milestones.LPD # Null")
$es:=ds:C1482.Customers_ReleaseSchedules.query("Actual_Date = 00/00/00 and ediASNmsgID=-1 and  user_date_3 = 00/00/00 and Milestones.LPD # Null")
For each ($e; $es)
	//[Customers_ReleaseSchedules]user_date_3
	$e.user_date_3:=Date:C102($e.Milestones.LPD)
	$status_o:=$e.save()
End for each 
BEEP:C151

$es:=ds:C1482.Customers_ReleaseSchedules.query("Actual_Date = 00/00/00 and ediASNmsgID=-1 and  user_date_1 = 00/00/00 and Milestones.EPD # Null")
For each ($e; $es)
	//[Customers_ReleaseSchedules]user_date_3
	$e.user_date_1:=Date:C102($e.Milestones.EPD)
	$status_o:=$e.save()
End for each 
BEEP:C151
