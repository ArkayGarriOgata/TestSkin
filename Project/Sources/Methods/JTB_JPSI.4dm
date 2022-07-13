//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): mlb
// Date and time: 2/7/02  14:47
// ----------------------------------------------------
// Method: JTB_JPSI
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

Case of 
	: (Count parameters:C259=0)
		tTitle:=""
		tMessage1:=""
		sAction:=""
		OBJECT SET ENABLED:C1123(rb1; False:C215)
		READ WRITE:C146([JPSI_Job_Physical_Support_Items:111])
		QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]ID:1=sCriterion7)
		If (Records in selection:C76([JPSI_Job_Physical_Support_Items:111])=1)
			If (fLockNLoad(->[JPSI_Job_Physical_Support_Items:111]))
				tTitle:=[JPSI_Job_Physical_Support_Items:111]ItemType:2
				tMessage1:=[JPSI_Job_Physical_Support_Items:111]Description:4
				OBJECT SET ENABLED:C1123(rb1; True:C214)
				
				$hit:=Find in array:C230(aKey; sCriterion7)
				If ($hit=-1)
					SetObjectProperties(""; ->rb1; True:C214; "Check-In")
					sAction:="ChkIN"
				Else 
					SetObjectProperties(""; ->rb1; True:C214; "Check-Out")
					sAction:="ChkOUT"
				End if 
				
			Else 
				BEEP:C151
				ALERT:C41(sCriterion7+" is locked, try later")
				sCriterion7:=""
				GOTO OBJECT:C206(sCriterion7)
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41(sCriterion7+" does not exist")
			sCriterion7:=""
			GOTO OBJECT:C206(sCriterion7)
		End if 
		
	: ($1="ChkIN") & (Length:C16(sCriterion7)=7) & (Length:C16(sCriterion1)>=6)
		$hit:=Find in array:C230(aKey; sCriterion7)
		If ($hit=-1)
			If (Length:C16([JTB_Job_Transfer_Bags:112]PjtNumber:2)=0)
				UNLOAD RECORD:C212([JTB_Job_Transfer_Bags:112])
				READ WRITE:C146([JTB_Job_Transfer_Bags:112])
				LOAD RECORD:C52([JTB_Job_Transfer_Bags:112])
				[JTB_Job_Transfer_Bags:112]PjtNumber:2:=[JPSI_Job_Physical_Support_Items:111]PjtNumber:3
				[JTB_Job_Transfer_Bags:112]Location:4:=JTB_setLocation
				$jobform:=Request:C163("Enter a job form number now?"; "00000.00"; "Assign Job"; "Not Now")
				If (OK=1)
					READ ONLY:C145([Job_Forms:42])
					QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)
					If (Records in selection:C76([Job_Forms:42])=1)
						[JTB_Job_Transfer_Bags:112]Jobform:3:=$jobform
						JTB_LogJTB([JTB_Job_Transfer_Bags:112]ID:1; "Assigned to Jobform "+$jobform)
					Else 
						BEEP:C151
						ALERT:C41("Jobform "+$jobform+" was not found.")
						$jobform:=""
					End if 
					REDUCE SELECTION:C351([Job_Forms:42]; 0)
				End if 
				SAVE RECORD:C53([JTB_Job_Transfer_Bags:112])
				JTB_LogJTB([JTB_Job_Transfer_Bags:112]ID:1; "Assigned to project "+[JPSI_Job_Physical_Support_Items:111]PjtNumber:3+" during packing")
				UNLOAD RECORD:C212([JTB_Job_Transfer_Bags:112])
				READ ONLY:C145([JTB_Job_Transfer_Bags:112])
				LOAD RECORD:C52([JTB_Job_Transfer_Bags:112])
				
			End if 
			
			If ([JTB_Job_Transfer_Bags:112]PjtNumber:2#[JPSI_Job_Physical_Support_Items:111]PjtNumber:3)
				CONFIRM:C162("This item belongs to another project. Add it anyway?"; "Add"; "Cancel")
			Else 
				OK:=1
			End if 
			
			If (OK=1)
				[JPSI_Job_Physical_Support_Items:111]Location:5:=JTB_setLocation("Inside "+sCriterion1)
				SAVE RECORD:C53([JPSI_Job_Physical_Support_Items:111])
				JTB_LogJTB(sCriterion1; sCriterion7+" Checked-In")
				JTB_LogJPSI(sCriterion7; "Checked-Into "+sCriterion1)
				
				CREATE RECORD:C68([JTB_Contents:113])
				[JTB_Contents:113]BagID:1:=sCriterion1
				[JTB_Contents:113]JPSIid:2:=sCriterion7
				[JTB_Contents:113]DateIN:3:=4D_Current_date
				[JTB_Contents:113]ByWho:4:=<>zResp
				SAVE RECORD:C53([JTB_Contents:113])
				REDUCE SELECTION:C351([JTB_Contents:113]; 0)
				
				INSERT IN ARRAY:C227(aKey; 1)
				INSERT IN ARRAY:C227(axRelTemp; 1)
				aKey{1}:=sCriterion7
				axRelTemp{1}:=Substring:C12([JPSI_Job_Physical_Support_Items:111]ItemType:2+" "+[JPSI_Job_Physical_Support_Items:111]Description:4; 1; 80)
				SORT ARRAY:C229(axRelTemp; aKey; >)
				
			Else 
				BEEP:C151
				ALERT:C41("This item belongs to another project and was not added to this job bag.")
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41(sCriterion7+" is already Checked into JTB "+sCriterion1)
		End if 
		
		REDUCE SELECTION:C351([JPSI_Job_Physical_Support_Items:111]; 0)
		sCriterion7:=""
		tTitle:=""
		tMessage1:=""
		GOTO OBJECT:C206(sCriterion7)
		OBJECT SET ENABLED:C1123(rb1; False:C215)
		
	: ($1="ChkOUT") & (Length:C16(sCriterion7)=7) & (Length:C16(sCriterion1)>=6)
		$hit:=Find in array:C230(aKey; sCriterion7)
		If ($hit>-1)
			[JPSI_Job_Physical_Support_Items:111]Location:5:=JTB_setLocation
			SAVE RECORD:C53([JPSI_Job_Physical_Support_Items:111])
			JTB_LogJTB(sCriterion1; sCriterion7+" Checked-Out")
			JTB_LogJPSI(sCriterion7; "Checked-Out of "+sCriterion1)
			
			QUERY:C277([JTB_Contents:113]; [JTB_Contents:113]JPSIid:2=sCriterion7)
			DELETE RECORD:C58([JTB_Contents:113])
			
			DELETE FROM ARRAY:C228(aKey; $hit; 1)
			DELETE FROM ARRAY:C228(axRelTemp; $hit; 1)
			
		Else 
			BEEP:C151
			ALERT:C41(sCriterion7+" has not been Checked into JTB "+sCriterion1)
		End if 
		
		REDUCE SELECTION:C351([JPSI_Job_Physical_Support_Items:111]; 0)
		sCriterion7:=""
		tTitle:=""
		tMessage1:=""
		GOTO OBJECT:C206(sCriterion7)
		OBJECT SET ENABLED:C1123(rb1; False:C215)
		
	Else 
		BEEP:C151
		ALERT:C41("You need to scan the Bag and the Item before doing a Check-In/Out")
		OBJECT SET ENABLED:C1123(rb1; False:C215)
		
End case 