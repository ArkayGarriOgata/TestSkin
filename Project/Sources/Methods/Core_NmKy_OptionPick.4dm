//%attributes = {}
//Method:  Core_NmKy_Option
//Description: This method will ask to save the values in the arrays
//  This can later be brought up as needed see Core_NmKy_OptionPick

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($cIdentifier)
	
	C_TEXT:C284($tPickCategory; $tCategory)
	
	ARRAY TEXT:C222($atName; 0)
	
	$cIdentifier:=New collection:C1472()
	
	$tCategory:="Core_NmKy"
	
	$tBlank:=CorektBlank
	
End if   //Done initialize

$cIdentifier:=Core_VdVl_FillIdentifierC($tCategory)  //Get identifier for category Core_NmKy

COLLECTION TO ARRAY:C1562($cIdentifier; $atName; "Identifier")

$tPickCategory:=Core_Array_CreatePopupMenuT(->$atName)  //Use as dropdown

$nElement:=Pop up menu:C542($tPickCategory)

Case of   //Picked a name
		
	: ($nElement<1)
	: ($atName{$nElement}=CorektBlank)
		
	Else   //Picked
		
		$tName:=$atName{$nElement}
		
		Core_Array_Clear(->Core_atNmKy_Name)  //Clear the arrays 
		Core_Array_Clear(->Core_atNmKy_NameValue)
		Core_Array_Clear(->Core_atNmKy_Key)
		Core_Array_Clear(->Core_atNmKy_KeyValue)
		
		$oValidValue:=Core_VdVl_GetValidValueO($tCategory; $tName)  //Get the array values
		
		If (OB Is defined:C1231($oValidValue; "Name"))
			
			OB GET ARRAY:C1229($oValidValue; "Name"; Core_atNmky_Name)  //Fill in arrays
			Core_Array_FillWithValue(->Core_atNmKy_Name; ->$tBlank; 25; Size of array:C274(Core_atNmKy_Name)+1)
			
		End if 
		
		If (OB Is defined:C1231($oValidValue; "NameValue"))
			
			OB GET ARRAY:C1229($oValidValue; "NameValue"; Core_atNmky_NameValue)  //Fill in arrays
			Core_Array_FillWithValue(->Core_atNmky_NameValue; ->$tBlank; 25; Size of array:C274(Core_atNmky_NameValue)+1)
			
		End if 
		
		If (OB Is defined:C1231($oValidValue; "Key"))
			
			OB GET ARRAY:C1229($oValidValue; "Key"; Core_atNmky_Key)  //Fill in arrays
			Core_Array_FillWithValue(->Core_atNmky_Key; ->$tBlank; 25; Size of array:C274(Core_atNmky_Key)+1)
			
		End if 
		
		If (OB Is defined:C1231($oValidValue; "KeyValue"))
			
			OB GET ARRAY:C1229($oValidValue; "KeyValue"; Core_atNmky_KeyValue)  //Fill in arrays
			Core_Array_FillWithValue(->Core_atNmKy_KeyValue; ->$tBlank; 25; Size of array:C274(Core_atNmKy_KeyValue)+1)
			
		End if 
		
End case   //Done picked a name
