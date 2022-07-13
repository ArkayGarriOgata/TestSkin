//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_SendSkidAMSProc - Created v0.1.0-JJG (05/05/16)
//trick ams into processing transaction
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($1; $2; $ttJobitStripped; $ttSkidNumber; $ttTime)
C_LONGINT:C283($3; $4; $xlScannedQty; $xlScannedCases)
C_DATE:C307($5; $dInsert)
$ttJobitStripped:=$1
$ttSkidNumber:=$2
$xlScannedQty:=$3
$xlScannedCases:=$4
$dInsert:=$5
$ttTime:=String:C10(4d_Current_time; HH MM SS:K7:1)

CREATE RECORD:C68([WMS_aMs_Exports:153])
[WMS_aMs_Exports:153]id:1:=Sequence number:C244([WMS_aMs_Exports:153])
[WMS_aMs_Exports:153]TypeCode:2:=100
[WMS_aMs_Exports:153]StateIndicator:3:="S"
[WMS_aMs_Exports:153]TransDate:4:=$dInsert
[WMS_aMs_Exports:153]TransTime:5:=$ttTime
[WMS_aMs_Exports:153]ModWho:6:=<>zResp
[WMS_aMs_Exports:153]Jobit:9:=$ttJobitStripped
[WMS_aMs_Exports:153]BinId:10:=wms_bin_id
[WMS_aMs_Exports:153]from_Bin_id:17:="WIP"
[WMS_aMs_Exports:153]ActualQty:11:=$xlScannedQty
[WMS_aMs_Exports:153]To_aMs_Location:12:="CC"
[WMS_aMs_Exports:153]From_aMs_Location:13:="WIP"
[WMS_aMs_Exports:153]Skid_number:14:=$ttSkidNumber
[WMS_aMs_Exports:153]case_id:15:=""
[WMS_aMs_Exports:153]number_of_cases:16:=$xlScannedCases
[WMS_aMs_Exports:153]PostDate:18:=$dInsert
[WMS_aMs_Exports:153]PostTime:19:=$ttTime
SAVE RECORD:C53([WMS_aMs_Exports:153])
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	UNLOAD RECORD:C212([WMS_aMs_Exports:153])
	REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
	
Else 
	
	REDUCE SELECTION:C351([WMS_aMs_Exports:153]; 0)
	
End if   // END 4D Professional Services : January 2019 
