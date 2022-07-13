//OM: ActionTaken() -> 
//@author mlb - 7/18/01  14:26

If (Length:C16([QA_Corrective_Actions:105]CAwho:25)=0)
	[QA_Corrective_Actions:105]CAwho:25:=<>zResp
	[QA_Corrective_Actions:105]CAwhen:26:=4D_Current_date
End if 