//%attributes = {}
//Method:  Core_Trigger_TextClean(papField)
//Description:  This method will handle triggers for tables

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $papField)
	C_LONGINT:C283($nField; $nNumberOfFields)
	C_TEXT:C284($tTableName)
	
	$papField:=$1
	
	$nNumberOfFields:=Size of array:C274($papField->)
	$tTableName:=CorektBlank
	
	If ($nNumberOfFields>0)
		
		$pField:=$papField->{1}
		
		$tTableName:=Table name:C256(Table:C252($pField))
		
	End if 
	
End if   //Done Initialize

Util_Trigger_OnErr(CorektTriggerPre; Current method name:C684+CorektSpace+$tTableName)

ON ERR CALL:C155("Util_Trigger_OnErr")

For ($nField; 1; $nNumberOfFields)  //Loop through fields
	
	$pField:=$papField->{$nField}
	
	Core_Text_Clean($pField)
	
End for   //Done looping through fields

Util_Trigger_OnErr(CorektTriggerPost)
