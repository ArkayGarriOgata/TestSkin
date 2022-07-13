//%attributes = {"invisible":true,"shared":true}
//Method:  Core_Macro_GetMethodNameT(tMethodCode)=>tMethodName
//Description:  This method 

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tMethodCode; $0; $tMethodName)
	
	C_LONGINT:C283($nMethodCarriageReturn; $nMethodColon; $nMethodEqual; $nMethodLeftParenthese; $nNumberOfCharacters)
	C_LONGINT:C283($nMethodStart)
	
	C_BOOLEAN:C305($bContinue)
	
	ARRAY TEXT:C222($atRemoveCharacter; 0)
	
	$tMethodCode:=$1
	$tMethodName:=CorektBlank
	
	$nMethodColon:=Position:C15("Method:"; $tMethodCode)
	
	$nMethodLeftParenthese:=Position:C15("("; $tMethodCode)
	$nMethodEqual:=Position:C15("="; $tMethodCode)
	$nMethodCarriageReturn:=Position:C15(CorektCR; $tMethodCode)
	
	If ($nMethodColon>0)
		$nMethodStart:=8+5  //For some reason 4D puts 5 special characters in the method that are invisible to us
	Else 
		$nMethodStart:=1+5  //For some reason 4D puts 5 special characters in the method that are invisible to us
	End if 
	
	APPEND TO ARRAY:C911($atRemoveCharacter; CorektCR)
	APPEND TO ARRAY:C911($atRemoveCharacter; CorektSpace)
	
End if   //Done Initialize

Case of   //Get $nNumberOfCharacters
		
	: ($nMethodLeftParenthese>0)
		
		$nNumberOfCharacters:=$nMethodLeftParenthese-$nMethodStart
		
	: ($nMethodEqual>0)
		
		$nNumberOfCharacters:=$nMethodEqual-$nMethodStart
		
	: ($nMethodCarriageReturn>0)
		
		$nNumberOfCharacters:=$nMethodCarriageReturn-$nMethodStart
		
End case   //Done get $nNumberOfCharacters

$tMethodName:=Substring:C12($tMethodCode; $nMethodStart; $nNumberOfCharacters)

$tMethodName:=Core_Text_RemoveT($tMethodName; ->$atRemoveCharacter; 3)

$0:=$tMethodName