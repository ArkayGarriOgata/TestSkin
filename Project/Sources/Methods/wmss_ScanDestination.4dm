//%attributes = {}

// Method: wmss_ScanDestination ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/23/15, 15:47:27
// ----------------------------------------------------
// Description
// 
//
// may need to split from skid
// ----------------------------------------------------
// Modified by: Mel Bohince (12/10/15) chg BNR to BN, chg the sql depending on whether moving to skid or bin

C_BOOLEAN:C305($0)
$0:=False:C215

//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)
	$update_datetime:=4D_Current_date
	
	Case of 
		: (Length:C16(rft_Response)=20) & (rft_object="case") & (Substring:C12(rft_Response; 1; 2)#"BN")  //SKID, not valid if object is a skid
			rft_destination:="skid"
			sToSkid:=rft_Response
			//case will need to take on the attributes of the skid
			$sql:="SELECT `bin_id`, `case_status_code`, `ams_location`, `jobit` FROM `cases` WHERE `skid_number` = '"+sToSkid+"'"
			//$rowSet:=MySQL Select ($conn_id;$sql)
			//$rowCount:=MySQL Get Row Count ($rowSet)
			If ($rowCount>0)  //get it's attributes
				//$bin_id:=MySQL Get String Column ($rowset;"bin_id")
				//$code:=MySQL Get Integer Column ($rowset;"case_status_code")
				//$ams_loc:=MySQL Get String Column ($rowset;"ams_location")
				//$jobit:=MySQL Get String Column ($rowset;"jobit")
				
			Else   //allow a new skid tag to be introduced
				$bin_id:="BNVFG_A"
				$code:=100
				$ams_loc:="FG"
				$jobit:="N/A"
				// 
				//rft_error_log:="Skid not found"
				//rft_destination:=""
				//$updateClause:=""
			End if 
			
			//If (rft_object="case")
			If ($jobit=sJobit) | ($jobit="N/A")
				$updateClause:="UPDATE `cases` SET `update_datetime` = ?, `update_initials` = ?, `bin_id` = ?, `skid_number` = ?, `case_status_code` = ?, `ams_location` = ?"
				sToBin:=$bin_id
				sToSkid:=rft_Response
				iToCode:=$code
				ams_location:=$ams_loc
				
				$sql:=$updateClause+tText
				
				//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
				//MySQL Set DateTime In SQL ($stmt;1;$update_datetime;Current time)  //updatedatetime
				//MySQL Set String In SQL ($stmt;2;<>zResp)  //user
				//MySQL Set String In SQL ($stmt;3;sToBin)  //bin id
				//MySQL Set String In SQL ($stmt;4;sToSkid)  //skid num
				//MySQL Set Integer In SQL ($stmt;5;iToCode)  //case status code
				//MySQL Set String In SQL ($stmt;6;ams_location)  //amslocation
				
			Else 
				rft_destination:=""
				rft_error_log:="Can't mix jobits"
				$updateClause:=""
			End if 
			
			//Else   //skid cant go to skid
			//rft_destination:=""
			//rft_error_log:="Can only move cases to skid"
			//$updateClause:=""
			//End if 
			
		: (Substring:C12(rft_Response; 1; 2)="BN")  //BIN// Modified by: Mel Bohince (12/10/15) chg BNR to BN
			$sql:="SELECT `bin_id`  FROM `bins` where `bin_id` = '"+rft_Response+"'"
			//$row_set:=MySQL Select ($conn_id;$sql)
			//$row_count:=MySQL Get Row Count ($row_set)
			If ($row_count>0)
				rft_destination:="bin"
				rft_Response:=Uppercase:C13(rft_Response)
				sToBin:=rft_Response
				//If (rft_object="case")// Modified by: Mel Bohince (12/10/15) not going to update skid
				//sToSkid:="NULL"
				//End if 
				
				Case of 
					: (Position:C15("CC"; sToBin)>0)
						iToCode:=1
						ams_location:="CC"
						
					: (Position:C15("SHIP"; sToBin)>0)
						iToCode:=300
						ams_location:="FG"
						
					: (Position:C15("FG"; sToBin)>0)
						iToCode:=100
						ams_location:="FG"
						
					: (Position:C15("XC"; sToBin)>0)
						iToCode:=350
						ams_location:="XC"
						
					: (Position:C15("SC"; sToBin)>0)
						iToCode:=400
						ams_location:="SC"
						
					Else   //assume rack location like BNV-01-01-1
						iToCode:=100
						ams_location:="FG"
				End case 
				//$updateClause:="UPDATE `cases` SET `update_datetime` = ?, `update_initials` = ?, `bin_id` = ?, `skid_number` = ?, `case_status_code` = ?, `ams_location` = ?"
				$updateClause:="UPDATE `cases` SET `update_datetime` = ?, `update_initials` = ?, `bin_id` = ?, `case_status_code` = ?, `ams_location` = ?"
				
				$sql:=$updateClause+tText
				
				//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
				//MySQL Set DateTime In SQL ($stmt;1;$update_datetime;Current time)  //updatedatetime
				//MySQL Set String In SQL ($stmt;2;<>zResp)  //user
				//MySQL Set String In SQL ($stmt;3;sToBin)  //bin id
				//MySQL Set Integer In SQL ($stmt;4;iToCode)  //case status code
				//MySQL Set String In SQL ($stmt;5;ams_location)  //amslocation
				
			Else 
				$updateClause:=""
				wmss_initMove
				rft_error_log:=rft_Response+" not valid bin"
				SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215)
			End if   //row count
			
		Else   //not a valid move
			$updateClause:=""
			wmss_initMove
			If (rft_object#"case")
				rft_error_log:="Must move to bin"
			Else 
				rft_error_log:="Must move to bin or skid"
			End if 
	End case 
	
	If (Length:C16($updateClause)>5)  //add the where clause and execute
		
		
		// Modified by: Mel Bohince (12/10/15) chg depending on moving a to a skid or a bin, see above
		//$sql:=$updateClause+tText
		//$stmt:=MySQL New SQL Statement ($conn_id;$sql)
		//MySQL Set DateTime In SQL ($stmt;1;$update_datetime;Current time)  //updatedatetime
		//MySQL Set String In SQL ($stmt;2;<>zResp)  //user
		//MySQL Set String In SQL ($stmt;3;sToBin)  //bin id
		//MySQL Set String In SQL ($stmt;4;sToSkid)  //skid num
		//MySQL Set Integer In SQL ($stmt;5;iToCode)  //case status code
		//MySQL Set String In SQL ($stmt;6;ams_location)  //amslocation
		
		//$result:=MySQL Execute ($conn_id;"";$stmt)
		//MySQL Delete SQL Statement ($stmt)
		
		If ($result>0)
			$0:=True:C214
			zwStatusMsg("MOVE"; $sql+"with bin="+sToBin+", skid="+sToSkid)
			
			//trick ams into processing transaction
			CREATE RECORD:C68([WMS_aMs_Exports:153])
			[WMS_aMs_Exports:153]id:1:=Sequence number:C244([WMS_aMs_Exports:153])*-1
			[WMS_aMs_Exports:153]TypeCode:2:=200
			[WMS_aMs_Exports:153]StateIndicator:3:="S"
			[WMS_aMs_Exports:153]TransDate:4:=$update_datetime
			[WMS_aMs_Exports:153]TransTime:5:=String:C10(4d_Current_time; HH MM SS:K7:1)
			[WMS_aMs_Exports:153]ModWho:6:=<>zResp
			[WMS_aMs_Exports:153]Jobit:9:=sJobit
			[WMS_aMs_Exports:153]BinId:10:=sToBin
			[WMS_aMs_Exports:153]from_Bin_id:17:=sFrom
			[WMS_aMs_Exports:153]ActualQty:11:=iQty
			[WMS_aMs_Exports:153]To_aMs_Location:12:=ams_location
			[WMS_aMs_Exports:153]From_aMs_Location:13:=sFrom
			[WMS_aMs_Exports:153]Skid_number:14:=sToSkid
			[WMS_aMs_Exports:153]case_id:15:=rft_caseId
			[WMS_aMs_Exports:153]number_of_cases:16:=$result
			
			[WMS_aMs_Exports:153]PostDate:18:=$update_datetime
			[WMS_aMs_Exports:153]PostTime:19:=String:C10(4d_Current_time; HH MM SS:K7:1)
			SAVE RECORD:C53([WMS_aMs_Exports:153])
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				UNLOAD RECORD:C212([WMS_aMs_Exports:153])  // Modified by: Mel Bohince (9/9/15) 
				REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
				
			Else 
				
				REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
				
			End if   // END 4D Professional Services : January 2019 
			
			
			wmss_initMove
			rft_error_log:=String:C10($result)+" cases moved"
			
		Else 
			wmss_initMove
			rft_error_log:=String:C10(<>WMS_ERROR)+" Move failed"
		End if 
		//$conn_id:=DB_ConnectionManager ("Close")
		
	End if   //Length($updateClause)>5
	
Else 
	wmss_initMove
	rft_error_log:="Could not connect to WMS."
End if   //conn id


If (Length:C16(rft_error_log)>0)
	SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215; Black:K11:16; Yellow:K11:2)
	BEEP:C151
	
Else 
	SetObjectProperties(""; ->rft_error_log; False:C215)
End if 