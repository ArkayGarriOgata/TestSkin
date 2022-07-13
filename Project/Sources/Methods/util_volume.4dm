//%attributes = {}
// _______
// Method: util_volume   ( ) ->
// By: Mel Bohince @ 07/09/19, 10:24:47
// Description
// given a delimited string, multiply the 3 dimensions
// ----------------------------------------------------
If (Count parameters:C259=1)
	$abh:=$1
Else 
	$abh:="19.00x15.25x9.25"  //test case
End if 

$vol:=0

$pos:=Position:C15("x"; $abh)
$a:=Num:C11(Substring:C12($abh; 1; ($pos-1)))

$abh:=Substring:C12($abh; ($pos+1))
$pos:=Position:C15("x"; $abh)
$b:=Num:C11(Num:C11(Substring:C12($abh; 1; ($pos-1))))

$abh:=Substring:C12($abh; ($pos+1))
$h:=Num:C11($abh)

If ($a>0) & ($b>0) & ($h>0)
	$vol:=Round:C94($a*$b*$h; 0)
End if 


$0:=$vol



