//%attributes = {}
//Method:  User_GetUserIdN({tUserName})=>nUserID 
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_LONGINT:C283($0; $nUserID)
	C_TEXT:C284($1; $tUserName)
	
	C_LONGINT:C283($nNumberOfParameters)
	
	C_LONGINT:C283($nUserID; $nUserIdLocation)
	
	ARRAY LONGINT:C221($anUserID; 0)
	ARRAY TEXT:C222($atUserName; 0)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tUserName:=Current user:C182
	
	If ($nNumberOfParameters>=1)
		$tUserName:=$1
	End if 
	
End if   //Done Initialize

GET USER LIST:C609($atUserName; $anUserID)

$nUserIdLocation:=Find in array:C230($atUserName; $tUserName)

$nUserID:=Choose:C955(\
($nUserIdLocation=CoreknNoMatchFound); \
CoreknNoMatchFound; \
$anUserID{$nUserIdLocation})

$0:=$nUserID
