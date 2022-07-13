//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: GetNextField - Created `v1.0.0-PJK (12/16/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//$1=-> Text
//$2=Delimiter
C_POINTER:C301($1)
C_TEXT:C284($2)
$xlPos:=Position:C15($2; $1->; *)
$xlDelLength:=Length:C16($2)
If ($xlPos>0)
	$0:=Substring:C12($1->; 1; $xlPos-1)
	$1->:=Substring:C12($1->; $xlPos+$xlDelLength)
Else 
	$0:=$1->
	$1->:=""
End if 