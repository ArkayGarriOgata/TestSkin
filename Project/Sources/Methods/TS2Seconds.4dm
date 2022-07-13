//%attributes = {"publishedWeb":true}
//PM: TS2Seconds() -> 
//@author mlb - 2/22/02  16:08
//convert longint  time stamp seconds

C_LONGINT:C283($1; $0)
$0:=($1%86400)