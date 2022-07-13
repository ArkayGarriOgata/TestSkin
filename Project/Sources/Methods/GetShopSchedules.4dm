//%attributes = {"executedOnServer":true}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: GetShopSchedules - Created `v1.0.0-PJK (12/22/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

// THIS METHOD IS SET TO EXECUTE ON SERVER

//$1=Department
//$2=StartDate
//$3=End Date
//$4=->Dates array
//$5=->Labels array

C_DATE:C307($2; $3; $dStart; $dEnd)
C_POINTER:C301($4; $5; $pDates; $pLabels)
C_TEXT:C284($1; $ttDept)
$ttDept:=$1
$dStart:=$2
$dEnd:=$3
$pDates:=$4
$pLabels:=$5

CLEAR_ARRAY($pDates)
CLEAR_ARRAY($pLabels)


$dDate:=$dStart
While ($dDate<=$dEnd)
	
	
	$ttValue:=SF_GetNumOfShifts($dDate; $ttDept; True:C214)  //v1.0.0-PJK (12/23/15) pass true to create the record if it doesn't exist
	
	APPEND TO ARRAY:C911($pDates->; $dDate)
	APPEND TO ARRAY:C911($pLabels->; $ttValue)
	$dDate:=$dDate+1
End while 

UNLOAD RECORD:C212([ProductionSchedules_Shifts:180])