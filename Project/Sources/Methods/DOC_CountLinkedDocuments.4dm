//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 12/11/07, 17:03:52
// ----------------------------------------------------
// Method: DOC_CountLinkedDocuments
// ----------------------------------------------------

C_LONGINT:C283($0)
C_TEXT:C284($1; LinkKey)

$0:=0

If (Count parameters:C259>=1)
	LinkKey:=$1
	$count:=0  // Modified by: Mel Bohince (6/9/21) 
	SET QUERY DESTINATION:C396(Into variable:K19:4; $count)
	QUERY:C277([x_linked_documents:133]; [x_linked_documents:133]LookUpKey:1=LinkKey)
	$0:=$count
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
Else 
	$0:=-1
End if 