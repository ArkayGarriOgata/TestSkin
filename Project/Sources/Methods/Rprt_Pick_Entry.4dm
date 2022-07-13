//%attributes = {}
//Method:  Rprt_Pick_Entry (tReport_Key)
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tReport_Key)
	C_LONGINT:C283($nNumberOfParameters)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tReport_Key:=CorektBlank
	
	If ($nNumberOfParameters>=1)
		$tReport_Key:=$1
	End if 
	
End if   //Done Initialize

Rprt_Dialog_Entry($tReport_Key)

Rprt_Pick_LoadHList

Rprt_Pick_Manager