//%attributes = {"publishedWeb":true}
//PM: util_stringBoolean(bool) -> string
//@author mlb - 4/18/01  14:51
C_BOOLEAN:C305($1)
C_TEXT:C284($0)
If ($1)
	$0:="Yes"
Else 
	$0:="No"
End if 