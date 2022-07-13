//%attributes = {}

// Method: util_MoveFolder ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 12/08/14, 13:04:47
// ----------------------------------------------------
// Description
// from http://kb.4d.com/assetid=77184  moveFolder
// $1 - Path of folder to be moved
// $2 - Path of destination directory

//on a pc
//$src:="C:\\Users\\Username\\Desktop\\SourceFolder"
//$dest:="C:\\Users\\Username\\Desktop\\DestFolder"
//util_MoveFolder($src;$dest)
//
//on a mac
//$src:="/Users/Username/Desktop/SourceFolder"
//$dest:="/Users/Username/Desktop/DestFolder"
//util_MoveFolder($src;$dest)

C_TEXT:C284($1; $2; $src; $dest; $cmd)
$src:=$1
$dest:=$2

Case of 
	: (Folder separator:K24:12="\\")  //win
		$cmd:="cmd.exe /C move "
	: (Folder separator:K24:12=":")  //mac
		$cmd:="mv "
End case 

SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "TRUE")
LAUNCH EXTERNAL PROCESS:C811($cmd+$src+" "+$dest)