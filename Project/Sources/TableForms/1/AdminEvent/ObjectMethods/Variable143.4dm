<>PassThrough:=True:C214

ALL RECORDS:C47([y_batches:10])
CREATE SET:C116([y_batches:10]; "◊PassThroughSet")
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
	
	UNLOAD RECORD:C212([y_batches:10])
	REDUCE SELECTION:C351([y_batches:10]; 0)
	
	
Else 
	
	REDUCE SELECTION:C351([y_batches:10]; 0)
	
End if   // END 4D Professional Services : January 2019 


ViewSetter(2; ->[y_batches:10])

//