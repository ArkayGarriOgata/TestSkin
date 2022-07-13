// _______
// Method: [x_shell_scripts].Input.import_script   ( ) ->
// By: Mel Bohince @ 10/09/21, 11:31:17
// Description
// original intent was to store an Excel file as a template
// ----------------------------------------------------


C_TIME:C306($docRef)
$docRef:=Open document:C264("")
If (ok=1)
	CLOSE DOCUMENT:C267($docRef)
	
	DOCUMENT TO BLOB:C525(document; [x_shell_scripts:138]theApplet:4)
	If (ok=1)
		C_COLLECTION:C1488($path)
		$path:=New collection:C1472
		$path:=Split string:C1554(document; ":")
		[x_shell_scripts:138]scriptName:1:=$path[$path.length-1]
		[x_shell_scripts:138]description:2:=Request:C163("Description:"; ""; "Ok"; "Well")
	Else 
		BEEP:C151
		uConfirm("Error occurred loading document to blob")
	End if 
End if 