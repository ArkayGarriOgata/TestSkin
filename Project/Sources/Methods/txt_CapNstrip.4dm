//%attributes = {"publishedWeb":true}
//PM:  txt_CapNstrip  
//formerly `(p) uCapNStrip
//DESC:  capitalizes the first letter of each word in the
//       string passed in $1»
//       Also strips leading and trailing spaces.
//       First checks the data type of the object pointed to
//       by $1, must be Text, alpha, or string.
//       If a bullet is typed as the first character, the capitalization
//       algorithm is ignored, and the bullet is stripped.
//       If a ≠ (the option-equals key) is typed as the first character, 
//       leading spaces are not stripped
//$1 = pointer to a string or text var
//$0 = n/a
//Examples:  Full Format (»[Contacts]Last Name)
//         Full Format (Self)
//         Full Format (»vNote)
//•2/11/97 cs  mod to get apostrophe to cap next letter correctly
C_LONGINT:C283($Type; $i)
C_TEXT:C284($chars)
C_POINTER:C301($1; $StrPtr)
$chars:=" -=+\\/?.,!#$%^'’“”:&*()  "  //any character following one of these will be uppercased
$StrPtr:=$1  //reassign for better readability
$Type:=Type:C295($StrPtr->)  //what type of data is pointed to?

If (($Type=0) | ($Type=2) | ($Type=24))  //ERROR CHECK!! - only work with text or string data
	
	If (Length:C16($StrPtr->)>0)  //be sure it's not an empty string
		
		If ($StrPtr->[[1]]#"•")  //use bullet to bypass capitalization routine 
			$StrPtr->:=Lowercase:C14($StrPtr->)  //first make everything lowercase
			$StrPtr->[[1]]:=Uppercase:C13($StrPtr->[[1]])  //uppercase the first character always
			
			For ($i; 1; Length:C16($StrPtr->)-1)  //step thru each character in string
				
				If (Position:C15($StrPtr->[[$i]]; $chars)>0)  //this a special character?
					$StrPtr->[[$i+1]]:=Uppercase:C13($StrPtr->[[$i+1]])  //if so, then cap the next character
					
					// • 2/11/97             If (($i=(Length($StrPtr»)-1)) & ($StrPtr»≤$i≥="'"))
					//              $StrPtr»≤$i+1≥:=Lowercase($StrPtr»≤$i+1≥)
					//End if 
					
					If ($StrPtr->[[$i]]="'")  //this is an apostrophe need to check next 2 chars
						
						If ($i+2<=Length:C16($StrPtr->))  //character after next exists (ie joe's $i + 2 > length of "joe's")
							
							If (Position:C15($StrPtr->[[$i+2]]; $Chars)>0)  //this apostrophe is an apostrophe "s"        
								$StrPtr->[[$i+1]]:=Lowercase:C14($StrPtr->[[$i+1]])  //reduce the "s' to small chars again
							Else   //this apostrophe is embedded in a word (O'Grady)
								//do nothing (Next charater after apostophe is already capped above) ,
							End if 
						Else   //this apostrophe is not embedded and is at the end of the string apostrophe "s"
							$StrPtr->[[$i+1]]:=Lowercase:C14($StrPtr->[[$i+1]])  //reduce the "s' to small chars again
						End if 
						//end mods 2/11/97    
						
					End if 
				End if   //character check  
			End for 
			
			If (Position:C15("Mc"; $StrPtr->)#0)
				$StrPtr->[[(Position:C15("Mc"; $StrPtr->)+2)]]:=Uppercase:C13($StrPtr->[[(Position:C15("Mc"; $StrPtr->)+2)]])
			End if 
		Else   //bullet was typed
			$StrPtr->:=Substring:C12($StrPtr->; 2; Length:C16($StrPtr->))  //strip the bullet character
		End if   //bullet check    
		
		If (Length:C16($StrPtr->)>0)  //recheck the length, if a bullet was the only char
			
			If ($StrPtr->[[1]]#"≠")  //special developer character to prevent stripping of leading or trailing spaces
				$StrPtr->:=fStripSpace("B"; $StrPtr->)
			Else   //developer character was typed
				$StrPtr->:=Substring:C12($StrPtr->; 2; Length:C16($StrPtr->))  //strip the developer character            
			End if   //($StrPtr»≤1≥#"≠")
		End if   //Length($StrPtr»)>0          
	End if   //length check   
Else   //something other than string or text passed
	$Message:="Error in CAPITALIZE procedure, type value "+String:C10($Type)+" passed!"
	ALERT:C41($Message)  //alert the user (really should be the developer)
End if   //type check      
//