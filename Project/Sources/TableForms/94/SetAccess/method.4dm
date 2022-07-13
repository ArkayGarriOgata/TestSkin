Case of 
	: (Form event code:C388=On Load:K2:1)
		SELECTION TO ARRAY:C260([Users:5]Initials:1; aUsersInitials; [Users:5]UserName:11; aUsersName)
		SORT ARRAY:C229(aUsersName; aUsersInitials; >)
		REDUCE SELECTION:C351([Users:5]; 0)
		ARRAY TEXT:C222(asBull; Size of array:C274(aUsersInitials))
		//set current accesses
		QUERY:C277([Users_Record_Accesses:94]; [Users_Record_Accesses:94]TableName:2=tblName; *)
		QUERY:C277([Users_Record_Accesses:94];  & ; [Users_Record_Accesses:94]PrimaryKey:3=tblPrimaryKey)
		If (Records in selection:C76([Users_Record_Accesses:94])>0)
			ARRAY TEXT:C222($hasAccess; 0)
			SELECTION TO ARRAY:C260([Users_Record_Accesses:94]UserInitials:1; $hasAccess)
			For ($i; 1; Size of array:C274($hasAccess))
				$hit:=Find in array:C230(aUsersInitials; $hasAccess{$i})
				If ($hit>-1)
					asBull{$hit}:="√"
				End if 
			End for 
			ARRAY TEXT:C222($hasAccess; 0)
		End if 
		
	: (Form event code:C388=On Unload:K2:2)
		If (baOk=1)
			For ($i; 1; Size of array:C274(asBull))
				QUERY:C277([Users_Record_Accesses:94]; [Users_Record_Accesses:94]TableName:2=tblName; *)
				QUERY:C277([Users_Record_Accesses:94];  & ; [Users_Record_Accesses:94]PrimaryKey:3=tblPrimaryKey; *)
				QUERY:C277([Users_Record_Accesses:94];  & ; [Users_Record_Accesses:94]UserInitials:1=aUsersInitials{$i})
				If (asBull{$i}="√")  //no access
					If (Records in selection:C76([Users_Record_Accesses:94])=0)  //new assignment
						User_GiveAccess(aUsersInitials{$i}; tblName; tblPrimaryKey; "RWD")
					End if 
				Else   // turn off
					If (Records in selection:C76([Users_Record_Accesses:94])>0)
						DELETE SELECTION:C66([Users_Record_Accesses:94])
					End if 
				End if 
			End for 
		End if 
		
End case 