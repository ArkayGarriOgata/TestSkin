
uConfirm("Add a Machine Ticket to this Jobform on the sly?"; "Yes"; "No")
If (OK=1)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			CREATE SET:C116([Job_Forms_Machine_Tickets:61]; "Hold")
			
			CREATE RECORD:C68([Job_Forms_Machine_Tickets:61])  //• 6/22/98 cs start
			[Job_Forms_Machine_Tickets:61]JobForm:1:=[Job_Forms:42]JobFormID:5
			[Job_Forms_Machine_Tickets:61]DateEntered:5:=4D_Current_date
			[Job_Forms_Machine_Tickets:61]Sequence:3:=0
			SAVE RECORD:C53([Job_Forms_Machine_Tickets:61])
			
			ADD TO SET:C119([Job_Forms_Machine_Tickets:61]; "Hold")
			USE SET:C118("Hold")
			CLEAR SET:C117("Hold")
			
		Else 
			
			ARRAY LONGINT:C221($_Hold; 0)
			SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]; $_Hold)
			
			CREATE RECORD:C68([Job_Forms_Machine_Tickets:61])  //• 6/22/98 cs start
			[Job_Forms_Machine_Tickets:61]JobForm:1:=[Job_Forms:42]JobFormID:5
			[Job_Forms_Machine_Tickets:61]DateEntered:5:=4D_Current_date
			[Job_Forms_Machine_Tickets:61]Sequence:3:=0
			SAVE RECORD:C53([Job_Forms_Machine_Tickets:61])
			
			APPEND TO ARRAY:C911($_Hold; Record number:C243([Job_Forms_Machine_Tickets:61]))
			CREATE SELECTION FROM ARRAY:C640([Job_Forms_Machine_Tickets:61]; $_Hold)
			
		End if   // END 4D Professional Services : January 2019 
		
	Else 
		ARRAY LONGINT:C221($_Hold; 0)
		LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Machine_Tickets:61]; $_Hold)
		
		CREATE RECORD:C68([Job_Forms_Machine_Tickets:61])  //• 6/22/98 cs start
		[Job_Forms_Machine_Tickets:61]JobForm:1:=[Job_Forms:42]JobFormID:5
		[Job_Forms_Machine_Tickets:61]DateEntered:5:=4D_Current_date
		[Job_Forms_Machine_Tickets:61]Sequence:3:=0
		SAVE RECORD:C53([Job_Forms_Machine_Tickets:61])
		
		APPEND TO ARRAY:C911($_Hold; Record number:C243([Job_Forms_Machine_Tickets:61]))
		CREATE SELECTION FROM ARRAY:C640([Job_Forms_Machine_Tickets:61]; $_Hold)
		
		
	End if   // END 4D Professional Services : January 2019 
	
	ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Sequence:3; >; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >; [Job_Forms_Machine_Tickets:61]DateEntered:5; >)
	COPY NAMED SELECTION:C331([Job_Forms_Machine_Tickets:61]; "machTicks")
End if 

//EOS