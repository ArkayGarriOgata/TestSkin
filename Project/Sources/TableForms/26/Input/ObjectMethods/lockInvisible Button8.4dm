If ([Finished_Goods:26]DateLaunchReceived:84#!00-00-00!)
	Cal_getDate(->[Finished_Goods:26]DateLaunchReceived:84; Month of:C24([Finished_Goods:26]DateLaunchReceived:84); Year of:C25([Finished_Goods:26]DateLaunchReceived:84))
Else 
	Cal_getDate(->[Finished_Goods:26]DateLaunchReceived:84)
End if 
