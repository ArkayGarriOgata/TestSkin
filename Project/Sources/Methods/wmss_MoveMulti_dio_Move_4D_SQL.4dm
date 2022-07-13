//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: MoveMulti_dio_Move_4D_SQL - Created v0.1.0-JJG (05/06/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($0; $ttSQL)
C_LONGINT:C283($1; $xlIndex)
$xlIndex:=$1

Case of 
	: (Position:C15("cases"; rft_Case{$xlIndex})>0)
		$ttSQL:=tSQL+",from_bin_id = '"+rft_Bin{$xlIndex}+"' WHERE skid_number = '"+rft_Skid{$xlIndex}+"'"
	Else 
		$ttSQL:=tSQL+",from_bin_id = '"+rft_Bin{$xlIndex}+"' WHERE case_id = '"+rft_Case{$xlIndex}+"'"
End case 

$0:=$ttSQL