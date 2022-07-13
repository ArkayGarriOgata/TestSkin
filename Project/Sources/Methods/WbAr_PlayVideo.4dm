//%attributes = {}
//Method:  WbAr_PlayVideo(oWebArea)
//Description:  This method will play a video in a web area
// tPathToVideo - is the pathname to the video

//Example:

//    C_OBJECT($oPlayVideo)

//    $oPlayVideo:=New object()

//    $oPlayVideo.tPathToVideo:=System folder(Documents folder)+"AMS_Documents"+Folder separator+"aMs_Help"+Folder separator+"MyVideo.MOV"

//    WbAr_PlayVideo ($oPlayVideo)

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oWebArea)
	
	C_TEXT:C284($tWebAreaName; $tPathToVideo)
	
	$oWebArea:=$1
	
	$tWebAreaName:=Choose:C955(\
		OB Is defined:C1231($oWebArea; "tWebAreaName"); \
		$oWebArea.tWebAreaName; \
		"Web Area")
	
	$tPathToVideo:=Choose:C955(\
		OB Is defined:C1231($oWebArea; "tPathToVideo"); \
		$oWebArea.tPathToVideo; \
		CorektBlank)
	
End if   //Done initialize

Case of   //Verify
		
	: ($tWebAreaName=CorektBlank)
	: ($tPathToVideo=CorektBlank)
		
	Else   //Play
		
		WA OPEN URL:C1020(*; $tWebAreaName; $tPathToVideo)
		
End case   //Done verify
