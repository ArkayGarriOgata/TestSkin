//%attributes = {}
// ----------------------------------------------------
// User name (OS): mlb
// Date and time: 10/11/05, 17:55:14
// ----------------------------------------------------
// Method: HR_ChgOfStatusNotices
// ----------------------------------------------------

READ WRITE:C146([Users:5])

QUERY:C277([Users:5]; [Users:5]StatusChange:43>0)
If (Records in selection:C76([Users:5])>0)
	$distribList:="mel.bohince@arkay.com,"
	While (Not:C34(End selection:C36([Users:5])))
		Case of 
			: ([Users:5]StatusChange:43=3)
				$distribList:=$distribList  //+"jane.hazlegrove@arkay.com,"
				$subject:="Chg Status Appvd for "+[Users:5]Initials:1+" by "+[Users:5]ModWho:9
				$body:="Approvals for '"+HR_setDisplayName+"' status change is complete.  Log into aMs and click 'Change Status'."+Char:C90(13)
				$body:=$body+[Users:5]ProposedChange:46+Char:C90(13)
				$body:=$body+HR_getCurrentStatus
				
				EMAIL_Sender($subject; ""; $body; $distribList)
				
			: ([Users:5]StatusChange:43=2)
				$noticeTo:=[Users:5]NeedApprovalFrom:44+Char:C90(13)
				$subject:="Approve Chg Status for "+[Users:5]Initials:1+" by "+[Users:5]ModWho:9
				$body:="Please review the proposed changes for "+HR_setDisplayName+" then log into aMs to give your approval."+Char:C90(13)
				$body:=$body+"Do this by opening the Human Resources palette from the Palettes menu, click Appr"+"ove Status Change, "
				$body:=$body+"then click the 'Give My Approval' button."+Char:C90(13)
				$body:=$body+""+Char:C90(13)
				$body:=$body+[Users:5]ProposedChange:46+Char:C90(13)
				$body:=$body+HR_getCurrentStatus
				
				util_TextParser(10; $noticeTo; Character code:C91(" "); 13)
				For ($i; 1; Size of array:C274(aParseArray))
					$who:=util_TextParser($i)
					If (Length:C16($who)>1)
						$distribList:=$distribList+Email_WhoAmI(""; $who)+","
					End if 
				End for 
				
				EMAIL_Sender($subject; ""; $body; $distribList)
				
			: ([Users:5]StatusChange:43=1)  //new hire, notivy systems
				If ([Users:5]aMsUser:39=True:C214)
					GET USER LIST:C609($aUserNames; $aUserNumbers)
					$i:=Find in array:C230($aUserNames; [Users:5]UserName:11)
					If ($i>-1)
						If (Length:C16([Users:5]NeedApprovalFrom:44)=0)
							[Users:5]StatusChange:43:=0
						Else   // I realize this is a little backwards, but lets see if they ever use it.
							[Users:5]StatusChange:43:=2
							$noticeTo:=[Users:5]NeedApprovalFrom:44+Char:C90(13)
							$subject:="Approve Chg Status for "+[Users:5]Initials:1+" by "+[Users:5]ModWho:9
							$body:="Please review the proposed changes for "+HR_setDisplayName+" then log into aMs to give your approval."+Char:C90(13)
							$body:=$body+"Do this by opening the Human Resources palette from the Palettes menu, click Appr"+"ove Status Change, "
							$body:=$body+"then click the 'Give My Approval' button."+Char:C90(13)
							$body:=$body+""+Char:C90(13)
							$body:=$body+[Users:5]ProposedChange:46+Char:C90(13)
							$body:=$body+HR_getCurrentStatus
							
							util_TextParser(10; $noticeTo; Character code:C91(" "); 13)
							For ($i; 1; Size of array:C274(aParseArray))
								$who:=util_TextParser($i)
								If (Length:C16($who)>1)
									$distribList:=$distribList+Email_WhoAmI(""; $who)+","
								End if 
							End for 
							
							EMAIL_Sender($subject; ""; $body; $distribList)
						End if 
						SAVE RECORD:C53([Users:5])
					End if 
				Else 
					distributionList:=Batch_GetDistributionList("Deleted User")
					$subject:="New User Added-"+[Users:5]Initials:1
					EMAIL_Sender($subject; ""; HR_setDisplayName+" was Added"; distributionList)
					[Users:5]StatusChange:43:=0  //don't keep sending it
					SAVE RECORD:C53([Users:5])
				End if 
				
				
		End case 
		
		NEXT RECORD:C51([Users:5])
	End while 
	
End if 
REDUCE SELECTION:C351([Users:5]; 0)