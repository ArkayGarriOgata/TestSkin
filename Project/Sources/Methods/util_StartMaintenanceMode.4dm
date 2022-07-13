//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/04/07, 09:10:57
// ----------------------------------------------------
// Method: util_StartMaintenanceMode
// Description
// look for a file in the servers Extras folder, if there set flag to lockout users
//
// Parameters
// ----------------------------------------------------
C_BOOLEAN:C305($0)
$0:=False:C215
C_TEXT:C284($flag_file_name; $path_to_file)

If (Application type:C494=4D Server:K5:6)
	
	$flag_file_name:="lock-out-users.txt"
	$path_to_file:=Get 4D folder:C485(Current resources folder:K5:16)
	If (Test path name:C476($path_to_file+$flag_file_name)=Is a document:K24:1)
		utl_Logfile("server.log"; "LOG-IN IS RESTRICTED TO SU")
		$0:=True:C214
	Else 
		//utl_Logfile ("server.log";"Running in NORMAL mode ")
	End if 
	
End if 