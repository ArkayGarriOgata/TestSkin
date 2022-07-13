//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: GanttCal_SelectDay - Created `v1.0.0-PJK (12/22/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 
C_TEXT:C284($1; $ttDay; $ttMonth; $ttText; $ttYear)
C_DATE:C307($dDate)

$ttText:=$1
$ttYear:=GetNextField(->$ttText; "-")
$ttMonth:=GetNextField(->$ttText; "-")
$ttDay:=GetNextField(->$ttText; "-")

$dDate:=Date:C102($ttMonth+"/"+$ttDay+"/"+$ttYear)

