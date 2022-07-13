//new login

C_OBJECT:C1216($enRec)

If (enLogin#Null:C1517)
	$enRec:=ds:C1482.Customer_Portal_Logins.new()
	$enRec.Customer_Portal_Extract_ID:=enLogin.pk_id
	$enRec.Name:="UNDEFINED"
	$enRec.Username:="name@email.com"
	$enRec.Active:=True:C214
	$enRec.save()
	esUsers:=esUsers.add($enRec)
	For ($i; 0; esUsers.length-1)
		If (esUsers[$i].pk_id=$enRec.pk_id)
			EDIT ITEM:C870(*; "LoginNameColumn"; $i+1)
		End if 
	End for 
Else 
	
End if 