//%attributes = {"publishedWeb":true}
//PM: util_isDateNull(->datefield) -> true if 00/00/00
//@author mlb - 5/16/02  15:13
C_POINTER:C301($1)
C_BOOLEAN:C305($0)
If ($1->=!00-00-00!)
	$0:=True:C214
Else 
	$0:=False:C215
End if 
//