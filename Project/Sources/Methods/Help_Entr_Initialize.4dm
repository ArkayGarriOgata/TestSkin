//%attributes = {}
//Method: Help_Entr_Initialize(tPhase)
//Description: This method will initialize the Help_Entr form

If (True:C214)  // Initialize
	
	C_TEXT:C284($1; $tPhase)
	
	C_BOOLEAN:C305($bExpanded)
	
	C_LONGINT:C283($nItemReference)
	C_LONGINT:C283($nNumberOfProperites; $nNumberOfValues)
	C_LONGINT:C283($nProperty; $nSubListReference)
	C_LONGINT:C283($nValue)
	
	C_OBJECT:C1216($esHelp; $eHelp)
	
	C_POINTER:C301($patHListKey99)
	
	C_TEXT:C284($tHelp_Key)
	C_TEXT:C284($tItem)
	C_TEXT:C284($tTableName; $tQuery)
	
	ARRAY TEXT:C222($atProperty; 0)
	ARRAY LONGINT:C221($anPropertyType; 0)
	
	ARRAY TEXT:C222($atValue; 0)
	
	$tPhase:=$1
	
	$tTableName:=Table name:C256(->[Help:36])
	$tQuery:=CorektBlank
	
	$esHelp:=New object:C1471()
	$eHelp:=New object:C1471()
	
End if   // Done initialize 

Case of   // Phase
		
	: ($tPhase="Help_Entr_HList")  // set form fields to blank
		
		Form:C1466.tHelp_Key:=CorektBlank
		Form:C1466.tTitle:=CorektBlank
		Form:C1466.tPathName:=CorektBlank
		Form:C1466.tKeyword:=CorektBlank
		
		Help_Entr_Manager
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		GET LIST ITEM:C378(CorenHList99; *; $nItemReference; $tItem; $nSubListReference; $bExpanded)
		
		$patHListKey99:=Get pointer:C304("CoreatHListKey99")
		
		$tHelp_Key:=$patHListKey99->{$nItemReference}
		
		$tQuery:="Help_Key = "+CorektSingleQuote+$tHelp_Key+CorektSingleQuote
		
		$esHelp:=ds:C1482[$tTableName].query($tQuery)
		
		If ($esHelp.length=1)  //Unique
			
			$eHelp:=$esHelp.first()
			
			Form:C1466.tHelp_Key:=$eHelp.Help_Key
			Form:C1466.tCategory:=$eHelp.Category
			Form:C1466.tTitle:=$eHelp.Title
			Form:C1466.tPathName:=$eHelp.PathName
			Form:C1466.tKeyword:=$eHelp.Keyword
			
		End if   //Done unique
		
		Help_Entr_Manager
		
	: ($tPhase=CorektPhaseInitialize)
		
		Help_Entr_Initialize(CorektPhaseClear)
		
		If (Not:C34(OB Is defined:C1231(Form:C1466; "tViewHelpKey")))  // Grab record/records
			
			$esHelp:=ds:C1482[$tTableName].all()
			
		Else 
			
			$tQuery:="Help_Key = "+Form:C1466.tViewHelpKey
			
			$esHelp:=ds:C1482[$tTableName].query($tQuery)
			
		End if   // Done grab record/records
		
		Help_Entr_LoadHList($esHelp)
		
		Help_Entr_Manager
		
	: ($tPhase=CorektPhaseClear)
		
		CLEAR LIST:C377(CorenHList99; *)
		
		Form:C1466.tHelp_Key:=CorektBlank
		Form:C1466.tCategory:=CorektBlank
		Form:C1466.tTitle:=CorektBlank
		Form:C1466.tPathName:=CorektBlank
		Form:C1466.tKeyword:=CorektBlank
		
End case   //Done phase