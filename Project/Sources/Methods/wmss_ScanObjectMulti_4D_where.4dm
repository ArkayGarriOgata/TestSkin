//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wmss_ScanObjectMulti_4D_where - Created v0.1.0-JJG (05/06/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($0; $ttSQLWhere)
$ttSQLWhere:=""

Case of 
	: (Position:C15(rft_Response; rft_log)>0)
		rft_error_log:="Duplicate scan"
		
	: (Length:C16(rft_Response)<3)
		rft_error_log:="Scan a label"
		
	: (Substring:C12(rft_Response; 1; 2)="BN")  //cant move a bin 
		rft_error_log:="Can't move a BIN"
		
	: (Length:C16(rft_Response)=20) & (rft_destination="skid")  //cant combine skids
		rft_error_log:="Can't combine SKIDS"
		
	: (Length:C16(rft_Response)=20) & (rft_destination="bin")  //skid, can only go to a bin
		rft_object:="skid"
		$ttSQLWhere:=" WHERE skid_number = ?"
		rft_caseId:=""
		rft_log:=rft_log+rft_object+" "+rft_Response+"\r"
		
	: (Length:C16(rft_Response)=22)  //case, can go to bin or skid
		rft_object:="case"
		$ttSQLWhere:=" WHERE case_id = ?"
		rft_log:=rft_log+rft_object+" "+rft_Response+"\r"
		
	Else 
		rft_error_log:="Scan a label"
		
End case 

$0:=$ttSQLWhere