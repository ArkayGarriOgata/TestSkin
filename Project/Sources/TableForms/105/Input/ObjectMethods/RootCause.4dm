//OM: RootCause() -> 
//@author mlb - 7/20/01  11:19

If (Length:C16([QA_Corrective_Actions:105]CAwho:25)=0)
	[QA_Corrective_Actions:105]CAwho:25:=<>zResp
	[QA_Corrective_Actions:105]CAwhen:26:=4D_Current_date
End if 