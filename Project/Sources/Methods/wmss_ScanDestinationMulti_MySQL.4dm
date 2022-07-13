//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wmss_ScanDestinationMulti_MySQL - Created v0.1.0-JJG (05/06/16)
//moved from wmss_ScanDestinationMulti
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

// ----------------------------------------------------
// Method: wmss_ScanDestinationMulti   ( ) ->
// By: Mel Bohince @ 04/06/16, 15:15:03
// Description
// 
// ----------------------------------------------------

//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)
	
	Case of 
		: ((Substring:C12(rft_Response; 1; 2)="BN"))
			rft_destination:="bin"
			$bin_id:=Uppercase:C13(rft_response)
			//validate that bin is allowed, get state
			$sql:="SELECT `bin_id`, `location_type_code` FROM `bins` WHERE `bin_id` = '"+$bin_id+"'"  //, `warehouse`
			//$rowSet:=MySQL Select ($conn_id;$sql)
			//$rowCount:=MySQL Get Row Count ($rowSet)
			If ($rowCount>0)  //get it's attributes
				//sToBin:=MySQL Get String Column ($rowset;"bin_id")
				//ams_location:=MySQL Get String Column ($rowset;"location_type_code")
				
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
				
				tSQL:="update cases set `case_status_code` = "+String:C10(iToCode)+", `ams_location` = '"+ams_location+"', `bin_id` = '"+sToBin
				tSQL:=tSQL+"', `update_datetime`  = '"+modDateTime+"', `update_initials` = '"+<>zResp+"'"
				
			Else 
				rft_destination:=""
				rft_error_log:="Invalid bin location"
			End if 
			
		: (Length:C16(rft_Response)=20)
			rft_destination:="skid"
			$skid_number:=rft_response
			//validate if skid is known to aMs, get jobit
			QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5=$skid_number)
			If (Records in selection:C76([WMS_SerializedShippingLabels:96])=1)
				sJobit:=[WMS_SerializedShippingLabels:96]Jobit:3
				sCPN:=[WMS_SerializedShippingLabels:96]CPN:2
				//validate if skid is know to wms, get state and location
				$sql:="SELECT `case_id`, `skid_number`, `bin_id`, `case_status_code`, `ams_location`, `jobit` FROM `cases` WHERE `skid_number` = '"+$skid_number+"'"
				//$rowSet:=MySQL Select ($conn_id;$sql)
				//$rowCount:=MySQL Get Row Count ($rowSet)
				If ($rowCount>0)  //get it's attributes
					//$case_id:=MySQL Get String Column ($rowset;"case_id")
					//sToSkid:=MySQL Get String Column ($rowset;"skid_number")
					//sToBin:=MySQL Get String Column ($rowset;"bin_id")
					//iToCode:=MySQL Get Integer Column ($rowset;"case_status_code")
					//ams_location:=MySQL Get String Column ($rowset;"ams_location")
					//sJobit:=MySQL Get String Column ($rowset;"jobit")
					
				Else   //allow a new skid tag to be introduced
					sToSkid:=$skid_number
					sToBin:="BNVFG_HOLD"
					iToCode:=100
					ams_location:="FG"
				End if 
				
				If ($case_id#sToSkid)
					tSQL:="update cases set `case_status_code` = "+String:C10(iToCode)+", `ams_location` = '"+ams_location+"', `bin_id` = '"+sToBin
					tSQL:=tSQL+"', `update_datetime`  = '"+modDateTime+"', `update_initials` = '"+<>zResp
					tSQL:=tSQL+"', `skid_number` = '"+sToSkid+"' "
					
				Else 
					rft_error_log:="Can't add to Supercase"
				End if 
				
			Else   //error
				rft_error_log:="Unknown SSCC#"
			End if 
			
			
		Else   //error -- destination needs to be a bin or skid
			rft_error_log:="Bin or Skid required"
	End case 
	
Else 
	rft_error_log:="Could not connect to WMS."
End if   //conn id


