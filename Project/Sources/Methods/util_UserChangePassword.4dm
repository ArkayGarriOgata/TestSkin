//%attributes = {"publishedWeb":true}
//PM: util_UserChangePassword() -> 
//@author Mel - 5/23/03  09:08
// Modified by: MelvinBohince (6/7/22) CHANGE PASSWORD will have no effect to structure when v19 compile project

ALERT:C41("Please contact the IT department if you wish to have your password changed.")


//CHANGE CURRENT USER  // Present user with password dialog 
//If (OK=1)
//$pw1:=Request("Enter new 6 character password for "+Current user)
//  // The password should be at leat five characters long 
//If (((OK=1) & ($pw1#"")) & (Length($pw1)>5))
//  // Make sure the password has been entered correctly 
//$pw2:=Request("Enter password again")
//If ((OK=1) & ($pw1=$pw2))
//CHANGE PASSWORD($pw2)  // Change the password

//End if 
//End if 
//End if 