//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wmss_ScanDestinationMulti - Created v0.1.0-JJG (05/06/16)
//re-written for MySQL vs 4D WMS.
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fSuccess)
$fSuccess:=False:C215
rft_error_log:=""

If (<>fWMS_Use4D)
	wmss_ScanDestinationMulti_4D
	
Else 
	wmss_ScanDestinationMulti_MySQL
	
End if 

If (Length:C16(rft_error_log)=0)
	rft_state:="object"
	If (rft_destination="bin")
		rft_prompt:="to "+sToBin
		rft_log:="Moving to "+rft_destination+"\r"+sToBin+"\rEnter 'Move' to apply\r Enter Done to quit\r"
		rft_log:="Move a Case to Bin or Skid\rMove a Skid to Bin\rEnter 'Move' to apply\rEnter 'Done' to quit\r"
	Else 
		rft_prompt:="to "+Substring:C12(sToSkid; 1; 3)+".."+Substring:C12(sToSkid; 14)
		rft_log:="Moving to "+rft_destination+"\r"+sToSkid+"\rEnter 'Move' to apply\r Enter Done to quit\r"
	End if 
	
	$fSuccess:=True:C214
	zwStatusMsg("WMS Move"; "Scan cases/skids moving to "+sToBin+" then MOVE to apply or DONE to quit")
	
Else 
	wmss_initMoveMulti
	SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215)
End if 

rft_response:=""

$0:=$fSuccess


If (False:C215)  //v0.1.0-JJG (05/06/16) - original code moved to wms_ScanDestinationMulti-MySQL
	//  // ----------------------------------------------------
	//  // Method: wmss_ScanDestinationMulti   ( ) ->
	//  // By: Mel Bohince @ 04/06/16, 15:15:03
	//  // Description
	//  // 
	//  // ----------------------------------------------------
	
	//$0:=False
	//rft_error_log:=""
	//$conn_id:=DB_ConnectionManager ("Open")
	//If ($conn_id>0)
	
	//Case of 
	//: ((Substring(rft_Response;1;2)="BN"))
	//rft_destination:="bin"
	//$bin_id:=Uppercase(rft_response)
	//  //validate that bin is allowed, get state
	//$sql:="SELECT `bin_id`, `location_type_code` FROM `bins` WHERE `bin_id` = '"+$bin_id+"'"  //, `warehouse`
	//$rowSet:=MySQL Select ($conn_id;$sql)
	//$rowCount:=MySQL Get Row Count ($rowSet)
	//If ($rowCount>0)  //get it's attributes
	//sToBin:=MySQL Get String Column ($rowset;"bin_id")
	//ams_location:=MySQL Get String Column ($rowset;"location_type_code")
	
	//Case of 
	//: (Position("CC";ams_location)>0)
	//iToCode:=1
	
	//: (Position("SHIP";ams_location)>0)
	//iToCode:=300
	
	//: (Position("FG";ams_location)>0)
	//iToCode:=100
	
	//: (Position("XC";ams_location)>0)
	//iToCode:=350
	
	//: (Position("SC";ams_location)>0)
	//iToCode:=400
	
	//Else   //assume rack location like BNV-01-01-1
	//iToCode:=100
	//End case 
	
	//tSQL:="update cases set `case_status_code` = "+String(iToCode)+", `ams_location` = '"+ams_location+"', `bin_id` = '"+sToBin
	//tSQL:=tSQL+"', `update_datetime`  = '"+modDateTime+"', `update_initials` = '"+<>zResp+"'"
	
	//Else 
	//rft_destination:=""
	//rft_error_log:="Invalid bin location"
	//End if 
	
	//: (Length(rft_Response)=20)
	//rft_destination:="skid"
	//$skid_number:=rft_response
	//  //validate if skid is known to aMs, get jobit
	//QUERY([WMS_SerializedShippingLabels];[WMS_SerializedShippingLabels]HumanReadable=$skid_number)
	//If (Records in selection([WMS_SerializedShippingLabels])=1)
	//sJobit:=[WMS_SerializedShippingLabels]Jobit
	
	//  //validate if skid is know to wms, get state and location
	//$sql:="SELECT `case_id`, `skid_number`, `bin_id`, `case_status_code`, `ams_location`, `jobit` FROM `cases` WHERE `skid_number` = '"+$skid_number+"'"
	//$rowSet:=MySQL Select ($conn_id;$sql)
	//$rowCount:=MySQL Get Row Count ($rowSet)
	//If ($rowCount>0)  //get it's attributes
	//$case_id:=MySQL Get String Column ($rowset;"case_id")
	//sToSkid:=MySQL Get String Column ($rowset;"skid_number")
	//sToBin:=MySQL Get String Column ($rowset;"bin_id")
	//iToCode:=MySQL Get Integer Column ($rowset;"case_status_code")
	//ams_location:=MySQL Get String Column ($rowset;"ams_location")
	//sJobit:=MySQL Get String Column ($rowset;"jobit")
	
	//Else   //allow a new skid tag to be introduced
	//sToSkid:=$skid_number
	//sToBin:="BNVFG_HOLD"
	//iToCode:=100
	//ams_location:="FG"
	//End if 
	
	//If ($case_id#sToSkid)
	//tSQL:="update cases set `case_status_code` = "+String(iToCode)+", `ams_location` = '"+ams_location+"', `bin_id` = '"+sToBin
	//tSQL:=tSQL+"', `update_datetime`  = '"+modDateTime+"', `update_initials` = '"+<>zResp
	//tSQL:=tSQL+"', `skid_number` = '"+sToSkid+"' "
	
	//Else 
	//rft_error_log:="Can't add to Supercase"
	//End if 
	
	//Else   //error
	//rft_error_log:="Unknown SSCC#"
	//End if 
	
	
	//Else   //error -- destination needs to be a bin or skid
	//rft_error_log:="Bin or Skid required"
	//End case 
	
	//Else 
	//rft_error_log:="Could not connect to WMS."
	//End if   //conn id
	
	//If (Length(rft_error_log)=0)
	//rft_state:="object"
	//If (rft_destination="bin")
	//rft_prompt:="to "+sToBin
	//rft_log:="Moving to "+rft_destination+"\r"+sToBin+"\r Enter Done to quit\r"
	//Else 
	//rft_prompt:="to "+Substring(sToSkid;1;3)+".."+Substring(sToSkid;14)
	//rft_log:="Moving to "+rft_destination+"\r"+sToSkid+"\r Enter Done to quit\r"
	//End if 
	
	//$0:=True
	//zwStatusMsg ("WMS Move";"Scan cases/skids moving to "+sToBin+" the SAVE or DONE")
	
	//Else 
	//wmss_initMoveMulti 
	//SetObjectProperties ("";->rft_error_log;True;"";False)
	//End if 
	
	//rft_response:=""
	
End if 