//%attributes = {}
// Method: CostCtr_RunHrsTransient ($sheetsToRun;rounding{;c/cID}) -> 
// ----------------------------------------------------
// by: mel: 05/02/05, 15:02:46
// ----------------------------------------------------
// Description:
// calculate run hours with different speeds as length of run changes
// per ben's request
// ----------------------------------------------------

C_LONGINT:C283($sheetsToRun; $1; $currentSpeed; $2; $roundBy)
C_TEXT:C284($3)
C_REAL:C285($runHrs; $0; $runMinimum)

$sheetsToRun:=$1
$roundBy:=0
$runHrs:=0

If (Count parameters:C259>1)
	$roundBy:=$2
End if 

If (Count parameters:C259>2)
	If ([Cost_Centers:27]ID:1#$3)
		READ ONLY:C145([Cost_Centers:27])
		QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$3)
	End if 
End if 

ARRAY LONGINT:C221($rates; 4)  //from the c/c table
$rates{1}:=[Cost_Centers:27]RS_short:46  //1600
$rates{2}:=[Cost_Centers:27]RS_Medium:48  //2500
$rates{3}:=[Cost_Centers:27]RS_Long:50  //2700
$rates{4}:=[Cost_Centers:27]RS_Spl:52  //2700

$runMinimum:=[Cost_Centers:27]RUN_minumum:55
$currentSpeed:=1

While ($sheetsToRun>0)
	Case of 
		: ($rates{$currentSpeed}=0)  //no running hrs
			$sheetsToRun:=0
			
		: ($sheetsToRun<=$rates{$currentSpeed})
			$runHrs:=$runHrs+($sheetsToRun/$rates{$currentSpeed})
			$sheetsToRun:=0
			
		: ($sheetsToRun>$rates{$currentSpeed})
			$runHrs:=$runHrs+1
			$sheetsToRun:=$sheetsToRun-$rates{$currentSpeed}
	End case 
	
	If ($currentSpeed<Size of array:C274($rates))
		$currentSpeed:=$currentSpeed+1
	End if 
End while 

If ($runHrs<$runMinimum)
	$runHrs:=$runMinimum
End if 

Case of 
	: ($roundBy=0)
		$0:=$runHrs
	: ($roundBy=2)
		$0:=Round:C94($runHrs; 2)
	: ($roundBy=25)  //disable for testing
		$0:=Round:C94($runHrs; 2)
		//$0:=util_roundUp ($runHrs)
End case 