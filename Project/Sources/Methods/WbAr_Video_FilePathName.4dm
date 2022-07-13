//%attributes = {}
//Method:  WbAr_Video_FilePathName
//Description:  This mehtod handles the dropdown for the WbAr_Video_atFilePathName
// it will play either or open a pdf
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_OBJECT:C1216($oWebArea)
	
	$oWebArea:=New object:C1471()
	
End if   //Done initialize

Case of   //Extension
		
	: (WbAr_Video_atFilePathName=0)
		
	: (Core_Document_GetExtensionT(WbAr_Video_atFilePathName{WbAr_Video_atFilePathName})=CorektExtensionMovie)
		
		$oWebArea.tPathToVideo:=WbAr_Video_atFilePathName{WbAr_Video_atFilePathName}
		
		WbAr_PlayVideo($oWebArea)
		
	: (Core_Document_GetExtensionT(WbAr_Video_atFilePathName{WbAr_Video_atFilePathName})=CorektExtensionPDF)
		
		$oWebArea.tPathToPDF:=WbAr_Video_atFilePathName{WbAr_Video_atFilePathName}
		
		WbAr_OpenPDF($oWebArea)
		
End case   //Done extension
