//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: GanttCal_StringToDate - Created `v1.0.0-PJK (12/22/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 


C_TEXT:C284($1)
C_DATE:C307($0)
C_POINTER:C301($2)
// 2015-11-25T11:01:57-05:00
$ttText:=$1

$ttDate:=GetNextField(->$ttText; "T")
$ttTime:=GetNextField(->$ttText; "-")

$ttYear:=GetNextField(->$ttDate; "-")
$ttMonth:=GetNextField(->$ttDate; "-")
$ttDay:=GetNextField(->$ttDate; "-")

$0:=Date:C102($ttMonth+"/"+$ttDay+"/"+$ttYear)
$2->:=Time:C179($ttTime)