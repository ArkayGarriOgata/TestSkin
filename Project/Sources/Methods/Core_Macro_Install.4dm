//%attributes = {"invisible":true,"shared":true}
//Method:  Core_Macro_Install
//Description:  This method will make sure the core macro file is installed
//   on the client so that either client or standalone 4D will see the macros
//   This assumes the server version of the application has the Macro folder in the resources folder

If (True:C214)  //Initialize
	
	C_TEXT:C284($tActive4DFolder; $tDestinationMacro; $tResourceFolder; $tSourceMacro; $tMacroPath)
	
	$tActive4DFolder:=Get 4D folder:C485(Active 4D Folder:K5:10)
	$tResourceFolder:=Get 4D folder:C485(Current resources folder:K5:16)
	
End if   //Done Initialize

If (Core_Document_FolderPathExistsB($tActive4DFolder+CorektMacroFolderName; True:C214))  //The folder for the macros to be stored does not exist create the folder
	
	$tMacroPath:=CorektMacroFolderName+Folder separator:K24:12+CorektMacroXmlName
	
	$tSourceMacro:=$tResourceFolder+$tMacroPath
	$tDestinationMacro:=$tActive4DFolder+$tMacroPath
	
	COPY DOCUMENT:C541($tSourceMacro; $tDestinationMacro; *)  //  copy the source Nucleus xml file from the resources folder and override if it already exists
	
End if 

