//%attributes = {}

// Method: pattern_NewFolder ("name" )  -> path
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 04/22/14, 08:20:11
// ----------------------------------------------------
// Description
// based on uCreateFolder()
// //create a folder in the default directory
// ----------------------------------------------------


C_TEXT:C284($1; $path; $0)

$path:=util_DocumentPath
$path:=$path+$1

If (Test path name:C476($path)<0)
	CREATE FOLDER:C475($path)
	If (OK=0)
		ALERT:C41("Disk access error: Trying to create folder.")
	End if 
End if 

$path:=$path+":"
$0:=$path
