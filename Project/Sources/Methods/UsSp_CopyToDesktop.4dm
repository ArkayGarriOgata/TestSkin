//%attributes = {}
//Method:  UsSp_CopyToDesktop(patAttachementPath)
//Description:  This method will copy documents from 
//.  {User}:Documents:AMS_Documents:User_Support to Desktop:aMsHelp

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $patAttachmentPath)
	
	C_LONGINT:C283($nAttachement; $nNumberOfAttachments)
	C_TEXT:C284($tDesktopPathName)
	
	$patAttachmentPath:=$1
	
	$tDesktopPathName:=System folder:C487(Desktop:K41:16)+"aMsUserSupport"
	
	$nNumberOfAttachments:=Size of array:C274($patAttachmentPath->)
	
End if   //Done initialize

If (Core_Document_FolderPathExistsB($tDesktopPathName; True:C214; True:C214))  //Create and clear aMsUserSupport folder
	
	For ($nAttachement; 1; $nNumberOfAttachments)  //Attachments
		
		$tSource:=$patAttachmentPath->{$nAttachement}
		
		$tFileName:=Core_Document_GetNameT($tSource)
		
		$tDestination:=$tDesktopPathName+Folder separator:K24:12+$tFileName
		
		COPY DOCUMENT:C541($tSource; $tDestination)  //Copy documents to desktop
		
	End for   //Done attachments
	
End if   //Done create and clear aMsUserSupport folder

