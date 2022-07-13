//%attributes = {"publishedWeb":true}
// (P) uUpdateTrail
C_POINTER:C301($1; $2)
$1->:=4D_Current_date  //update ModDate field
If (Count parameters:C259>2)  //count field referenced
	$3->:=1
End if 

If (Not:C34(Application type:C494=4D Server:K5:6))
	$2->:=<>zResp  //update ModWho Field
Else 
	$2->:="_aMs"
End if 
// EOP