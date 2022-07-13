//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_MySQL_deleteSelCases - Created v0.1.0-JJG (05/12/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

// moved from [WMS_SerializedShippingLabels].BinCheck_dio.delete

//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)  //only continue if connection to wms works
	$datetime:=TS_ISO_String_TimeStamp
	For ($i; 1; Size of array:C274(ListBox1))
		If (ListBox1{$i})  //selected
			If (rft_Response="BNV-99-99-9")
				$sql:="DELETE FROM `cases` WHERE `case_id` = '"+rft_Case{$i}+"'"
			Else 
				$sql:="UPDATE `cases` SET `bin_id` = 'BNV-99-99-9', `skid_number` = '', `case_status_code` = 400, "
				$sql:=$sql+"`from_bin_id` = '"+rft_Bin{$i}+"', `update_initials` = '"+<>zResp+"', `update_datetime` = '"+$datetime+"'"
				$sql:=$sql+" WHERE `case_id` = '"+rft_Case{$i}+"'"
			End if 
			//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
			//$result:=MySQL Execute ($conn_id;"";$stmt)
			//MySQL Delete SQL Statement ($stmt)
			If ($result=0)
				rft_Status{$i}:="NOT DELTED"
			Else 
				rft_Skid{$i}:="------------------"
				rft_Status{$i}:="DELETED"
				rft_Bin{$i}:="BNV-99-99-9"
			End if 
		End if 
	End for 
	
Else 
	uConfirm("Sorry, could not connect to WMS at this time."; "Try Later"; "Help")
End if 
//$conn_id:=DB_ConnectionManager ("Close")