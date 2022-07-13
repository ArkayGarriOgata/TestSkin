//%attributes = {}
//Method:  Core_Document_GetPathReferenceH(oPath)=>hDocumentReference
//Description:  This method will ask for a document to be created or open the document if it exists
//   and returns the document reference.  If hDocumentReference=†00:00:00† then it means the document was
//   not created. (So we can use Path to object and Object to path

//    C_OBJECT($oPath)
//    C_LONGINT($hDocumentReference)

//    $oPath:=New object()

//    $oPath.tDocumentName:="{Name of document to save defaults to blank and asks for document name}"
//    $oPath.tPathname:="{Pathname of where to save document defualts to blank and asks}"
//    $oPath.tMessage:="{Message to display in document selector}"
//    $oPath.tExtension:="{Extension to add at end of document name defaults to txt}"
//    $oPath.bOpenDocument:={Use open document instead of new if no pathname}

//    $hDocumentReference:=Core_Document_GetPathReferenceH($oPath)

If (True:C214)  //Initialize
	
	C_TIME:C306($0; $hDocumentReference)
	C_OBJECT:C1216($1; $oPath)
	
	C_BOOLEAN:C305($bOpenDocument)
	
	C_TEXT:C284($tDocumentPath)
	C_TEXT:C284($tDocumentName; $tExtension)
	C_TEXT:C284($tMessage; $tPathName)
	
	C_OBJECT:C1216($oAsk)
	
	$oPath:=$1
	
	$tDocumentName:=Choose:C955(OB Is defined:C1231($oPath; "tDocumentName"); \
		$oPath.tDocumentName; \
		CorektBlank)
	
	$tPathName:=Choose:C955(OB Is defined:C1231($oPath; "tPathName"); \
		$oPath.tPathName; \
		CorektBlank)
	
	$tMessage:=Choose:C955(OB Is defined:C1231($oPath; "tMessage"); \
		$oPath.tMessage; \
		CorektBlank)
	
	$tExtension:=Choose:C955(OB Is defined:C1231($oPath; "tExtension"); \
		$oPath.tExtension; \
		CorektBlank)
	
	$bOpenDocument:=Choose:C955(OB Is defined:C1231($oPath; "bOpenDocument"); \
		$oPath.bOpenDocument; \
		False:C215)
	
	$hDocumentReference:=?00:00:00?
	
	$oAsk:=New object:C1471()
	
End if   //Done initializing

Case of   //Document & pathname
		
	: (($tDocumentName=CorektBlank) & ($tPathname=CorektBlank))
		
		If ($bOpenDocument)  //Open
			
			$hDocumentReference:=Open document:C264(CorektBlank)
			
		Else   //Create
			
			$hDocumentReference:=Create document:C266(CorektBlank)
			
		End if   //Done open
		
		If (OK=0)
			$hDocumentReference:=?00:00:00?
		End if 
		
	: (($tDocumentName#CorektBlank) & ($tPathname=CorektBlank))
		
		If ($tMessage=CorektBlank)
			$tMessage:="Please select the folder the doucment "+$tDocumentName+" will be saved."
		End if 
		
		$tPathName:=Select folder:C670($tMessage)
		
		If (($tPathName[[Length:C16($tPathName)]])=Folder separator:K24:12)
			
			$tDocumentPath:=$tPathName+$tDocumentName
			
		Else 
			
			$tDocumentPath:=$tPathName+Folder separator:K24:12+$tDocumentName
			
		End if 
		
		Case of 
			: (Not:C34(Test path name:C476($tPathName)=Is a folder:K24:2))
				
			: (Not:C34(Test path name:C476($tDocumentPath)=Is a document:K24:1))
				
				$hDocumentReference:=Create document:C266($tDocumentPath)
				
			: ((Test path name:C476($tDocumentPath)=Is a document:K24:1))
				
				$hDocumentReference:=Open document:C264($tDocumentPath)
				
		End case 
		
	: (($tDocumentName=CorektBlank) & ($tPathname#CorektBlank))
		
		If ($tMessage=CorektBlank)
			$tMessage:="What is the name of the document you would like me to save?"
		End if 
		
		$oAsk.tMessage:=$tMessage
		$oAsk.tValue:=$tDocumentName
		
		Case of 
				
			: (Not:C34(Core_Dialog_RequestN($oAsk)=CoreknDefault))
				
			: ($oAsk.tValue=CorektBlank)
				
			Else 
				
				$hDocumentReference:=Core_Document_GetPathReferenceH($oPath)
				
		End case 
		
	: (($tDocumentName#CorektBlank) & ($tPathname#CorektBlank))
		
		If (($tPathName[[Length:C16($tPathName)]])=Folder separator:K24:12)
			
			$tDocumentPath:=$tPathName+$tDocumentName
			
		Else 
			
			$tDocumentPath:=$tPathName+Folder separator:K24:12+$tDocumentName
			
		End if 
		
		Case of 
				
			: (Not:C34(Test path name:C476($tPathName)=Is a folder:K24:2))
				
			: (Not:C34(Test path name:C476($tDocumentPath)=Is a document:K24:1))
				
				$hDocumentReference:=Create document:C266($tDocumentPath)
				
			: ((Test path name:C476($tDocumentPath)=Is a document:K24:1))
				
				$hDocumentReference:=Open document:C264($tDocumentPath)
				
		End case 
		
End case   //Done document and pathname

$0:=$hDocumentReference
