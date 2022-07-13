//%attributes = {}
//Method:  Core_Pick_ListBox
//Description:  This method will handle the ListBox in the Core_Pick dialog

If (True:C214)  //Initialization
	
	C_LONGINT:C283($nRow; $nNumberOfRows)
	C_LONGINT:C283($nColumn)
	C_LONGINT:C283($nFormEvent)
	
	$nFormEvent:=Form event code:C388
	
	LISTBOX GET CELL POSITION:C971(Core_abPick; $nColumn; $nRow)  //Get selected row
	
End if   //Done Initialization

Case of   //Form event
		
	: (($nRow<1) | ($nRow>Size of array:C274(Core_abPick)))  //Invalid row
		
	: (($nFormEvent=On Clicked:K2:4) | ($nFormEvent=On Selection Change:K2:29))
		
		If (Not:C34(Core_oPick.bPickMultiple))
			
			Core_Array_Clear(->Core_abPick_Picked)
			
		End if 
		
		Core_abPick_Picked{$nRow}:=True:C214
		
	: ($nFormEvent=On Double Clicked:K2:5)  //Double clicked on a row so do opposite
		
		Core_abPick_Picked{$nRow}:=Not:C34(Core_abPick_Picked{$nRow})  //Set to opposite
		
End case   //Done form event

Core_ListBox_SetBackground(->Core_abPick; ->Core_abPick_Picked)
