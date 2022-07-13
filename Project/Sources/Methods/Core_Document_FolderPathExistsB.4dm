//%attributes = {}
//Method:  Core_Document_FolderPathExistsB(tPathName{;bCreate}{;bClear})=>bFolderExists
//Description:  This method will return true if the pathname exists.
//   True for create then it will try and create it if it doesn't exist
//   True for clear will clear its contents.

If (True:C214)  //Initializing
	
	C_BOOLEAN:C305($2; $bCreate; $3; $bClear; $0; $bFolderExists)
	C_TEXT:C284($1; $tPathName; $tTemporaryDirectory)
	
	C_LONGINT:C283($nNumberOfParameters; $nFolderPathName)
	C_LONGINT:C283($nFolder; $nNumberOfFolders)
	
	ARRAY TEXT:C222($atFolder; 0)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tPathName:=$1
	
	$bCreate:=False:C215
	$bClear:=False:C215
	
	If ($nNumberOfParameters>=2)  //Options
		$bCreate:=$2
		If ($nNumberOfParameters>=3)
			$bClear:=$3
		End if 
	End if   //Done options
	
	$nFolderPathName:=Test path name:C476($tPathName)
	$bFolderExists:=False:C215
	
End if   //Done initializing

Case of   //Folder
		
	: (($nFolderPathName#Is a folder:K24:2) & $bCreate)
		
		Core_Text_ParseToArray($tPathName; ->$atFolder; Folder separator:K24:12)
		
		$nNumberOfFolders:=Size of array:C274($atFolder)
		$tTemporaryDirectory:=$atFolder{1}
		
		For ($nFolder; 2; $nNumberOfFolders)  //Loop through Folder
			
			$tTemporaryDirectory:=$tTemporaryDirectory+Folder separator:K24:12+$atFolder{$nFolder}
			
			If (Test path name:C476($tTemporaryDirectory)#Is a folder:K24:2)
				CREATE FOLDER:C475($tTemporaryDirectory)
			End if 
			
		End for   //Done looping through Folder
		
		$bFolderExists:=(Test path name:C476($tTemporaryDirectory)=Is a folder:K24:2)
		
	: (($nFolderPathName=Is a folder:K24:2) & $bClear)
		
		$bFolderExists:=Core_Document_ClearFolderB($tPathName)
		
	: ($nFolderPathName=Is a folder:K24:2)
		
		$bFolderExists:=True:C214
		
End case   //Done folder

$0:=$bFolderExists
