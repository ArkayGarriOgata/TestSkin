//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 08/14/08, 11:28:02
// ----------------------------------------------------
// Method: wms_api_find_cases_by_jobit(connectionid;jobit{;option})->numrows
// Description
// 
//
// Parameters
// ----------------------------------------------------

//v0.1.0-JJG (05/05/16) - renamed to wms_api_mySQL_findCasesByJobit 

C_TEXT:C284($2; $jobit)
C_LONGINT:C283($0; $1; $number_found)
$number_found:=0
If (Count parameters:C259=2)
	$jobit:=Replace string:C233($2; "."; "")
	$sql:="SELECT case_id, qty_in_case, skid_number, bin_id, case_status_code "
	$sql:=$sql+" FROM cases WHERE "
	$sql:=$sql+"jobit = '"+$jobit+"'"
	
	//$row_set:=MySQL Select ($1;$sql)
	//$number_found:=MySQL Get Row Count ($row_set)
End if 
$0:=$number_found