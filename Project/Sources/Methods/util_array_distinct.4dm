//%attributes = {}
// -------
// Method: util_array_distinct   (->$arr;->$newarr ) -> error
// By: Mel Bohince @ 04/25/17, 10:38:27
// Description
// based on UTIL_ARR_REMOVE_DUPLICATES from http://kb.4d.com/assetid=77758
// ----------------------------------------------------
// 
// $1 - Pointer to source array
// $2 - Pointer to array to contain results
C_POINTER:C301($1; $arr; $2; $newArr)
C_LONGINT:C283($i; $0)

$arr:=$1
$newArr:=$2

For ($i; 1; Size of array:C274($arr->))
	If (Find in array:C230($newArr->; $arr->{$i})=-1)
		APPEND TO ARRAY:C911($newArr->; $arr->{$i})
	End if 
End for 

If (Size of array:C274($newArr->)>0)
	$0:=0
Else   //empty is err
	$0:=-1
End if 

//usage:

//ARRAY LONGINT($arr;5)
//$arr{1}:=1
//$arr{2}:=1
//$arr{3}:=2
//$arr{4}:=3
//$arr{5}:=1

//ARRAY LONGINT($newArr;0)
//$err:=util_array_distinct(->$arr;->$newarr)