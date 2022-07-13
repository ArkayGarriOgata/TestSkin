//%attributes = {"publishedWeb":true}
//(P) uRejectAlert: Presents alert and rejects record

C_TEXT:C284($1)
C_POINTER:C301($2)  //pointer to field or variable to reject

uConfirm($1; "OK"; "Help")

If (Count parameters:C259>1)  //field or var passed
	REJECT:C38($2->)
Else   //none passed
	REJECT:C38
End if 