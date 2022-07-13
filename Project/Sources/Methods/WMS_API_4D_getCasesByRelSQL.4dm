//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getCasesByRelSQL - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fSuccess)
C_LONGINT:C283($1; $xlReleaseNumber)
C_TEXT:C284($ttSQL)
$xlReleaseNumber:=$1
$fSuccess:=False:C215

$ttSQL:="SELECT qty_in_case,jobit,SUBSTRING(skid_number,11),from_bin_id,COUNT(case_id),SUM(qty_in_case) "
$ttSQL:=$ttSQL+" FROM cases WHERE release_number = ? GROUP BY qty_in_case,jobit,skid_number,from_bin_id"

SQL SET PARAMETER:C823($xlReleaseNumber; SQL param in:K49:1)
SQL EXECUTE:C820($ttSQL; aPackQty; aJobit; aPallet; aLocation; aNumCases; aTotalPicked)

Case of 
	: (OK=0)
		
	: (SQL End selection:C821)
		SQL CANCEL LOAD:C824
		
	Else 
		SQL LOAD RECORD:C822(SQL all records:K49:10)
		SQL CANCEL LOAD:C824
		$fSuccess:=True:C214
		
End case 

$0:=$fSuccess