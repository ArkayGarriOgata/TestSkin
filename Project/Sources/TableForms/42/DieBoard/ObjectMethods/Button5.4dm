If (bool1)
	[Job_DieBoards:152]DateDieOH:19:=4D_Current_date
Else 
	[Job_DieBoards:152]DateDieOH:19:=!00-00-00!
End if 
SetObjectProperties(""; ->[Job_DieBoards:152]DateDieOH:19; bool1)