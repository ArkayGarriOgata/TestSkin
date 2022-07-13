docName:=Request:C163("In AMS_Documents folder, Save as: "; Form:C1466.title+".txt"; "Save"; "Cancel")
If (ok=1) & (Length:C16(docName)>0)
	$doc:=util_putFileName(->docName)
	If (ok=1)
		SEND PACKET:C103($doc; Form:C1466.text)
		CLOSE DOCUMENT:C267($doc)
	End if 
Else 
	BEEP:C151
End if 
//