//%attributes = {}
//Method:  Core_Peek_Delete
//Description:  This method deletes all the [Core_Peek] records.

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nNotDropped)
	
	C_TEXT:C284($tAlert)
	
	C_OBJECT:C1216($esCorePeek)
	C_OBJECT:C1216($esNotDropped)
	
	C_OBJECT:C1216($oAsk)
	C_OBJECT:C1216($oAlert)
	
	$esCorePeek:=New object:C1471()
	$esNotDropped:=New object:C1471()
	
	$oAsk:=New object:C1471()
	$oAlert:=New object:C1471()
	
	$oAsk.tMessage:="Do you really want to delete all the [Core_Peek] records?"
	$oAsk.tDefault:="Don't Delete"
	$oAsk.tCancel:="Delete"
	
End if   //Done initialize

If (Core_Dialog_ConfirmN($oAsk)=CoreknCancel)
	
	$esCorePeek:=ds:C1482.Core_Peek.all()
	
	$esNotDropped:=$esCorePeek.drop()
	
	$nNotDropped:=$esNotDropped.length
	
	$tAlert:=Choose:C955(\
		($nNotDropped=0); \
		"All records were deleted"; \
		String:C10($nNotDropped)+CorektSpace+Core_PluralizeT("record"; $nNotDropped)+CorektSpace+\
		Core_PluralizeT("was"; $nNotDropped; "were")+CorektSpace+\
		"not deleted.")
	
	$oAlert.tMessage:=$tAlert
	
	Core_Dialog_Alert($oAlert)
	
End if 
