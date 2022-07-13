//%attributes = {}
//Method:   Quik_Entry_OnLoad(tQuick_Key)
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tQuick_Key)
	
	$tQuick_Key:=$1
	
End if   //Done Initialize

Quik_Entry_Initialize(CorektPhaseInitialize; ->$tQuick_Key)