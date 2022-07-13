//%attributes = {"publishedWeb":true}
//PM: util_SelectionToText() -> 
//@author mlb - 4/20/01  10:18
//useful in patch set
C_POINTER:C301($fieldPtr; $1)
C_LONGINT:C283($i; $type)
C_TEXT:C284($0; $return)
C_TEXT:C284($cr)
$cr:=Char:C90(13)
$return:="error"
$fieldPtr:=$1
$type:=Type:C295($fieldPtr->)

Case of 
	: ($type=Is alpha field:K8:1) | ($type=Is text:K8:3)
		ARRAY TEXT:C222($aText; 0)
		SELECTION TO ARRAY:C260($fieldPtr->; $aText)
		SORT ARRAY:C229($aText; >)
		$return:=Field name:C257($fieldPtr)+$cr
		For ($i; 1; Size of array:C274($aText))
			$return:=$return+$aText{$i}+$cr
		End for 
		$return:=$return+$cr+String:C10(Size of array:C274($aText))+" records"+$cr
		
	: ($type=Is date:K8:7)
		ARRAY DATE:C224($aDate; 0)
		SELECTION TO ARRAY:C260($fieldPtr->; $aDate)
		SORT ARRAY:C229($aDate; >)
		$return:=Field name:C257($fieldPtr)+$cr
		For ($i; 1; Size of array:C274($aDate))
			$return:=$return+String:C10($aDate{$i}; Internal date short:K1:7)+$cr
		End for 
		$return:=$return+$cr+String:C10(Size of array:C274($aDate))+" records"+$cr
		
	Else 
		ARRAY REAL:C219($aNumber; 0)
		SELECTION TO ARRAY:C260($fieldPtr->; $aNumber)
		SORT ARRAY:C229($aNumber; >)
		$return:=Field name:C257($fieldPtr)+$cr
		For ($i; 1; Size of array:C274($aNumber))
			$return:=$return+String:C10($aNumber{$i})+$cr
		End for 
		$return:=$return+$cr+String:C10(Size of array:C274($aNumber))+" records"+$cr
End case 

$0:=$return+$cr
//
