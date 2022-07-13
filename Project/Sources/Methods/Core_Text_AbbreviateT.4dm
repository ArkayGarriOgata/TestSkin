//%attributes = {}
//Method: Core_Text_AbbreviateT(tWord;{nLength})=>tAbbreviation)
//Description:  This method will find an abbreviation or 
// simply remove variables from a word

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tWord)
	C_LONGINT:C283($2; $nLength)
	C_TEXT:C284($0; $tAbbreviation)
	
	C_LONGINT:C283($nLetter; $nNumberOfLetters)
	
	ARRAY TEXT:C222($atVowel; 0)
	
	$tWord:=$1
	
	$nLength:=0
	
	If (Count parameters:C259>=2)
		$nLength:=$2
	End if 
	
	$tAbbreviation:=CorektBlank
	
	$nNumberOfLetters:=Length:C16($tWord)
	
	APPEND TO ARRAY:C911($atVowel; "a")
	APPEND TO ARRAY:C911($atVowel; "e")
	APPEND TO ARRAY:C911($atVowel; "i")
	APPEND TO ARRAY:C911($atVowel; "o")
	APPEND TO ARRAY:C911($atVowel; "u")
	
End if   //Done initialize

If (Core_Query_UniqueRecordB(->[Core_Abbreviate:62]Word:2; ->$tWord))  //Abbreviation
	
	$tAbbreviation:=[Core_Abbreviate:62]Abbreviation:3
	
Else   //Remove variables
	
	For ($nLetter; $nNumberOfLetters; 1; -1)  //Letter
		
		$tLetter:=$tWord[[$nLetter]]
		
		Case of   //Vowel
				
			: ($nLetter=1)
				
				$tAbbreviation:=$tLetter+$tAbbreviation
				
			: ($tAbbreviation#CorektBlank) & (Length:C16($tAbbreviation)=$nLength)  //Abbreviation is ok at this length
				
				$nLetter:=0  //Done
				
			Else   //Remove vowel
				
				$tAbbreviation:=Choose:C955(\
					(Find in array:C230($atVowel; $tLetter)=CoreknNoMatchFound); \
					($tLetter+$tAbbreviation); \
					$tAbbreviation)
				
		End case   // Done vowel
		
	End for   //Done letter
	
End if   //Done abbreviation

$0:=$tAbbreviation