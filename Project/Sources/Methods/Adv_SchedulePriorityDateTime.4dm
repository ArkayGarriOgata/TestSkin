//%attributes = {"executedOnServer":true}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: Adv_SchedulePriorityDateTime - Created `v1.0.0-PJK (12/17/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

// ** EXECUTE ON SERVER Checkbox set for this method **

//$1=MachineID
//$2=->Priority
//$3=->Date
//$4=->Time
C_TEXT:C284($1; $ttID)
C_POINTER:C301($2; $3; $4; $pPriority; $pDate; $pTime)
C_LONGINT:C283($xlPriority)
$ttID:=$1
$pPriority:=$2
$pDate:=$3
$pTime:=$4

$pDate->:=!00-00-00!
$pTime->:=?00:00:00?

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=$ttID)
	ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; <)
	FIRST RECORD:C50([ProductionSchedules:110])
	$xlPriority:=[ProductionSchedules:110]Priority:3
	$pDate->:=[ProductionSchedules:110]EndDate:6
	$pTime->:=[ProductionSchedules:110]EndTime:7
	UNLOAD RECORD:C212([ProductionSchedules:110])
	
	
	
Else 
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=$ttID)
	ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; <)
	$xlPriority:=[ProductionSchedules:110]Priority:3
	$pDate->:=[ProductionSchedules:110]EndDate:6
	$pTime->:=[ProductionSchedules:110]EndTime:7
	UNLOAD RECORD:C212([ProductionSchedules:110])
	
	
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  

If ($xlPriority<9000)
	$xlPriority:=8990
End if 
$pPriority->:=$xlPriority+10
