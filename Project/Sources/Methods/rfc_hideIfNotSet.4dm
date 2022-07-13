//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/17/08, 14:55:30
// ----------------------------------------------------
// Method: rfc_hideIfNotSet
// Description
// don't show if not set
// ----------------------------------------------------

OBJECT SET VISIBLE:C603($2->; $1->)
If (Count parameters:C259>=3)
	OBJECT SET VISIBLE:C603($3->; $1->)
End if 

If (Count parameters:C259>=4)
	OBJECT SET VISIBLE:C603($4->; $1->)
End if 