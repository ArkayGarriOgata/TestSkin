//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wmss_ScanObjectMulti_4D_CaseGo - Created v0.1.0-JJG (05/06/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fGo)
C_TEXT:C284($1; $ttJobit)
$ttJobit:=$1
$fGo:=True:C214

Case of 
	: (rft_destination#"skid")
		
	: (sJobit="MIXED")
		
	: ($ttJobit=sJobit)
		
	Else 
		rft_error_log:="MIXED LOT "+$ttJobit+" not "+sJobit
		$fGo:=False:C215
		
End case 

$0:=$fGo


