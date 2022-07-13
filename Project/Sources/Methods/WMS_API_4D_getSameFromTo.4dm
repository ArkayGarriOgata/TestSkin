//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getSameFromTo - Created v0.1.0-JJG (05/16/16)
// Modified by: Mel Bohince (12/1/18) skip the mixed skids and they may be moving cases to skids in the same area
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $xlNumRecs)
C_TEXT:C284($ttSQL; $ttSQLWhere)
$xlNumRecs:=0

If (WMS_API_4D_DoLogin)
	$ttSQLWhere:=" WHERE transaction_state_indicator = 'S' AND "  //not yet imported as indicated by 'S' rather than 'X'
	$ttSQLWhere:=$ttSQLWhere+" bin_id = from_bin_id AND "
	$ttSQLWhere:=$ttSQLWhere+" skid_number not like '005%' AND "  // Modified by: Mel Bohince (12/1/18) skip the mixed skids and they may be moving cases to skids in the same area
	$ttSQLWhere:=$ttSQLWhere+"(transaction_type_code = 350 OR transaction_type_code = 200) "  //looking for specific types of transactions *** was <= $1  ****
	
	$ttSQL:="SELECT COUNT(*) FROM ams_exports "+$ttSQLWhere
	SQL EXECUTE:C820($ttSQL; $xlNumRecs)
	If (OK=1)
		If (Not:C34(SQL End selection:C821))
			SQL LOAD RECORD:C822(SQL all records:K49:10)
			SQL CANCEL LOAD:C824
			If ($xlNumRecs>0)
				$ttSQL:="UPDATE ams_exports SET transaction_state_indicator = 'X' "+$ttSQLWhere
				SQL EXECUTE:C820($ttSQL)
				If (OK=0)
					$xlNumRecs:=0
				Else 
					SQL CANCEL LOAD:C824
				End if 
			End if 
		End if 
	End if 
	WMS_API_4D_DoLogout
End if 

$0:=$xlNumRecs