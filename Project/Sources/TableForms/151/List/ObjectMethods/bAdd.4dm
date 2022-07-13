If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	CREATE SET:C116([Tool_Drawers:151]; "beforeAdd")
	CUT NAMED SELECTION:C334([Tool_Drawers:151]; "beforeAddSelection")
	ADD RECORD:C56([Tool_Drawers:151]; *)
	
	If (ok=1)
		CREATE SET:C116([Tool_Drawers:151]; "afterAdd")
		UNION:C120("afterAdd"; "beforeAdd"; "afterAdd")
		USE SET:C118("afterAdd")
		CLEAR SET:C117("afterAdd")
		ORDER BY:C49([Tool_Drawers:151]; [Tool_Drawers:151]Bin:1; >)
		CLEAR NAMED SELECTION:C333("beforeAddSelection")
		
	Else 
		USE NAMED SELECTION:C332("beforeAddSelection")
	End if 
	
	CLEAR SET:C117("beforeAdd")
	
Else 
	
	ARRAY LONGINT:C221($_record_number; 0)
	LONGINT ARRAY FROM SELECTION:C647([Tool_Drawers:151]; $_record_number)
	
	ADD RECORD:C56([Tool_Drawers:151]; *)
	
	If (ok=1)
		APPEND TO ARRAY:C911($_record_number; Record number:C243([Tool_Drawers:151]))
		CREATE SELECTION FROM ARRAY:C640([Tool_Drawers:151]; $_record_number)
		ORDER BY:C49([Tool_Drawers:151]; [Tool_Drawers:151]Bin:1; >)
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Tool_Drawers:151]; $_record_number)
		
	End if 
	
	
End if   // END 4D Professional Services : January 2019 

