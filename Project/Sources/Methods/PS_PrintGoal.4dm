//%attributes = {}

// Method: PS_PrintGoal ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 05/08/14, 10:18:48
// ----------------------------------------------------
// Description
// take a snapshot of the expected sheets to print in the following week.
//
// ----------------------------------------------------
// Modified by: Mel Bohince (5/15/14) chg range to Sunday -> Saturday
// Modified by: Mel Bohince (9/28/16) Expect run to be monday, set BeginDate at 10pm (sunday) yesterday
// Modified by: Mel Bohince (10/17/16) add option for thru put
// Modified by: Mel Bohince (1/29/19) do query constraint before selecting for the department group of C/C's

C_LONGINT:C283($todayIs)
C_DATE:C307($sunday; $next_saturday; $pastSunday)
C_BOOLEAN:C305($showTP)

$currentDate:=Current date:C33
//$currentDate:=!10/03/2016!

$todayIs:=Day number:C114($currentDate)
//$sunday:=Add to date(Current date;0;0;(8-$todayIs))
//$next_saturday:=Add to date($sunday;0;0;6)
$pastSunday:=Add to date:C393($currentDate; 0; 0; -($todayIs-1))
$next_saturday:=Add to date:C393($pastSunday; 0; 0; 6)

If (Count parameters:C259>=1)
	$group:=$1
	$showTP:=(Count parameters:C259=2)
Else 
	$group:="Printing"
	$showTP:=False:C215
End if 

If (Current user:C182="Designer")
	$showTP:=True:C214
End if 

QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]Priority:3>0; *)
QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]Completed:23=0; *)
QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]StartDate:4>=$pastSunday; *)
QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]EndDate:6<=$next_saturday)

Case of 
	: ($group="Printing")  // get the schedule for all printing
		$numRecs:=PS_qryPrintingOnly("selection")  //leave qry open
		
	: ($group="Blanking")  // get the schedule for all blankers
		$numRecs:=PS_qryDieCuttingOnly("selection")  //leave qry open
		
	: ($group="Stamping")  // get the schedule for all blankers
		$numRecs:=PS_qryStampingOnly("selection")  //leave qry open
		
	Else 
		$numRecs:=PS_qryPrintingOnly("selection")  //leave qry open
End case 




C_LONGINT:C283($i; $numRecs; $hit; $totalSheets)
C_BOOLEAN:C305($break)

$break:=False:C215
$numRecs:=Records in selection:C76([ProductionSchedules:110])

$totalSheets:=0
$totalThruput:=0
ARRAY TEXT:C222($aPress; 0)
ARRAY LONGINT:C221($aNetSheets; 0)
ARRAY LONGINT:C221($aThruput; 0)

uThermoInit($numRecs; "Updating Records")
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
	
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		$hit:=Find in array:C230($aPress; [ProductionSchedules:110]CostCenter:1)
		If ($hit=-1)
			APPEND TO ARRAY:C911($aPress; [ProductionSchedules:110]CostCenter:1)
			APPEND TO ARRAY:C911($aNetSheets; [ProductionSchedules:110]Planned_QtyGood:56)
			APPEND TO ARRAY:C911($aThruput; [ProductionSchedules:110]ThruPutValueOfJob:78)
		Else 
			$aNetSheets{$hit}:=$aNetSheets{$hit}+[ProductionSchedules:110]Planned_QtyGood:56
			$aThruput{$hit}:=$aThruput{$hit}+[ProductionSchedules:110]ThruPutValueOfJob:78
		End if 
		$totalSheets:=$totalSheets+[ProductionSchedules:110]Planned_QtyGood:56
		$totalThruput:=$totalThruput+[ProductionSchedules:110]ThruPutValueOfJob:78
		NEXT RECORD:C51([ProductionSchedules:110])
		uThermoUpdate($i)
	End for 
	
	
Else 
	
	ARRAY TEXT:C222($_CostCenter; 0)
	ARRAY LONGINT:C221($_Planned_QtyGood; 0)
	ARRAY LONGINT:C221($_ThruPutValueOfJob; 0)
	
	SELECTION TO ARRAY:C260([ProductionSchedules:110]CostCenter:1; $_CostCenter; \
		[ProductionSchedules:110]Planned_QtyGood:56; $_Planned_QtyGood; \
		[ProductionSchedules:110]ThruPutValueOfJob:78; $_ThruPutValueOfJob)
	
	For ($i; 1; $numRecs; 1)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		$hit:=Find in array:C230($aPress; $_CostCenter{$i})
		If ($hit=-1)
			APPEND TO ARRAY:C911($aPress; $_CostCenter{$i})
			APPEND TO ARRAY:C911($aNetSheets; $_Planned_QtyGood{$i})
			APPEND TO ARRAY:C911($aThruput; $_ThruPutValueOfJob{$i})
		Else 
			$aNetSheets{$hit}:=$aNetSheets{$hit}+$_Planned_QtyGood{$i}
			$aThruput{$hit}:=$aThruput{$hit}+$_ThruPutValueOfJob{$i}
		End if 
		$totalSheets:=$totalSheets+$_Planned_QtyGood{$i}
		$totalThruput:=$totalThruput+$_ThruPutValueOfJob{$i}
		
		uThermoUpdate($i)
	End for 
	
	
End if   // END 4D Professional Services : January 2019 

uThermoClose

$tSubject:=$group+" Goal "+String:C10($totalSheets; "#,###,###,###")
$tBodyHeader:=$group+" Goal for "+String:C10($pastSunday; System date long:K1:3)+" to "+String:C10($next_saturday; System date long:K1:3)
$tBody:=""
$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$r:="</td></tr>"+Char:C90(13)
If ($showTP)
	$tBody:=$tBody+$b+"Press"+$t+"NetSheets"+$t+"$Thru-put"+$r
Else 
	$tBody:=$tBody+$b+"Press"+$t+"NetSheets"+$r
End if 
$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
SORT ARRAY:C229($aPress; $aNetSheets; >)
For ($i; 1; Size of array:C274($aPress))
	If ($showTP)
		$tBody:=$tBody+$b+$aPress{$i}+$t+String:C10($aNetSheets{$i}; "###,###,###")+$t+String:C10($aThruput{$i}; "###,###,###")+$r
	Else 
		$tBody:=$tBody+$b+$aPress{$i}+$t+String:C10($aNetSheets{$i}; "###,###,###")+$r
	End if 
End for 

$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"

If ($showTP)
	$tBody:=$tBody+$b+"Ttl"+$t+String:C10($totalSheets; "#,###,###,###")+$t+String:C10($totalThruput; "#,###,###,###")+$r
Else 
	$tBody:=$tBody+$b+"Ttl"+$t+String:C10($totalSheets; "#,###,###,###")+$r
End if 

If (Size of array:C274($aPress)>0)
	//distributionList:=Email_WhoAmI// for testing
	Email_html_table($tSubject; $tBodyHeader; $tBody; 250; distributionList)
End if 
