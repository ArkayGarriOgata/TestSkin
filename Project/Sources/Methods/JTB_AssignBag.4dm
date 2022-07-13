//%attributes = {"publishedWeb":true}
//JTB_AssignBag

C_BOOLEAN:C305($continue)

Pjt_setReferId(pjtId)
READ WRITE:C146([JTB_Job_Transfer_Bags:112])
$bagId:=Request:C163("Scan a Job Transfer Bag:"; "TB0000"; "Assign"; "Cancel")

If (OK=1)
	If (Length:C16($bagId)=6) | (Length:C16($bagId)=8)  // & (Substring($bagId;1;2)="TB")
		READ WRITE:C146([JTB_Job_Transfer_Bags:112])
		QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]ID:1=$bagId)
		If (Records in selection:C76([JTB_Job_Transfer_Bags:112])=0)  //& (Substring($bagId;1;2)="TB")
			CREATE RECORD:C68([JTB_Job_Transfer_Bags:112])
			[JTB_Job_Transfer_Bags:112]ID:1:=$bagId
			JTB_LogJTB([JTB_Job_Transfer_Bags:112]ID:1; "Deployed")
			$continue:=True:C214
		Else 
			$continue:=fLockNLoad(->[JTB_Job_Transfer_Bags:112])
		End if 
		
		If ($continue)
			QUERY:C277([JTB_Contents:113]; [JTB_Contents:113]BagID:1=$bagId)  //• mlb - 9/11/02  14:39
			If (Records in selection:C76([JTB_Contents:113])>0)
				zwStatusMsg("WARNING"; "This JTB has items already checked into it.")
				
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					
					SELECTION TO ARRAY:C260([JTB_Contents:113]JPSIid:2; aKey)
					QUERY WITH ARRAY:C644([JPSI_Job_Physical_Support_Items:111]ID:1; aKey)
					QUERY SELECTION:C341([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]PjtNumber:3#pjtId)
					
				Else 
					
					//see ligne 23
					
					QUERY BY FORMULA:C48([JPSI_Job_Physical_Support_Items:111]; \
						([JTB_Contents:113]BagID:1=$bagId)\
						 & ([JTB_Contents:113]JPSIid:2=[JPSI_Job_Physical_Support_Items:111]ID:1)\
						 & ([JPSI_Job_Physical_Support_Items:111]PjtNumber:3#pjtId)\
						)
					
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				If (Records in selection:C76([JPSI_Job_Physical_Support_Items:111])>0)
					BEEP:C151
					BEEP:C151
					$msg:=$bagId+" has items checked into it that don't belong to this Project."+(Char:C90(13)*2)
					$msg:=$msg+"You must use the 'Put Away' button on the Finished tab of the BagTrack diolog "+"before using this bag."
					ALERT:C41($msg; "I didn't know that")
					$continue:=False:C215
				End if 
			End if 
		End if 
		
		If ($continue)
			zwStatusMsg("TRANSFER BAG"; "Job Transfer Bag "+$bagId+" has been assigned to the "+pjtName+" project.")
			[JTB_Job_Transfer_Bags:112]PjtNumber:2:=pjtId
			[JTB_Job_Transfer_Bags:112]Location:4:=JTB_setLocation
			JTB_LogJTB([JTB_Job_Transfer_Bags:112]ID:1; "Assigned to project "+pjtId+":"+pjtName)
			If (Length:C16($bagId)=8)
				$jobform:=Request:C163("Enter a job form number now?"; $bagId; "Assign Job"; "Not Now")
			Else 
				$jobform:=Request:C163("Enter a job form number now?"; "00000.00"; "Assign Job"; "Not Now")
			End if 
			If (OK=1)
				READ ONLY:C145([Job_Forms:42])
				QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)
				If (Records in selection:C76([Job_Forms:42])=1)
					[JTB_Job_Transfer_Bags:112]Jobform:3:=$jobform
					If ([Job_Forms:42]ProjectNumber:56#pjtId)
						ALERT:C41("Jobform: "+$jobform+" doesn't belong to Project Nº:"+pjtID+Char:C90(13)+"Use the 'Add to Project...' button on the Jobs tab."; "Soon as I get time")
					End if 
					JTB_LogJTB([JTB_Job_Transfer_Bags:112]ID:1; "Assigned to Jobform "+$jobform)
				Else 
					BEEP:C151
					ALERT:C41("Jobform "+$jobform+" was not found.")
					$jobform:=""
				End if 
				REDUCE SELECTION:C351([Job_Forms:42]; 0)
			Else 
				$jobform:=""
			End if 
			
			SAVE RECORD:C53([JTB_Job_Transfer_Bags:112])
			
		Else 
			BEEP:C151
			ALERT:C41([JTB_Job_Transfer_Bags:112]ID:1+"'s record is in use, try again later or use another bag.")
		End if 
		
		REDUCE SELECTION:C351([JTB_Job_Transfer_Bags:112]; 0)
		READ ONLY:C145([JTB_Job_Transfer_Bags:112])
		QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]PjtNumber:2=pjtId)
		ORDER BY:C49([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]Jobform:3; >)
		
	Else 
		BEEP:C151
		ALERT:C41($bagId+" is not a valid Job Transfer Bag ID.")
	End if   //valid
End if   //scanned