//%attributes = {}
//Method:  Core_Pick_SetPicked (tSelected)
//Description:  This method sets the Pick array that determines what was Picked
// prior to dialog being displayed

If (True:C214)  //Initialization
	
	C_TEXT:C284($1; $tSelected)
	
	C_LONGINT:C283($nSelected; $nNumberOfSelected)
	C_LONGINT:C283($nRow)
	C_TEXT:C284($tSeparator)
	
	ARRAY TEXT:C222($atSelected; 0)
	
	$tSelected:=$1
	
	$tSeparator:=CorektPipe
	
	Core_Text_ParseToArray($tSelected; ->$atSelected; $tSeparator)
	
End if   //Done Initialization

$nNumberOfSelected:=Size of array:C274($atSelected)

For ($nSelected; 1; $nNumberOfSelected)
	
	$nRow:=Num:C11($atSelected{$nSelected})
	
	If ($nRow>0)  //Valid row
		
		Core_Pick_Select($nRow)
		
	Else   //Invalid row
		
		Core_ListBox_DeselectAll(->Core_abPick)
		
	End if   //Done valid row
	
End for 
