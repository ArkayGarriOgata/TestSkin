//OM: bDuplicate() -> 
//@author mlb - 2/8/02  11:29

//OM: bFGSCopy() -> 
//@author mlb - 2/1/02  15:05

Pjt_setReferId(pjtId)
$pjt:=[JTB_Job_Transfer_Bags:112]PjtNumber:2
If ($pjt=pjtId)
	$location:=JTB_setLocation("supply closet")
	$id:=[JTB_Job_Transfer_Bags:112]ID:1
	CONFIRM:C162("Tear Down "+[JTB_Job_Transfer_Bags:112]ID:1+" and put away items?")
	If (ok=1)
		CUT NAMED SELECTION:C334([JTB_Job_Transfer_Bags:112]; "hold")
		READ WRITE:C146([JTB_Job_Transfer_Bags:112])
		QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]ID:1=$id)
		If (fLockNLoad(->[JTB_Job_Transfer_Bags:112]))
			[JTB_Job_Transfer_Bags:112]Location:4:=$location
			[JTB_Job_Transfer_Bags:112]Jobform:3:=""
			[JTB_Job_Transfer_Bags:112]PjtNumber:2:=""
			SAVE RECORD:C53([JTB_Job_Transfer_Bags:112])
			JTB_LogJTB($id; "Moved to "+$location)
			
			READ WRITE:C146([JTB_Contents:113])
			READ WRITE:C146([JPSI_Job_Physical_Support_Items:111])
			QUERY:C277([JTB_Contents:113]; [JTB_Contents:113]BagID:1=$id)
			$numJPSI:=Records in selection:C76([JTB_Contents:113])
			For ($i; 1; $numJPSI)
				QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]ID:1=[JTB_Contents:113]JPSIid:2)
				[JPSI_Job_Physical_Support_Items:111]Location:5:=JTB_setLocation
				SAVE RECORD:C53([JPSI_Job_Physical_Support_Items:111])
				JTB_LogJPSI([JPSI_Job_Physical_Support_Items:111]ID:1; "Checked-Out of "+$id+" (Tear down)")
				NEXT RECORD:C51([JTB_Contents:113])
			End for 
			DELETE SELECTION:C66([JTB_Contents:113])
			REDUCE SELECTION:C351([JPSI_Job_Physical_Support_Items:111]; 0)
			JTB_LogJTB($id; "Torn Down ")
			BEEP:C151
			ALERT:C41("Return the Job Transfer Bag to the Supply Closet and file the "+String:C10($numJPSI)+" items that were in it.")
			
		Else 
			BEEP:C151
			ALERT:C41([JTB_Job_Transfer_Bags:112]ID:1+"'s record is in use, try again later.")
		End if 
		REDUCE SELECTION:C351([JTB_Job_Transfer_Bags:112]; 0)
		READ ONLY:C145([JTB_Job_Transfer_Bags:112])
		USE NAMED SELECTION:C332("hold")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Please select a JobTransfer Bag to Tear Down.")
End if 