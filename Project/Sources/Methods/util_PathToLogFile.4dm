//%attributes = {}
// Method: util_PathToLogFile()  --> path to ~/Libary/Logs/4D/aMs
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/08/07, 08:33:10
// ----------------------------------------------------
// Description
// get path (created if necessary) for log files to be dumped
//shooting for ~/Library/Logs/4D/appname/
// ----------------------------------------------------
// v Extras Folder 
// ----------------------------------------------------
C_TEXT:C284($application; $1; $path_to_prefs; $path_to_log; $0)

If (Count parameters:C259=1)
	$application:=$1
Else 
	$application:="aMs"
End if 
$path_to_prefs:=System folder:C487(User preferences_user:K41:4)
$path_to_log:=Replace string:C233($path_to_prefs; "Application Support"; "Logs")  // Modified by: Mel Bohince (9/23/13) Preferences replaced with Application Support

If (Test path name:C476($path_to_log)#0)
	CREATE FOLDER:C475($path_to_log)
End if 

$path_to_log:=$path_to_log+"4D"+<>DELIMITOR
If (Test path name:C476($path_to_log)#0)
	CREATE FOLDER:C475($path_to_log)
End if 

$path_to_log:=$path_to_log+$application+<>DELIMITOR
If (Test path name:C476($path_to_log)#0)
	CREATE FOLDER:C475($path_to_log)
End if 

$0:=$path_to_log
