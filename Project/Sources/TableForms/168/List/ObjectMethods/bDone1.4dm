PRINT SETTINGS:C106
If (OK=1)
	OPEN PRINTING JOB:C995
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		COPY NAMED SELECTION:C331([Job_DieBoard_Inv:168]; "DBINV")
		
	Else 
		
		ARRAY LONGINT:C221($_DBINV; 0)
		LONGINT ARRAY FROM SELECTION:C647([Job_DieBoard_Inv:168]; $_DBINV)
		
		
	End if   // END 4D Professional Services : January 2019 
	
	USE SET:C118("Userset")
	For ($i; 1; Records in selection:C76([Job_DieBoard_Inv:168]))
		GOTO SELECTED RECORD:C245([Job_DieBoard_Inv:168]; $i)
		$xlPix:=Print form:C5("DieboardBarcode"; Form detail:K43:1)
		
	End for 
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		USE NAMED SELECTION:C332("DBINV")
		CLEAR NAMED SELECTION:C333("DBINV")
		
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Job_DieBoard_Inv:168]; $_DBINV)
		
	End if   // END 4D Professional Services : January 2019 
	CLOSE PRINTING JOB:C996
End if 
