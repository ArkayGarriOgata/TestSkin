//%attributes = {}
// -------
// Method: PF_ResetJMLtoNotExported   ( ) ->
// By: Mel Bohince @ 10/02/18, 16:06:52
// Description
// 
// ----------------------------------------------------

READ WRITE:C146([Job_Forms_Master_Schedule:67])


QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Exported_PrintFlow:89#!00-00-00!)
APPLY TO SELECTION:C70([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Exported_PrintFlow:89:=!00-00-00!)

If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
	
	UNLOAD RECORD:C212([Job_Forms_Master_Schedule:67])
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
Else 
	
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
	
End if   // END 4D Professional Services : January 2019 
