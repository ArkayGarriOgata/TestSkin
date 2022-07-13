//%attributes = {}
//Method: Rprt_Pick_Initialize(tPhase{;pOption1}{;pOption2)
//Description: This method will initialize the Rprt_Pick form

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	C_POINTER:C301($2; $pOption1)
	C_POINTER:C301($3; $pOption2)
	
	C_OBJECT:C1216($eReport)
	C_OBJECT:C1216($oReport)
	
	C_POINTER:C301($pDate)
	
	$tPhase:=$1
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=2)  //Parameters
		$pOption1:=$2
		If ($nNumberOfParameters>=3)
			$pOption2:=$3
		End if 
	End if   //Done parameters
	
	$eReport:=New object:C1471()
	$oReport:=New object:C1471()
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase="Rprt_Pick_ViewPro")
		
		$tReport_Key:=Form:C1466.tReport_Key
		
		If (Core_Query_UniqueRecordB(->[Report:66]Report_Key:1; ->$tReport_Key; ->$oReport))  //Unique
			
			Form:C1466.tLastRun:="Ran:"+CorektSpace+String:C10($oReport.RunOn)+CorektSpace+\
				CorektPipe+CorektSpace+$oReport.RunBy+CorektSpace+\
				CorektLeftParen+String:C10($oReport.RunCount)+CorektRightParen
			
		End if   //Done unique
		
	: ($tPhase=("Rprt_Pick_CriterionSet"+"Enterable"))
		
		OBJECT SET TITLE:C194(*; "Rprt_Pick_Title0"; $pOption1->)
		Form:C1466.tValue0:=$pOption2->
		
		Rprt_Pick_Manager($tPhase)
		
	: ($tPhase=("Rprt_Pick_CriterionSet"+"PopUp"))
		
		OBJECT SET TITLE:C194(*; "Rprt_Pick_Title0"; $pOption1->)
		
		Core_Text_ParseToArray($pOption2->; ->Rprt_Pick_atValue0; CorektPipe)
		
		Rprt_Pick_Manager($tPhase)
		
	: ($tPhase=("Rprt_Pick_CriterionSet"+"Start Date"))
		
		Rprt_Pick_dStart:=$pOption1->
		
		Rprt_Pick_Manager($tPhase)
		
	: ($tPhase=("Rprt_Pick_CriterionSet"+"End Date"))
		
		Rprt_Pick_dEnd:=$pOption1->
		
		Rprt_Pick_Manager($tPhase)
		
	: ($tPhase=("Rprt_Pick_CriterionSet"+CorektPhaseClear))
		
		Compiler_Rprt_Array(Current method name:C684; 0)
		
		Form:C1466.tValue0:=CorektBlank
		Rprt_Pick_dStart:=!00-00-00!
		Rprt_Pick_dEnd:=!00-00-00!
		
		Rprt_Pick_Manager($tPhase)
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		Rprt_Pick_Initialize(CorektPhaseClear)
		
		GET LIST ITEM:C378(CorenHList1; *; $nItemReference; $tItem; $nSubListReference; $bExpanded)
		
		$patHListKey1:=Get pointer:C304("CoreatHListKey1")
		
		$tReport_Key:=$patHListKey1->{$nItemReference}
		
		Form:C1466.tReport_Key:=$tReport_Key
		
		If (Core_Query_UniqueRecordB(->[Report:66]Report_Key:1; ->$tReport_Key; ->$oReport))  //Unique
			
			Rprt_Pick_CriterionSet($oReport.Report_Key)
			
			Form:C1466.tDescription:=$oReport.Description
			
			If ($oReport.RunCount=0)  //Last run
				
				Form:C1466.tLastRun:="This report has never been run."
				
			Else 
				
				Form:C1466.tLastRun:="Ran:"+CorektSpace+String:C10($oReport.RunOn)+CorektSpace+\
					CorektPipe+CorektSpace+$oReport.RunBy+CorektSpace+\
					CorektLeftParen+String:C10($oReport.RunCount)+CorektRightParen
				
			End if   //Done last run
			
			Case of   //Valid sample raw
					
				: (Not:C34(OB Is defined:C1231($oReport; "SampleRaw")))
					
					VP NEW DOCUMENT("ViewProArea")
					
				: ($oReport.SampleRaw=Null:C1517)
					
					VP NEW DOCUMENT("ViewProArea")
					
				: (OB Is empty:C1297($oReport.SampleRaw))
					
					VP NEW DOCUMENT("ViewProArea")
					
				Else   //Clear
					
					VP IMPORT FROM OBJECT("ViewProArea"; $oReport.SampleRaw)
					
			End case   //Done valid sample raw
			
			Rprt_Pick_Manager(Current method name:C684+$tPhase)
			
		End if   //Done unique
		
	: ($tPhase=CorektPhaseInitialize)
		
		Rprt_Pick_Initialize(CorektPhaseClear)
		
		Rprt_Pick_LoadHList
		
		Rprt_Pick_Manager($tPhase)
		
	: ($tPhase=CorektPhaseClear)
		
		Compiler_Rprt_Array(Current method name:C684; 0)
		
		Form:C1466.tReport_Key:=CorektBlank
		
		Form:C1466.tValue0:=CorektBlank
		Rprt_Pick_dStart:=!00-00-00!
		Rprt_Pick_dEnd:=!00-00-00!
		
		Form:C1466.tDescription:=CorektBlank
		Form:C1466.tLastRun:=CorektBlank
		
		Form:C1466.nSave:=0
		Form:C1466.nViewPro:=0
		
		Case of   //Valid form event
				
			: (FORM Event:C1606=Null:C1517)
			: (Not:C34(OB Is defined:C1231(FORM Event:C1606; "Code")))
				
			: (FORM Event:C1606.code#On Load:K2:1)
				
				VP NEW DOCUMENT("ViewProArea")
				
		End case   //Done valid form event
		
End case   //Done phase