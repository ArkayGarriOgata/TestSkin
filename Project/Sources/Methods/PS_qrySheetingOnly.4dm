//%attributes = {"publishedWeb":true}
//PM: PS_qrySheetingOnly() -> 
//@author mlb - 6/5/02  13:54
// Modified by: Mel Bohince (7/9/21) //set up group ipv's

C_TEXT:C284($1)
C_LONGINT:C283($0)

CostCtrInit  // Modified by: Mel Bohince (7/9/21) //set up group ipv's

If (Count parameters:C259=0)
	QUERY WITH ARRAY:C644([ProductionSchedules:110]CostCenter:1; <>aSHEETERS)
Else 
	QUERY SELECTION WITH ARRAY:C1050([ProductionSchedules:110]CostCenter:1; <>aSHEETERS)
End if 

$0:=Records in selection:C76([ProductionSchedules:110])