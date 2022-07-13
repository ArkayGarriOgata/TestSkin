//%attributes = {"publishedWeb":true}
//PM: HFSCatToArray2(path;rtnArray) -> 0 if success
//@author mlb - 9/5/02  13:03
//replace filepack

C_LONGINT:C283($0; $i; $numDocs; $numFlds)
C_TEXT:C284($1)
C_POINTER:C301($2)
ARRAY TEXT:C222($2->; 0)

If (Test path name:C476($1)=0)  //folder asked for
	ARRAY TEXT:C222($rtnDocuments; 0)
	DOCUMENT LIST:C474($1; $rtnDocuments)
	$numDocs:=Size of array:C274($rtnDocuments)
	
	ARRAY TEXT:C222($rtnFolders; 0)
	FOLDER LIST:C473($1; $rtnFolders)
	$numFlds:=Size of array:C274($rtnFolders)
	
	ARRAY TEXT:C222($2->; $numDocs+$numFlds)
	For ($i; 1; $numDocs)
		$2->{$i}:=$rtnDocuments{$i}
	End for 
	
	For ($i; 1; $numFlds)
		$2->{$i+$numDocs}:=$rtnFolders{$i}
	End for 
	
	$0:=0
	
Else 
	$0:=-1
End if 