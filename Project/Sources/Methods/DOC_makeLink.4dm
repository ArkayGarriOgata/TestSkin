//%attributes = {}
// Method: DOC_makeLink (key{;path}) -> 
// ----------------------------------------------------
// by: mel: 09/09/04, 12:15:38
// ----------------------------------------------------

C_TEXT:C284($1)
C_TEXT:C284($2)
C_LONGINT:C283($0)

REDUCE SELECTION:C351([x_linked_documents:133]; 0)

If (Count parameters:C259=2)
	CREATE RECORD:C68([x_linked_documents:133])
	[x_linked_documents:133]LookUpKey:1:=$1
	[x_linked_documents:133]DocPath:3:=$2
	SAVE RECORD:C53([x_linked_documents:133])
	
Else 
	zwStatusMsg("LINK DOC"; "Please find and open the document that you wish to link.")
	C_TIME:C306($docRef)
	$docRef:=Open document:C264("")
	If (OK=1)
		CLOSE DOCUMENT:C267($docRef)
		CREATE RECORD:C68([x_linked_documents:133])
		[x_linked_documents:133]LookUpKey:1:=$1
		[x_linked_documents:133]DocPath:3:=document
		[x_linked_documents:133]DateLinked:6:=4D_Current_date
		[x_linked_documents:133]LinkedBy:7:=<>zResp
		SAVE RECORD:C53([x_linked_documents:133])
		
	End if 
End if 

$0:=Record number:C243([x_linked_documents:133])
REDUCE SELECTION:C351([x_linked_documents:133]; 0)