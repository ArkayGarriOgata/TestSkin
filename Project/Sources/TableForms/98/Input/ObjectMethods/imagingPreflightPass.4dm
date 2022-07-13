If (cbPFpass=1)
	FG_PrepServiceStateChange("Preflight-Pass")
	
Else 
	[Finished_Goods_Specifications:98]DatePreflighted:85:=!00-00-00!
	[Finished_Goods_Specifications:98]PreflightBy:58:=""
End if 
