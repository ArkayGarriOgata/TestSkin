//%attributes = {}
//Method:  Core_User_DocRemove({tMethod})
//Description:  This method creates a document of users that should be removed

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tMethod)
	
	C_LONGINT:C283($nUser; $nNumberOfUsers)
	
	ARRAY TEXT:C222($atUser; 0)
	ARRAY LONGINT:C221($anUserNumber; 0)
	
	ARRAY TEXT:C222($atValidUser; 0)
	ARRAY TEXT:C222($atRemoveUser; 0)
	
	$tMethod:=CorektBlank
	If (Count parameters:C259>=1)
		$tMethod:=$1
	End if 
	
	GET USER LIST:C609($atUser; $anUserNumber)
	
	$nNumberOfUsers:=Size of array:C274($atUser)
	
End if   //Done Initialize

ARRAY POINTER:C280($apColumn; 0)
APPEND TO ARRAY:C911($apColumn; ->$atValidUser)
Core_Array_FromDocument(->$apColumn)

If ($tMethod#CorektBlank)
	EXECUTE METHOD:C1007($tMethod; *; ->$atValidUser)
End if 

SORT ARRAY:C229($atUser; >)
SORT ARRAY:C229($atValidUser; >)

For ($nUser; 1; $nNumberOfUsers)  //Users
	
	Case of   //Employee
			
		: (Position:C15(CorektSpace; $atUser{$nUser})=CoreknNoMatchFound)  //Do not check
			
		: (Find in array:C230($atValidUser; $atUser{$nUser})=CoreknNoMatchFound)  //Not an employee
			
			APPEND TO ARRAY:C911($atRemoveUser; $atUser{$nUser})
			
	End case   //Done employee
	
End for   //Done users

ARRAY POINTER:C280($apColumn; 0)
APPEND TO ARRAY:C911($apColumn; ->$atRemoveUser)
Core_Array_ToDocument(->$apColumn)