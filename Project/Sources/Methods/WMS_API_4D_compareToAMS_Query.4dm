//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_compareToAMS_Query - Created v0.1.0-JJG (05/18/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $xlNumRecs; $i)
C_TEXT:C284($1; $2; $ttBinID; $ttJobit; $ttQuery)
C_POINTER:C301($3; $4; $5; $psttBinID; $psttJobit; $psxlQty)
$ttBinID:=$1
$ttJobit:=$2
$psttBinID:=$3
$psttJobit:=$4
$psxlQty:=$5
ARRAY TEXT:C222($sttBinID; 0)
ARRAY TEXT:C222($sttJobit; 0)
ARRAY LONGINT:C221($sxlQty; 0)

$xlNumRecs:=0
$ttQuery:="SELECT bin_id,jobit,qty_in_case FROM cases "
$ttQuery:=$ttQuery+" WHERE bin_id = ? AND jobit = ? AND (case_status_code < 300 OR case_status_code = 350)  ORDER BY jobit ASC"

SQL SET PARAMETER:C823($ttBinID; SQL param in:K49:1)
SQL SET PARAMETER:C823($ttJobit; SQL param in:K49:1)
SQL EXECUTE:C820($ttQuery; $sttBinID; $sttJobit; $sxlQty)
Case of 
	: (OK=0)
		
	: (SQL End selection:C821)
		SQL CANCEL LOAD:C824
		
	Else 
		SQL LOAD RECORD:C822(SQL all records:K49:10)
		SQL CANCEL LOAD:C824
		
		For ($i; Size of array:C274($sttJobit); 2; -1)  //because group by and SUM(qty_in_case) would not work
			$sxlQty{$i-1}:=$sxlQty{$i-1}+$sxlQty{$i}
			DELETE FROM ARRAY:C228($sxlQty; $i; 1)
			DELETE FROM ARRAY:C228($sttJobit; $i; 1)
			DELETE FROM ARRAY:C228($sttBinID; $i; 1)
		End for 
		
		$xlNumRecs:=Size of array:C274($sttBinID)
		COPY ARRAY:C226($sttBinID; $psttBinID->)
		COPY ARRAY:C226($sttJobit; $psttJobit->)
		COPY ARRAY:C226($sxlQty; $psxlQty->)
End case 

$0:=$xlNumRecs