//%attributes = {"publishedWeb":true}
//(p) uOccurs
//determines the number of time string A ($1) occurs inside string B($2)
//$1 - string - string or character to find
//$2 text - string or text in which to find it
//$0-long int- number of times $1 exists in $2
C_TEXT:C284($1; $Find)
C_TEXT:C284($2; $Text)
C_LONGINT:C283($0; $Found)
$0:=0
$Found:=0
$Text:=$2
$Find:=$1

Repeat 
	$Found:=Position:C15($Find; $Text)  //does the string we are looking for exist?
	If ($Found>0)  //if found
		$Text:=Substring:C12($Text; $Found+1)  // want to try again, later in string
		$0:=$0+1  //increment counter
	End if 
Until ($Found<=0)
//end