If (cbPFfail=1)
	FG_PrepServiceStateChange("Preflight-Fail")
	
Else 
	[Finished_Goods_Specifications:98]DatePreflighted:85:=!00-00-00!
	[Finished_Goods_Specifications:98]PreflightBy:58:=""
	[Finished_Goods_Specifications:98]DateSubmitted:5:=Old:C35([Finished_Goods_Specifications:98]DateSubmitted:5)
	If ([Finished_Goods_Specifications:98]DateSubmitted:5>!00-00-00!)
		bSubmit:=1
	End if 
End if 