If (bPrepDone=1)
	FG_PrepServiceStateChange("PrepDone"; 4D_Current_date)
Else 
	[Finished_Goods_Specifications:98]DatePrepDone:6:=!00-00-00!
End if 
