If ([Finished_Goods_Color_Submission:78]Is_Ok:6)
	[Finished_Goods_Color_Submission:78]Returned:5:=4D_Current_date
	[Finished_Goods_Color_SpecSolids:129]approved:6:=4D_Current_date
Else 
	[Finished_Goods_Color_SpecSolids:129]approved:6:=!00-00-00!
End if 
