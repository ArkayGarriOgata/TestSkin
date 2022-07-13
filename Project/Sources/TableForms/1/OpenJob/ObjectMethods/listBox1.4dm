// _______
// Method: [zz_control].OpenJob.List Box   ( ) ->
// By: Mel Bohince @ 11/01/21, 12:33:52
// Description
// 
// ----------------------------------------------------

$fromLB_p:=OBJECT Get pointer:C1124(Object named:K67:5; "listBox1")

For ($i; 1; Size of array:C274(asBull))
	asBull{$i}:=""
End for 

asBull{$fromLB_p->}:="•"

