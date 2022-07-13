//%attributes = {"publishedWeb":true}
//fCalcGeneric
//491 Flat Pack, 501 Hand Labor, 502 Examining
//Flat pack has no waste, & no make ready.  IT is simply used to determine the #
//of cartons which can be packed per hour.  
//upr 1277 11/3/94
//•090696  MLB 

C_LONGINT:C283($waste; $net; $gross; $0; $1; $2)
C_REAL:C285($MR_hrs)

$net:=[Estimates_Machines:20]Flex_field1:18  //upr 1277 11/3/94
If ($net=0)
	$net:=$1
End if 

If ([Estimates_Machines:20]Flex_Field5:25)  //then its doing sheets
	$yield:=$net
Else 
	$yield:=[Estimates_Machines:20]Flex_Field2:19
	If ($yield=0)
		If (Count parameters:C259=2)  //•090696  MLB 
			$yield:=$2  //= want qty of cartons at carton spec level
		End if 
	End if 
End if 
//$GrossOrig:=$Net  `# of sheets, carry thru calculation untouched
//WASTE
$Waste:=0
$gross:=$net+$waste

//C_LONGINT($NumberUp)
//$NumberUp:=$2  `fCalcNumberUp 
//$gross:=$net*$NumberUp  `get # of cartons

//MAKE READY
$MR_hrs:=[Cost_Centers:27]MR_mimumum:33
If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	[Estimates_Machines:20]MakeReadyHrs:30:=$MR_hrs
End if 

//RUNNING RATE
If ([Estimates_Machines:20]Run_Override:27#0)
	[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
Else 
	[Estimates_Machines:20]RunningRate:31:=fCalcDoRunRate($Gross)  //this is Cartons per hour though
End if 

fCalcStdTotals($Gross; $Waste; $net)

If ($yield#$net)
	fCalcYield($yield-$net)
End if 

If ([Estimates_Machines:20]Flex_Field5:25)  //then its doing sheets
	$0:=$gross
Else 
	$0:=$waste  //$gross 
End if 