If (aPath>0)
	$selected:=aPath
	CONFIRM:C162("Remove the link from this record to the document "+aPath{$selected})
	If (ok=1)
		$errCode:=DOC_removeLink(aRecNum{$selected})
		If ($errCode=0)
			DELETE FROM ARRAY:C228(aPath; $selected; 1)
			DELETE FROM ARRAY:C228(aRecNum; $selected; 1)
			aPath:=0
			aRecNum:=0
			OBJECT SET ENABLED:C1123(*; "selected@"; False:C215)
		End if 
	End if 
	
Else 
	BEEP:C151
	zwStatusMsg("SELECT"; "Click on a document to remove the link from this record.")
	ALERT:C41("Select a document to remove the link from this record..")
End if 
