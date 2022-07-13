//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: MoveMulti_dio_Move_MySQL - Created v0.1.0-JJG (05/06/16)
//moved here from MoveMulti_dio - now called my MoveMulti_dio_Move
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)
	
	For ($i; 1; Size of array:C274(ListBox1))
		If (Position:C15("SKIP"; rft_Case{$i})=0)
			If (Position:C15("cases"; rft_Case{$i})>0)
				$sql:=tSQL+",`from_bin_id` = '"+rft_Bin{$i}+"' where `skid_number` = '"+rft_Skid{$i}+"'"
			Else 
				$sql:=tSQL+",`from_bin_id` = '"+rft_Bin{$i}+"' where `case_id` = '"+rft_Case{$i}+"'"
			End if 
			//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
			//$result:=MySQL Execute ($conn_id;"";$stmt)
			//MySQL Delete SQL Statement ($stmt)
			If ($result=0)
				rft_Status{$i}:="FAILED"
			Else 
				rft_Status{$i}:="UPDATED"
				
				//trick ams into processing transaction
				CREATE RECORD:C68([WMS_aMs_Exports:153])
				[WMS_aMs_Exports:153]id:1:=Sequence number:C244([WMS_aMs_Exports:153])*-1
				[WMS_aMs_Exports:153]TypeCode:2:=200
				[WMS_aMs_Exports:153]StateIndicator:3:="S"
				[WMS_aMs_Exports:153]TransDate:4:=4D_Current_date
				[WMS_aMs_Exports:153]TransTime:5:=String:C10(4d_Current_time; HH MM SS:K7:1)
				[WMS_aMs_Exports:153]ModWho:6:=<>zResp
				[WMS_aMs_Exports:153]Jobit:9:=rft_jobit{$i}
				[WMS_aMs_Exports:153]BinId:10:=sToBin
				[WMS_aMs_Exports:153]from_Bin_id:17:=rft_Bin{$i}
				If (Position:C15("cases"; rft_Case{$i})>0)
					$posSpace:=Position:C15(" "; rft_Case{$i})
					[WMS_aMs_Exports:153]ActualQty:11:=Num:C11(Substring:C12(rft_Case{$i}; 1; $posSpace))
				Else 
					[WMS_aMs_Exports:153]ActualQty:11:=Num:C11(WMS_CaseId(rft_Case{$i}; "qty"))
				End if 
				[WMS_aMs_Exports:153]To_aMs_Location:12:=ams_location
				[WMS_aMs_Exports:153]From_aMs_Location:13:=sFrom
				[WMS_aMs_Exports:153]Skid_number:14:=rft_Skid{$i}  //sToSkid
				[WMS_aMs_Exports:153]case_id:15:=rft_Case{$i}  //rft_caseId
				[WMS_aMs_Exports:153]number_of_cases:16:=$result
				
				[WMS_aMs_Exports:153]PostDate:18:=4D_Current_date
				[WMS_aMs_Exports:153]PostTime:19:=String:C10(4d_Current_time; HH MM SS:K7:1)
				SAVE RECORD:C53([WMS_aMs_Exports:153])
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
					
					UNLOAD RECORD:C212([WMS_aMs_Exports:153])  // Modified by: Mel Bohince (9/9/15) 
					REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
					
				Else 
					
					REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
					
				End if   // END 4D Professional Services : January 2019 
				
			End if 
		End if 
	End for 
	
	uConfirm("Reset")
	If (ok=1)
		wmss_initMoveMulti
	End if 
	
	
Else 
	rft_error_log:="Could not connect to WMS."
	BEEP:C151
	ALERT:C41(rft_error_log)
End if   //conn id
//$conn_id:=DB_ConnectionManager ("Close")