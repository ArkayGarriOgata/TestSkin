//%attributes = {"publishedWeb":true}
//Procedure: fMakeOLkey()  110498  MLB
//handle orderline createion
// Modified by: Mel Bohince (2/25/21) prepare for 6 digit order numbers

C_TEXT:C284($0; $orderSegment; $lineSegment)
C_LONGINT:C283($1; $2)

//$ol:=fMakeOLkey (1;2)
//$ol:=fMakeOLkey (12345;2)
//$ol:=fMakeOLkey (123456;101)
//$ol:=fMakeOLkey (123456;8)

If ($2<100)  //force 2 digit lines other
	$lineSegment:=String:C10($2; "00")
Else 
	$lineSegment:=String:C10($2; "000")
End if 

If ($1<100000)  //force 5 digit ordernumber segment
	$orderSegment:=String:C10($1; "00000")
Else 
	$orderSegment:=String:C10($1)
End if 

$0:=$orderSegment+"."+$lineSegment
//