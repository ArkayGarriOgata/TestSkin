If ([Finished_Goods_Specifications:98]Approved:10)
	FG_PrepServiceStateChange("Approved"; 4D_Current_date)
Else 
	[Finished_Goods_Specifications:98]DateReturned:9:=!00-00-00!
	[Finished_Goods_Specifications:98]Approved:10:=False:C215
	bRejected:=0
End if 