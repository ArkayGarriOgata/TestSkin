// ----------------------------------------------------
// User name (OS): mlb
// Date and time: 2/8/02  11:14
// ----------------------------------------------------
// Object Method:[Customers_Projects].ControlCtr.bDispose
// ----------------------------------------------------

QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]ID:1=atID{abSuptItemTopLB})  // Added by: Mark Zinke (3/26/13)
Pjt_setReferId(pjtId)
$tablePtr:=->[JPSI_Job_Physical_Support_Items:111]
If (Records in set:C195("clickedIncludeRecord")>0)
	
	UNLOAD RECORD:C212($tablePtr->)
	CUT NAMED SELECTION:C334($tablePtr->; "hold")
	USE SET:C118("clickedIncludeRecord")
	
	
	$id:=[JPSI_Job_Physical_Support_Items:111]ID:1
	CONFIRM:C162("Dispose of "+$id+", "+[JPSI_Job_Physical_Support_Items:111]ItemType:2+"?")
	If (ok=1)
		
		READ WRITE:C146([JPSI_Job_Physical_Support_Items:111])
		QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]ID:1=$id)
		If (Substring:C12([JPSI_Job_Physical_Support_Items:111]Location:5; 1; 6)#"Inside")
			$jtb:=Substring:C12([JPSI_Job_Physical_Support_Items:111]Location:5; 8)
			READ WRITE:C146([JTB_Contents:113])
			QUERY:C277([JTB_Contents:113]; [JTB_Contents:113]JPSIid:2=$id)
			DELETE RECORD:C58([JTB_Contents:113])
			JTB_LogJTB($jtb; $id+" Checked-Out"+" (Disposed)")
			JTB_LogJPSI($id; "Checked-Out of "+$jtb+" (Disposed)")
		End if 
		DELETE RECORD:C58([JPSI_Job_Physical_Support_Items:111])
		REDUCE SELECTION:C351([JPSI_Job_Physical_Support_Items:111]; 0)
		JTB_LogJPSI($id; "Disposed by "+<>zResp)
	End if 
	READ ONLY:C145([JPSI_Job_Physical_Support_Items:111])
	
	FORM GOTO PAGE:C247(ppHome)
	SELECT LIST ITEMS BY POSITION:C381(tc_PjtControlCtr; 1)
	
	USE NAMED SELECTION:C332("hold")
	
Else 
	uConfirm("Please select a "+"Finished_Goods_SizeAndStyles"+" record to update."; "OK"; "Help")
End if 