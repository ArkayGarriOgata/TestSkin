//%attributes = {}
//Method:  Core_Parse_Text(oParse)
//Description: This method will parse oParse.tValue into whole words based on nMaxLength (number of characters per line) or
//  (tFontName;nFontSize;nWidthInPixels) given nMaxLines allowed.

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($cLineWord)
	C_COLLECTION:C1488($cWord)
	
	C_OBJECT:C1216($1; $oParse)
	
	C_TEXT:C284($tFontName; $tLine; $tLineNumber; $tValue; $tWord; $tWords)
	
	C_LONGINT:C283($nFontSize; $nLine; $nLineLength)
	C_LONGINT:C283($nMaxLength; $nMaxLines; $nNumberOfLines)
	C_LONGINT:C283($nNumberOfWords; $nValueLength; $nWidthInPixels; $nWord; $nWordLength)
	
	C_BOOLEAN:C305($bUseTextToArray)
	
	ARRAY TEXT:C222($atWord; 0)
	ARRAY TEXT:C222($atLine; 0)
	
	$oParse:=New object:C1471()
	$oParse:=$1
	
	$cLineWord:=New collection:C1472()
	$cWord:=New collection:C1472()
	
	$tLine:=CorektBlank
	$tWord:=CorektBlank
	
	$nLineLength:=0
	$nLine:=1
	$nWordLength:=0
	
	$tLineNumber:="tLine"+String:C10($nLine)
	
	$bUseTextToArray:=False:C215
	
	$nMaxLines:=Choose:C955(\
		(OB Is defined:C1231($oParse; "nMaxLines")); \
		$oParse.nMaxLines; \
		0)
	
	$nMaxLength:=Choose:C955(\
		(OB Is defined:C1231($oParse; "nMaxLength")); \
		$oParse.nMaxLength; \
		0)
	
	$tFontName:=Choose:C955(\
		(OB Is defined:C1231($oParse; "tFontName")); \
		$oParse.tFontName; \
		CorektBlank)
	
	$nFontSize:=Choose:C955(\
		(OB Is defined:C1231($oParse; "nFontSize")); \
		$oParse.nFontSize; \
		0)
	
	$nWidthInPixels:=Choose:C955(\
		(OB Is defined:C1231($oParse; "nWidthInPixels")); \
		$oParse.nWidthInPixels; \
		0)
	
	$nValueLength:=Length:C16($oParse.tValue)
	
	Case of   //Text to array
			
		: ($nWidthInPixels=0)
		: ($tFontName=CorektBlank)
		: ($nFontSize=0)
			
		Else   //use
			
			TEXT TO ARRAY:C1149($oParse.tValue; $atLine; $nWidthInPixels; $tFontName; $nFontSize)
			
			$nNumberOfLines:=Size of array:C274($atLine)
			
			$bUseTextToArray:=($nNumberOfLines<=$oParse.nMaxLines)
			
	End case   //Done text to array
	
End if   //Done initialize

Case of   //Evaluate
		
	: ($bUseTextToArray)  //Fits in lines
		
		For ($nLine; 1; $nNumberOfLines)  //Line
			
			$tLineNumber:="tLine"+String:C10($nLine)
			
			If (OB Is defined:C1231($oParse; $tLineNumber))
				
				OB SET:C1220($oParse; $tLineNumber; $atLine{$nLine})
				
			End if 
			
		End for   //Done line
		
	: ($nValueLength<=$nMaxLength)  //One line
		
		If (OB Is defined:C1231($oParse; $tLineNumber))
			
			OB SET:C1220($oParse; $tLineNumber; $oParse.tValue)
			
		End if 
		
	: ($nNumberOfLines>0)  //Abbreviate
		
		For ($nLine; 1; $nNumberOfLines)  //Line
			
			$cLineWord:=Split string:C1554($atLine{$nLine}; CorektSpace; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			
			For each ($tWord; $cLineWord)  //Word
				
				$cWord.push($tWord)
				
			End for each   //Done word
			
		End for   //Done line
		
		ARRAY TEXT:C222($atWord; 0)
		COLLECTION TO ARRAY:C1562($cWord; $atWord)
		$nNumberOfWords:=Size of array:C274($atWord)
		
		For ($nWord; $nNumberOfWords; 1; -1)  //Words
			
			$atWord{$nWord}:=Core_Text_AbbreviateT($atWord{$nWord})
			$tValue:=Core_Array_ToTextT(->$atWord; CorektSpace)
			
			ARRAY TEXT:C222($atLine; 0)
			TEXT TO ARRAY:C1149($tValue; $atLine; $nWidthInPixels; $tFontName; $nFontSize)
			
			If (Size of array:C274($atLine)<=$nMaxLines)  //Fits
				
				$oParse.tValue:=$tValue
				
				Core_Parse_Text($oParse)
				
				$nLine:=CoreknNoMatchFound  //Terminate the loop
				
			End if   //Done fits
			
		End for   //Done words
		
		If ($nLine#CoreknNoMatchFound)  //Too many lines
			
			For ($nLine; 1; $nMaxLines)  //Lines
				
				$tLineNumber:="tLine"+String:C10($nLine)
				
				If (OB Is defined:C1231($oParse; $tLineNumber))
					
					OB SET:C1220($oParse; $tLineNumber; $atLine{$nLine})
					
				End if 
				
			End for   //Done lines
			
		End if   //Done too many lines
		
	Else   //Build
		
		Core_Text_ParseToArray($oParse.tValue; ->$atWord; CorektSpace)
		
		$nNumberOfWords:=Size of array:C274($atWord)
		
		For ($nWord; 1; $nNumberOfWords)  //Words
			
			$tWord:=$atWord{$nWord}
			
			$nWordLength:=Length:C16($tWord)
			$nLineLength:=Length:C16($tLine)
			
			If ($nWordLength>=$nMaxLength)  //Truncate word
				
				$tWord:=Substring:C12($tWord; 1; $nMaxLengthh)
				$nWordLength:=Length:C16($tWord)
				
			End if   //Done truncate word
			
			Case of   //Line
					
				: ($nLine=$oParse.nMaxLine)  //Last line
					
					For ($nWord; $nWord+1; $nNumberOfWords)  //Remaining
						
						$tWord:=$tWord+CorektSpace+$atWord{$nWord}
						
					End for   //Done remaining
					
					$tLine:=$tLine+CorektSpace+$tWord
					
					If (OB Is defined:C1231($oParse; $tLineNumber))
						
						OB SET:C1220($oParse; $tLineNumber; Substring:C12($tLine; 1; $nMaxLength))
						
					End if 
					
				: (($nLineLength+$nWordLength-1)>$nMaxLength)  //Full (-1 is for space)
					
					If (OB Is defined:C1231($oParse; $tLineNumber))
						
						OB SET:C1220($oParse; $tLineNumber; $tLine)
						
					End if 
					
					$nLine:=$nLine+1
					$tLine:=$tWord
					
					$tLineNumber:="tLine"+String:C10($nLine)
					
				: (($nLineLength+$nWordLength-1)=$nMaxLength)  //Exact (-1 is for space)
					
					If (OB Is defined:C1231($oParse; $tLineNumber))
						
						OB SET:C1220($oParse; $tLineNumber; $tLine+$tWord)
						
					End if 
					
					$nLine:=$nLine+1
					$tLine:=CorektBlank
					
					$tLineNumber:="tLine"+String:C10($nLine)
					
				Else   //Build
					
					$tLine:=Choose:C955(\
						($tLine=CorektBlank); \
						$tWord; \
						$tLine+CorektSpace+$tWord)
					
			End case   //Done line
			
		End for   //Done words
		
End case   //Done evaluate
