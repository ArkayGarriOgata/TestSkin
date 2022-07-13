//%attributes = {"publishedWeb":true}
//PM: SF_calcSecondsRemaining(shift;starttime) -> 
//@author mlb - 2/25/02  11:52

C_LONGINT:C283($start; $1; $secondsRemaining; $0; $numShifts; $HOUR; $timeStartInSeconds)
C_DATE:C307($date)
C_TEXT:C284($2; $ttDept)

$HOUR:=3600
$start:=$1
$ttDept:=$2  //v1.0.0-PJK (12/23/15)

$date:=TS2Date($start)
$timeStartInSeconds:=TS2Seconds($start)
$numShifts:=SF_GetNumOfShifts($date; $ttDept)  //v1.0.0-PJK (12/23/15) added second parameter
$offSet:=(8*$HOUR)  //if only 1 or 2 shifs

Case of 
	: ($numShifts=3)
		$secondsRemaining:=(24*$HOUR)-$timeStartInSeconds
		
	: ($numShifts=2)
		If ($timeStartInSeconds<$offSet)
			$timeStartInSeconds:=$offSet
		End if 
		$secondsRemaining:=(24*$HOUR)-$timeStartInSeconds
		
	: ($numShifts=1)
		If ($timeStartInSeconds<$offSet)
			$timeStartInSeconds:=$offSet
		End if 
		$secondsRemaining:=(16*$HOUR)-$timeStartInSeconds
		
	Else 
		$secondsRemaining:=0
End case 

If ($secondsRemaining<0)
	$secondsRemaining:=0
End if 

$0:=$secondsRemaining