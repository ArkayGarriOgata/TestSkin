If (Not:C34(util_isDateNull(->[Finished_Goods:26]DateLaunchApproved:85)))
	If (Length:C16([Finished_Goods:26]LaunchApproved:94)=0)
		[Finished_Goods:26]LaunchApproved:94:="APPROVED"
	End if 
End if 
