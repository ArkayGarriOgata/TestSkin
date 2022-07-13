//%attributes = {"publishedWeb":true}
//doQuickSave

If (Length:C16(sFile)>0)
	zwStatusMsg("SAVE"; "Saving record "+sFile+".")
	SAVE RECORD:C53(filePtr->)
Else 
	BEEP:C151
	zwStatusMsg("SAVE"; "File to save not specified")
End if 