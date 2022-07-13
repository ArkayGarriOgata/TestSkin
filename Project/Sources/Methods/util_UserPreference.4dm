//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/15/05, 13:54:05
// ----------------------------------------------------
// Method: util_UserPreference
// Description
// 
//
// Parameters name of pref file
// ----------------------------------------------------
C_TEXT:C284(docName; $1; $2; $3)
C_TIME:C306($docRef)
$0:=""

Case of 
	: ($1="get")
		$aMsDocFolder:=util_DocumentPath("get")
		$prefDoc:=$aMsDocFolder+$2
		If (Test path name:C476($prefDoc)#Is a document:K24:1)
			$docRef:=Create document:C266($prefDoc)
			CLOSE DOCUMENT:C267($docRef)
		End if 
		$docRef:=Open document:C264($prefDoc)
		If ($docRef#?00:00:00?)
			RECEIVE PACKET:C104($docRef; $pref; 32000)
			CLOSE DOCUMENT:C267($docRef)
			$0:=$pref
		End if 
		
	: ($1="set")
		docName:=$2
		$docRef:=util_putFileName(->docName)
		If ($docRef#?00:00:00?)
			SEND PACKET:C103($docRef; $3)
			CLOSE DOCUMENT:C267($docRef)
			$0:=docName
		End if 
		
End case 
