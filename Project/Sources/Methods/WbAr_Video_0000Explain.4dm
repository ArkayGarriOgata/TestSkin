//%attributes = {}
//WbAr_Video_0000Explain
//Description:  This method explains playing video using Web Area

C_OBJECT:C1216($oWebArea)

$oWebArea:=New object:C1471()

$oWebArea.tWebAreaName:="MyWebArea"
$oWebArea.tPathToVideo:="{FullPathnameToVideo}.{Extension}"  //Usually Extension is mp4 or mov

WbAr_PlayVideo($oWebArea)