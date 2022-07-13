//%attributes = {"publishedWeb":true}
//(p) mViewUserAuth
//view user authorization code for printing POs

READ WRITE:C146([Users:5])

Repeat 
	$User:=""
	$User:=Request:C163("Please enter the User's Initials")
Until ($User#"") | (OK=0)

If (OK=1)
	QUERY:C277([Users:5]; [Users:5]Initials:1=$User)
	
	If (Records in selection:C76([Users:5])=1)
		ALERT:C41([Users:5]PIN:16)
	Else 
		ALERT:C41("Users Initials not found or not unique.")
	End if 
End if 