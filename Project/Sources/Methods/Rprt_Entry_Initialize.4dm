//%attributes = {}
//Method:  Rprt_Entry_Initialize(tPhase{;pOption1}{;pOption2})
//Description:  This method will inititlaize the values for the
//  Rprt_Report form.

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	C_POINTER:C301($2; $pOption1)
	C_POINTER:C301($3; $pOption2)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_LONGINT:C283($nQuery; $nNumberOfQueries)
	
	C_OBJECT:C1216($esReport; $eReport)
	C_OBJECT:C1216($oReport)
	
	C_TEXT:C284($tReportName; $tReport_Key)
	
	$tPhase:=$1
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=2)  //Parameters
		$pOption1:=$2
		If ($nNumberOfParameters>=3)
			$pOption2:=$3
		End if 
	End if   //Done parameters
	
	$esReport:=New object:C1471()
	$eReport:=New object:C1471()
	$oReport:=New object:C1471()
	
	$tReport_Key:=CorektBlank
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhasePreDialog)
		
		OB SET:C1220($pOption1->; "tReport_Key"; $pOption2->)  //Form.tReport_Key
		
	: ($tPhase=CorektPhaseInitialize)
		
		Rprt_Entry_Initialize(CorektPhaseClear)
		
		Rprt_Group_Load(->Rprt_atEntry_Group)
		
		If (Form:C1466.tReport_Key#CorektBlank)  //Modify
			
			Rprt_Entry_Initialize(CorektPhaseAssignVariable)
			
		Else   //New
			
			Form:C1466.tReport_Key:=Generate UUID:C1066
			
		End if   //Done modify
		
		Rprt_Entry_Manager
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		$tReport_Key:=Form:C1466.tReport_Key
		
		If (Core_Query_UniqueRecordB(->[Report:66]Report_Key:1; ->$tReport_Key; ->$oReport))  //Report
			
			Rprt_atEntry_Group:=Find in array:C230(Rprt_atEntry_Group; $oReport.Group)
			Rprt_atEntry_Group{0}:=Rprt_atEntry_Group{Rprt_atEntry_Group}
			
			Rprt_Entry_Group  //Fill category
			
			Rprt_atEntry_Category:=Find in array:C230(Rprt_atEntry_Category; $oReport.Category)
			Rprt_atEntry_Category{0}:=Rprt_atEntry_Category{Rprt_atEntry_Category}
			
			Form:C1466.tName:=$oReport.Name
			Form:C1466.tMethod:=$oReport.Method
			
			Form:C1466.tDescription:=$oReport.Description
			
			Form:C1466.tCreatedFor:=$oReport.CreatedFor
			Form:C1466.dCreatedOn:=$oReport.CreatedOn
			
			
			If ($oReport.RunCount=0)  //Last run
				
				Form:C1466.tLastRun:="This report has never been run."
				
			Else 
				
				Form:C1466.tLastRun:="Ran:"+CorektSpace+String:C10($oReport.RunOn)+CorektSpace+\
					CorektPipe+CorektSpace+$oReport.RunBy+CorektSpace+\
					CorektLeftParen+String:C10($oReport.RunCount)+CorektRightParen
				
			End if   //Done last run
			
			Rprt_Entry_LoadCriterion(Form:C1466.tReport_Key)
			
		End if   //Done report
		
	: ($tPhase=CorektPhaseAssignField)
		
		$tReport_Key:=Form:C1466.tReport_Key
		
		If (Core_Query_UniqueRecordB(->[Report:66]Report_Key:1; ->$tReport_Key; ->$oReport))  //Exists
			
			$eReport:=ds:C1482.Report.query("Report_Key = :1"; $tReport_Key).first()
			
		Else   //New
			
			$eReport:=ds:C1482.Report.new()
			
		End if   //Done exists
		
		$eReport.Report_Key:=Form:C1466.tReport_Key
		
		$eReport.Group:=Rprt_atEntry_Group{Rprt_atEntry_Group}
		$eReport.Category:=Rprt_atEntry_Category{Rprt_atEntry_Category}
		
		$eReport.Name:=Form:C1466.tName
		$eReport.Method:=Form:C1466.tMethod
		
		$eReport.Description:=Form:C1466.tDescription
		
		$eReport.CreatedFor:=Form:C1466.tCreatedFor
		$eReport.CreatedOn:=Form:C1466.dCreatedOn
		
		$oSave:=$eReport.save()
		
	: ($tPhase=CorektPhaseClear)
		
		Compiler_Rprt_Array(Current method name:C684; 0)
		
		Rprt_atEntry_Group:=0
		Rprt_atEntry_Category:=0
		
		Rprt_atEntry_Group{0}:=CorektBlank
		Rprt_atEntry_Category{0}:=CorektBlank
		
		Form:C1466.tName:=CorektBlank
		Form:C1466.tMethod:=CorektBlank
		
		Form:C1466.tDescription:=CorektBlank
		
		Form:C1466.tCreatedFor:=CorektBlank
		Form:C1466.dCreatedOn:=!00-00-00!
		
		Form:C1466.tLastRun:=CorektBlank
		
		Form:C1466.nOnLoad:=0
		
		Form:C1466.nCancel:=0
		Form:C1466.nDelete:=0
		Form:C1466.nSave:=0
		
		Form:C1466.nRemove:=0
		Form:C1466.nAdd:=0
		
End case   //Done phase
