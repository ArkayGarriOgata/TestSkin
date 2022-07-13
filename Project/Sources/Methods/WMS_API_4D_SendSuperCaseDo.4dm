//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_SendSuperCaseDo - Created v0.1.0-JJG (05/05/16)
// Modified by: Mel Bohince (4/9/18) line 42 -- this is causing a 2x qty when sending supercase with receipt turned on
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fSuccess; $fDoSkidNum)
C_TEXT:C284($1; $4; $6; $7; $10; $11; $12)
C_TEXT:C284($ttCaseID; $ttJobit; $ttAMSLocation; $ttBinID; $ttInits; $ttWarehouse; $ttSkidNum; $ttSQL)
C_DATE:C307($2; $8; $9; $dGlueDate; $dInsert; $dUpdate)
C_LONGINT:C283($3; $5; $xlQtyInCase; $xlCaseStatCode)
$fSuccess:=False:C215
$fDoSkidNum:=(Count parameters:C259>11)

$ttCaseID:=$1
$dGlueDate:=$2
$xlQtyInCase:=$3
$ttJobit:=$4
$xlCaseStatCode:=$5
$ttAMSLocation:=$6
$ttBinID:=$7
$dInsert:=$8
$dUpdate:=$9
$ttInits:=$10
$ttWarehouse:=$11

If ($fDoSkidNum)
	$ttSkidNum:=$12
End if 

WMS_API_4D_SendSuperCasePar($ttCaseID; $dGlueDate; $xlQtyInCase; $ttJobit; $xlCaseStatCode; $ttAMSLocation; $ttBinID; $dInsert; $dUpdate; $ttInits; $ttWarehouse)
If ($fDoSkidNum)
	SQL SET PARAMETER:C823($ttSkidNum; SQL param in:K49:1)
End if 

SQL EXECUTE:C820(WMS_API_4D_SendSuperCaseSQL($fDoSkidNum))
$fSuccess:=(OK=1)
SQL CANCEL LOAD:C824

$0:=$fSuccess

If ((cbMoveOS=1))  // Modified by: Mel Bohince (4/9/18) this is causing a 2x qty when sending supercase with receipt turned on
	//trick ams into processing transaction
	CREATE RECORD:C68([WMS_aMs_Exports:153])
	[WMS_aMs_Exports:153]id:1:=Sequence number:C244([WMS_aMs_Exports:153])*-1
	[WMS_aMs_Exports:153]TypeCode:2:=200
	[WMS_aMs_Exports:153]StateIndicator:3:="S"
	[WMS_aMs_Exports:153]TransDate:4:=4D_Current_date
	[WMS_aMs_Exports:153]TransTime:5:=String:C10(4d_Current_time; HH MM SS:K7:1)
	[WMS_aMs_Exports:153]ModWho:6:=<>zResp
	[WMS_aMs_Exports:153]Jobit:9:=$ttJobit
	[WMS_aMs_Exports:153]BinId:10:=$ttBinID
	[WMS_aMs_Exports:153]from_Bin_id:17:=fromLocation
	
	[WMS_aMs_Exports:153]ActualQty:11:=$xlQtyInCase
	
	[WMS_aMs_Exports:153]To_aMs_Location:12:=$ttAMSLocation
	[WMS_aMs_Exports:153]From_aMs_Location:13:="FG"
	[WMS_aMs_Exports:153]Skid_number:14:=$ttCaseID
	[WMS_aMs_Exports:153]case_id:15:=$ttCaseID  //rft_caseId
	[WMS_aMs_Exports:153]number_of_cases:16:=1
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