//%attributes = {}
// -------
// Method: PF_util_FormatDate   (->ams_date ) -> iso string, not null
// By: Mel Bohince @ 10/11/17, 08:13:00
// Description
// chg ams date to iso, and future if null
// ----------------------------------------------------

C_POINTER:C301($1)
C_DATE:C307($date)
C_TIME:C306($2; $time)
C_TEXT:C284($0; $iso)

If (Count parameters:C259>1)
	$time:=$2
Else 
	$time:=?13:01:00?  //pick a time in the afternoon
End if 


If (Count parameters:C259>0)
	$date:=$1->
Else 
	$date:=!00-00-00!  //Current date
End if 

If ($date=!00-00-00!)
	$date:=<>MAGIC_DATE
End if 


$iso:=TS2iso(TSTimeStamp($date; $time); "T")
$0:=$iso
