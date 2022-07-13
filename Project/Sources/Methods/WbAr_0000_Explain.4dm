//%attributes = {}
//Method: WbAr_0000_Explain
//Description:  This method explains using 4D's Web Area methods

C_OBJECT:C1216($oVideo)

$oVideo:=New object:C1471()

$oVideo.tWebAreaName:="Web Area"
$oVideo.tPathToVideo:=System folder:C487(Documents folder:K41:18)+"AMS_Documents"+Folder separator:K24:12+"aMs_Help"+Folder separator:K24:12
$oVideo.tVideo:="3D file.MOV"

WbAr_Dialog_Video($oVideo)
