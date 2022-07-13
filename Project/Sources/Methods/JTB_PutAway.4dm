//%attributes = {"publishedWeb":true}
//PM: JTB_PutAway() -> 
//@author mlb - 4/25/02  15:01

If (Length:C16(sCriterion1)=6)
	$location:=JTB_setLocation("supply closet")
	$id:=[JTB_Job_Transfer_Bags:112]ID:1
	CONFIRM:C162("Release "+[JTB_Job_Transfer_Bags:112]ID:1+" and put away items?")
	If (OK=1)
		READ WRITE:C146([JTB_Job_Transfer_Bags:112])
		QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]ID:1=sCriterion1)
		If (fLockNLoad(->[JTB_Job_Transfer_Bags:112]))
			[JTB_Job_Transfer_Bags:112]Location:4:=$location
			[JTB_Job_Transfer_Bags:112]Jobform:3:=""
			[JTB_Job_Transfer_Bags:112]PjtNumber:2:=""
			SAVE RECORD:C53([JTB_Job_Transfer_Bags:112])
			JTB_LogJTB($id; "Moved to "+$location)
			
			READ WRITE:C146([JTB_Contents:113])
			READ WRITE:C146([JPSI_Job_Physical_Support_Items:111])
			QUERY:C277([JTB_Contents:113]; [JTB_Contents:113]BagID:1=sCriterion1)
			$numJPSI:=Records in selection:C76([JTB_Contents:113])
			For ($i; 1; $numJPSI)
				QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]ID:1=[JTB_Contents:113]JPSIid:2)
				If (Records in selection:C76([JPSI_Job_Physical_Support_Items:111])=1)
					If (fLockNLoad(->[JPSI_Job_Physical_Support_Items:111]))
						$location:=JTB_setLocation
						$location:=Request:C163("Where will you be putting "+[JTB_Contents:113]JPSIid:2+"?"; $location)
						[JPSI_Job_Physical_Support_Items:111]Location:5:=$location
						SAVE RECORD:C53([JPSI_Job_Physical_Support_Items:111])
						JTB_LogJPSI([JPSI_Job_Physical_Support_Items:111]ID:1; "Checked-Out of "+$id+" (Put Away)")
					End if 
				End if 
				NEXT RECORD:C51([JTB_Contents:113])
			End for 
			DELETE SELECTION:C66([JTB_Contents:113])
			REDUCE SELECTION:C351([JPSI_Job_Physical_Support_Items:111]; 0)
			JTB_LogJTB($id; "Torn Down ")
			BEEP:C151
			ALERT:C41("Return Job Transfer Bag "+sCriterion1+" to the Supply Closet and file the "+String:C10($numJPSI)+" items where you said you would.")
			sCriterion1:=""
			
		Else 
			BEEP:C151
			ALERT:C41([JTB_Job_Transfer_Bags:112]ID:1+"'s record is in use, try again later.")
		End if 
		REDUCE SELECTION:C351([JTB_Job_Transfer_Bags:112]; 0)
		READ ONLY:C145([JTB_Job_Transfer_Bags:112])
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Please select a JobTransfer Bag to Put Away.")
End if 