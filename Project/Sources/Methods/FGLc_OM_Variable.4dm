//%attributes = {}
//Method:  UsSp_OM_Variable(pVariable)
//Description:  This method handles the button

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pVariable)
	C_TEXT:C284($tVariable)
	C_LONGINT:C283($nTable; $nField)
	
	$pVariable:=$1
	
	RESOLVE POINTER:C394($pVariable; $tVariable; $nTable; $nField)
	
End if   //Done Initialize

Case of   //Variable
		
	: ($tVariable="UsSp_tEntry_Issue")
		
		UsSp_tEntry_Issue:=Get edited text:C655
		
		UsSp_Entry_Manager
		
	: ($tVariable="UsSp_tEntry_Email")
		
		UsSp_tEntry_Email:=Get edited text:C655
		
		UsSp_Entry_Manager
		
End case   //Done variable
