//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/07/08, 10:50:08
// ----------------------------------------------------
// Method: TS2iso({timestamp}) -> iso DateTime as string

// Description
// return timestamp as yyyy-mm-dd hh:mm:ss
//  see also TS_ISO_String_TimeStamp which is more native

// Parameters
// ----------------------------------------------------
// Modified by: Mel Bohince (10/11/17) option $2 to leave "T"
C_LONGINT:C283($1; $time_stamp)
C_TEXT:C284($0; $isoDateTime; $2)
C_DATE:C307($date)
C_TIME:C306($time)

If (Count parameters:C259>0)
	$time_stamp:=$1
Else   //use now
	$time_stamp:=TSTimeStamp
End if 

//$date:=!00/00/0000!
//$time:=?00:00:00?
TS2DateTime($time_stamp; ->$date; ->$time)  //convert timestamp to date and time
$isoDateTime:=String:C10($date; ISO date:K1:8)  //2008-12-31T00:00:00, time not specified
If (Count parameters:C259<2)  //orig
	$isoDateTime:=Change string:C234($isoDateTime; " "+String:C10($time; HH MM SS:K7:1); 11)  //add the time section
Else 
	$isoDateTime:=Change string:C234($isoDateTime; String:C10($time; HH MM SS:K7:1); 12)  //add the time section
End if 
$0:=$isoDateTime  //2008-12-31 23:59:59
