If (Length:C16([Addresses:30]Country:9)>2)
	BEEP:C151
	$country:=Request:C163("Must use 2 character abrievation:"; ""; "Ok"; "Lookup")
	If (ok=0)
		OPEN URL:C673("https://www.ncbi.nlm.nih.gov/books/NBK7249/")
		[Addresses:30]Country:9:=""
		GOTO OBJECT:C206([Addresses:30]Country:9)
		
	Else 
		[Addresses:30]Country:9:=Substring:C12($country; 1; 2)
	End if 
	
End if 

[Addresses:30]Country:9:=Uppercase:C13([Addresses:30]Country:9)