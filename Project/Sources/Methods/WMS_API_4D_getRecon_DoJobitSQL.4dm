//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getRecon_DoJobitSQL - Created v0.1.0-JJG (05/18/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 
C_BOOLEAN:C305($0; $fSuccess)
C_TEXT:C284($1; $ttWMSJobit; $ttSQL)
C_POINTER:C301($2; $3; $4; $5; $pst3CaseBinID; $psxlCaseQty; $pst3SkidNumber; $psxlNumCases)
C_LONGINT:C283($i; $xlSize)
ARRAY TEXT:C222($st3CaseBinID; 0)
ARRAY LONGINT:C221($sxlCaseQty; 0)
ARRAY TEXT:C222($st3SkidNumber; 0)
$ttWMSJobit:=$1
$pst3CaseBinID:=$2
$psxlCaseQty:=$3
$pst3SkidNumber:=$4
$psxlNumCases:=$5
$fSuccess:=False:C215

$ttSQL:="SELECT bin_id,qty_in_case,skid_number FROM cases "
$ttSQL:=$ttSQL+" WHERE jobit = ? AND (case_status_code < 300 OR  case_status_code = 350) ORDER BY bin_id"
SQL SET PARAMETER:C823($ttWMSJobit; SQL param in:K49:1)
SQL EXECUTE:C820($ttSQL; $st3CaseBinID; $sxlCaseQty; $st3SkidNumber)
Case of 
	: (OK=0)
		
	: (SQL End selection:C821)
		SQL CANCEL LOAD:C824
		
	Else 
		SQL LOAD RECORD:C822(SQL all records:K49:10)
		SQL CANCEL LOAD:C824
		
		$xlSize:=Size of array:C274($st3CaseBinID)
		ARRAY LONGINT:C221($sxlNumCases; $xlSize)
		If ($xlSize>0)
			$sxlNumCases{$xlSize}:=1
		End if 
		For ($i; $xlSize; 2; -1)  //because SQL SUM and group by don't seem to work with 4D very well
			$sxlNumCases{$i-1}:=1
			If ($st3CaseBinID{$i-1}=$st3CaseBinID{$i})
				$sxlCaseQty{$i-1}:=$sxlCaseQty{$i-1}+$sxlCaseQty{$i}
				$sxlNumCases{$i-1}:=$sxlNumCases{$i-1}+$sxlNumCases{$i}
				DELETE FROM ARRAY:C228($st3CaseBinID; $i; 1)
				DELETE FROM ARRAY:C228($st3SkidNumber; $i; 1)
				DELETE FROM ARRAY:C228($sxlCaseQty; $i; 1)
				DELETE FROM ARRAY:C228($sxlNumCases; $i; 1)
			End if 
		End for 
		
		COPY ARRAY:C226($st3CaseBinID; $pst3CaseBinID->)
		COPY ARRAY:C226($sxlCaseQty; $psxlCaseQty->)
		COPY ARRAY:C226($st3SkidNumber; $pst3SkidNumber->)
		COPY ARRAY:C226($sxlNumCases; $psxlNumCases->)
		$fSuccess:=True:C214
		
End case 

$0:=$fSuccess


