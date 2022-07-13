//%attributes = {}


ttText:=Request:C163("Enter barcode value")
If (OK=1)
	sPOIcode39:="*"+ttText+"*"
	PRINT SETTINGS:C106
	
	If (OK=1)
		$xlPix:=Print form:C5("BARCODE")
		PAGE BREAK:C6
	End if 
End if 