If (bool2)
	[Job_DieBoards:152]DateBlankerOH:20:=4D_Current_date
Else 
	[Job_DieBoards:152]DateBlankerOH:20:=!00-00-00!
End if 
SetObjectProperties(""; ->[Job_DieBoards:152]DateBlankerOH:20; bool2)