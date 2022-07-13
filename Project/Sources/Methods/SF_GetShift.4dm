//%attributes = {"publishedWeb":true}
//PM: SF_GetShift($timestamp) -> number
//@author mlb - 2/22/02  15:57

C_TIME:C306($time)
C_LONGINT:C283($1; $0)

$time:=TS2Time($1)

Case of 
	: ($time<=?06:00:00?)
		$0:=3
	: ($time<=?15:30:00?)
		$0:=1
	Else 
		$0:=2
End case 