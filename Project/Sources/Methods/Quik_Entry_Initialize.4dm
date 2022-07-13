//%attributes = {}
//Method:  Quik_Entry_Initialize(tPhase{;pOption1})
//Description:  This method will inititlaize the values for the
//  Rprt_Quick form.

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	C_POINTER:C301($2; $pOption1)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_LONGINT:C283($nQuery; $nNumberOfQueries)
	
	C_TEXT:C284($tReportName)
	
	$tPhase:=$1
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=2)
		$pOption1:=$2
	End if 
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhasePreDialog)
		
		Quik_tEntry_QuickKey:=$pOption1->
		
	: ($tPhase=CorektPhaseInitialize)
		
		Quik_Entry_Initialize(CorektPhaseClear)
		
		Quik_Group_Load(->Quik_atEntry_Group)
		
		Quik_nEntry_ShowQuery:=1  //Always default to this
		
		If (Quik_tEntry_QuickKey#CorektBlank)
			Quik_Entry_Initialize(CorektPhaseAssignVariable; ->Quik_tEntry_QuickKey)
		End if 
		
		Quik_Entry_Manager
		
	: ($tPhase=CorektPhaseAssignVariable)
		
		If (Core_Query_UniqueRecordB(->[Quick:85]Quick_Key:1; $pOption1))
			
			Quik_atEntry_Group:=Find in array:C230(Quik_atEntry_Group; [Quick:85]Group:3)
			Quik_Entry_Group
			Quik_atEntry_Category:=Find in array:C230(Quik_atEntry_Category; [Quick:85]Category:4)
			Quik_atEntry_Category{0}:=Quik_atEntry_Category{Quik_atEntry_Category}
			Quik_tEntry_Name:=[Quick:85]Name:2
			Quik_nEntry_ShowQuery:=Num:C11([Quick:85]ShowQuery:5)
			
			Quik_nEntry_ParentTable:=[Quick:85]ParentTable:6
			Quik_lEntry_Query:=[Quick:85]Query:8
			Quik_tEntry_QueryMethod:=[Quick:85]QueryMethod:9
			Quik_lEntry_QuickReport:=[Quick:85]QuickReport:7
			
			Quik_tEntry_QuickKey:=[Quick:85]Quick_Key:1
			
		End if 
		
	: ($tPhase=CorektPhaseAssignField)
		
		UNLOAD RECORD:C212([Quick:85])
		
		READ WRITE:C146([Quick:85])
		
		If (Not:C34(Core_Query_UniqueRecordB(->[Quick:85]Quick_Key:1; ->Quik_tEntry_QuickKey)))
			
			CREATE RECORD:C68([Quick:85])
			
			[Quick:85]Quick_Key:1:=Generate UUID:C1066
			
		End if 
		
		[Quick:85]Group:3:=Quik_atEntry_Group{Quik_atEntry_Group}
		[Quick:85]Category:4:=Quik_atEntry_Category{Quik_atEntry_Category}
		[Quick:85]Name:2:=Quik_tEntry_Name
		[Quick:85]ShowQuery:5:=(Quik_nEntry_ShowQuery=1)
		[Quick:85]ParentTable:6:=Quik_nEntry_ParentTable
		[Quick:85]Query:8:=Quik_lEntry_Query
		[Quick:85]QueryMethod:9:=Quik_tEntry_QueryMethod
		[Quick:85]QuickReport:7:=Quik_lEntry_QuickReport
		
		SAVE RECORD:C53([Quick:85])
		
		READ ONLY:C145([Quick:85])
		
	: ($tPhase=CorektPhaseClear)
		
		Compiler_Quik_Array(Current method name:C684; 0)
		
		Quik_atEntry_Group:=0
		Quik_atEntry_Category:=0
		
		Quik_atEntry_Group{0}:=CorektBlank
		Quik_atEntry_Category{0}:=CorektBlank
		
		Quik_tEntry_Name:=CorektBlank
		Quik_tEntry_QueryMethod:=CorektBlank
		
		Quik_nEntry_ShowQuery:=0
		
		Quik_nEntry_ParentTable:=0
		SET BLOB SIZE:C606(Quik_lEntry_Query; 0)
		SET BLOB SIZE:C606(Quik_lEntry_QuickReport; 0)
		
End case   //Done phase
