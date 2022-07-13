If (Length:C16([Contacts:51]EmailAddress:14)=0)
	[Contacts:51]EmailAddress:14:="?"+Substring:C12([Contacts:51]FirstName:27; 1; 1)+[Contacts:51]LastName:26+"@"+[Contacts:51]Company:3+".com"
End if 
//