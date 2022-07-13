//%attributes = {}
//Method: Skin_Entr_Initialize(tPhase)
//Description: This method will initialize the Skin_Entr form
If (True:C214)  // Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	//C_BOOLEAN($bExpanded)
	
	//C_LONGINT($nItemReference)
	//C_LONGINT($nNumberOfProperites; $nNumberOfValues)
	//C_LONGINT($nProperty; $nSubListReference)
	//C_LONGINT($nValue)
	
	//C_OBJECT($esHelp; $eHelp)
	
	//C_POINTER($patHListKey99)
	
	//C_TEXT($tHelp_Key)
	//C_TEXT($tItem)
	//C_TEXT($tTableName; $tQuery)
	
	//ARRAY TEXT($atProperty; 0)
	//ARRAY LONGINT($anPropertyType; 0)
	
	//ARRAY TEXT($atValue; 0)
	
	$tPhase:=$1
	
	//$tTableName:=Table name(->[Help])
	//$tQuery:=CorektBlank
	
	//$esHelp:=New object()
	//$eHelp:=New object()
	
End if   // Done initialize 

Case of   // Phase
	: ($tPhase=CorektPhaseInitialize)
		Skin_Entr_Initialize(CorektPhaseClear)
		
	: ($tPhase=CorektPhaseClear)
		
		CLEAR LIST:C377(atSelected; *)
		
		//Form.
		
		
End case 