//%attributes = {}
//Method:  Core_Array_CreatePopupMenuT(patMenuItem)=>tMenuChoice
//Description:  This method will loop through the arrays in Part and 
//    put them into the array combined.

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patMenuItem)
	C_TEXT:C284($0; $tMenuChoice)
	C_LONGINT:C283($nNumberOfItems)
	C_LONGINT:C283($nItem)
	
	$patMenuItem:=$1
	$tMenuChoice:=CorektBlank
	
	$nNumberOfItems:=Size of array:C274($patMenuItem->)
	
End if   //Done Initialize

For ($nItem; 1; $nNumberOfItems)  //Loop thru items
	
	$tMenuChoice:=$tMenuChoice+$patMenuItem->{$nItem}+CorektSemiColon
	
End for   //Done loop thru items

$tMenuChoice:=Delete string:C232($tMenuChoice; Length:C16($tMenuChoice); 1)

$0:=$tMenuChoice