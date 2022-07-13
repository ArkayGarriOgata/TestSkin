//%attributes = {"publishedWeb":true}
//Function: parsestring
//Parameters: 4 - string,number(integer),   
//     $1 string to search in
//          $2 integer number of times to locate character
//     $3 (optional) string, the character to search for
//     $4 - (optional) pointer - pointer to initial string to allow truncation 
//         (Destructive parsing)
//returns the string PRECEEDING the instance of the character indicated
//Ex:  uParseString("A,B,C,D,E,F"; 3; ",") -> "C"
//       uParseString("A,B,C,D,E,F"; 1; ",") -> "A"
//       uParseString("A,B,C,D,E,F"; 6; ",") -> "F"    
//       uParseString("A,B,C,D,E,F"; 0; ",") -> ""    
//• 12/20/96 cs - allow destructive processing of incoming string

C_TEXT:C284($0; $String; $1)
C_LONGINT:C283($wanted; $2)
C_TEXT:C284($Search; $3)
C_POINTER:C301($4; $Truncate)  //• 12/20/96

$String:=$1
$Wanted:=$2  //the number of the character to find

If (Count parameters:C259=2)  //if this is looking just for tabs
	$Search:=Char:C90(9)
Else   //assign passed string
	$Search:=$3
End if 

If (Count parameters:C259=4)  //• 12/20/96
	$Truncate:=$4  //pointer to value to truncate
End if 

If ($Wanted>0)  //if the number wanted is > 0 find instance
	For ($i; 1; $Wanted)
		$Found:=Position:C15($Search; $String)  //locate next instance of character
		
		Case of 
			: ($i<$Wanted) & ($Found>0)  //if the number of char wanted is not yet reached 
				$String:=Substring:C12($String; $Found+1)
				
			: ($Wanted=$i) & ($Found>0)  //instance found
				$0:=Substring:C12($String; 1; $Found-1)
				If (Count parameters:C259=4)  //• 12/20/96
					$Truncate->:=Substring:C12($String; $Found+1)  //replace the incomming string with the truncated version (found removed)
				End if 
				
			: ($Found=0)  //no more instances
				$0:=$String
				If (Count parameters:C259=4)  //• 12/20/96
					$Truncate->:=""  //replace the incomming string with empty string
				End if 
				$i:=$Wanted+1  //end loop
		End case 
	End for 
Else   //else # wanted <= zero return empty string
	$0:=""
End if 