If (Length:C16([Job_DieBoards:152]UsingDie:6)=8)  //going to swap out to and older version
	
	uConfirm("Base "+[Job_Forms:42]JobFormID:5+" on "+[Job_DieBoards:152]UsingDie:6+"?"; "Yes"; "Cancel")
	If (ok=1)
		
		$usingDie:=[Job_DieBoards:152]UsingDie:6
		$numFound:=0  // Modified by: Mel Bohince (6/9/21) 
		SET QUERY DESTINATION:C396(Into variable:K19:4; $numFound)
		QUERY:C277([Job_DieBoards:152]; [Job_DieBoards:152]JobformId:1=$usingDie)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		If ($numFound>0)
			DELETE RECORD:C58([Job_DieBoards:152])  //this is the current one
			QUERY:C277([Job_DieBoards:152]; [Job_DieBoards:152]JobformId:1=$usingDie)
			DUPLICATE RECORD:C225([Job_DieBoards:152])
			[Job_DieBoards:152]pk_id:27:=Generate UUID:C1066
			[Job_DieBoards:152]JobformId:1:=[Job_Forms:42]JobFormID:5
			[Job_DieBoards:152]UsingDie:6:=$usingDie
			SAVE RECORD:C53([Job_DieBoards:152])
		Else 
			uConfirm("Couldn't find "+$usingDie; "Try Again"; "Cancel")
		End if 
		
	End if 
	
Else 
	uConfirm("You need to enter a jobform like 12345.12"; "Try Again"; "Cancel")
End if 