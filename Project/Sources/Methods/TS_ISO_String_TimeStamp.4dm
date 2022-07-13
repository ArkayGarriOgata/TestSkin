//%attributes = {}
// -------
// Method: TS_ISO_String_TimeStamp   ( ) ->
// By: Mel Bohince @ 01/22/19, 16:17:38
// Description
// make a date time string like iso without the T
// see also TS2iso (TSTimeStamp (current date;Time(current time)))
// ----------------------------------------------------
C_DATE:C307($date; $1)
C_TIME:C306($time; $2)
C_TEXT:C284($0)

If (Count parameters:C259=2)
	$date:=$1
	$time:=$2
Else 
	$date:=Current date:C33
	$time:=Current time:C178
End if 

$0:=Substring:C12(String:C10($date; ISO date:K1:8); 1; 10)+" "+Substring:C12(String:C10($time; ISO time:K7:8); 12; 8)