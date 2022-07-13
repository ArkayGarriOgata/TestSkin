//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_SendSkidDo - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($fSuccess)
C_POINTER:C301($1; $pstxManifest)
C_TEXT:C284($2; $ttSkidNumber; $ttCaseID; $ttJobitStripped; $ttWarehouse; $ttAMSLocation)
C_LONGINT:C283($3; $4; $xlScannedQty; $xlScannedCases; $i; $xlNumCases; $xlCaseQty; $xlCaseStatusCode)
C_DATE:C307($dInsert)
$pstxManifest:=$1
$ttSkidNumber:=$2
$xlScannedQty:=$3
$xlScannedCases:=$4

$xlCaseStatusCode:=1
wms_bin_id:="BNRCC"
$ttWarehouse:=Substring:C12(wms_bin_id; 3; 1)
$ttAMSLocation:=Substring:C12(wms_bin_id; 4)
$dInsert:=4D_Current_date

$xlNumCases:=Size of array:C274($pstxManifest->)
For ($i; 1; $xlNumCases)
	$ttCaseID:=$pstxManifest->{$i}
	$xlCaseQty:=Num:C11(WMS_CaseId($ttCaseID; "qty"))
	$ttJobitStripped:=Substring:C12($ttCaseID; 1; 9)
	$fSuccess:=WMS_API_4D_SendSuperCase("insert"; $ttCaseID; $dInsert; $xlCaseQty; $ttJobitStripped; $xlCaseStatusCode; $ttAMSLocation; wms_bin_id; $dInsert; $dInsert; <>zResp; $ttWarehouse; $ttSkidNumber)
End for 

//trick ams into processing transaction
WMS_API_4D_SendSkidAMSProc($ttJobitStripped; $ttSkidNumber; $xlScannedQty; $xlScannedCases; $dInsert)