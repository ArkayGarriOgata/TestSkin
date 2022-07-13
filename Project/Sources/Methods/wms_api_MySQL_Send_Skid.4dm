//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_MySQL_Send_Skid - Created v0.1.0-JJG (05/05/16)
//moved here from wms_api_send_skid
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 


// Method: wms_api_Send_Skid (->array of case ids; skidnumber )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/05/15, 12:16:33
// ----------------------------------------------------
// Description
// insert cases into the wms database
//
// ----------------------------------------------------
C_BOOLEAN:C305($0)

$insert_datetime:=4D_Current_date
$update_datetime:=4D_Current_date
$time:=String:C10(4d_Current_time; HH MM SS:K7:1)
$ptrManifest:=$1
$skid_number:=$2
$scannedQty:=$3
$scannedCases:=$4

$case_status_code:=1
wms_bin_id:="BNRCC"
$warehouse:=Substring:C12(wms_bin_id; 3; 1)
$ams_location:=Substring:C12(wms_bin_id; 4)

$success:=wms_api_Send_Super_Case("init")
//$connId:=DB_ConnectionManager ("connection")
If ($connId>0)
	
	$sqlPrefix:="select case_id, bin_id, skid_number from cases where case_id = '"
	$errors:=""
	$numberOfCases:=Size of array:C274($ptrManifest->)
	For ($case; 1; $numberOfCases)  // insert cases into wms
		If (Length:C16($ptrManifest->{$case})>0)
			$case_id:=$ptrManifest->{$case}
			$sql:=$sqlPrefix+$case_id+"'"
			//$rowSet:=MySQL Select ($connId;$sql)
			//$rowCount:=MySQL Get Row Count ($rowSet)
			If ($rowCount>0)
				//$bin_id:=MySQL Get String Column ($rowset;"bin_id")
				//$skid_id:=MySQL Get String Column ($rowset;"skid_number")
				$errors:=$errors+$case_id+" is already saved in WMS in bin "+$bin_id+" on skid "+$skid_id+Char:C90(13)+Char:C90(13)
			End if 
		End if 
	End for 
	
	If (Length:C16($errors)=0)
		$numberOfCases:=Size of array:C274($ptrManifest->)
		For ($case; 1; $numberOfCases)  // insert cases into wms
			If (Length:C16($ptrManifest->{$case})>0)
				$case_id:=$ptrManifest->{$case}
				$case_qty:=Num:C11(WMS_CaseId($case_id; "qty"))
				$jobit_stripped:=Substring:C12($case_id; 1; 9)
				$success:=wms_api_Send_Super_Case("insert"; $case_id; $insert_datetime; $case_qty; $jobit_stripped; $case_status_code; $ams_location; wms_bin_id; $insert_datetime; $update_datetime; <>zResp; $warehouse; $skid_number)
			End if 
		End for 
		
		//trick ams into processing transaction
		CREATE RECORD:C68([WMS_aMs_Exports:153])
		[WMS_aMs_Exports:153]id:1:=Sequence number:C244([WMS_aMs_Exports:153])
		[WMS_aMs_Exports:153]TypeCode:2:=100
		[WMS_aMs_Exports:153]StateIndicator:3:="S"
		[WMS_aMs_Exports:153]TransDate:4:=$insert_datetime
		[WMS_aMs_Exports:153]TransTime:5:=$time
		[WMS_aMs_Exports:153]ModWho:6:=<>zResp
		[WMS_aMs_Exports:153]Jobit:9:=$jobit_stripped
		[WMS_aMs_Exports:153]BinId:10:=wms_bin_id
		[WMS_aMs_Exports:153]from_Bin_id:17:="WIP"
		[WMS_aMs_Exports:153]ActualQty:11:=$scannedQty
		[WMS_aMs_Exports:153]To_aMs_Location:12:="CC"
		[WMS_aMs_Exports:153]From_aMs_Location:13:="WIP"
		[WMS_aMs_Exports:153]Skid_number:14:=$skid_number
		[WMS_aMs_Exports:153]case_id:15:=""
		[WMS_aMs_Exports:153]number_of_cases:16:=$scannedCases
		[WMS_aMs_Exports:153]PostDate:18:=$insert_datetime
		[WMS_aMs_Exports:153]PostTime:19:=$time
		SAVE RECORD:C53([WMS_aMs_Exports:153])
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			UNLOAD RECORD:C212([WMS_aMs_Exports:153])  // Modified by: Mel Bohince (9/9/15) 
			REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
			
			
		Else 
			
			REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
			
		End if   // END 4D Professional Services : January 2019 
		$0:=True:C214
		
	Else 
		utl_LogIt("init")
		utl_LogIt(" === ")
		utl_LogIt(" PALLET NOT SAVED, PROBLEMS:  ")
		utl_LogIt(" === ")
		utl_LogIt($errors)
		utl_LogIt("show")
		$0:=False:C215
		
	End if 
	
Else 
	$errors:="Connection to WMS lost"
	utl_LogIt("init")
	utl_LogIt(" === ")
	utl_LogIt(" PALLET NOT SAVED, PROBLEMS:  ")
	utl_LogIt(" === ")
	utl_LogIt($errors)
	utl_LogIt("show")
	$0:=False:C215
End if   //$connId

$success:=wms_api_Send_Super_Case("kill")