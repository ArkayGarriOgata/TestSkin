//%attributes = {"invisible":true,"shared":true}
//Method:  Core_Macro_Parameter([tMethodNameParameter])=>[tCodeStart]
//Description:  This method will help create code for a new method

If (True:C214)  //Initialize
	
	C_TEXT:C284($tMethodDefinition)
	
	C_TEXT:C284($tMethodTemplate; $tParameterDeclaration; $tParameterAssignment; $tCompilerDeclaration)
	C_LONGINT:C283($nLeftParen; $nReturn; $nStart; $nNumberOfCharacters; $nParameterNumber; $nCharacter)
	C_LONGINT:C283($nNumberOfParameters; $nParameterElement)
	C_TEXT:C284($tParameterName; $tCurrentType; $tNextType; $tMethodName)
	C_TEXT:C284($tCharacter)
	C_BOOLEAN:C305($bltReturnValue; $bltOptionalParameter; $bltParameterDefined)
	C_POINTER:C301($pNull)
	
	ARRAY LONGINT:C221($anParameterNumber; 0)  //Array for parameter number
	ARRAY TEXT:C222($atParameterName; 0)  //Array for the variable name to use
	ARRAY TEXT:C222($atParameterType; 0)  //Array for type
	ARRAY BOOLEAN:C223($abOpitionalParameter; 0)  //Array for optional parameter or not
	
	$tMethodTemplate:=CorektBlank
	$tParameterDeclaration:=CorektBlank
	$tParameterAssignment:=CorektBlank
	$tCompilerDeclaration:=CorektBlank
	
	$nStart:=0
	
	$tParameterName:=CorektBlank
	$bltReturnValue:=False:C215
	$bltOptionalParameter:=False:C215
	
	$nParameterNumber:=0
	
	$pNull:=Null:C1517
	
	GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $tMethodDefinition)
	
	$nLeftParen:=Position:C15(CorektLeftParen; $tMethodDefinition)  //Find the (
	$nReturn:=Position:C15("="; $tMethodDefinition)
	
	Case of 
			
		: ($nLeftParen>0)  //we have Parameters
			
			$nStart:=$nLeftParen+1  //Skip the (
			
		: ($nReturn>0)  //no parameters but a return value
			
			$nStart:=$nReturn+2  //Skip the = and the >
			$bltReturnValue:=True:C214
			
	End case 
	
End if   //Done Initialize

$tMethodTemplate:="//Method:"+CorektSpace+CorektSpace+$tMethodDefinition+CorektCR
$tMethodTemplate:=$tMethodTemplate+"//Description:  This method "+CorektDoubleSpace

If ($nStart>0)  //We have either parameters and/or a return value
	
	$tMethodTemplate:=$tMethodTemplate+"If(True) //Initialize "+CorektDoubleSpace
	$nNumberOfCharacters:=Length:C16($tMethodDefinition)
	
	For ($nCharacter; $nStart; $nNumberOfCharacters)  //Loop through all the characters
		
		$tCharacter:=$tMethodDefinition[[$nCharacter]]  //Get a character
		
		Case of   //What type of character did we find
				
			: ($tCharacter="{")  //start of optional parameter
				$bltParameterDefined:=False:C215
				
			: ($tCharacter=";")  //is the character ; this starts a new parameter
				$bltParameterDefined:=True:C214
				
			: ($tCharacter="}")  //end of optional parameter
				$bltParameterDefined:=True:C214
				$bltOptionalParameter:=True:C214
				
			: ($tCharacter=")")  //end of parameters
				
				$bltParameterDefined:=True:C214
				
			: ($tCharacter="=")  //start of return character
				$bltReturnValue:=True:C214
				$bltParameterDefined:=True:C214
				
			: ($tCharacter=">")  //end of return parameter
				$bltReturnValue:=True:C214
				$bltParameterDefined:=True:C214
				
			: ($nCharacter=$nNumberOfCharacters)  //We've defined a return value (this is already set to true)
				$tParameterName:=$tParameterName+$tCharacter  //continue getting the parameter name
				$bltParameterDefined:=True:C214
				
			Else   //its part of the parameter
				
				$tParameterName:=$tParameterName+$tCharacter  //continue getting the parameter name
				$bltParameterDefined:=False:C215
				
		End case   //Done what type of character did we find
		
		If ($bltParameterDefined) & ($tParameterName#CorektBlank)  //The parameter is now defined and it isn't just a function without any parameters
			
			$nParameterNumber:=Choose:C955(($bltReturnValue | ($tParameterName=CorektBlank)); 0; $nParameterNumber+1)  //Is this a return value
			
			APPEND TO ARRAY:C911($anParameterNumber; $nParameterNumber)  //Store the parameter number
			APPEND TO ARRAY:C911($atParameterName; $tParameterName)  //Store the variable name
			APPEND TO ARRAY:C911($atParameterType; $tParameterName[[1]])  //Store the type
			APPEND TO ARRAY:C911($abOpitionalParameter; $bltOptionalParameter)  //Store if this is an optional parameter 
			
			$tParameterName:=CorektBlank
			$bltReturnValue:=False:C215
			$bltOptionalParameter:=False:C215
			
		End if   //Done character ends the parameter name
		
	End for   //Done looping through the characters
	
	SORT ARRAY:C229($atParameterType; $atParameterName; $anParameterNumber; $abOpitionalParameter; >)  //order by type
	
	$nParameterElement:=1
	
	$tCurrentType:=$atParameterType{$nParameterElement}  //Get the start type
	
	$tParameterDeclaration:=Core_Compiler_SetDeclarationT($tCurrentType)
	$tParameterDeclaration:=$tParameterDeclaration+"$"+String:C10($anParameterNumber{$nParameterElement})+";"
	$tParameterDeclaration:=$tParameterDeclaration+"$"+$atParameterName{$nParameterElement}+";"
	
	$tCompilerDeclaration:=$tCompilerDeclaration+Core_Compiler_SetDeclarationT($tCurrentType)
	$tCompilerDeclaration:=$tCompilerDeclaration+"$"+String:C10($anParameterNumber{$nParameterElement})+";"
	
	$nNumberOfParameters:=Size of array:C274($atParameterType)
	
	For ($nParameterElement; 2; $nNumberOfParameters)  //loop through the parameters
		
		$tNextType:=$atParameterType{$nParameterElement}
		
		If ($tNextType=$tCurrentType)  //Is the type same or different
			
			$tParameterDeclaration:=$tParameterDeclaration+"$"+String:C10($anParameterNumber{$nParameterElement})+";"
			$tParameterDeclaration:=$tParameterDeclaration+"$"+$atParameterName{$nParameterElement}+";"
			
			$tCompilerDeclaration:=$tCompilerDeclaration+"$"+String:C10($anParameterNumber{$nParameterElement})+";"
			
		Else   //Different type
			
			$tParameterDeclaration:=Substring:C12($tParameterDeclaration; 1; Length:C16($tParameterDeclaration)-1)  //remove the last ;
			$tParameterDeclaration:=$tParameterDeclaration+")"+CorektCR  //Add the closing parenthesis and CR
			
			$tCompilerDeclaration:=Substring:C12($tCompilerDeclaration; 1; Length:C16($tCompilerDeclaration)-1)  //remove the last ;
			$tCompilerDeclaration:=$tCompilerDeclaration+")"+CorektCR  //Add the closing parenthesis and CR
			
			$tCurrentType:=$tNextType  //Start new type
			
			$tParameterDeclaration:=$tParameterDeclaration+Core_Compiler_SetDeclarationT($tCurrentType)
			$tParameterDeclaration:=$tParameterDeclaration+"$"+String:C10($anParameterNumber{$nParameterElement})+";"
			$tParameterDeclaration:=$tParameterDeclaration+"$"+$atParameterName{$nParameterElement}+";"
			
			$tCompilerDeclaration:=$tCompilerDeclaration+Core_Compiler_SetDeclarationT($tCurrentType)
			$tCompilerDeclaration:=$tCompilerDeclaration+"$"+String:C10($anParameterNumber{$nParameterElement})+";"
			
		End if   //Done same type or different type
		
	End for   //Done looping through the parameters
	
	$tParameterDeclaration:=Substring:C12($tParameterDeclaration; 1; Length:C16($tParameterDeclaration)-1)  //remover the last ;
	$tParameterDeclaration:=$tParameterDeclaration+")"+CorektDoubleSpace  //Add the closing parenthesis and CR
	
	$tCompilerDeclaration:=Substring:C12($tCompilerDeclaration; 1; Length:C16($tCompilerDeclaration)-1)  //remover the last ;
	$tCompilerDeclaration:=$tCompilerDeclaration+")"+CorektDoubleSpace  //Add the closing parenthesis and CR
	
	If (Find in array:C230($abOpitionalParameter; True:C214)>0)  //Any opitional parameters
		$tParameterDeclaration:=$tParameterDeclaration+Command name:C538(283)+"($nNumberOfParameters)"+CorektCR  //C_LONGINT
		$tParameterDeclaration:=$tParameterDeclaration+"$nNumberOfParameters:=Count Parameters"+CorektDoubleSpace
	End if   //Done any optional parameters
	
	$tMethodTemplate:=$tMethodTemplate+$tParameterDeclaration
	
	//Build the assignment code
	SORT ARRAY:C229($anParameterNumber; $abOpitionalParameter; $atParameterType; $atParameterName; >)  //order by Optional Parameter
	$tParameterAssignment:=CorektBlank
	
	For ($nParameterElement; 1; $nNumberOfParameters)  //loop through the parameters to build assignment code
		
		Case of 
				
			: ($anParameterNumber{$nParameterElement}=0)  //Not the return value
				
			: ($abOpitionalParameter{$nParameterElement})  //Its an optional parameter
				
				$tType:=Core_Variable_GetTypeT($atParameterName{$nParameterElement}; True:C214; True:C214)
				$tDefaultType:=Core_Variable_DefaultT($pNull; $tType)
				
				$tParameterAssignment:=$tParameterAssignment+"$"+$atParameterName{$nParameterElement}+" := Choose(($nNumberOfParameters >="
				$tParameterAssignment:=$tParameterAssignment+String:C10($anParameterNumber{$nParameterElement})+");"
				$tParameterAssignment:=$tParameterAssignment+"$"+String:C10($anParameterNumber{$nParameterElement})+";"
				$tParameterAssignment:=$tParameterAssignment+$tDefaultType+")"+CorektDoubleSpace
				
			Else   //Not optional
				
				$tParameterAssignment:=$tParameterAssignment+"$"+$atParameterName{$nParameterElement}+" := $"+String:C10($anParameterNumber{$nParameterElement})+CorektCR
				
		End case 
		
	End for   //Done looping through the parameters to build assignment code
	
	$tParameterAssignment:=$tParameterAssignment+"End if //Done Initialize"+CorektDoubleSpace
	
	If ($anParameterNumber{1}=0)  //Build the return code
		
		$tParameterAssignment:=$tParameterAssignment+"$0:=$"+$atParameterName{1}
		
	End if   //Done build the return code
	
	$tMethodName:=Substring:C12($tMethodDefinition; 1; $nLeftParen-1)
	$tCompilerDeclaration:=Core_Macro_CompilerDeclarationT($tMethodName; $tCompilerDeclaration)  //Get the parameter declarations for the compiler definition code before assigning default values
	
	$tMethodTemplate:=$tMethodTemplate+$tParameterAssignment+CorektDoubleSpace+$tCompilerDeclaration  //Add it to the end so it is easy to see and then delete
	
End if   //Done we have either parameters and/or a return value

SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $tMethodTemplate)

SET TEXT TO PASTEBOARD:C523($tMethodTemplate)