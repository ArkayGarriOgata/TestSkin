If (Length:C16([Finished_Goods:26]LaunchApproved:94)>0)
	If (util_isDateNull(->[Finished_Goods:26]DateLaunchApproved:85))
		[Finished_Goods:26]DateLaunchApproved:85:=4D_Current_date
	End if 
End if 
