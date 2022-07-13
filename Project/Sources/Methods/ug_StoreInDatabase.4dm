//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/15/06, 11:46:28
// ----------------------------------------------------
// Method: ug_StoreInDatabase
// Description
// save users&groups to the datafile so that they can be restored
// this was necessary because of a corruption in the password
// and Load Groups from Edit Access, and User to Blob carried the corruption
// 
// ----------------------------------------------------


CONFIRM:C162("Which?"; "Backup"; "Restore")
If (ok=1)
	CONFIRM:C162("Are you sure you want to Backup?"; "Yes"; "No")
	If (ok=1)
		READ WRITE:C146([ug_Groups:140])
		ALL RECORDS:C47([ug_Groups:140])
		DELETE SELECTION:C66([ug_Groups:140])
		READ WRITE:C146([ug_UsersInGroups:142])
		ALL RECORDS:C47([ug_UsersInGroups:142])
		DELETE SELECTION:C66([ug_UsersInGroups:142])
		READ WRITE:C146([ug_Users:141])
		ALL RECORDS:C47([ug_Users:141])
		DELETE SELECTION:C66([ug_Users:141])
		
		GET USER LIST:C609($aUserNames; $aUserNumbers)
		For ($i; 1; Size of array:C274($aUserNumbers))
			If (Not:C34(Is user deleted:C616($aUserNumbers{$i})))
				$id:=$aUserNumbers{$i}
				$name:=""
				$method:=""
				$password:=""
				$logins:=0
				$lastlogin:=!00-00-00!
				GET USER PROPERTIES:C611($id; $name; $method; $password; $logins; $lastlogin)
				If (Length:C16($name)>0) & ($name#"Designer")
					CREATE RECORD:C68([ug_Users:141])
					[ug_Users:141]userID:1:=$id
					[ug_Users:141]name:2:=$name
					[ug_Users:141]startup_method:3:=$method
					[ug_Users:141]password:4:=String:C10((Random:C100%(9999-1000))+1000)
					[ug_Users:141]numLogins:5:=$logins
					[ug_Users:141]lastLogin:6:=$lastlogin
					SAVE RECORD:C53([ug_Users:141])
				End if 
			End if 
		End for 
		
		GET GROUP LIST:C610($aGroupNames; $aGroupNumbers)
		For ($i; 1; Size of array:C274($aGroupNumbers))
			$id:=$aGroupNumbers{$i}
			$name:=""
			$owner:=0
			ARRAY LONGINT:C221($aMembers; 0)
			GET GROUP PROPERTIES:C613($id; $name; $owner; $aMembers)
			If (Length:C16($name)>0)
				CREATE RECORD:C68([ug_Groups:140])
				[ug_Groups:140]groupID:1:=$aGroupNumbers{$i}
				[ug_Groups:140]name:2:=$name
				[ug_Groups:140]owner:3:=$owner
				[ug_Groups:140]numUsers:4:=Size of array:C274($aMembers)
				SAVE RECORD:C53([ug_Groups:140])
				
				For ($member; 1; [ug_Groups:140]numUsers:4)
					$hit:=Find in array:C230($aUserNumbers; $aMembers{$member})
					If ($hit>-1)
						If (Not:C34(Is user deleted:C616($aMembers{$member})))
							CREATE RECORD:C68([ug_UsersInGroups:142])
							[ug_UsersInGroups:142]groupID:2:=[ug_Groups:140]groupID:1
							[ug_UsersInGroups:142]groupName:3:=[ug_Groups:140]name:2
							[ug_UsersInGroups:142]userID:1:=$aMembers{$member}
							[ug_UsersInGroups:142]userName:4:=$aUserNames{$hit}
							SAVE RECORD:C53([ug_UsersInGroups:142])
						End if 
						
					Else 
						$hit:=Find in array:C230($aGroupNumbers; $aMembers{$member})
						If ($hit>-1)
							CREATE RECORD:C68([ug_UsersInGroups:142])
							[ug_UsersInGroups:142]groupID:2:=[ug_Groups:140]groupID:1
							[ug_UsersInGroups:142]groupName:3:=[ug_Groups:140]name:2
							[ug_UsersInGroups:142]userID:1:=$aMembers{$member}
							[ug_UsersInGroups:142]userName:4:=$aGroupNames{$hit}
							SAVE RECORD:C53([ug_UsersInGroups:142])
						End if 
					End if 
					
				End for 
			End if 
			
		End for 
		
	End if 
	
Else 
	GET GROUP LIST:C610($aGroupNames; $aGroupNumbers)
	GET USER LIST:C609($aUserNames; $aUserNumbers)
	If (Size of array:C274($aUserNumbers)<3) & (Size of array:C274($aGroupNumbers)=0)  //assumes starting from scratch
		
		CONFIRM:C162("Are you sure you want to Restore?"; "Yes"; "No")
		If (ok=1)
			READ WRITE:C146([ug_Users:141])
			ALL RECORDS:C47([ug_Users:141])
			ORDER BY:C49([ug_Users:141]name:2; >)
			While (Not:C34(End selection:C36([ug_Users:141])))
				$newID:=Set user properties:C612(-2; [ug_Users:141]name:2; [ug_Users:141]startup_method:3; [ug_Users:141]password:4; [ug_Users:141]numLogins:5; [ug_Users:141]lastLogin:6)
				[ug_Users:141]userID:1:=$newID
				SAVE RECORD:C53([ug_Users:141])
				
				//get the groups so they can be rekeyed
				QUERY:C277([ug_UsersInGroups:142]; [ug_UsersInGroups:142]userName:4=[ug_Users:141]name:2)
				ARRAY LONGINT:C221($aMembers; 0)
				SELECTION TO ARRAY:C260([ug_UsersInGroups:142]userID:1; $aMembers)
				//prep new key and apply
				For ($member; 1; Size of array:C274($aMembers))
					$aMembers{$member}:=$newID
				End for 
				ARRAY TO SELECTION:C261($aMembers; [ug_UsersInGroups:142]userID:1)
				
				NEXT RECORD:C51([ug_Users:141])
			End while 
			
			READ WRITE:C146([ug_Groups:140])
			ALL RECORDS:C47([ug_Groups:140])
			ORDER BY:C49([ug_Groups:140]name:2; >)
			While (Not:C34(End selection:C36([ug_Groups:140])))
				ARRAY LONGINT:C221($aMembers; 0)  //to clear members
				$newID:=Set group properties:C614(-2; [ug_Groups:140]name:2; [ug_Groups:140]owner:3; $aMembers)  //create the group with no members
				[ug_Groups:140]groupID:1:=$newID
				SAVE RECORD:C53([ug_Groups:140])
				
				ARRAY LONGINT:C221($aGroup; 0)  //rekey group fkey in relation
				QUERY:C277([ug_UsersInGroups:142]; [ug_UsersInGroups:142]groupName:3=[ug_Groups:140]name:2)
				SELECTION TO ARRAY:C260([ug_UsersInGroups:142]groupID:2; $aGroup)
				For ($group; 1; Size of array:C274($aGroup))
					$aGroup{$group}:=$newID
				End for 
				ARRAY TO SELECTION:C261($aGroup; [ug_UsersInGroups:142]groupID:2)
				
				ARRAY LONGINT:C221($aMembers; 0)  //rekey groups that are members of other groups
				QUERY:C277([ug_UsersInGroups:142]; [ug_UsersInGroups:142]userName:4=[ug_Groups:140]name:2)
				SELECTION TO ARRAY:C260([ug_UsersInGroups:142]userID:1; $aMembers)
				For ($group; 1; Size of array:C274($aMembers))
					$aMembers{$group}:=$newID
				End for 
				ARRAY TO SELECTION:C261($aMembers; [ug_UsersInGroups:142]userID:1)
				
				NEXT RECORD:C51([ug_Groups:140])
			End while 
			
			FIRST RECORD:C50([ug_Groups:140])
			While (Not:C34(End selection:C36([ug_Groups:140])))
				ARRAY LONGINT:C221($aMembers; 0)
				QUERY:C277([ug_UsersInGroups:142]; [ug_UsersInGroups:142]groupID:2=[ug_Groups:140]groupID:1)
				SELECTION TO ARRAY:C260([ug_UsersInGroups:142]userID:1; $aMembers)
				Set group properties:C614([ug_Groups:140]groupID:1; [ug_Groups:140]name:2; [ug_Groups:140]owner:3; $aMembers)  //add members to group
				
				NEXT RECORD:C51([ug_Groups:140])
			End while 
			
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("Must have only a Designer and no Groups to Restore.")
	End if 
	
End if 
BEEP:C151