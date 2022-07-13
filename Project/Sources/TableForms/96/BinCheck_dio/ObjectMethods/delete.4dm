// Method: [WMS_SerializedShippingLabels].BinCheck_dio.delete
// Modified by: Mel Bohince (12/9/15) tidy up the enable on the bDelete
// Modified by: Mel Bohince (3/29/16) do a move to 99-99-9 instead of deleting, so can restore if needed
//                                    if lookup was on 99-99-9 then do the delete

uConfirm("Are you sure you want to delete the selected cases?"; "Remove"; "Keep")
If (ok=1)
	wms_api_deleteSelCases  //v0.1.0-JJG (05/12/16) - added for 4D vs MySQL
	If (False:C215)  //v0.1.0-JJG (05/12/16) - modularized above
		//$conn_id:=DB_ConnectionManager ("Open")
		//If ($conn_id>0)  //only continue if connection to wms works
		//$datetime:=TS2iso 
		//For ($i;1;Size of array(ListBox1))
		//If (ListBox1{$i})  //selected
		//If (rft_Response="BNV-99-99-9")
		//$sql:="DELETE FROM `cases` WHERE `case_id` = '"+rft_Case{$i}+"'"
		//Else 
		//$sql:="UPDATE `cases` SET `bin_id` = 'BNV-99-99-9', `skid_number` = '', `case_status_code` = 400, "
		//$sql:=$sql+"`from_bin_id` = '"+rft_Bin{$i}+"', `update_initials` = '"+<>zResp+"', `update_datetime` = '"+$datetime+"'"
		//$sql:=$sql+" WHERE `case_id` = '"+rft_Case{$i}+"'"
		//End if 
		//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
		//$result:=MySQL Execute ($conn_id;"";$stmt)
		//MySQL Delete SQL Statement ($stmt)
		//If ($result=0)
		//rft_Status{$i}:="NOT DELTED"
		//Else 
		//rft_Skid{$i}:="------------------"
		//rft_Status{$i}:="DELETED"
		//rft_Bin{$i}:="BNV-99-99-9"
		//End if 
		//End if 
		//End for 
		
		//Else 
		//uConfirm ("Sorry, could not connect to WMS at this time.";"Try Later";"Help")
		//End if 
		//$conn_id:=DB_ConnectionManager ("Close")
	End if   //v0.1.0-JJG (05/12/16) - end of commented block
End if 

OBJECT SET ENABLED:C1123(*; "delete"; False:C215)
