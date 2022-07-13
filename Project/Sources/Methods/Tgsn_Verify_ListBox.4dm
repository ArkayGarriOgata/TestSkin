//%attributes = {}
//Method:  Tgsn_Verify_ListBox
//Description:  This method will handle the ListBox in the Core_Pick dialog

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nRow; $nNumberOfRows)
	C_LONGINT:C283($nFormEvent)
	
	$nFormEvent:=Form event code:C388
	
End if   //Done Initialize

Case of   //Form event
		
	: ($nFormEvent=On Selection Change:K2:29)
		
		Tgsn_Verify_ColumnSetSend
		
		Core_ListBox_SetBackground(->Tgsn_abVerify)
		
	: ($nFormEvent=On Double Clicked:K2:5)
		
		Tgsn_Verify_ColumnSetSend
		
End case   //Done form event

