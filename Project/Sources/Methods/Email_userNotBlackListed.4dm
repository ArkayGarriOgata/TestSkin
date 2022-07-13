//%attributes = {}
// Method:  Email_userNotBlackListed($calledByMethod;$usersInitials) -> $okToSendEmail:boolean
// ----------------------------------------------------
// Author: Garri Ogata
// Created: 09/14/21, 09:20:10
// ----------------------------------------------------
// Description: This method returns true if user is valid to use in MethodName's email

// first level case: traps if the calling method is to trap for blacklist,
// second level case: are the restricted users
// usage:      If (Email_userNotBlackListed (Current method name;$teamMember)) 
//                          //add the user to the email

// Modified by: MelvinBohince (6/7/22) renamed method and variables, was User_Valid_ToUseB, add unit test

C_TEXT:C284($1; $calledByMethod)
C_TEXT:C284($2; $usersInitials)
C_BOOLEAN:C305($0; $okToSendEmail)

If (Count parameters:C259=2)
	$calledByMethod:=$1
	$usersInitials:=$2
Else   //test
	$calledByMethod:="Est_Send_Priced_Letter"
	$usersInitials:="MAP"
End if 

$okToSendEmail:=True:C214  //optimistic

Case of   //MethodName test
		
	: (($calledByMethod="Est_Send_Priced_Ltr_html") | ($calledByMethod="Est_Send_Priced_Letter"))
		
		Case of   //test if user is not to receive email
				
			: ($usersInitials="MAP")  //Mary palmer not to receive pricing ltr
				$okToSendEmail:=False:C215
				
		End case   //Done user
		
		
End case   //Done MethodName

$0:=$okToSendEmail

If (Count parameters:C259=0)
	ASSERT:C1129((Not:C34($okToSendEmail)); "FAIL, expected $okToSendEmail=false")
End if 
