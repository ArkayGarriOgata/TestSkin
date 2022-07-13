//%attributes = {}
// Method: DOC_ShowLinkedDocuments (lookupKey) -> 
// ----------------------------------------------------
// by: mel: 09/09/04, 12:11:27
// ----------------------------------------------------

C_LONGINT:C283($0)
C_TEXT:C284($1; LinkKey)

$0:=0
If (Count parameters:C259>=1)
	LinkKey:=$1
	READ ONLY:C145([x_linked_documents:133])
	QUERY:C277([x_linked_documents:133]; [x_linked_documents:133]LookUpKey:1=LinkKey)
	ARRAY LONGINT:C221(aRecNum; 0)
	ARRAY TEXT:C222(aPath; 0)
	SELECTION TO ARRAY:C260([x_linked_documents:133]; aRecNum; [x_linked_documents:133]DocPath:3; aPath)
	$winRef:=Open form window:C675([x_linked_documents:133]; "pickLinkedDoc"; 8)
	DIALOG:C40([x_linked_documents:133]; "pickLinkedDoc")
	CLOSE WINDOW:C154($winRef)
	REDUCE SELECTION:C351([x_linked_documents:133]; 0)
	$0:=Size of array:C274(aPath)
	ARRAY TEXT:C222(aPath; 0)
	ARRAY LONGINT:C221(aRecNum; 0)
	
Else 
	$0:=-1
End if 