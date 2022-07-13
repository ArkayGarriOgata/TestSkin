//%attributes = {"publishedWeb":true}
//PM: utl_ListReplace(->listRef) -> null
//@author mlb - 6/21/02  08:53
C_POINTER:C301($listPtr; $1)
$listPtr:=$1
C_LONGINT:C283($2)
If (Is a list:C621($listPtr->))
	CLEAR LIST:C377($listPtr->)
End if 
$listPtr->:=0

If (Count parameters:C259=2)  //make new list
	$srcList:=$2
	If (Is a list:C621($srcList))  //then copy
		$listPtr->:=utl_ListNew($srcList)
	Else 
		$listPtr->:=utl_ListNew
	End if 
End if 
//