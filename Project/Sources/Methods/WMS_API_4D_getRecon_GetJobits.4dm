//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getRecon_GetJobits - Created v0.1.0-JJG (05/18/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $xlNumJobits)
C_POINTER:C301($1; $psttCaseJobits)
ARRAY TEXT:C222($sttCaseJobits; 0)
$psttCaseJobits:=$1
$xlNumJobits:=0

SQL EXECUTE:C820("SELECT DISTINCT jobit FROM cases"; $sttCaseJobits)
Case of 
	: (OK=0)
		
	: (SQL End selection:C821)
		SQL CANCEL LOAD:C824
		
	Else 
		SQL LOAD RECORD:C822(SQL all records:K49:10)
		SQL CANCEL LOAD:C824
End case 
$xlNumJobits:=Size of array:C274($sttCaseJobits)

COPY ARRAY:C226($sttCaseJobits; $psttCaseJobits->)

$0:=$xlNumJobits