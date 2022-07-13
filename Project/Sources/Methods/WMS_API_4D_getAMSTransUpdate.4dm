//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getAMSTransUpdate - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_POINTER:C301($1; $psxlTransID)
C_LONGINT:C283($i; $xlNumElements; $xlTransId)
C_TEXT:C284($ttSQL)
$psxlTransID:=$1

$xlNumElements:=Size of array:C274($psxlTransID->)
$ttSQL:="UPDATE ams_exports SET transaction_state_indicator = 'X' WHERE transaction_id = ?"
uThermoInit($xlNumElements; "Saving Status State change")
For ($i; 1; $xlNumElements)
	$xlTransID:=$psxlTransID->{$i}
	SQL SET PARAMETER:C823($xlTransID; SQL param in:K49:1)
	SQL EXECUTE:C820($ttSQL)
	SQL CANCEL LOAD:C824
	uThermoUpdate($i)
End for 
uThermoClose

