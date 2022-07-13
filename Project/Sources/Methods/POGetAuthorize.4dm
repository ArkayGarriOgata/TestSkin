//%attributes = {"publishedWeb":true}
//(p) POGetAutorize 
//get from user authorization code and determine validity
//Returns String 'Stop' do not print po(s), 'Print' authorization OK, 
//'NoSig' Print with out signature
//• 3/3/98 cs created
// • mel (11/2/04, 15:44:48) refactor to make options more clear

C_TEXT:C284($0)

Repeat 
	<>PIN:=util_UserGetPIN
	
	Case of   // • mel (11/2/04, 15:44:48) refactor to make options more clear
		: (<>PIN="ABORTED")
			$0:="Stop"
			
		: (util_UserValidation(<>PIN))  // • mel (11/2/04, 15:44:48) new pin validator
			$0:="NoSig"  //flag that the user is authorized to print/fax a signed PO
			If (User in group:C338(Current user:C182; "RoleBuyer"))
				$0:="Print"
			End if 
			
		Else   //offer to try again
			uConfirm("Entered PIN is not valid."; "Try Again"; "Cancel Printing")
			If (ok=1)  //try again
				$0:=""
			Else   //abort printing
				$0:="Stop"
			End if 
	End case 
Until (Length:C16($0)>0)