//%attributes = {}
// Method: HR_inputOnValidate
// User name (OS): work
// Date and time: 10/27/05, 14:44:05
// ----------------------------------------------------
// Modified by: Mel Bohince (6/8/21) set the date of termination if user name is removed
ARRAY TEXT:C222(aDepartment; 0)

[Users:5]ModDate:7:=4D_Current_date
[Users:5]ModTime:8:=4d_Current_time
[Users:5]ModWho:9:=<>zResp

If (Current user:C182=[Users:5]UserName:11)
	NotifyParseDept([Users:5]WorksInDept:15)
End if 

//is the user having access yanked?
If ([Users:5]UserName:11="") & (Length:C16(Old:C35([Users:5]UserName:11))>0)  //then kill the loggin
	
	[Users:5]DOT:30:=4D_Current_date  // Modified by: Mel Bohince (6/8/21) 
	
	GET USER LIST:C609($aUserNames; $aUserNumbers)
	For ($i; 1; Size of array:C274($aUserNames))
		If ($aUserNames{$i}=Old:C35([Users:5]UserName:11))
			If (Not:C34(Is user deleted:C616($aUserNumbers{$i})))
				$username:=$aUserNames{$i}
				DELETE USER:C615($aUserNumbers{$i})
				READ WRITE:C146([z_administrators:2])
				ALL RECORDS:C47([z_administrators:2])
				If (fLockNLoad(->[z_administrators:2]))
					uConfirm("Save a backup of your changes to Users & Groups?"; "Yes"; "No")
					If (OK=1)
						USERS TO BLOB:C849([z_administrators:2]UsersAndGroupsBlob:32)
						SAVE RECORD:C53([z_administrators:2])
					End if 
				End if 
				REDUCE SELECTION:C351([z_administrators:2]; 0)
				distributionList:=Batch_GetDistributionList("Deleted User")
				EMAIL_Sender("Deleted aMs User"; ""; "User named "+$username+" has been deleted from aMs by "+<>zResp; distributionList)
			End if 
		End if 
	End for 
End if 

If (Length:C16([Users:5]UserName:11)>0) & (Length:C16(Old:C35([Users:5]UserName:11))=0)  //add a user login
	If (Length:C16([Users:5]UserName:11)>0) & ([Users:5]aMsUser:39)
		GET USER LIST:C609($aUserNames; $aUserNumbers)
		$hit:=Find in array:C230($aUserNames; [Users:5]UserName:11)
		If ($hit=-1)
			ARRAY LONGINT:C221($aMemberships; 0)
			GET GROUP LIST:C610($aGroupNames; $aGroupNumbers)
			$hit:=Find in array:C230($aGroupNames; "RoleProduction")
			If ($hit>-1)
				APPEND TO ARRAY:C911($aMemberships; $aGroupNumbers{$hit})
			End if 
			
			If ([Users:5]Location:38="Roanoke")
				$hit:=Find in array:C230($aGroupNames; "Roanoke")
				If ($hit>-1)
					APPEND TO ARRAY:C911($aMemberships; $aGroupNumbers{$hit})
				End if 
			End if 
			
			Case of 
				: ([Users:5]Dept:31="Planning")
					$hit:=Find in array:C230($aGroupNames; "RolePlanner")
				: ([Users:5]Dept:31="Imaging")
					$hit:=Find in array:C230($aGroupNames; "RoleImaging")
				: ([Users:5]Dept:31="Accounting")
					$hit:=Find in array:C230($aGroupNames; "RoleAccounting")
				: ([Users:5]Dept:31="Customer Service")
					$hit:=Find in array:C230($aGroupNames; "RoleCustomerService")
				: ([Users:5]Dept:31="Manangement")
					$hit:=Find in array:C230($aGroupNames; "RoleManagementTeam")
				: ([Users:5]Dept:31="Personnel")
					$hit:=Find in array:C230($aGroupNames; "RolePayRoll")
				: ([Users:5]Dept:31="Purchasing")
					$hit:=Find in array:C230($aGroupNames; "RoleBuyer")
				: ([Users:5]Dept:31="Quality Assurance")
					$hit:=Find in array:C230($aGroupNames; "RoleQA")
				: ([Users:5]Dept:31="Receiving/Shipping")
					$hit:=Find in array:C230($aGroupNames; "RoleMaterialHandler")
				: ([Users:5]Dept:31="Sales")
					$hit:=Find in array:C230($aGroupNames; "RoleSalesman")
			End case 
			If ($hit>-1)
				APPEND TO ARRAY:C911($aMemberships; $aGroupNumbers{$hit})
			End if 
			
			If ([Users:5]Location:38="Roanoke")
				$hit:=Find in array:C230($aGroupNames; "Roanoke")
				If ($hit>-1)
					APPEND TO ARRAY:C911($aMemberships; $aGroupNumbers{$hit})
				End if 
			End if 
			
			Error:=0
			$hit:=Set user properties:C612(-2; [Users:5]UserName:11; "x"; "ChangeThis"; 0; !00-00-00!; $aMemberships)
			If (Error=0)
				zwStatusMsg("NEW AMS USER"; "User named "+[Users:5]UserName:11+" has been given a login to aMs with password 'ChangeThis'")
				distributionList:=Batch_GetDistributionList("Deleted User")
				EMAIL_Sender("New aMs User"; ""; "User named "+[Users:5]UserName:11+" has been given a login to aMs with password ChangeThis by "+<>zResp; distributionList)
				READ WRITE:C146([z_administrators:2])
				ALL RECORDS:C47([z_administrators:2])
				If (fLockNLoad(->[z_administrators:2]))
					uConfirm("Save a backup of your changes to Users & Groups?"; "Yes"; "No")
					If (OK=1)
						USERS TO BLOB:C849([z_administrators:2]UsersAndGroupsBlob:32)
						SAVE RECORD:C53([z_administrators:2])
					End if 
				End if 
				REDUCE SELECTION:C351([z_administrators:2]; 0)
			Else 
				BEEP:C151
				ALERT:C41("Problem creating login for "+[Users:5]UserName:11+". Error: "+String:C10(Error))
			End if 
			
		Else 
			uConfirm([Users:5]UserName:11+" has already been used as a login."; "OK"; "Cancel")
		End if 
	End if 
	//distributionList:=Batch_GetDistributionList ("Deleted User")
	//EMAIL_Sender ("New User";"";"User named "+[USER]FirstName+" "+[USER]LastName+" has been added to aMs.";distributionList)
End if 

//revert fields because these changes 
//are in [USER]ProposedChange and
//this is a change of status
HR_setProposedChange(0; ""; fCanChange)

Case of 
	: ([Users:5]StatusChange:43=0)
		//do nothing
		
	: ([Users:5]StatusChange:43=1)  //added to U&G?
		If ([Users:5]aMsUser:39=True:C214)
			GET USER LIST:C609($aUserNames; $aUserNumbers)
			$i:=Find in array:C230($aUserNames; [Users:5]UserName:11)
			If ($i>-1)
				[Users:5]StatusChange:43:=0
			End if 
		Else 
			uConfirm("Will this employee need their own login id for aMs?"; "Not Sure"; "No")
			If (OK=0)
				[Users:5]StatusChange:43:=0
				ALERT:C41("Call Systems Dept if you change your mind.")
			End if 
		End if 
		
	: ([Users:5]StatusChange:43=2)  //has it been approved?
		//HR_clearProposedChangeTemplate 
		$sigsNeeded:=Replace string:C233([Users:5]NeedApprovalFrom:44; " "; "")  //strip blanks
		If (Length:C16($sigsNeeded)=0)  //approved
			[Users:5]NeedApprovalFrom:44:=""
			[Users:5]StatusChange:43:=3  //approved
		End if 
		
	: ([Users:5]StatusChange:43=3)  //has it been approved?
		If (Length:C16([Users:5]ProposedChange:46)=0)  //chg's applied
			[Users:5]StatusChange:43:=0  //current status now as proposed
		End if 
End case 