If (bRejected=1)
	FG_PrepServiceStateChange("Rejected"; 4D_Current_date)
Else 
	[Finished_Goods_Specifications:98]DateReturned:9:=!00-00-00!
End if 
