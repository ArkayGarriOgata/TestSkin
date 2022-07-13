$picked:=CAR_BuildReasonList("pick"; ->[QA_Corrective_Actions:105]Reason:16; ->[QA_Corrective_Actions:105]ReasonId:15)
If (Length:C16([QA_Corrective_Actions:105]Reason:16)=0)
	GOTO OBJECT:C206([QA_Corrective_Actions:105]Reason:16)
Else 
	GOTO OBJECT:C206([QA_Corrective_Actions:105]CostCenter:14)
End if 