//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_SendSkid - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fSuccess)
C_POINTER:C301($1; $pstxManifest)
C_TEXT:C284($2; $ttSkidNumber; $ttSQL; $ttCaseID; $ttError)
C_LONGINT:C283($3; $4; $xlScannedQty; $xlScannedCases; $i; $xlNumCases)
$pstxManifest:=$1
$ttSkidNumber:=$2
$xlScannedQty:=$3
$xlScannedCases:=$4
$fSuccess:=False:C215
$ttError:=""

If (WMS_API_4D_SendSuperCase("init"))
	
	If (WMS_API_4D_SendSkidCheck($pstxManifest; ->$ttError))
		
		WMS_API_4D_SendSkidDo($pstxManifest; $ttSkidNumber; $xlScannedQty; $xlScannedCases)
		
		$fSuccess:=True:C214
	End if 
	
	WMS_API_4D_DoLogout
Else 
	$ttError:="Connection to WMS lost"
	
End if 

WMS_API_4D_SendSkidErrorLog($fSuccess; $ttError)

$0:=$fSuccess