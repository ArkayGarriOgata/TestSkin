//%attributes = {}
//Method:  Quik_List_Entry (tQuick_Key)
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tQuick_Key)
	C_LONGINT:C283($nNumberOfParameters)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tQuick_Key:=CorektBlank
	
	If ($nNumberOfParameters>=1)
		$tQuick_Key:=$1
	End if 
	
End if   //Done Initialize

Quik_Dialog_Entry($tQuick_Key)

Quik_List_LoadHList

Quik_List_Manager