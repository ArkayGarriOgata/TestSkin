If ([Finished_Goods:26]DateShip:91#!00-00-00!)
	Cal_getDate(->[Finished_Goods:26]DateShip:91; Month of:C24([Finished_Goods:26]DateShip:91); Year of:C25([Finished_Goods:26]DateShip:91))
Else 
	Cal_getDate(->[Finished_Goods:26]DateShip:91)
End if 


[Finished_Goods:26]DateClosing:92:=[Finished_Goods:26]DateShip:91-(7*[Customers:16]DefaultLeadTime:56)