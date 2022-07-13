//%attributes = {}
//Method: Arcv_Store({nTable})
//Description: This method will arcive the currently selected tables

If (True:C214)  //Initialize
	
	C_LONGINT:C283($1; $nTable)
	
	If (Count parameters:C259=1)
		
		$nTable:=$1
		
	Else 
		
		$nTable:=Core_Application_GetTableN
		
	End if 
	
End if   //Done initialize

If (Is table number valid:C999($nTable))
	
	Arcv_Store_TableSetting($nTable)
	
	Arcv_Store_RecordRow($nTable)
	
End if 
