//%attributes = {}
// -------
// Method: Job_SetStartDate   ( ) ->
// By: Mel Bohince @ 06/15/16, 10:29:09
// Description
// make sure start date is set if there are machine tickets for it
// ----------------------------------------------------

READ WRITE:C146([Job_Forms:42])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])

//look for machine tickes on jobs that haven't been started
ARRAY TEXT:C222($aJobforms; 0)
Begin SQL
	select distinct(JobForm)
	from Job_Forms_Machine_Tickets where JobForm in
	(Select JobFormID from Job_Forms
	where StartDate < '01/01/1994' and jobformid not like '02%')
	into :$aJobforms
End SQL


C_LONGINT:C283($job; $numElements)
$numElements:=Size of array:C274($aJobforms)
uThermoInit($numElements; "Processing Array")
For ($job; 1; $numElements)
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=$aJobforms{$job})
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
		SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]DateEntered:5; $MTdate)
		SORT ARRAY:C229($MTdate; >)
		
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$aJobforms{$job})
		If (Records in selection:C76([Job_Forms:42])>0)
			[Job_Forms:42]StartDate:10:=$MTdate{1}
			SAVE RECORD:C53([Job_Forms:42])
		End if 
	End if   //mt's
	
	uThermoUpdate($job)
End for 
uThermoClose

UNLOAD RECORD:C212([Job_Forms:42])
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([Job_Forms_Machine_Tickets:61])
	
Else 
	
	// you have selection to array on line 28
	
End if   // END 4D Professional Services : January 2019 
