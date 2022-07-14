//%attributes = {}
If (True:C214)
	
	C_BOOLEAN:C305($0; $bVerify)
	
	$bVerify:=False:C215
	
End if 

Case of 
	: (Form:C1466.tSource=CorektBlank)
	: (Form:C1466.tDestination=CorektBlank)
	Else 
		$0:=True:C214
End case 