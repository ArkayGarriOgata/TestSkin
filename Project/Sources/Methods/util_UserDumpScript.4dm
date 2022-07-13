//%attributes = {"publishedWeb":true}
//PM: util_UserDumpScript() -> 
//@author Mel - 5/23/03  16:03
//see also util_UserDumpImport
path:=Select folder:C670("Destination of UserDump ƒ")
If (ok=1)
	path:=path+"UserDump ƒ:"
	If (Test path name:C476(path)#0)
		CREATE FOLDER:C475(path)
	Else 
		util_deleteDocument(path+"users.txt")
		util_deleteDocument(path+"groups.txt")
		util_deleteDocument(path+"GroupInGroup.txt")
		util_deleteDocument(path+"RoanokeUsers.txt")
		util_deleteDocument(path+"FunctionsOnly.txt")
		util_deleteDocument(path+"RolesOnly.txt")
	End if 
	
	util_UserNameExport(True:C214)
	util_UserGroupExport(True:C214)
	util_UserGroupMembershipExport(True:C214)
	util_UserMembershipExport(True:C214; False:C215; False:C215)
	util_UserMembershipExport(False:C215; True:C214; False:C215)
	util_UserMembershipExport(False:C215; False:C215; True:C214)
End if 
//

//import in this order?
//first edit out junk, create an Adminitrator
//groups
//groupInGroups
//then save groups file

//users
//roanoke
//rolesonly
//functions only