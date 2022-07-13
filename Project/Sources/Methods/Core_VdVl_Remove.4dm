//%attributes = {}
//Method:  Core_VdVl_Remove
//Description:  This method will remove a line item

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nRow; $nNumberOfRows)
	
	$nNumberOfRows:=Size of array:C274(Core_abVdVl_ValidValue)
	
End if   //Done initialize

For ($nRow; $nNumberOfRows; 1; -1)
	
	If (Core_abVdVl_ValidValue{$nRow})
		
		LISTBOX DELETE ROWS:C914(Core_abVdVl_ValidValue; $nRow)
		
	End if 
	
End for 
