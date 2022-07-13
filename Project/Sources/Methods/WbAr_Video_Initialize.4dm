//%attributes = {}
//Method: WbAr_Video_Initialize(tPhase)
//Description: This method will initialize the WbAr_Video table
Compiler_0000_ConstantsToDo
If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	C_OBJECT:C1216($oWebArea)
	
	$tPhase:=$1
	
	$oWebArea:=New object:C1471()
	
End if   //Done Initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		WbAr_Video_Initialize(CorektPhaseClear)
		
		COLLECTION TO ARRAY:C1562(Form:C1466.cFilePathName; WbAr_Video_atFilePathName)
		
		$nNumberOfFilePaths:=Size of array:C274(WbAr_Video_atFilePathName)
		
		For ($nFilePath; 1; $nNumberOfFilePaths)  //Files
			
			$tFilePathName:=WbAr_Video_atFilePathName{$nFilePath}
			
			If (Core_Document_GetExtensionT($tFilePathName)=CorektExtensionMovie)  //Movie
				
				$oWebArea.tPathToVideo:=$tFilePathName
				
				WbAr_Video_atFilePathName:=$nFilePath
				WbAr_Video_atFilePathName{0}:=WbAr_Video_atFilePathName{$nFilePath}
				
				$nFilePath:=$nNumberOfFilePaths+1
				
			End if   //Done movie
			
		End for   //Done files
		
		WbAr_PlayVideo($oWebArea)
		
	: ($tPhase=CorektPhaseClear)
		
		Compiler_WbAr_Array(Current method name:C684; 0)
		
End case   //Done phase