// _______
// Method: [Customer_Portal_Extracts].LoginList.Column3   ( ) ->

C_TEXT:C284($ttUsername; $ttUUID)
If (Form event code:C388=On Data Change:K2:15)
	$ttUsername:=This:C1470.Username
	$ttUUID:=This:C1470.pk_id
	C_OBJECT:C1216($esRecs)
	$esRecs:=ds:C1482.Customer_Portal_Logins.query("(Username = :1) AND (pk_id # :2)"; $ttUsername; $ttUUID)
	If ($esRecs.length>0)
		If ($esRecs[0].LOGINS_TO_EXTRACT#Null:C1517)
			uConfirm("That Email has already been used in the Company Named "+$esRecs[0].LOGINS_TO_EXTRACT.Name; "Dang"; "Help")
			
		Else 
			uConfirm("That Email has already been used."; "Dang"; "Help")
		End if 
		This:C1470.Username:="UNDEFINED"
		This:C1470.save()
		esUsers:=esUsers
	End if 
End if 