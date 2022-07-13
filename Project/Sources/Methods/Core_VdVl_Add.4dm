//%attributes = {}
//Method:  Core_VdVl_Add
//Desctiption:  This method will add a valid value

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($oAsk)
	
	$oAsk:=New object:C1471()
	
	$oAsk.tMessage:="How many valid values would you like to add?"
	$oAsk.tValue:="1"
	$oAsk.tDefault:="Add"
	
End if   //Done initialize

If (Core_Dialog_RequestN($oAsk)=CoreknDefault)
	
	LISTBOX INSERT ROWS:C913(Core_abVdVl_ValidValue; 1; Num:C11($oAsk.tValue))
	
End if 
