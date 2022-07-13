READ WRITE:C146([Contacts_Tags:183])
$id:=Request:C163("Mark this contact with initials:"; <>zResp)
util_textNoGremlins(->$id)
If (ok=1)
	If ($id#"")
		If (Length:C16($id)<5)
			QUERY:C277([Contacts_Tags:183]; [Contacts_Tags:183]id_added_by_converter:2=[Contacts:51]WhoseContact:37; *)
			QUERY:C277([Contacts_Tags:183];  & ; [Contacts_Tags:183]UserID:1=$id)
			If (Records in selection:C76([Contacts_Tags:183])=0)
				CREATE RECORD:C68([Contacts_Tags:183])
				[Contacts_Tags:183]UserID:1:=$id
				[Contacts_Tags:183]id_added_by_converter:2:=[Contacts:51]WhoseContact:37
				SAVE RECORD:C53([Contacts_Tags:183])
			Else 
				BEEP:C151
				CONFIRM:C162("The initials "+$id+" were already there, Delete them?")
				If (ok=1)
					DELETE RECORD:C58([Contacts_Tags:183])
				End if 
			End if 
			QUERY:C277([Contacts_Tags:183]; [Contacts_Tags:183]id_added_by_converter:2=[Contacts:51]WhoseContact:37)
			
		Else 
			BEEP:C151
			ALERT:C41("Initials must be less than 5 letters.")
		End if   //length      
	Else 
		BEEP:C151
		ALERT:C41("Must enter someones initials.")
	End if   //not blank  
End if   //ok
//