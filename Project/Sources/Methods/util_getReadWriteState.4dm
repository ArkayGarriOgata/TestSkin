//%attributes = {"publishedWeb":true}
//PM: util_getReadWriteState(filePtr) -> t|f
//@author mlb - 6/26/02  12:08
C_POINTER:C301($1)
C_BOOLEAN:C305($readOnly; $0)
$readOnly:=Read only state:C362($1->)
If ($readOnly)
	zwStatusMsg("READ ONLY"; "File: "+Table name:C256($1))
Else 
	zwStatusMsg("READ WRITE"; "File: "+Table name:C256($1))
End if 
$0:=$readOnly