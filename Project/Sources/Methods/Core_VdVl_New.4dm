//%attributes = {}
//Method: Core_VdVl_New
//Description: This method allows you to create a new valid value

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($oConfirm)
	
	$oConfirm:=New object:C1471()
	
	$oConfirm.tMessage:="Would you like to save your changes?"
	
	$oConfirm.tDefault:="Save"
	
End if   //Done initialize

Case of   //Changes
	: (Core_tVdVl_Category=CorektBlank)
	: (Core_tVdVl_Identifier=CorektBlank)
	: (Core_Dialog_ConfirmN($oConfirm)=CoreknDefault)  //Save
		
		Core_VdVl_Save
		
End case   //Done changes

Core_VdVl_Initialize(CorektPhaseInitialize)

