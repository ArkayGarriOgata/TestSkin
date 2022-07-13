//%attributes = {"publishedWeb":true}
//PM: util_CurrentDocumentPath(get|set{;path) -> 

//@author mlb - 5/1/01  16:28

C_TEXT:C284($1)
C_TEXT:C284($0; $2)
C_TIME:C306($docRef)

Case of 
	: ($1="Get")
		//$0:=GetAppPath 
		
		$0:=util_DocumentPath  //mlb 08/18/03
		
		
	: ($1="Set")
		$docRef:=Create document:C266($2+"temp")
		CLOSE DOCUMENT:C267($docRef)
		util_deleteDocument(document)
		$0:=$2
End case 
//