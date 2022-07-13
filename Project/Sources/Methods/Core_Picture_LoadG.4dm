//%attributes = {}
//Method: Core_Picture_LoadG(tFilename)=>gPicture
//Description:  This method will return a picture it looks in the Resources:Skin:Master
//. for the name of the icon

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tFilename)
	C_PICTURE:C286($0; $gPicture)
	
	C_TEXT:C284($tPathname)
	C_BLOB:C604($lPicture)
	
	$tFilename:=$1
	
	$tPathname:=CorektBlank
	
End if   //Done initialize

$tPathname:=Get 4D folder:C485(Current resources folder:K5:16)+"Skin"+Folder separator:K24:12+"Master"+Folder separator:K24:12

$tPathname:=$tPathname+$tFilename+".png"

DOCUMENT TO BLOB:C525($tPathname; $lPicture)

BLOB TO PICTURE:C682($lPicture; $gPicture)

$0:=$gPicture