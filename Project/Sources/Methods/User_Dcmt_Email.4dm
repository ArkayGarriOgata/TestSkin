//%attributes = {}
//Mehtod: User_Dcmt_Email
//Description:  This method will create a document for all users emails

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nUser; $nNumberOfUsers)
	C_TEXT:C284($tTab)
	C_TEXT:C284($tCR)
	C_TIME:C306($hDocumentReference)
	
	ARRAY TEXT:C222($atFirstName; 0)
	ARRAY TEXT:C222($atLastName; 0)
	ARRAY TEXT:C222($atUserName; 0)
	ARRAY TEXT:C222($atInitials; 0)
	
	$tTab:=Char:C90(Tab:K15:37)
	$tCR:=Char:C90(Carriage return:K15:38)
	
	READ ONLY:C145([Users:5])
	ALL RECORDS:C47([Users:5])
	SELECTION TO ARRAY:C260([Users:5]FirstName:3; $atFirstName; \
		[Users:5]LastName:2; $atLastName; \
		[Users:5]UserName:11; $atUserName; \
		[Users:5]Initials:1; $atInitials)
	
	$nNumberOfUsers:=Size of array:C274($atFirstName)
	
	MULTI SORT ARRAY:C718($atFirstName; >; $atLastName; >; $atUserName; $atInitials)
	
End if   //Done Initialize

$hDocumentReference:=Create document:C266(CorektBlank)

If (OK=1)  //Ok to create document
	
	For ($nUser; 1; $nNumberOfUsers)  //Loop thru users
		
		$tUserName:=$atFirstName{$nUser}+CorektSpace+$atLastName{$nUser}
		$tEmail:=Email_WhoAmI($tUserName; $atInitials{$nUser})
		
		If ($tEmail#CorektBlank)
			SEND PACKET:C103($hDocumentReference; $tUserName+$tTab)
			SEND PACKET:C103($hDocumentReference; $tEmail+$tCR)
		End if 
		
	End for   //Done looping thru users
	
	CLOSE DOCUMENT:C267($hDocumentReference)
	
End if   //Done ok to create the document
