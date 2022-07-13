If (aPath>0)
	$errCode:=DOC_openLinkedDocument(aPath{aPath})
	If ($errCode#0)
		aPath:=0
		OBJECT SET ENABLED:C1123(*; "selected@"; False:C215)
	End if 
	
Else 
	BEEP:C151
	zwStatusMsg("SELECT"; "Click on a document to open.")
	ALERT:C41("Select a document to open.")
End if 
