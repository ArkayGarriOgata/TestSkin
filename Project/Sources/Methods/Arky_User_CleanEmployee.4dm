//%attributes = {}
//Method:  Arky_User_CleanEmployee(patEmployee)
//Description:  This method will clean up employee names
//.   after they are imported

If (True:C214)
	
	C_POINTER:C301($1; $patEmployee)
	
	C_LONGINT:C283($nComma; $nEmployee)
	C_LONGINT:C283($nEnd; $nSpace)
	
	C_TEXT:C284($tFirstName; $tLastName)
	
	$patEmployee:=$1
	
End if 

For ($nEmployee; 1; Size of array:C274($patEmployee->))  //Employee
	
	$nComma:=Position:C15(CorektComma; $patEmployee->{$nEmployee})
	
	$tLastName:=Substring:C12($patEmployee->{$nEmployee}; 1; $nComma-1)
	
	$tFirstName:=Substring:C12($patEmployee->{$nEmployee}; $nComma+2)  //,<space>
	
	$nSpace:=Position:C15(CorektSpace; $tFirstName)
	
	$nEnd:=Choose:C955(($nSpace>0); $nSpace-1; Length:C16($tFirstName))
	
	$tFirstName:=Substring:C12($tFirstName; 1; $nEnd)
	
	Core_Text_Clean(->$tFirstName)
	Core_Text_Clean(->$tLastName)
	
	$patEmployee->{$nEmployee}:=$tFirstName+CorektSpace+$tLastName
	
End for   //Done employee

