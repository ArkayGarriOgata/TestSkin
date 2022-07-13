//%attributes = {}
//Method: Tgsn_Verify_ColumnSetSend
//Description:  This method will set the send checkbox 

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nColumn; $nRow)
	
	$nColumn:=0
	$nRow:=0
	
End if   //Done Initialize

LISTBOX GET CELL POSITION:C971(Tgsn_abVerify; $nColumn; $nRow)

Case of   //Valid row
		
	: ($nRow<1)
	: ($nRow>Size of array:C274(Tgsn_abVerify))
	: (Tgsn_abVerify_Fix{$nRow})
		
	Else   //Valid row
		
		Tgsn_abVerify_Send{$nRow}:=Not:C34(Tgsn_abVerify_Send{$nRow})
		
End case   //Done valid row
