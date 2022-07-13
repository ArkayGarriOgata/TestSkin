//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_Send_Skid - Created v0.1.0-JJG (05/05/16)
//re-written to account for 4D vs MySQL WMS
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fSuccess)
C_POINTER:C301($1; $pstxManifest)
C_TEXT:C284($2; $ttSkidNumber)
C_LONGINT:C283($3; $4; $xlScannedQty; $xlScannedCases)
$pstxManifest:=$1
$ttSkidNumber:=$2
$xlScannedQty:=$3
$xlScannedCases:=$4
$fSuccess:=False:C215

WMS_API_LoginLookup  //make sure <>WMS variables are up to date.

If (<>fWMS_Use4D)
	$fSuccess:=WMS_API_4D_SendSkid($pstxManifest; $ttSkidNumber; $xlScannedQty; $xlScannedCases)
	
Else 
	$fSuccess:=wms_api_MySQL_Send_Skid($pstxManifest; $ttSkidNumber; $xlScannedQty; $xlScannedCases)
	
End if 

$0:=$fSuccess


If (False:C215)  //v0.1.0-JJG (05/05/16) - original code moved to wms_api_MySQL_Send_Skid
	//  // Method: wms_api_Send_Skid (->array of case ids; skidnumber )  -> 
	//  // ----------------------------------------------------
	//  // Author: Mel Bohince
	//  // Created: 02/05/15, 12:16:33
	//  // ----------------------------------------------------
	//  // Description
	//  // insert cases into the wms database
	//  //
	//  // ----------------------------------------------------
	//C_BOOLEAN($0)
	
	//$insert_datetime:=4D_Current_date
	//$update_datetime:=4D_Current_date
	//$time:=String(4d_Current_time;HH MM SS)
	//$ptrManifest:=$1
	//$skid_number:=$2
	//$scannedQty:=$3
	//$scannedCases:=$4
	
	//$case_status_code:=1
	//wms_bin_id:="BNRCC"
	//$warehouse:=Substring(wms_bin_id;3;1)
	//$ams_location:=Substring(wms_bin_id;4)
	
	//$success:=wms_api_Send_Super_Case ("init")
	//$connId:=DB_ConnectionManager ("connection")
	//If ($connId>0)
	
	//$sqlPrefix:="select case_id, bin_id, skid_number from cases where case_id = '"
	//$errors:=""
	//$numberOfCases:=Size of array($ptrManifest->)
	//For ($case;1;$numberOfCases)  // insert cases into wms
	//If (Length($ptrManifest->{$case})>0)
	//$case_id:=$ptrManifest->{$case}
	//$sql:=$sqlPrefix+$case_id+"'"
	//$rowSet:=MySQL Select ($connId;$sql)
	//$rowCount:=MySQL Get Row Count ($rowSet)
	//If ($rowCount>0)
	//$bin_id:=MySQL Get String Column ($rowset;"bin_id")
	//$skid_id:=MySQL Get String Column ($rowset;"skid_number")
	//$errors:=$errors+$case_id+" is already saved in WMS in bin "+$bin_id+" on skid "+$skid_id+Char(13)+Char(13)
	//End if 
	//End if 
	//End for 
	
	//If (Length($errors)=0)
	//$numberOfCases:=Size of array($ptrManifest->)
	//For ($case;1;$numberOfCases)  // insert cases into wms
	//If (Length($ptrManifest->{$case})>0)
	//$case_id:=$ptrManifest->{$case}
	//$case_qty:=Num(WMS_CaseId ($case_id;"qty"))
	//$jobit_stripped:=Substring($case_id;1;9)
	//$success:=wms_api_Send_Super_Case ("insert";$case_id;$insert_datetime;$case_qty;$jobit_stripped;$case_status_code;$ams_location;wms_bin_id;$insert_datetime;$update_datetime;<>zResp;$warehouse;$skid_number)
	//End if 
	//End for 
	
	//  //trick ams into processing transaction
	//CREATE RECORD([WMS_aMs_Exports])
	//[WMS_aMs_Exports]id:=Sequence number([WMS_aMs_Exports])
	//[WMS_aMs_Exports]TypeCode:=100
	//[WMS_aMs_Exports]StateIndicator:="S"
	//[WMS_aMs_Exports]TransDate:=$insert_datetime
	//[WMS_aMs_Exports]TransTime:=$time
	//[WMS_aMs_Exports]ModWho:=<>zResp
	//[WMS_aMs_Exports]Jobit:=$jobit_stripped
	//[WMS_aMs_Exports]BinId:=wms_bin_id
	//[WMS_aMs_Exports]from_Bin_id:="WIP"
	//[WMS_aMs_Exports]ActualQty:=$scannedQty
	//[WMS_aMs_Exports]To_aMs_Location:="CC"
	//[WMS_aMs_Exports]From_aMs_Location:="WIP"
	//[WMS_aMs_Exports]Skid_number:=$skid_number
	//[WMS_aMs_Exports]case_id:=""
	//[WMS_aMs_Exports]number_of_cases:=$scannedCases
	//[WMS_aMs_Exports]PostDate:=$insert_datetime
	//[WMS_aMs_Exports]PostTime:=$time
	//SAVE RECORD([WMS_aMs_Exports])
	//UNLOAD RECORD([WMS_aMs_Exports])  // Modified by: Mel Bohince (9/9/15) 
	//REDUCE SELECTION([WMS_aMs_Exports];0)
	//$0:=True
	
	//Else 
	//utl_LogIt ("init")
	//utl_LogIt (" === ")
	//utl_LogIt (" PALLET NOT SAVED, PROBLEMS:  ")
	//utl_LogIt (" === ")
	//utl_LogIt ($errors)
	//utl_LogIt ("show")
	//$0:=False
	
	//End if 
	
	//Else 
	//$errors:="Connection to WMS lost"
	//utl_LogIt ("init")
	//utl_LogIt (" === ")
	//utl_LogIt (" PALLET NOT SAVED, PROBLEMS:  ")
	//utl_LogIt (" === ")
	//utl_LogIt ($errors)
	//utl_LogIt ("show")
	//$0:=False
	//End if   //$connId
	
	//$success:=wms_api_Send_Super_Case ("kill")
End if 