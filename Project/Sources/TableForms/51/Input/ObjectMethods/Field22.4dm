//(S) [contacts]Input'[contacts]State

If (Length:C16([Contacts:51]State:7)=2)
	[Contacts:51]State:7:=Uppercase:C13([Contacts:51]State:7)
End if 