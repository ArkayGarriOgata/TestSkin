If ([Finished_Goods:26]DateDockDelivery:90#!00-00-00!)
	Cal_getDate(->[Finished_Goods:26]DateDockDelivery:90; Month of:C24([Finished_Goods:26]DateDockDelivery:90); Year of:C25([Finished_Goods:26]DateDockDelivery:90))
Else 
	Cal_getDate(->[Finished_Goods:26]DateDockDelivery:90)
End if 

[Finished_Goods:26]DateShip:91:=[Finished_Goods:26]DateDockDelivery:90-2
[Finished_Goods:26]DateClosing:92:=[Finished_Goods:26]DateShip:91-(7*[Customers:16]DefaultLeadTime:56)