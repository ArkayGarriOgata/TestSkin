docName:=Request:C163("In AMS_Documents folder, Save as: "; "log.txt"; "Save"; "Cancel")
If (ok=1) & (Length:C16(docName)>0)
	$doc:=util_putFileName(->docName)
	If (ok=1)
		SEND PACKET:C103($doc; t1)
		CLOSE DOCUMENT:C267($doc)
		// obsolete call, method deleted 4/28/20 uDocumentSetType 
	End if 
Else 
	BEEP:C151
End if 
//