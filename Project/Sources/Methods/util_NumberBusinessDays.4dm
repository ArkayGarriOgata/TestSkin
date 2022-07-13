//%attributes = {}

// Method: util_NumberBusinessDays ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/25/15, 12:31:34
// ----------------------------------------------------
// Description
// calc the number of business days
//
// ----------------------------------------------------

If (Count parameters:C259>0)
	$test_date:=$1
	$first_day:=$2
Else 
	$test_date:=4D_Current_date
	$first_day:=Add to date:C393($test_date; 0; 1-Month of:C24($test_date); 1-Day of:C23($test_date))  //first of the year
	//$first_day:=Add to date($test_date;0;0;1-Day of($test_date))  //first of the month
End if 


$fullBlockDays:=$test_date-$first_day

$numberWeeks:=Int:C8(($test_date-$first_day)/7)
$weekEnds:=$numberWeeks*2
$fullBlockDays:=$fullBlockDays-$weekEnds

//$yearBegin:=Day number($first_day)
//If ($yearBegin>1)
//$fullBlockDays:=$fullBlockDays-1`remove a saturday
//Else 
//$fullBlockDays:=$fullBlockDays-2`remove weekend
//end if
//
//
$currentDay:=Day number:C114(Current date:C33)
If ($currentDay=7)
	$fullBlockDays:=$fullBlockDays-2  //remove weekend
Else 
	$fullBlockDays:=$fullBlockDays-1  //remove sunday
End if 

$0:=$fullBlockDays