//%attributes = {}
//Method:  Core_OM_Variable(pVariable)
//Description:  This method handles the Variable

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pVariable)
	C_TEXT:C284($tVariableName)
	C_LONGINT:C283($nTable; $nField)
	
	$pVariable:=$1
	
	RESOLVE POINTER:C394($pVariable; $tVariableName; $nTable; $nField)
	
End if   //Done Initialize

Case of   //Variable
		
	: ($tVariableName="Core_tVdVl_Category")
		
		Core_VdVl_Category
		
	: ($tVariableName="Core_tVdVl_Identifier")
		
		Core_VdVl_Name
		
	: ($tVariableName="Core_tVdVl_Find")
		
		Core_VdVl_Find
		
	: ($tVariableName="Core_tPick_Find")
		
		Core_Pick_Find
		
End case   //Done variable

