//%attributes = {}
//Method:  Core_Array_Combine(papPart;paCombined{;tSeperator})
//Description:  This method will loop through the arrays in Part and 
//    put them into the array combined.

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $2; $papPart; $paCombined)
	C_TEXT:C284($3; $tSeperator)
	C_LONGINT:C283($nColumn; $nNumberOfColumns; $nRow; $nNumberOfRows)
	C_POINTER:C301($pColumn)
	C_TEXT:C284($tCombined)
	C_LONGINT:C283($nNumberOfParamters)
	
	$papPart:=$1
	$paCombined:=$2
	
	$nNumberOfParamters:=Count parameters:C259
	
	$tSeperator:=CorektBlank
	
	If ($nNumberOfParamters>=3)
		$tSeperator:=$3
	End if 
	
	$nNumberOfColumns:=Size of array:C274($papPart->)
	
	$pColumn:=$papPart->{1}
	
	$nNumberOfRows:=Size of array:C274($pColumn->)
	
End if   //Done Initialize

For ($nRow; 1; $nNumberOfRows)  //Loop through the rows
	
	$tCombined:=CorektBlank
	
	For ($nColumn; 1; $nNumberOfColumns)  //Loop through the columns
		
		$pColumn:=$papPart->{$nColumn}
		
		$tCombined:=$tCombined+$tSeperator+$pColumn->{$nRow}
		
	End for   //Done looping columns
	
	$tCombined:=Substring:C12($tCombined; Length:C16($tSeperator)+1)  //Remove the seperator at the beginning
	
	APPEND TO ARRAY:C911($paCombined->; $tCombined)
	
End for   //Done looping rows