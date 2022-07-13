//%attributes = {"publishedWeb":true}
//PM: SetDefaultPath(path) -> 
//@author mlb - 9/5/02  12:29
//replace FilePack

C_TEXT:C284($1; $tempFile)
C_LONGINT:C283($0)
C_TIME:C306($docRef)

$tempFile:=$1+"tempFile.txt"

If (Test path name:C476($tempFile)>0)
	util_deleteDocument($tempFile)
End if 

$docRef:=Create document:C266($tempFile)
CLOSE DOCUMENT:C267($docRef)
DELETE DOCUMENT:C159($tempFile)

If (Test path name:C476($1)=0)
	$0:=0
Else 
	$0:=-1
End if 