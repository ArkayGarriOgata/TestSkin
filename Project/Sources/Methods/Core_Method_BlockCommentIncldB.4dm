//%attributes = {}
//Method: Core_Method_BlockCommentIncldB(ptMethodCode;ptLine)=>bInclude
//Description:  This method will determine if a line is a comment or not

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $ptMethodCode; $2; $ptLine)
	C_BOOLEAN:C305($0; $bInclude)
	
	C_TEXT:C284($tFirstCharacter)
	
	$ptMethodCode:=$1
	$ptLine:=$2
	
	$bInclude:=True:C214
	
End if   //Done initialize

If (Length:C16($ptMethodCode->)>0)  //Line to process
	
	$tFirstCharacter:=$ptMethodCode->[[1]]
	
	Case of   //Include line
		: ($tFirstCharacter="/")  //Starts with /
		: ($tFirstCharacter=CorektCR)  //Starts with CR
		: ($tFirstCharacter=CorektSpace)  //Starts with Space
		Else   //Don't include line
			
			$bInclude:=False:C215
			
	End case   //Done include line
	
Else   //No line
	
	$bInclude:=False:C215
	
End if   //Done line to process

If ($bInclude)  //Include
	
	$ptMethodCode->:=Core_Text_RemoveLineT($ptMethodCode->; $ptLine)
	
	$ptLine->:=Replace string:C233($ptLine->; "//"; CorektBlank)
	
End if   //Done include

$0:=$bInclude