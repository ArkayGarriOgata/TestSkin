//%attributes = {}
// Method: Core_Text_RemoveGremlinsT   (tGremlinText) -> tNoGremlinText
// By: Garri Ogata @ 05/06/21, 10:33:26
// Description:  This method removes gremlins from text
// 
// ----------------------------------------------------

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tGremlinText)
	C_TEXT:C284($0; $tNoGremlinText)
	
	C_LONGINT:C283($nCharacter; $nLastCharacter)
	C_TEXT:C284($tCharacter)
	
	$tGremlinText:=$1
	
	$tNoGremlinText:=CorektBlank
	$tCharacter:=CorektBlank
	
	$nLastCharacter:=Length:C16($tGremlinText)
	
End if   //Done initialize

For ($nCharacter; 1; $nLastCharacter)
	
	$tCharacter:=$tGremlinText[[$nCharacter]]
	
	If (Not:C34(Core_Text_IsGremlinB(Character code:C91($tCharacter))))
		
		$tNoGremlinText:=$tNoGremlinText+$tCharacter
		
	End if 
	
End for 

$0:=$tNoGremlinText