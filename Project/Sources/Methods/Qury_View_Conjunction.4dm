//%attributes = {}
//Method: Qury_View_Conjunction(patConjunction)
//Description:  This method will resize the window correctly
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patConjunction)
	
	C_POINTER:C301($patLastCriterion; $patNewConjunction)
	
	C_LONGINT:C283($nTable; $nField)
	C_LONGINT:C283($nResizeVertical)
	
	C_LONGINT:C283($nNewLine)
	
	C_TEXT:C284($tConjunction)
	
	$patConjunction:=$1
	
	$nResizeVertical:=CoreknQuryRowHeight
	
	RESOLVE POINTER:C394($patConjunction; $tConjunction; $nTable; $nField)
	
	$patLastCriterion:=Get pointer:C304("Core_atQury_Criterion"+String:C10(CoreknQuryRowMax))
	
	$nNewLine:=Choose:C955(\
		(Size of array:C274($patLastCriterion->)>0); \
		CoreknQuryRowMax+1; \
		Num:C11($tConjunction)+1)
	
	$patNewConjunction:=Get pointer:C304("Qury_View_atConjunction"+String:C10($nNewLine))
	
End if   //Done initialize

Case of   //Array
		
	: ($patConjunction->{$patConjunction->}=CorektBlank)  //Remove
		
		Qury_View_Remove($patConjunction)
		
		$nResizeVertical:=(-1*$nResizeVertical)
		
	: ($nNewLine>CoreknQuryRowMax)  //Last Row Exists
		
		$nResizeVertical:=0
		
	: ($nNewLine=CoreknQuryRowMax)  //Adding last row
		
		//Qury_View_Add (String($nNewLine))
		
	: (Size of array:C274($patNewConjunction->)>0)  //Changing
		
		$nResizeVertical:=0
		
	Else   //Add row
		
		//Qury_View_Add (String($nNewLine))
		
End case   //Done array

Core_Window_Resize(0; $nResizeVertical)