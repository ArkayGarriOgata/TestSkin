//%attributes = {}
/*
 Method: util_camelCase   (text ) -> $camelCase:text
 By: MelvinBohince @ 06/24/22, 09:27:10
 Description:
  return a text in camelCase


*/
var $textToConvert; $1; $2 : Text
var $words_c : Collection
var $i; $capitalizeFirstLetter : Integer

If (Count parameters:C259>0)
	$textToConvert:=$1
	If (Count parameters:C259>1)
		$capitalizeFirstLetter:=0  //this represents the first element of the word collection
	Else 
		$capitalizeFirstLetter:=1  //this represents the second element of the word collection
	End if 
	
Else   //test
	$textToConvert:="Acetate  Laminator  "
	$capitalizeFirstLetter:=1  //0 =capitalize first word 1=2nd word
End if 



$words_c:=Split string:C1554(Lowercase:C14($textToConvert); " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)

For ($i; $capitalizeFirstLetter; $words_c.length-1)  //leave the first word alone
	$words_c[$i]:=Uppercase:C13($words_c[$i][[1]])+Substring:C12($words_c[$i]; 2)
End for 

return $words_c.join("")
