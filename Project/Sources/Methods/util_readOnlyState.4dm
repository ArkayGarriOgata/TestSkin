//%attributes = {}
// -------
// Method: util_readOnlyState   ( ) -> Read | Write
// By: Mel Bohince @ 04/10/17, 16:17:50
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($0)
C_POINTER:C301($1)

If (Read only state:C362($1->))
	$0:="ReadOnly"
Else 
	$0:="ReadWrite"
End if 