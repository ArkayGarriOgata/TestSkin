//%attributes = {}
//Method:  Core_User_IsUserB(nUserNumber)=>bIsUser
//Description:  This method validates nUserNumber is indeed a user number

If (True:C214)  //Initialize 
	
	C_BOOLEAN:C305($0; $bIsUser)
	C_LONGINT:C283($1; $nUserNumber)
	
	ARRAY TEXT:C222($atUser; 0)
	ARRAY LONGINT:C221($anUserNumber; 0)
	
	$nUserNumber:=$1
	$bIsUser:=False:C215
	
	GET USER LIST:C609($atUser; $anUserNumber)
	
End if   //Done Initialize

$bIsUser:=(Find in array:C230($anUserNumber; $nUserNumber)#CoreknNoMatchFound)

$0:=$bIsUser
