//%attributes = {}
// Method:  Skin_Init4State
// Description:  This method....
//. ??? Ref 4D source  ???

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nFile; $nNumberOfFiles)
	
	C_PICTURE:C286($gImage; $g4State)
	
	C_TEXT:C284($tSourcePath; $tDestinationPath)
	
	ARRAY TEXT:C222($atSourcePath; 0)
	
End if   //Done initialize

$tSourcePath:=Get 4D folder:C485(Current resources folder:K5:16)+"Skin"+Folder separator:K24:12+"pngsrc"+Folder separator:K24:12

DOCUMENT LIST:C474($tSourcePath; $atSourcePath; Ignore invisible:K24:16 | Absolute path:K24:14)

$tDestinationPath:=Get 4D folder:C485(Current resources folder:K5:16)+"Skin"+Folder separator:K24:12+"TestSkin"+Folder separator:K24:12

CREATE FOLDER:C475($tDestinationPath; *)

$nNumberOfFiles:=Size of array:C274($atSourcePath)

For ($nFile; 1; $nNumberOfFiles)  //Image
	
	$tSourcePath:=$atSourcePath{$nFile}
	
	If (Is picture file:C1113($tSourcePath))  //Picture
		
		READ PICTURE FILE:C678($tSourcePath; $gImage)
		
		$tDestinationPath:=$tDestinationPath+Get picture file name:C1171($gImage)  // set the destination name
		
		$g4State:=Skin_4State($gImage)
		
		WRITE PICTURE FILE:C680($tDestinationPath; $g4State)
		
	End if   //Done picture
	
End for   //Done image

SHOW ON DISK:C922($tDestinationPath)
