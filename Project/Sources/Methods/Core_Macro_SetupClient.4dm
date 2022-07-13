//%attributes = {"invisible":true,"shared":true}
//Method:  Core_Macro_SetupClient
//Description:  This method will copy the macros from the server onto the developers computer

C_TEXT:C284($tClientMacrosFolder; $tClientResourceMacrosFolder)

If (Not:C34(Is compiled mode:C492) & (Application type:C494=4D Remote mode:K5:5))
	
	$tClientMacrosFolder:=Get 4D folder:C485(4D Client database folder:K5:13)+"Macros v2"
	
	$tClientResourceMacrosFolder:=Get 4D folder:C485(Current resources folder:K5:16)+"Macros v2"
	
	If (Test path name:C476($tClientMacrosFolder)#Is a folder:K24:2)
		CREATE FOLDER:C475($tClientMacrosFolder)
	End if 
	
	COPY DOCUMENT:C541($tClientResourceMacrosFolder+Folder separator:K24:12+"NucleusMacro.xml"; $tClientMacrosFolder+Folder separator:K24:12+"NucleusMacro.xml")
	
End if 

