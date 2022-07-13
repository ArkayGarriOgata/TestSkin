//%attributes = {"publishedWeb":true}
//PM: JTB_Move() -> 
//@author mlb - 2/7/02  14:43

Case of 
	: (Length:C16(sCriterion1)=6) | (Length:C16(sCriterion1)=8)
		[JTB_Job_Transfer_Bags:112]Location:4:=sLocation
		SAVE RECORD:C53([JTB_Job_Transfer_Bags:112])
		JTB_LogJTB(sCriterion1; "Moved to "+sLocation)
		
		INSERT IN ARRAY:C227(aKey; 1)
		INSERT IN ARRAY:C227(axRelTemp; 1)
		aKey{1}:=TS2String(TSTimeStamp)
		axRelTemp{1}:="Moved to "+sLocation+"  ["+<>zResp+"]"
		
		JML_updateViaBagTrack([JTB_Job_Transfer_Bags:112]Jobform:3; sLocation)
		
	: (Length:C16(sCriterion1)=7)
		QUERY:C277([JTB_Contents:113]; [JTB_Contents:113]JPSIid:2=sCriterion1)
		If (Records in selection:C76([JTB_Contents:113])=1)
			DELETE RECORD:C58([JTB_Contents:113])
			$jtb:=[JPSI_Job_Physical_Support_Items:111]Location:5  //Substring([JobPhysSuptItem]Location)
			JTB_LogJTB($jtb; sCriterion1+" Checked-Out")
			JTB_LogJPSI(sCriterion1; "Checked-Out of "+$jtb)
			DELAY PROCESS:C323(Current process:C322; 10)  //so timestamp can update
		End if 
		
		[JPSI_Job_Physical_Support_Items:111]Location:5:=sLocation
		SAVE RECORD:C53([JPSI_Job_Physical_Support_Items:111])
		JTB_LogJPSI(sCriterion1; "Moved to "+sLocation)
		
		INSERT IN ARRAY:C227(aKey; 1)
		INSERT IN ARRAY:C227(axRelTemp; 1)
		aKey{1}:=TS2String(TSTimeStamp)
		axRelTemp{1}:="Moved to "+sLocation+"  ["+<>zResp+"]"
		
	Else 
		BEEP:C151
End case 

OBJECT SET ENABLED:C1123(bMove; False:C215)