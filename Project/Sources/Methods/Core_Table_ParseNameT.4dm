//%attributes = {}
//Name:  Core_Table_ParseNameT(tTableField)=>tTableName
//Description: This method will parse a [TableName]FieldName=>TableName

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tTableField)
	C_TEXT:C284($0; $tTableName)
	
	C_LONGINT:C283($nLeftBracket; $nRightBracket)
	C_LONGINT:C283($nStart; $nNumberOfCharacters)
	
	$tTableField:=$1
	$tTableName:=CorektBlank
	
End if   //Done initialize

$nLeftBracket:=Position:C15(CorektLeftBracket; $tTableField)
$nRightBracket:=Position:C15(CorektRightBracket; $tTableField)

Case of   //Parse
		
	: ($nLeftBracket=CoreknNoMatchFound)
	: ($nRightBracket=CoreknNoMatchFound)
	: ($nRightBracket<=($nLeftBracket+1))
		
	Else   //Parseable
		
		$nStart:=$nLeftBracket+1
		$nNumberOfCharacters:=($nRightBracket-$nStart)
		
		$tTableName:=Substring:C12($tTableField; $nStart; $nNumberOfCharacters)
		
End case   //Done parse

$0:=$tTableName