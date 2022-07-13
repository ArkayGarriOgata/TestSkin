//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 01/26/06, 10:35:41
// ----------------------------------------------------
// Method: util_UserSyncUnGwithUSERtable
// Description
// delete usernames that are not set as ams users in [USERS]
//see also util_UserNameDelete
// Parameters
// ----------------------------------------------------
If (User in group:C338(Current user:C182; "RoleSuperUser"))
	uConfirm("Delete users' logins with 'aMs Account' unchecked?"; "Yes..."; "No")
	If (ok=1)
		QUERY:C277([Users:5]; [Users:5]aMsUser:39=True:C214)
		SELECTION TO ARRAY:C260([Users:5]UserName:11; $aCurrentUsers)
		C_LONGINT:C283($numDeleted; $i; $hit)
		$numDeleted:=0
		GET USER LIST:C609($aUserNames; $aUserNumbers)
		For ($i; 1; Size of array:C274($aUserNames))
			$hit:=Find in array:C230($aCurrentUsers; $aUserNames{$i})
			If ($hit=-1)
				If (Not:C34(Is user deleted:C616($aUserNumbers{$i})))
					Case of 
						: ($aUserNames{$i}="Unassigned")  //system defined
						: ($aUserNames{$i}="EDI")  //system defined
						: ($aUserNames{$i}="Web")  //system defined
						: ($aUserNames{$i}="VirtualFactory")  //system defined
						Else 
							CONFIRM:C162("Delete "+$aUserNames{$i}+" from the Login dialog?"; "Keep"; "Remove")
							If (ok=0)
								DELETE USER:C615($aUserNumbers{$i})
								$numDeleted:=$numDeleted+1
								zwStatusMsg("USER DELETE"; $aUserNames{$i}+" has been removed.")
							End if 
					End case 
				End if 
			End if 
		End for 
		
		ALERT:C41(String:C10(Size of array:C274($aUserNames))+" usernames tested, "+String:C10($numDeleted)+" users were deleted.")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Access Denied.")
End if 