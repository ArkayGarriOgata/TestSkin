If ((Current user:C182="Administrator"))  //| (True)  `•061295 
	uConfirm("Which do you want to do to the Users and Groups?"; "Make a Change"; "Restore Prior")
	If (ok=1)
		If (fLockNLoad(->[z_administrators:2]))
			EDIT ACCESS:C281
			uConfirm("Save a backup of your changes?"; "Yes"; "No")
			If (ok=1)
				USERS TO BLOB:C849([z_administrators:2]UsersAndGroupsBlob:32)
				SAVE RECORD:C53([z_administrators:2])
			End if 
		End if 
		
	Else 
		LOAD RECORD:C52([z_administrators:2])
		If (BLOB size:C605([z_administrators:2]UsersAndGroupsBlob:32)>5)
			uConfirm("Overwrite Users and Groups?"; "I'm Sure"; "Later")
			If (ok=1)
				BLOB TO USERS:C850([z_administrators:2]UsersAndGroupsBlob:32)
			End if 
			
		Else 
			uConfirm("Backup of Users and Groups does not exist."; "OK"; "Help")
		End if 
	End if 
	
	FLUSH CACHE:C297
	
Else 
	uConfirm("Must be Logged in as the Administrator to Edit Access."; "OK"; "Help")
End if 