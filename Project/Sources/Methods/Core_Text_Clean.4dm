//%attributes = {}
// _______
// Method: Core_Text_Clean (ptValue{;panAsciiException})
// By: Garri Ogata @ 06/30/20, 09:16:44
// Description:  This method will clean a field to make it only alphanumeric
//. spaces and single quotes are ok always strips leading and trailing spaces

//. Example with $anAsciiException (ok to allow)

//.  ARRAY LONGINT($anAsciiException;0)

//.  APPEND TO ARRAY($anAsciiException;Space)//32
//.  APPEND TO ARRAY($anAsciiException;38)  //ampersand &
//.  APPEND TO ARRAY($anAsciiException;39)  //single quote '
//.  APPEND TO ARRAY($anAsciiException;44)  //comma ,
//.  APPEND TO ARRAY($anAsciiException;45)  //hyphen -
//.  APPEND TO ARRAY($anAsciiException;Period)//period . 46
//.  APPEND TO ARRAY($anAsciiException;96) //grave accent `
//.  APPEND TO ARRAY($anAsciiException;233)  //Latin small letter e with acute e'

//.  Core_Text_Clean (->[Customers]Name;->$anAsciiException)

// Website for ascii codes:  https://www.ascii-code.com/
// ----------------------------------------------------

If (True:C214)  //Initialize 
	
	C_POINTER:C301($1; $ptValue)
	C_POINTER:C301($2; $panAsciiException)
	
	ARRAY LONGINT:C221($anAsciiException; 0)
	ARRAY TEXT:C222($atStripCharacter; 0)
	
	$ptValue:=$1
	
	APPEND TO ARRAY:C911($anAsciiException; Space:K15:42)  //Space is ok
	APPEND TO ARRAY:C911($anAsciiException; 39)  //Single quote is ok
	
	APPEND TO ARRAY:C911($atStripCharacter; Char:C90(Space:K15:42))
	
	If (Count parameters:C259>=2)
		
		COPY ARRAY:C226($2->; $anAsciiException)
		
	End if 
	
	$nNumberOfCharacters:=Length:C16($ptValue->)
	
	$tCharacter:=CorektBlank
	$tFieldCleaned:=CorektBlank
	
	$nAsciiCharacter:=0
	
End if   //Done Initialize

For ($nCharacter; 1; $nNumberOfCharacters)  //Loop thru all the characters
	
	$nAsciiCharacter:=Character code:C91($ptValue->[[$nCharacter]])
	
	$bAddCharacter:=True:C214
	
	Case of   //Character
			
		: (Find in array:C230($anAsciiException; $nAsciiCharacter)#CoreknNoMatchFound)  //Exception so OK
		: (($nAsciiCharacter>=48) & ($nAsciiCharacter<=57))  //Numbers (0-9) 48-57
		: (($nAsciiCharacter>=65) & ($nAsciiCharacter<=90))  //Uppercase letters (A-Z) 65-90
		: (($nAsciiCharacter>=97) & ($nAsciiCharacter<=122))  //Lowercase letters (a-z) 97-122
			
		Else   //Bad character
			
			$bAddCharacter:=False:C215
			
	End case   //Done character
	
	If ($bAddCharacter)
		
		$tCharacter:=Char:C90($nAsciiCharacter)
		$tFieldCleaned:=$tFieldCleaned+$tCharacter
		
	End if 
	
End for   //Done looping thru all the characters

$tFieldCleaned:=Core_Text_RemoveT($tFieldCleaned; ->$atStripCharacter; 3)  //Removes <Spaces> from front and back

$ptValue->:=$tFieldCleaned



