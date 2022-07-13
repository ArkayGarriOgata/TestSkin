//%attributes = {}
//Method:  Core_VdVl_Save
//Description: This method will save the information on
// the Core_VdVl form

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nIdentifier; $nNumberOfIdentifiers)
	C_LONGINT:C283($nValue; $nNumberOfValues)
	
	C_TEXT:C284($tBlank)
	
	C_OBJECT:C1216($oValidValue)
	C_OBJECT:C1216($oCoreValidValue)
	
	ARRAY TEXT:C222($atIdentifier; 0)
	ARRAY TEXT:C222($atValue; 0)
	ARRAY TEXT:C222($atValidValue; 0)
	
	$tBlank:=CorektBlank
	
	$oValidValue:=New object:C1471()  //ValidValue field object
	$oCoreValidValue:=New object:C1471()  //Core_ValidValue record object
	
	COPY ARRAY:C226(Core_atVdVl_Identifier; $atIdentifier)
	COPY ARRAY:C226(Core_atVdVl_Value; $atValue)
	
End if   //Done initialize

Core_Array_Remove(->$atIdentifier; ->$tBlank)
Core_Array_Remove(->$atValue; ->$tBlank)

$nNumberOfIdentifiers:=Size of array:C274($atIdentifier)
$nNumberOfValues:=Size of array:C274($atValue)

Case of   //Equal
		
	: ($nNumberOfIdentifiers=$nNumberOfValues)
	: ($nNumberOfIdentifiers<$nNumberOfValues)
		
		For ($nIdentifier; 1; ($nNumberOfValues-$nNumberOfIdentifiers))  //Identifier
			
			APPEND TO ARRAY:C911($atIdentifier; $atIdentifier{$nNumberOfIdentifiers})
			
		End for   //Done Identifier
		
	: ($nNumberOfIdentifiers>$nNumberOfValues)
		
		For ($nValue; 1; ($nNumberOfIdentifiers-$nNumberOfValues))  //Value
			
			APPEND TO ARRAY:C911($atValue; CorektBlank)
			
		End for   //Value
		
End case   //Done equal

MULTI SORT ARRAY:C718($atIdentifier; >; $atValue; >)

For ($nIdentifier; 1; $nNumberOfIdentifiers)  //Identifier
	
	$tCurrentIdentifier:=$atIdentifier{$nIdentifier}
	
	Case of   //Valid value
			
		: (($nIdentifier=1) & ($nNumberOfIdentifiers=1))  //Start and end
			
			$tIdentifier:=$atIdentifier{$nIdentifier}
			APPEND TO ARRAY:C911($atValidValue; $atValue{$nIdentifier})
			
			OB SET ARRAY:C1227($oValidValue; $tIdentifier; $atValidValue)
			
		: ($nIdentifier=1)  //Start
			
			$tIdentifier:=$atIdentifier{$nIdentifier}
			
			APPEND TO ARRAY:C911($atValidValue; $atValue{$nIdentifier})
			
		: ($nIdentifier=$nNumberOfIdentifiers)  //End
			
			If ($tIdentifier=$tCurrentIdentifier)  //Identifier
				
				APPEND TO ARRAY:C911($atValidValue; $atValue{$nIdentifier})
				
				OB SET ARRAY:C1227($oValidValue; $tIdentifier; $atValidValue)
				
			Else   //Different
				
				OB SET ARRAY:C1227($oValidValue; $tIdentifier; $atValidValue)
				
				ARRAY TEXT:C222($atValidValue; 0)
				
				$tIdentifier:=$tCurrentIdentifier
				
				APPEND TO ARRAY:C911($atValidValue; $atValue{$nIdentifier})
				
				OB SET ARRAY:C1227($oValidValue; $tIdentifier; $atValidValue)
				
			End if   //Done identifier
			
		: ($tIdentifier=$tCurrentIdentifier)  //
			
			APPEND TO ARRAY:C911($atValidValue; $atValue{$nIdentifier})
			
		Else   //Set the array
			
			OB SET ARRAY:C1227($oValidValue; $tIdentifier; $atValidValue)
			
			ARRAY TEXT:C222($atValidValue; 0)
			
			APPEND TO ARRAY:C911($atValidValue; $atValue{$nIdentifier})
			
			$tIdentifier:=$atIdentifier{$nIdentifier}
			
	End case   //Done valid value
	
End for   //Done Identifier

$oCoreValidValue.Category:=Core_tVdVl_Category
$oCoreValidValue.Identifier:=Core_tVdVl_Identifier
$oCoreValidValue.ValidValue:=$oValidValue

Core_VdVl_Commit($oCoreValidValue)

Core_VdVl_Initialize(CorektPhaseInitialize)

