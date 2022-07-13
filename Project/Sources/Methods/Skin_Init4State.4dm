//%attributes = {}
// Created by 4d Modified by Steve Andes Jul 6 2022

// determine source folder
$tFolderPath:=Get 4D folder:C485(Current resources folder:K5:16)+"Skin"+Folder separator:K24:12+"pngsrc"+Folder separator:K24:12
DOCUMENT LIST:C474($tFolderPath; $atFilePaths; Ignore invisible:K24:16 | Absolute path:K24:14)

// determine destination folder
$tFolderPath:=Get 4D folder:C485(Current resources folder:K5:16)+"Skin"+Folder separator:K24:12+"TestSkin"+Folder separator:K24:12
CREATE FOLDER:C475($tFolderPath; *)

// loop through files in the source
For ($i; 1; Size of array:C274($atFilePaths))
	$tFilePath:=$atFilePaths{$i}
	If (Is picture file:C1113($tFilePath))  // check if the current file is a picture
		READ PICTURE FILE:C678($tFilePath; $gImage)  // pull in the picture file
		$tFilePath:=$tFolderPath+Get picture file name:C1171($gImage)  // set the destination name
		$gImage:=Skin_4State($gImage)
		WRITE PICTURE FILE:C680($tFilePath; $gImage)  // write the file
	End if 
End for 

SHOW ON DISK:C922($tFolderPath)  // show output
