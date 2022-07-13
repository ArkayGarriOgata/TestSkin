//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wmss_ScanObjectMulti_4D_Case - Created v0.1.0-JJG (05/06/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fSuccess)
C_TEXT:C284($1; $ttSQL; $ttStatus)
C_LONGINT:C283($i; $xlNumRows)
ARRAY TEXT:C222($sttCaseID; 0)
ARRAY TEXT:C222($sttSkidNumber; 0)
ARRAY TEXT:C222($sttBinID; 0)
ARRAY TEXT:C222($sttJobit; 0)
ARRAY LONGINT:C221($sxlCaseStatusCode; 0)
$ttSQL:=$1
$fSuccess:=False:C215

If (wmss_ScanObjectMulti_4D_SQLEx($ttSQL; ->$sttCaseID; ->$sttSkidNumber; ->$sxlCaseStatusCode; ->$sttBinID; ->$sttJobit) & (Size of array:C274($sttCaseID)>0))
	If (wmss_ScanObjectMulti_4D_CaseGo($sttJobit{1}))
		$xlNumRows:=Size of array:C274($sttCaseID)
		For ($i; 1; $xlNumRows)
			$ttStatus:=wmss_CaseState($sxlCaseStatusCode{$i})
			iQty:=iQty+Num:C11(WMS_CaseId($sttCaseID{$i}; "qty"))
			
			APPEND TO ARRAY:C911(ListBox1; False:C215)
			APPEND TO ARRAY:C911(rft_Case; $sttCaseID{$i})
			APPEND TO ARRAY:C911(rft_Skid; $sttSkidNumber{$i})
			APPEND TO ARRAY:C911(rft_Bin; $sttBinID{$i})
			APPEND TO ARRAY:C911(rft_jobit; $sttJobit{$i})
			APPEND TO ARRAY:C911(rft_Status; $ttStatus)
		End for 
		$fSuccess:=True:C214
		
	End if 
	
Else 
	rft_error_log:="No cases found."
End if 

$0:=$fSuccess