If (bQADone=1)
	FG_PrepServiceStateChange("ProofRead"; 4D_Current_date)
Else 
	[Finished_Goods_Specifications:98]DateProofRead:7:=!00-00-00!
End if 
