If ([Finished_Goods_Color_Submission:78]Is_Ok:6)
	If ([Finished_Goods_Color_Submission:78]Returned:5=!00-00-00!)
		[Finished_Goods_Color_Submission:78]Returned:5:=4D_Current_date
	End if 
End if 