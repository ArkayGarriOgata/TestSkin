If ([Users:5]hasEMail:40)
	If (Length:C16([Users:5]email:27)=0)
		[Users:5]email:27:=[Users:5]FirstName:3+"."+[Users:5]LastName:2
	End if 
	
Else 
	[Users:5]email:27:=""
End if 