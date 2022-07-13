//%attributes = {}
// -------
// Method: Job_ConvertSheetsToLoads   ( Sheets{;caliper{;heightInInches}}) -> loads (truncated interger)
// By: Mel Bohince @ 01/29/19, 15:33:21
// Description
// estimate how many load would make up a given sheet count
// ----------------------------------------------------

C_LONGINT:C283($1; $0; $3)
C_REAL:C285($2)

$sheets:=$1
If (Count parameters:C259>1)
	$caliper:=$2
	
	If (Count parameters:C259>2)
		$height:=$3
	Else 
		$height:=40
	End if 
	
Else 
	$caliper:=0.018
End if 

$0:=Round:C94($sheets/($height/$caliper); 0)
