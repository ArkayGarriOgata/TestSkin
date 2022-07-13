If ([Purchase_Orders_Items:12]PromiseDate:9#!00-00-00!)
	Cal_getDate(->[Purchase_Orders_Items:12]PromiseDate:9; Month of:C24([Purchase_Orders_Items:12]PromiseDate:9); Year of:C25([Purchase_Orders_Items:12]PromiseDate:9))
Else 
	Cal_getDate(->[Purchase_Orders_Items:12]PromiseDate:9)
End if 
//
If (sDateLimitor(->[Purchase_Orders_Items:12]PromiseDate:9; 365)=0)
	dDate:=[Purchase_Orders_Items:12]PromiseDate:9
End if 
dDate:=[Purchase_Orders_Items:12]PromiseDate:9