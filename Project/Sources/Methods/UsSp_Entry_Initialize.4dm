//%attributes = {}
//Method:  UsSp_Entry_Initialize(tPhase)
//Description:  This method handles initializing values

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	C_TEXT:C284($tFolder)
	
	$tPhase:=$1
	
	$tFolder:="User_Support"
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhasePreDialog)
		
		Compiler_UsSp_Array(Current method name:C684; 0)  //Store attachment path names
		
		Core_Form_Document($tFolder; ->UsSp_atEntry_Attachment)  //Creates {...}:Document:AMS_Documents:User_Support:{ScreenShot}.jpg and Data
		
		UsSp_tEntry_Form:="["+Table name:C256(Current form table:C627)+"];"+CorektDoubleQuote+Current form name:C1298+CorektDoubleQuote+CorektSpace
		
	: ($tPhase=CorektPhaseInitialize)
		
		UsSp_Entry_Initialize(CorektPhaseClear)
		
		UsSp_tEntry_Email:=Email_WhoAmI
		
		UsSp_Entry_Manager
		
	: ($tPhase=CorektPhaseClear)
		
		UsSp_tEntry_Issue:=CorektBlank
		UsSp_tEntry_Email:=CorektBlank
		
End case   //Done phase