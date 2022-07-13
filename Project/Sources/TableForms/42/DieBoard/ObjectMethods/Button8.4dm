If (bool4)
	[Job_DieBoards:152]DateFSB_OH:22:=4D_Current_date
Else 
	[Job_DieBoards:152]DateFSB_OH:22:=!00-00-00!
End if 
SetObjectProperties(""; ->[Job_DieBoards:152]DateFSB_OH:22; bool4)