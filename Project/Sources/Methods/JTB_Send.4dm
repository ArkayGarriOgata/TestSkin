//%attributes = {"publishedWeb":true}
//PM: JTB_Send() -> 
//@author mlb - 2/7/02  14:44

If (Length:C16(sCriterion1)>0)
	$where:=Request:C163("Where are you sending this bag?"; "House Truck"; "Move"; "Cancel")
	If (OK=1)
		[JTB_Job_Transfer_Bags:112]Location:4:=JTB_setLocation($where)
		SAVE RECORD:C53([JTB_Job_Transfer_Bags:112])
		JTB_LogJTB(sCriterion1; "Moved to "+[JTB_Job_Transfer_Bags:112]Location:4)
		
		INSERT IN ARRAY:C227(aKey; 1)
		INSERT IN ARRAY:C227(axRelTemp; 1)
		aKey{1}:=TS2String(TSTimeStamp)
		axRelTemp{1}:="Moved to "+[JTB_Job_Transfer_Bags:112]Location:4
	End if 
	
Else 
	BEEP:C151
End if 