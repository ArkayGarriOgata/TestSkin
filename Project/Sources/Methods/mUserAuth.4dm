//%attributes = {"publishedWeb":true}
//(p) mUserAuth
//setup user authorization code for printing POs

C_TEXT:C284($Verify; $Code; $user)

READ WRITE:C146([Users:5])

Repeat 
	$User:=""
	$User:=Request:C163("Please enter the User's Initials")
Until ($User#"") | (OK=0)

If (OK=1)
	QUERY:C277([Users:5]; [Users:5]Initials:1=$User)
	
	If (Records in selection:C76([Users:5])=1)
		If (fLockNLoad(->[Users:5]))
			<>fContinue:=True:C214
			uConfirm("Enter/Change an Authorization code."+Char:C90(13)+"      or"+Char:C90(13)+"Clear Authorization Code."; "Enter/Chng"; "Clear")
			
			If (OK=1)  //enter/change
				Repeat 
					$Code:=""
					$Code:=Request:C163("Please Enter User PO Printing Code."; "xxxxxxxxxx")
					
					If (OK=1)
						If ($Code#"")
							$Verify:=""
							$Verify:=Request:C163("Please VERIFY the User PO Printing Code."; "xxxxxxxxxx")
						End if 
						
						If (OK=1)
							If ($Verify#$Code)
								ALERT:C41("The originally entered Code and the Verification  -  Do NOT match.")
								OK:=1
								$Verify:=""
								$Code:=""
							End if 
						End if 
					End if 
				Until (OK=0) | (($Verify#"") & ($Code#""))
				
				If ($Verify#"") & ($Code#"")
					[Users:5]PIN:16:=$Code
					SAVE RECORD:C53([Users:5])
					ALERT:C41("Done")
				End if 
			Else 
				uConfirm("Are you sure that you want to clear the selected User's Authorization code?")
				
				If (OK=1)
					[Users:5]PIN:16:=""
					SAVE RECORD:C53([Users:5])
					ALERT:C41("Done")
				End if 
			End if 
		End if 
	Else 
		ALERT:C41("Users Initials not found or not unique.")
	End if 
End if 