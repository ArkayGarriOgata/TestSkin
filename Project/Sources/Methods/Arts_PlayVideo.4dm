//%attributes = {}
//Method:  Arts_PlayVideo(tANumber)
//Description:  This method plays videos created by Artios in WbAr_Video dialog
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tANumber)
	
	C_COLLECTION:C1488($cFilePathName)
	
	C_OBJECT:C1216($oVideo)
	
	C_OBJECT:C1216($oAlert)
	
	C_TEXT:C284($tLocation)
	
	ARRAY TEXT:C222($atFilePathName; 0)
	
	$tANumber:=$1
	
	$cFilePathName:=New collection:C1472()
	
	$oVideo:=New object:C1471()
	$oAlert:=New object:C1471()
	
	$oAlert.tMessage:="No movie found."
	
End if   //Done initialize

$tLocation:=UrWk_GetLocationT

Case of   //Location
		
	: ($tLocation=ArkyktLctnHauppauge)
		
		$tServer:="3D_NY"
		
	: ($tLocation=ArkyktLctnRoanoke)
		
		$tServer:="3D_VA"
		
	: ($tLocation=ArkyktLctnWarehouse)
		
		$tServer:="3D_VA"
		
	: ($tLocation=ArkyktLctnRemote)
		
		$tServer:="3D_NY"
		
End case   //Done location

$oVideo.tPathToVideo:=$tServer+Folder separator:K24:12+$tANumber+Folder separator:K24:12

If (Core_Document_ExistsB($oVideo.tPathToVideo; CorektBlank))  //PathName
	
	DOCUMENT LIST:C474($oVideo.tPathToVideo; $atFilePathName; Absolute path:K24:14)
	
	ARRAY TO COLLECTION:C1563($cFilePathName; $atFilePathName)
	
	$oVideo.cFilePathName:=$cFilePathName
	
	WbAr_Dialog_Video($oVideo)
	
Else   //Error
	
	Core_Dialog_Alert($oAlert)
	
End if   //Done pathname

