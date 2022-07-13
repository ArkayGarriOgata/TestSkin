//%attributes = {}
// Modified from 4d Depot by Steve Andes


// get the source folder path
$folderPath:=Get 4D folder:C485(Current resources folder:K5:16)+"Skin"+Folder separator:K24:12+"TestSkin"+Folder separator:K24:12
DOCUMENT LIST:C474($folderPath; $filePaths; Ignore invisible:K24:16 | Absolute path:K24:14)

// get the destination folder path
$folderPath:=Get 4D folder:C485(Current resources folder:K5:16)+"Skin"+Folder separator:K24:12+"TestSkin"+Folder separator:K24:12+"splitButtons"+Folder separator:K24:12
CREATE FOLDER:C475($folderPath; *)

// loop through the items in the source
For ($i; 1; Size of array:C274($filePaths))
	$filePath:=$filePaths{$i}
	If (Is picture file:C1113($filePath))  // check that the file is a picture
		READ PICTURE FILE:C678($filePath; $image)  // pull in the picture
		$filePath:=$folderPath+Get picture file name:C1171($image)  // determine the destination name
		Skin_Split($image; $filePath)
	End if 
End for 