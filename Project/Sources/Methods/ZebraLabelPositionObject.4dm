//%attributes = {"publishedWeb":true}
//PM: ZebraLabelPositionObject(x;y) -> 
//@author mlb - 11/2/01  13:41
C_LONGINT:C283($1; $2; $y; $3)  //x,y,offset position
If (Count parameters:C259=3)
	$y:=$2+$3
Else 
	$y:=$2
End if 

$0:="^FO"+String:C10($1)+","+String:C10($y)  //+Char(13)+Char(10)
//