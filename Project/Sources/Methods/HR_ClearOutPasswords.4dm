//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/11/07, 14:31:36
// ----------------------------------------------------
// Method: HR_ClearOutPasswords()  --> 
// Description
// remove all passwords to keep people out of a test system
// ----------------------------------------------------

$newPassword:=Request:C163("Reset all user passwords to: "; "testing"; "OK"; "Cancel")
If (OK=1)
	GET USER LIST:C609($aUserNames; $aUserNumbers)
	uThermoInit(Size of array:C274($aUserNumbers); "Setting Passwords to "+$newPassword)
	For ($i; 1; Size of array:C274($aUserNumbers))
		
		Case of 
			: ($aUserNumbers{$i}=1)
				//leave designer alone
				
			: ($aUserNumbers{$i}=2)
				//leave administrator alone
			Else 
				
				If (Not:C34(Is user deleted:C616($aUserNumbers{$i})))
					GET USER PROPERTIES:C611($aUserNumbers{$i}; $name; $STARTUP; $password; $nbLogin; $lastLogin)
					Set user properties:C612($aUserNumbers{$i}; $name; $STARTUP; $newPassword; $nbLogin; $lastLogin)
				End if 
				
		End case 
		
		uThermoUpdate($i)
	End for 
	uThermoClose
	
End if 
BEEP:C151