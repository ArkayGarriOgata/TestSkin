//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wmss_ScanObjectMulti_4D_Skid - Created v0.1.0-JJG (05/06/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 
C_BOOLEAN:C305($0; $fSuccess)
C_TEXT:C284($1; $ttSQL; $ttQty)
C_LONGINT:C283($i; $xlNumRows; $xlSkidQty)
ARRAY TEXT:C222($sttCaseID; 0)
ARRAY TEXT:C222($sttSkidNumber; 0)
ARRAY TEXT:C222($sttBinID; 0)
ARRAY TEXT:C222($sttJobit; 0)
ARRAY LONGINT:C221($sxlCaseStatusCode; 0)
$ttSQL:=$1
$fSuccess:=False:C215

If (wmss_ScanObjectMulti_4D_SQLEx($ttSQL; ->$sttCaseID; ->$sttSkidNumber; ->$sxlCaseStatusCode; ->$sttBinID; ->$sttJobit) & (Size of array:C274($sttCaseID)>0))
	APPEND TO ARRAY:C911(ListBox1; False:C215)
	APPEND TO ARRAY:C911(rft_Skid; $sttSkidNumber{1})
	APPEND TO ARRAY:C911(rft_Bin; $sttBinID{1})
	APPEND TO ARRAY:C911(rft_jobit; $sttJobit{1})
	APPEND TO ARRAY:C911(rft_Status; wmss_CaseState($sxlCaseStatusCode{1}))
	
	$xlSkidQty:=0
	$xlNumRows:=Size of array:C274($sttCaseID)
	For ($i; 1; $xlNumRows)
		$xlSkidQty:=$xlSkidQty+Num:C11(WMS_CaseId($sttCaseID{$i}; "qty"))
	End for 
	
	iQty:=iQty+$xlSkidQty
	$ttQty:=txt_Pad(String:C10($xlSkidQty); " "; 3; 14)
	APPEND TO ARRAY:C911(rft_Case; $ttQty+String:C10($xlNumRows)+" cases")
	
	$fSuccess:=True:C214
Else 
	rft_error_log:="No cases found."
	
End if 

$0:=$fSuccess

