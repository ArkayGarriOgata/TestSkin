//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 04/24/19, 09:40:31
// ----------------------------------------------------
// Method: util_isOnlyAlpha(text) -> true if number found
// Description
// to be used to see if there is at least one number in a po
//
// Parameters
// ----------------------------------------------------

C_LONGINT:C283($i; $char)
C_TEXT:C284($1; $test)
C_BOOLEAN:C305($0)
//If (Count parameters=1)
$test:=$1
//Else 
//$test:="as 9"
//End if 

$0:=True:C214
For ($i; 1; Length:C16($test))
	$char:=Character code:C91($test[[$i]])
	If ($char>47) & ($char<58)
		$0:=False:C215  //numeric found
		$i:=1+Length:C16($test)  //break
	End if 
End for 
//