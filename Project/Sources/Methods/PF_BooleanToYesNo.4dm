//%attributes = {}
// -------
// Method: PF_BooleanToYesNo   ( ) ->
// By: Mel Bohince @ 12/13/17, 12:01:14
// Description
// 
// ----------------------------------------------------

C_BOOLEAN:C305($1)
C_TEXT:C284($0)
If ($1)
	$0:="Yes"
Else 
	$0:="No"
End if 
//