//%attributes = {}
//Method:  Compiler_Arcv_Array(tMethodName{;nRows}{;nColumns})
//Description:  This method initializes arrays

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tMethodName)
	C_LONGINT:C283($2; $nRows; $3; $nColumns)
	C_LONGINT:C283($nNumberOfParameters)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tMethodName:=$1
	$nRows:=0
	$nColumns:=0
	
	If ($nNumberOfParameters>=2)  //Optional
		$nRows:=$2
		If ($nNumberOfParameters>=3)
			$nColumns:=$3
		End if 
	End if   //Done optional
	
End if   //Done Initialize

Case of   //Method name
		
	: ($tMethodName="Arcv_View_Table")
		
		ARRAY BOOLEAN:C223(Arcv_abView_ FieldValue; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Field; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Value; $nRows)
		
	: (($tMethodName=("Arcv_View_TableName"+CorektPhaseAssignVariable)) | ($tMethodName="Arcv_View_TableFill"))
		
		ARRAY BOOLEAN:C223(Arcv_abView_ FieldValue; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Field; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Value; $nRows)
		
		ARRAY BOOLEAN:C223(Arcv_abViewTable; $nRows)
		
		ARRAY TEXT:C222(Arcv_atView_Column01; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column02; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column03; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column04; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column05; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column06; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column07; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column08; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column09; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column10; $nRows)
		
	: ($tMethodName=("Arcv_View_TableName"+CorektPhaseClear))
		
		ARRAY TEXT:C222(Arcv_atView_TableName; $nRows)  //Table name dropdown
		
		ARRAY BOOLEAN:C223(Arcv_abView_ FieldValue; $nRows)  //FieldValue ListBox
		ARRAY TEXT:C222(Arcv_atView_Field; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Value; $nRows)
		
		ARRAY BOOLEAN:C223(Arcv_abViewTable; $nRows)  //RowValue ListBox
		
		ARRAY TEXT:C222(Arcv_atView_Column01; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column02; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column03; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column04; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column05; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column06; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column07; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column08; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column09; $nRows)
		ARRAY TEXT:C222(Arcv_atView_Column10; $nRows)
		
End case   //Done method name
