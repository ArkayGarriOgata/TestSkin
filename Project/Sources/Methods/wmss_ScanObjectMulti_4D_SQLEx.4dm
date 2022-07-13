//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wmss_ScanObjectMulti_4D_SQLEx - Created v0.1.0-JJG (05/06/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fSQLSuccess)
C_TEXT:C284($1; $ttSQL)
C_POINTER:C301($2; $3; $4; $5; $6; $psttCaseID; $psttSkidNumber; $psxlCaseStatusCode; $psttBinID; $psttJobit)
ARRAY TEXT:C222($sttCaseID; 0)
ARRAY TEXT:C222($sttSkidNumber; 0)
ARRAY TEXT:C222($sttBinID; 0)
ARRAY TEXT:C222($sttJobit; 0)
ARRAY LONGINT:C221($sxlCaseStatusCode; 0)
$ttSQL:=$1
$psttCaseID:=$2
$psttSkidNumber:=$3
$psxlCaseStatusCode:=$4
$psttBinID:=$5
$psttJobit:=$6
$fSQLSuccess:=False:C215

SQL SET PARAMETER:C823(rft_Response; SQL param in:K49:1)
SQL EXECUTE:C820($ttSQL; $sttCaseID; $sttSkidNumber; $sxlCaseStatusCode; $sttBinID; $sttJobit)
If (OK=1)
	If (Not:C34(SQL End selection:C821))
		SQL LOAD RECORD:C822(SQL all records:K49:10)
		$fSQLSuccess:=True:C214
	End if 
	SQL CANCEL LOAD:C824
	
End if 

COPY ARRAY:C226($sttCaseID; $psttCaseID->)
COPY ARRAY:C226($sttSkidNumber; $psttSkidNumber->)
COPY ARRAY:C226($sttBinID; $psttBinID->)
COPY ARRAY:C226($sttJobit; $psttJobit->)
COPY ARRAY:C226($sxlCaseStatusCode; $psxlCaseStatusCode->)

$0:=$fSQLSuccess