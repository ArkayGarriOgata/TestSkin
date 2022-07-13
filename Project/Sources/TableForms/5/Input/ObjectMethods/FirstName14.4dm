// • mel (4/18/05, 12:17:00) make auto delete user procedure

If ([Users:5]aMsUser:39)
	If (Length:C16([Users:5]UserName:11)=0)
		[Users:5]UserName:11:=[Users:5]FirstName:3+" "+[Users:5]LastName:2
	End if 
	
	If (Length:C16([Users:5]Initials:1)=0)
		[Users:5]Initials:1:=HR_setUsersInitials([Users:5]FirstName:3; [Users:5]MI:4; [Users:5]LastName:2)
	End if 
	
Else 
	uConfirm("Prevent "+[Users:5]UserName:11+" from logging into aMs?"; "Delete User"; "Cancel")
	If (ok=1)
		[Users:5]UserName:11:=""
		If ([Users:5]DOT:30=!00-00-00!)
			uConfirm("Set the termination date to today?"; "Yes"; "No")
			If (ok=1)
				[Users:5]DOT:30:=4D_Current_date
			End if 
		End if 
		ALERT:C41("Save '√' this record to confirm the User Deletion.")
	End if 
End if 
