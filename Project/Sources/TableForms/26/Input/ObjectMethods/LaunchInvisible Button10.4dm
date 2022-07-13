If ([Finished_Goods:26]DateLaunchApproved:85#!00-00-00!)
	Cal_getDate(->[Finished_Goods:26]DateLaunchApproved:85; Month of:C24([Finished_Goods:26]DateLaunchApproved:85); Year of:C25([Finished_Goods:26]DateLaunchApproved:85))
Else 
	Cal_getDate(->[Finished_Goods:26]DateLaunchApproved:85)
End if 

If (Not:C34(util_isDateNull(->[Finished_Goods:26]DateLaunchApproved:85)))
	If (Length:C16([Finished_Goods:26]LaunchApproved:94)=0)
		[Finished_Goods:26]LaunchApproved:94:="APPROVED"
	End if 
End if 
