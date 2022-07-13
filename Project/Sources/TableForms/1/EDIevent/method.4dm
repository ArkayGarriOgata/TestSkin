// _______
// Method: [zz_control].EDIevent   ( ) ->
// By: MelvinBohince
// Description
// make sure that hot folders exist in Finder to 
// support sftp client software usage
// ----------------------------------------------------


Case of 
	: (Form event code:C388=On Load:K2:1)
		$path:=util_DocumentPath("get")
		<>inboxFolderPath:=$path+"EDI_Inbox"+<>DELIMITOR
		If (Test path name:C476(<>inboxFolderPath)#Is a folder:K24:2)
			CREATE FOLDER:C475(<>inboxFolderPath)
		End if 
		<>outboxFolderPath:=$path+"EDI_Outbox"+<>DELIMITOR
		If (Test path name:C476(<>outboxFolderPath)#Is a folder:K24:2)
			CREATE FOLDER:C475(<>outboxFolderPath)
		End if 
		<>tempFolderPath:=$path+"EDI_Archive"+<>DELIMITOR
		If (Test path name:C476(<>tempFolderPath)#Is a folder:K24:2)
			CREATE FOLDER:C475(<>tempFolderPath)
		End if 
End case 