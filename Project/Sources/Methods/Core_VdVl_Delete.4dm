//%attributes = {}
//Method:  Core_VdVl_Delete({tFormName})
//Description:  This method will delete all Core_ValidValue records

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tFormName)
	
	C_OBJECT:C1216($esCoreValidValue)
	
	C_TEXT:C284($tCore_ValidValue; $tQuery)
	C_TEXT:C284($tDelete)
	
	C_OBJECT:C1216($oConfirm)
	
	$tFormName:=CorektBlank
	
	If (Count parameters:C259>=1)
		$tFormName:=$1
	End if 
	
	$tDelete:=Choose:C955($tFormName=CorektBlank; "ALL"; Core_tVdVl_Category+CorektSpace+CorektPipe+CorektSpace+Core_tVdVl_Identifier)
	
	$oConfirm:=New object:C1471()
	$oConfirm.tDefault:="Cancel"
	$oConfirm.tCancel:="Delete"
	$oConfirm.tMessage:="Are you sure you want to delete "+$tDelete+"?"
	
	$tCore_ValidValue:=Table name:C256(->[Core_ValidValue:69])
	
	$esCoreValidValue:=New object:C1471()
	
	$tQuery:=CorektBlank
	
End if   //Done initialize

Case of   //$tFormName
		
	: (Core_Dialog_ConfirmN($oConfirm)#CoreknCancel)
		
	: ($tFormName=CorektBlank)
		
		$esCoreValidValue:=ds:C1482[$tCore_ValidValue].all()
		
		$esCoreValidValue.drop()
		
	: ($tFormName="Core_VdVl")
		
		$tQuery:="Category = "+Core_tVdVl_Category+" And Identifier = "+Core_tVdVl_Identifier
		
		$esCoreValidValue:=ds:C1482[$tCore_ValidValue].query($tQuery)
		
		$esCoreValidValue.drop()
		
		Core_VdVl_Initialize(CorektPhaseInitialize)
		
End case   //Done $tFormName
