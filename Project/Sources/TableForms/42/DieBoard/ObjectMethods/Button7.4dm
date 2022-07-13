If (bool3)
	[Job_DieBoards:152]DateCounterOH:21:=4D_Current_date
Else 
	[Job_DieBoards:152]DateCounterOH:21:=!00-00-00!
End if 
SetObjectProperties(""; ->[Job_DieBoards:152]DateCounterOH:21; bool3)