//%attributes = {}
// _______
// Method: pattern_ListBox_Set_Bullet   ( ) ->
// By: Mel Bohince @ 11/01/21, 10:21:15
// Description
// remediation converting grouped arrays with
// a Bullet column to listboxs
// this would be the object method for the listbox
// ----------------------------------------------------

$fromLB_p:=OBJECT Get pointer:C1124(Object named:K67:5; "fromListBox")

If (aBullet{$fromLB_p->}="√")
	aBullet{$fromLB_p->}:=""
Else 
	aBullet{$fromLB_p->}:="√"
End if 
