// ----------------------------------------------------
// Method: [WMS_SerializedShippingLabels].MoveMult_dio   ( ) ->
// By: Mel Bohince @ 04/06/16, 14:07:04
// Description
// 
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		WMS_API_LoginLookup  //make sure <>WMS variables are up to date. `v0.1.0-JJG (05/06/16) - added 
		wmss_initMoveMulti
		OBJECT SET ENABLED:C1123(*; "delete"; False:C215)
		
	: (Form event code:C388=On Data Change:K2:15)
		
		Case of 
			: (rft_response="DONE")  //A way to bail
				CANCEL:C270
				
			: (rft_response="MOVE")  //Make it happen
				wmss_MoveMulti_dio_Move  //v0.1.0-JJG (05/06/16) - modularized 
				If (False:C215)  //v0.1.0-JJG (05/06/16) - modularized above
					//$conn_id:=DB_ConnectionManager ("Open")
					//If ($conn_id>0)
					
					//For ($i;1;Size of array(ListBox1))
					//If (Position("SKIP";rft_Case{$i})=0)
					//If (Position("cases";rft_Case{$i})>0)
					//$sql:=tSQL+",`from_bin_id` = '"+rft_Bin{$i}+"' where `skid_number` = '"+rft_Skid{$i}+"'"
					//Else 
					//$sql:=tSQL+",`from_bin_id` = '"+rft_Bin{$i}+"' where `case_id` = '"+rft_Case{$i}+"'"
					//End if 
					//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
					//$result:=MySQL Execute ($conn_id;"";$stmt)
					//MySQL Delete SQL Statement ($stmt)
					//If ($result=0)
					//rft_Status{$i}:="FAILED"
					//Else 
					//rft_Status{$i}:="UPDATED"
					
					//  //trick ams into processing transaction
					//CREATE RECORD([WMS_aMs_Exports])
					//[WMS_aMs_Exports]id:=Sequence number([WMS_aMs_Exports])*-1
					//[WMS_aMs_Exports]TypeCode:=200
					//[WMS_aMs_Exports]StateIndicator:="S"
					//[WMS_aMs_Exports]TransDate:=4D_Current_date
					//[WMS_aMs_Exports]TransTime:=String(4d_Current_time;HH MM SS)
					//[WMS_aMs_Exports]ModWho:=<>zResp
					//[WMS_aMs_Exports]Jobit:=rft_jobit{$i}
					//[WMS_aMs_Exports]BinId:=sToBin
					//[WMS_aMs_Exports]from_Bin_id:=rft_Bin{$i}
					//If (Position("cases";rft_Case{$i})>0)
					//$posSpace:=Position(" ";rft_Case{$i})
					//[WMS_aMs_Exports]ActualQty:=Num(Substring(rft_Case{$i};1;$posSpace))
					//Else 
					//[WMS_aMs_Exports]ActualQty:=Num(WMS_CaseId (rft_Case{$i};"qty"))
					//End if 
					//[WMS_aMs_Exports]To_aMs_Location:=ams_location
					//[WMS_aMs_Exports]From_aMs_Location:=sFrom
					//[WMS_aMs_Exports]Skid_number:=sToSkid
					//[WMS_aMs_Exports]case_id:=rft_caseId
					//[WMS_aMs_Exports]number_of_cases:=$result
					
					//[WMS_aMs_Exports]PostDate:=4D_Current_date
					//[WMS_aMs_Exports]PostTime:=String(4d_Current_time;HH MM SS)
					//SAVE RECORD([WMS_aMs_Exports])
					//UNLOAD RECORD([WMS_aMs_Exports])  // Modified by: Mel Bohince (9/9/15) 
					//REDUCE SELECTION([WMS_aMs_Exports];0)
					
					//End if 
					//End if 
					//End for 
					
					//uConfirm ("Reset")
					//If (ok=1)
					//wmss_initMoveMulti 
					//End if 
					
					
					//Else 
					//rft_error_log:="Could not connect to WMS."
					//End if   //conn id
					//$conn_id:=DB_ConnectionManager ("Close")
				End if 
				
			: (rft_state="object")
				$success:=wmss_ScanObjectMulti
				
			: (rft_state="destination")
				$success:=wmss_ScanDestinationMulti
				
			Else 
				rft_error_log:="Reset"
				SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215)
				wmss_initMoveMulti
		End case 
		
		rft_Response:=""
		
End case 
