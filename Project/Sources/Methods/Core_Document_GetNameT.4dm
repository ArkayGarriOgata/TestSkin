//%attributes = {}
//Method:  Core_Document_GetNameT({tFullPathname};{nAsciiFolderSeparator})=>tFileName
//Description:  This method uses document if tFullPathname is not passed in

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tFullPathname; $0; $tFileName)
	C_LONGINT:C283($2; $nAsciiFolderSeparator)
	
	C_LONGINT:C283($nAsciiCharacter)
	C_LONGINT:C283($nCharacter; $nEndFileName)
	C_LONGINT:C283($nLengthFilename; $nNumberOfCharacters)
	C_LONGINT:C283($nStartFileName)
	
	C_LONGINT:C283($nNumberOfParameters)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tFullPathname:=Document  //use 4D's document value
	$nAsciiFolderSeparator:=Character code:C91(Folder separator:K24:12)
	
	If ($nNumberOfParameters>=1)  //Parameters
		$tFullPathname:=$1
		If ($nNumberOfParameters>=2)
			$nAsciiFolderSeparator:=$2
		End if 
	End if   //Done parameters
	
	$tFileName:=CorektBlank
	
	$nNumberOfCharacters:=Length:C16($tFullPathname)
	
	$nEndFileName:=0
	$nStartFileName:=0
	
End if   //Done Initialize

For ($nCharacter; $nNumberOfCharacters; 1; -1)  //Pathname
	
	$nAsciiCharacter:=Character code:C91($tFullPathname[[$nCharacter]])
	
	Case of   //Start and end
			
		: ($nAsciiCharacter=$nAsciiFolderSeparator)
			
			$nStartFileName:=$nCharacter+1
			
			$nCharacter:=0
			
		: ($nAsciiCharacter=Period:K15:45)
			
			$nEndFileName:=$nCharacter
			
	End case   //Done start and end
	
End for   //Done pathname

$nLengthFilename:=$nEndFileName-$nStartFileName

$tFileName:=Substring:C12($tFullPathname; $nStartFileName; $nLengthFilename)

$0:=$tFileName