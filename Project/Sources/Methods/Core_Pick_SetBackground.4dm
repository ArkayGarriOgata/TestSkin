//%attributes = {}
//Method:  Core_Pick_SetBackground(nRow)
//Description:  This method will set the background for Core_Pick

If (True:C214)  //Initialization
	
	C_LONGINT:C283($1; $nRow)
	
	$nRow:=$1
	
End if   //Done initialization

Core_anPick_RowBackground{$nRow}:=Choose:C955(Core_abPick{$nRow}; CoreknBackgroundGreen; lk inherited:K53:26)