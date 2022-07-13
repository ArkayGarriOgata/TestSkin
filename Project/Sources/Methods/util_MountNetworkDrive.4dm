//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 01/17/07, 16:59:23
// ----------------------------------------------------
// Method: util_MountNetworkDrive(shellscript.sh)  --> true if success
// Description
// mount drive on a network using a shellscrip like that is in the structure's folder:
//#!/bin/sh
//mkdir/Volumes/Data_Collection
//mount-t afp afp://ssiflex:ssi2006@192.168.3.30/Data_Collection/Volumes/Data_Collection
// ## make sure it is executable ##
//not tested on Windows
// ----------------------------------------------------
C_TEXT:C284($1; $case; $pathToScript; $shell_script_that_mounts_drive; $stdin; $stdout; $stderr; $volumeRequired; $localDriveName)

If (Count parameters:C259=1)
	$volumeRequired:=$1
Else 
	$volumeRequired:="Data_collection"
End if 

If (User in group:C338(Current user:C182; "VA_Servers"))
	$shell_script_that_mounts_drive:="VA_mount_"+Lowercase:C14($volumeRequired)+".sh"
Else 
	$shell_script_that_mounts_drive:="mount_"+Lowercase:C14($volumeRequired)+".sh"
End if 

C_LONGINT:C283($driveNamePosition)
C_BOOLEAN:C305($0; $success)
$success:=False:C215
//test if already mounted
ARRAY TEXT:C222($asVolumes; 0)
VOLUME LIST:C471($asVolumes)
//C_LONGINT($vlPlatform;$vlSystem;$vlMachine)
//_O_PLATFORM_PROPERTIES($vlPlatform;$vlSystem;$vlMachine)
If (Is macOS:C1572)
	If (Find in array:C230($asVolumes; $volumeRequired)=-1)  //need to mount
		
		// ----------------------------------------------------
		//what we want -> $shell_script_that_mounts_drive:="/Users/work/Documents/Bench/aMs /aMs2004/mount_data_collection.sh"
		//what we'll get -> $shell_script_that_mounts_drive:="laptop:Users:work:Documents:Bench:aMs:aMs2004:mount_data_collection.sh"
		//so massage it a bit:
		$pathToScript:=Get 4D folder:C485(Current resources folder:K5:16)+$shell_script_that_mounts_drive
		Case of 
			: (Application type:C494=4D Remote mode:K5:5)
				$case:="4D Client"
				//$pathToScript:=Get 4D folder(Active 4D Folder )
				//$pathToScript:="laptop:Users:work:Library:Application Support:4D:"
				
				//FOLDER LIST($pathToScript;$aDirectories)
				//For ($i;1;Size of array($aDirectories))
				//If (Position("AMS";Uppercase($aDirectories{$i}))>0)
				//$newPath:=$pathToScript+$aDirectories{$i}+":Mac4DX:"+$shell_script_that_mounts_drive
				//If (Test path name($newPath)=Is a document )
				//$pathToScript:=$newPath
				//$i:=$i+Size of array($aDirectories)
				//End if 
				//
				//End if 
				//End for 
				
				$driveNamePosition:=Position:C15(<>DELIMITOR; $pathToScript)
				$localDriveName:=Substring:C12($pathToScript; 1; ($driveNamePosition-1))
				$pathToScript:=Delete string:C232($pathToScript; 1; ($driveNamePosition-1))
				$unix_path:=""
				
			: (Application type:C494=4D Server:K5:6)
				$case:="4D Server"
				//$pathToScript:=util_getPathFromLongName (Structure file)+"Mac4DX:"+$shell_script_that_mounts_drive
				$localDriveName:=""  //Substring($pathToScript;1;($driveNamePosition-1))
				$unix_path:="/Volumes/"
				
			Else   //4d or runtime
				$case:="4D Mono"
				//$pathToScript:=util_getPathFromLongName (Structure file)+"Mac4DX:"+$shell_script_that_mounts_drive
				$driveNamePosition:=Position:C15(<>DELIMITOR; $pathToScript)
				$localDriveName:=Substring:C12($pathToScript; 1; ($driveNamePosition-1))
				$pathToScript:=Delete string:C232($pathToScript; 1; ($driveNamePosition-1))
				$unix_path:=""
		End case 
		utl_Logfile("mount_volume.log"; $case+", pathToScript: "+$pathToScript)
		
		
		If (Test path name:C476($localDriveName+$pathToScript)=Is a document:K24:1)
			$pathToScript:=Replace string:C233($pathToScript; <>DELIMITOR; "/")  //convert to unix uri
			$pathToScript:=Replace string:C233($pathToScript; " "; "\\ ")  //convert to unix uri
			$pathToScript:=$unix_path+$pathToScript
			$stdin:=""  //not used
			$stdout:=""  //not used
			$stderr:=""
			LAUNCH EXTERNAL PROCESS:C811("chmod 777 "+$pathToScript; $stdin; $stdout; $stderr)
			//utl_Logfile ("mount_volume.log";$stderr)
			$stdin:=""  //not used
			$stdout:=""  //not used
			$stderr:=""
			LAUNCH EXTERNAL PROCESS:C811($pathToScript; $stdin; $stdout; $stderr)
			//stderr should be:
			//mount_afp: the mount flags are 0000 the altflags are 0020
			//if successful and it should appear in Finder
			
			//retest if mounted
			ARRAY TEXT:C222($asVolumes; 0)
			VOLUME LIST:C471($asVolumes)
			If (Find in array:C230($asVolumes; $volumeRequired)>-1)  //was there any joy?
				$success:=True:C214
			End if 
			
		Else   //script not available
			utl_Logfile("mount_volume.log"; "Shell script not available")
		End if 
		
		If ($success)
			utl_Logfile("mount_volume.log"; "util_MountNetworkDrive to "+$volumeRequired+" was SUCCESSFUL")
		Else 
			utl_Logfile("mount_volume.log"; $stderr)
			utl_Logfile("mount_volume.log"; "util_MountNetworkDrive to "+$volumeRequired+" FAILED")
		End if 
		
	Else 
		$success:=True:C214
	End if 
	
Else   //I don't know, what the hell, return true
	$success:=True:C214
End if 


$0:=$success

