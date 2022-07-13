//%attributes = {"publishedWeb":true}
//PM: util_UserDumpImport() -> 
//@author Mel - 5/28/03  11:09
//see also util_UserDumpScript
path:=Select folder:C670("Select UserDump folder")
If (ok=1)
	If (Test path name:C476(path)=0)
		
		util_UserGroupImport(path+"groups.txt")
		util_UserGroupMembershipImport(path+"GroupInGroup.txt")
		
		util_UserNameImport(path+"users.txt")
		util_UserMembershipImport(path+"RoanokeUsers.txt")
		util_UserMembershipImport(path+"RolesOnly.txt")
		util_UserMembershipImport(path+"FunctionsOnly.txt")
		
	Else 
		BEEP:C151
		ALERT:C41("Invalid path")
	End if 
	
End if 