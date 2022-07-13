//%attributes = {}
//Method: Core_VdVl_Initialize(tPhase)
//Description: This method will initialize the Core_VdVl table

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	C_TEXT:C284($tCore_ValidValue_Key; $tProperty)
	C_TEXT:C284($tItem)
	C_TEXT:C284($tTableName; $tQuery)
	
	C_POINTER:C301($patHListKey1)
	
	C_BOOLEAN:C305($bExpanded)
	
	C_LONGINT:C283($nItemReference)
	C_LONGINT:C283($nNumberOfProperites; $nNumberOfValues)
	C_LONGINT:C283($nProperty; $nSubListReference)
	C_LONGINT:C283($nValue)
	
	C_OBJECT:C1216($esCoreValidValue; $eCoreValidValue)
	
	ARRAY TEXT:C222($atProperty; 0)
	ARRAY LONGINT:C221($anPropertyType; 0)
	
	ARRAY TEXT:C222($atValue; 0)
	
	$tPhase:=$1
	
	$tTableName:=Table name:C256(->[Core_ValidValue:69])
	$tQuery:=CorektBlank
	
	$esCoreValidValue:=New object:C1471()
	$eCoreValidValue:=New object:C1471()
	
End if   //Done initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		Core_VdVl_Initialize(CorektPhaseClear)
		
		GET LIST ITEM:C378(CorenHList1; *; $nItemReference; $tItem; $nSubListReference; $bExpanded)
		
		$patHListKey1:=Get pointer:C304("CoreatHListKey1")
		
		$tCore_ValidValue_Key:=$patHListKey1->{$nItemReference}
		
		$tQuery:="Core_ValidValue_Key = "+CorektSingleQuote+$tCore_ValidValue_Key+CorektSingleQuote
		
		$esCoreValidValue:=ds:C1482[$tTableName].query($tQuery)
		
		If ($esCoreValidValue.length=1)  //Unique
			
			$eCoreValidValue:=$esCoreValidValue.first()
			
			Core_tVdVl_Category:=$eCoreValidValue.Category
			Core_tVdVl_Identifier:=$eCoreValidValue.Identifier
			
			If ($eCoreValidValue.ValidValue#Null:C1517)
				
				OB GET PROPERTY NAMES:C1232($eCoreValidValue.ValidValue; $atProperty; $anPropertyType)
				
			End if 
			
			$nNumberOfProperites:=Size of array:C274($atProperty)
			
			For ($nProperty; 1; $nNumberOfProperites)  //Property
				
				$tProperty:=$atProperty{$nProperty}
				
				OB GET ARRAY:C1229($eCoreValidValue.ValidValue; $tProperty; $atValue)
				
				$nNumberOfValues:=Size of array:C274($atValue)
				
				For ($nValue; 1; $nNumberOfValues)  //Value
					
					APPEND TO ARRAY:C911(Core_atVdVl_Identifier; $tProperty)
					APPEND TO ARRAY:C911(Core_atVdVl_Value; $atValue{$nValue})
					
				End for   //Done value
				
			End for   //Done property
			
		End if   //Done unique
		
		Core_VdVl_Manager($tPhase)
		
	: ($tPhase=CorektPhaseInitialize)
		
		Core_VdVl_Initialize(CorektPhaseClear)
		
		$esCoreValidValue:=ds:C1482[$tTableName].all()
		
		Core_VdVl_LoadHList($esCoreValidValue)
		
		Core_VdVl_Manager($tPhase)
		
	: ($tPhase=CorektPhaseClear)
		
		Compiler_Core_Array(Current method name:C684; 0)
		
		Core_tVdVl_Category:=CorektBlank
		Core_tVdVl_Identifier:=CorektBlank
		
		If (Form event code:C388=On Load:K2:1)
			
			Core_tVdVl_Find:=CorektBlank
			
		End if 
		
End case   //Done phase