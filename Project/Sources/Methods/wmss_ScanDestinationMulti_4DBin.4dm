//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_ScanDestinationMulti_4D_Bin - Created v0.1.0-JJG (05/06/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 
C_BOOLEAN:C305($fProblem)
C_TEXT:C284($ttSQL; $ttBinID)
rft_destination:="bin"
$ttBinID:=Uppercase:C13(rft_response)
$fProblem:=True:C214

$ttSQL:="SELECT bin_id,location_type_Code FROM bins WHERE bin_id = ?"
SQL SET PARAMETER:C823($ttBinID; SQL param in:K49:1)
SQL EXECUTE:C820($ttSQL; sToBin; ams_location)

Case of 
	: (OK=0)
		
	: (SQL End selection:C821)
		SQL CANCEL LOAD:C824
		
	Else 
		$fProblem:=False:C215
		SQL LOAD RECORD:C822(SQL all records:K49:10)
		SQL CANCEL LOAD:C824
		Case of 
			: (Position:C15("CC"; ams_location)>0)
				iToCode:=1
				
			: (Position:C15("SHIP"; ams_location)>0)
				iToCode:=300
				
			: (Position:C15("FG"; ams_location)>0)
				iToCode:=100
				
			: (Position:C15("XC"; ams_location)>0)
				iToCode:=350
				
			: (Position:C15("SC"; ams_location)>0)
				iToCode:=400
				
			Else   //assume rack location like BNV-01-01-1
				iToCode:=100
		End case 
		tSQL:="UPDATE cases set case_status_code = "+String:C10(iToCode)+", ams_location='"+ams_location+"', bin_id='"+sToBin+"', update_initials = '"+<>zResp+"'"
		
End case 

If ($fProblem)
	rft_destination:=""
	rft_error_log:="Invalid bin location"
End if 



