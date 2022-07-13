Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([To_Do_Tasks_Sets:99]))
			[To_Do_Tasks_Sets:99]id:1:=app_set_id_as_string(Table:C252(->[To_Do_Tasks_Sets:99]))  //fGetNextID (->[To_Do_Tasks_Sets];5)
			
		End if 
		
End case 