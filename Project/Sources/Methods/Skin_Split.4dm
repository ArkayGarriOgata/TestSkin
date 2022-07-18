//%attributes = {}
// Method:  Skin_Init4State
// Description:  This meathod takes a file path to a 4-state button picture files and
// slices it into 4 separate icon files, each with the proper button position name

$filePath:=$2

For ($count; 0; 300; 100)
	$initialPicture:=$1
	
	// determine position of the end of the file name (before the .png)
	$pos:=Position:C15(".png"; $filePath)
	
	// crop picture depending on $count (equivalent to the nuber of pixels to shift down)
	// this whole loop assumes 100x100 icons (can be updated to deal with relative sizes later)
	TRANSFORM PICTURE:C988($initialPicture; Crop:K61:7; 0; $count; 100; 100)
	
	// creating temp path
	$finalPath:=$filePath
	
	// determine how to name each individual file
	Case of 
		: ($count=0)
			
			$finalPath:=Insert string:C231($filePath; "-enable"; $pos)
			
		: ($count=100)
			
			$finalPath:=Insert string:C231($filePath; "-click"; $pos)
			
		: ($count=200)
			
			$finalPath:=Insert string:C231($filePath; "-hover"; $pos)
			
		: ($count=300)
			
			$finalPath:=Insert string:C231($filePath; "-disable"; $pos)
			
	End case 
	
	// write cropped image to temp path
	WRITE PICTURE FILE:C680($finalPath; $initialPicture)
	
End for 



