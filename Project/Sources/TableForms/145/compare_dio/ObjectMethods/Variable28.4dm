// Method: Object Method: b2Edit () -> 
// ----------------------------------------------------
// by: mel: 06/14/05, 14:21:24
// ----------------------------------------------------

If (ListBox2#0)
	READ ONLY:C145([Customers_ReleaseSchedules:46])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		GOTO RECORD:C242([Customers_ReleaseSchedules:46]; aRecNum{ListBox2})
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "◊PassThroughSet")
		<>PassThrough:=True:C214
		REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
		
	Else 
		
		ARRAY LONGINT:C221($_record_number; 0)
		APPEND TO ARRAY:C911($_record_number; aRecNum{ListBox2})
		CREATE SET FROM ARRAY:C641([Customers_ReleaseSchedules:46]; $_record_number; "◊PassThroughSet")
		<>PassThrough:=True:C214
		REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
		
		
	End if   // END 4D Professional Services : January 2019 
	
	ViewSetter(2; ->[Customers_ReleaseSchedules:46])
	uConfirm("Remember to refresh the Compare screen to reflect changes you made to our Release"+"."; "OK"; "Help")
End if 