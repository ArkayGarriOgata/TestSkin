//%attributes = {}
//Method:  Core_Document_ClearFolderB(tPathName)=>bFolderCleared
//Description:  This method is recursive.  It is used to clear folders and documents and subfolders

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($0; $bFolderCleared)
	C_TEXT:C284($1; $tPathName)
	
	ARRAY TEXT:C222($atDocument; 0)
	ARRAY TEXT:C222($atFolder; 0)
	
	C_LONGINT:C283($nFolder; $nNumberOfFolders)
	C_LONGINT:C283($nDocument; $nNumberOfDocuments)
	
	C_TEXT:C284($tDocumentPath)
	C_BOOLEAN:C305($bLocked; $bInvisible)
	C_DATE:C307($dCreatedOn; $dModifiedOn)
	C_TIME:C306($hCreatedAt; $dModifiedAt)
	
	$tPathName:=$1
	$bFolderCleared:=False:C215
	
End if   //Done inialization

Case of   //Delete document
		
	: (Test path name:C476($tPathName)=Is a folder:K24:2)  //Folder
		
		FOLDER LIST:C473($tPathName; $atFolder)
		
		$nNumberOfFolders:=Size of array:C274($atFolder)
		
		If ($nNumberOfFolders>0)  //Folder 
			
			For ($nFolder; 1; $nNumberOfFolders)  //Loop thru folder
				
				$bFolderCleared:=Core_Document_ClearFolderB($atFolder{$nFolder})
				
			End for   //Done loop thur folder
			
		Else   //Document
			
			DOCUMENT LIST:C474($tPathName; $atDocument)
			
			$nNumberOfDocuments:=Size of array:C274($atDocument)
			
			For ($nDocument; 1; $nNumberOfDocuments)  //Loop thru documents
				
				$tDocumentPath:=$tPathName+Folder separator:K24:12+$atDocument{$nDocument}
				
				GET DOCUMENT PROPERTIES:C477($tDocumentPath; $bLocked; $bInvisible; $dCreatedOn; $hCreatedAt; $dModifiedOn; $dModifiedAt)
				
				If ($bLocked)  //Unlock it
					
					SET DOCUMENT PROPERTIES:C478($tDocumentPath; True:C214; $bInvisible; $dCreatedOn; $hCreatedAt; $dModifiedOn; $dModifiedAt)
					
				End if   //Done unlock it
				
				DELETE DOCUMENT:C159($tDocumentPath)
				
			End for   //Done looping thru documents
			
			$bFolderCleared:=True:C214
			
		End if   //Done folder
		
	: (Test path name:C476($tPathName)=Is a document:K24:1)
		
		GET DOCUMENT PROPERTIES:C477($tPathName; $bLocked; $bInvisible; $dCreatedOn; $hCreatedAt; $dModifiedOn; $dModifiedAt)
		
		If ($bLocked)  //Unlock it
			
			SET DOCUMENT PROPERTIES:C478($tPathName; True:C214; $bInvisible; $dCreatedOn; $hCreatedAt; $dModifiedOn; $dModifiedAt)
			
		End if   //Done unlock it
		
		DELETE DOCUMENT:C159($tPathName)
		
End case 

$0:=$bFolderCleared