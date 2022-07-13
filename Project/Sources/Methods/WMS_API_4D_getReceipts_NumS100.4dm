//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getReceipts_NumS100 - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $xlCases)
C_TEXT:C284($ttSQL)
$xlCases:=0

$ttSQL:="SELECT Count(*) FROM ams_exports WHERE transaction_state_indicator = 'S' AND transaction_type_code = 100"
SQL EXECUTE:C820($ttSQL; $xlCases)
If (OK=1)
	If (Not:C34(SQL End selection:C821))
		SQL LOAD RECORD:C822(SQL all records:K49:10)
	End if 
	SQL CANCEL LOAD:C824
End if 

$0:=$xlCases