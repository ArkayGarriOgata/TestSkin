// Method: [zz_control].MoveRM.fromListBox   ( ) ->
// By: Mel Bohince @ 11/01/21, 09:33:53
// Description
// 
// ----------------------------------------------------

$fromLB_p:=OBJECT Get pointer:C1124(Object named:K67:5; "fromListBox")

If (aBullet{$fromLB_p->}="√")
	aBullet{$fromLB_p->}:=""
Else 
	aBullet{$fromLB_p->}:="√"
End if 
