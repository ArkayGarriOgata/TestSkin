//allow user to save this message to a disk file

$vhDocRef:=Create document:C266("")
If (OK=1)
	CLOSE DOCUMENT:C267($vhDocRef)
	BLOB TO DOCUMENT:C526(Document; [edi_Inbox:154]Content:3)
	If (OK=0)
		uConfirm("Error writing document."; "OK"; "Help")
	End if 
	
End if 
