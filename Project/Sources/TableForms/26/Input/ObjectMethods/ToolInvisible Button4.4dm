If ([Finished_Goods:26]DateSpecReceived:87#!00-00-00!)
	Cal_getDate(->[Finished_Goods:26]DateSpecReceived:87; Month of:C24([Finished_Goods:26]DateSpecReceived:87); Year of:C25([Finished_Goods:26]DateSpecReceived:87))
Else 
	Cal_getDate(->[Finished_Goods:26]DateSpecReceived:87)
End if 
