//%attributes = {}
// _______
// Method: app_ExportScript   ( ) ->
// By: Mel Bohince @ 10/09/21, 16:12:36
// Description
// original intent was to store an Excel file as a template
// assumes you're on the correct script record, so query first
// ----------------------------------------------------

C_TIME:C306($docRef)
C_TEXT:C284($path; $shortName)

$shortName:=Request:C163("Save as..."; [x_shell_scripts:138]scriptName:1; "Ok"; "Cancel")
If (ok=1)
	
	$path:=Select folder:C670("Select a folder for "+$shortName; "")
	
	$docRef:=Create document:C266($path+$shortName)
	
	If (ok=1)
		CLOSE DOCUMENT:C267($docRef)
		
		$path:=$path+$shortName
		
		BLOB TO DOCUMENT:C526($path; [x_shell_scripts:138]theApplet:4)
		If (ok=0)
			uConfirm("Error occurred saving blob to document")
		End if 
		
		
		$err:=util_Launch_External_App($path)
		
	End if   //getting path
	
End if   //naming