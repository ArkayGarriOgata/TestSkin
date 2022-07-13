//%attributes = {}
//Method:  Qury_View_Remove(patConjunction)
//Description:  This method will remove the query line that is blank, move others up
// and shrink the window
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patConjunction)
	
	C_LONGINT:C283($nLineHeight)
	C_LONGINT:C283($nTable; $nField)
	C_LONGINT:C283($nCurrentRow)
	
	C_TEXT:C284($tConjunction)
	C_TEXT:C284($tLine)
	
	C_BOOLEAN:C305($bDone)
	
	$patConjunction:=$1
	
	RESOLVE POINTER:C394($patConjunction; $tConjunction; $nTable; $nField)
	
	$nCurrentRow:=Num:C11($tConjunction)
	$nNextRow:=$nCurrentRow
	
End if   //Done initialize

If ($tConjunction="Qury_View_nRemove")  //Called from button
	
	$tLast:=String:C10(CoreknQuryRowMax)
	
	OB SET:C1220(Form:C1466; "tField"+$tLast; CorektBlank)
	OB SET:C1220(Form:C1466; "tCriteria"+$tLast; CorektBlank)
	
	$patConjunction:=Get pointer:C304("Qury_View_atConjunction"+String:C10(CoreknQuryRowMax-1))
	
	$patConjunction->{0}:=CorektBlank
	$patConjunction->:=1
	
	Core_Window_Resize(0; -CoreknQuryRowHeight)  //Resize window
	
	$nCurrentRow:=CoreknQuryRowMax
	
Else   //Called from the dropdown menu
	
	Repeat   //Update
		
		$tLine:=Choose:C955(\
			($nCurrentRow=0); \
			CorektBlank; \
			String:C10($nCurrentRow))
		
		$nNextRow:=$nNextRow+1
		
		$patConjunctionCurrent:=$patConjunction
		$patConjunctionNext:=Get pointer:C304("Qury_View_atConjunction"+String:C10($nNextRow))
		
		$bDone:=Choose:C955(\
			(Size of array:C274($patConjunctionNext->)>0); \
			False:C215; \
			True:C214)
		
		If (Not:C34($bDone))  //Fill
			
			$tCurrent:=String:C10($nCurrentRow)
			$tNext:=String:C10($nNextRow)
			
			OB SET:C1220(Form:C1466; "tField"+$tCurrent; OB Get:C1224(Form:C1466; "tField"+$tNext))
			OB SET:C1220(Form:C1466; "tCriteria"+$tCurrent; OB Get:C1224(Form:C1466; "tCriteria"+$tNext))
			
			$patCriterionCurrent:=Get pointer:C304("Qury_View_atCriterion"+$tCurrent)
			$patCriterionNext:=Get pointer:C304("Qury_View_atCriterion"+$tNext)
			
			$patCriterionCurrent->:=$patCriterionNext->
			
			$patConjunctionCurrent:=Get pointer:C304("Qury_View_atConjunction"+$tCurrent)
			$patConjunctionNext:=Get pointer:C304("Qury_View_atConjunction"+$tNext)
			
			$patConjunctionCurrent->:=$patConjunctionNext->
			
			$nCurrentRow:=$nNextRow
			
		End if   //Done fill
		
	Until ($bDone)  //Done update
	
End if   //Done last line

Qury_View_Manager(Current method name:C684; String:C10($nCurrentRow))

Compiler_Core_Array(Current method name:C684; $nCurrentRow)
