//%attributes = {}
// Method:  Skin_Init4State
// Description:  This method takes the selection made by the user and determines the source and destination for the
// converstion process from single icon to 4-state button icon
// https://github.com/miyako/4d-component-generate-icon // reference code from 4d


If (True:C214)  //Initialize
	
	C_LONGINT:C283($nFile; $nNumberOfFiles)
	
	C_PICTURE:C286($gImage; $g4State)
	
	C_TEXT:C284($tSourcePath; $tDestinationPath)
	
	ARRAY TEXT:C222($atSourcePath; 0)
	
	ARRAY TEXT:C222($atSourceFamily; 0)
	
End if   //Done initialize

COLLECTION TO ARRAY:C1562(Form:C1466.cSources; $atSourcePath; "pathName")

COLLECTION TO ARRAY:C1562(Form:C1466.cSources; $atSourceFamily; "FamilyName")

$tDestinationPath:=Get 4D folder:C485(Current resources folder:K5:16)+"Skin"+Folder separator:K24:12+$atSourceFamily{1}+Folder separator:K24:12

CREATE FOLDER:C475($tDestinationPath; *)

$nNumberOfFiles:=Size of array:C274($atSourcePath)

For ($nFile; 1; $nNumberOfFiles)  //Image
	
	$tSourcePath:=$atSourcePath{$nFile}
	
	If (Is picture file:C1113($tSourcePath))  //Picture
		
		READ PICTURE FILE:C678($tSourcePath; $gImage)
		
		$tFinalDestinationPath:=$tDestinationPath+Get picture file name:C1171($gImage)  // set the destination name
		
		$g4State:=Skin_4State($gImage)
		
		WRITE PICTURE FILE:C680($tFinalDestinationPath; $g4State)
		
	End if   //Done picture
	
End for   //Done image

SHOW ON DISK:C922($tDestinationPath)
