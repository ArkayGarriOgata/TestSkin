If ([Purchase_Orders_Items:12]ReqdDate:8#!00-00-00!)
	Cal_getDate(->[Purchase_Orders_Items:12]ReqdDate:8; Month of:C24([Purchase_Orders_Items:12]ReqdDate:8); Year of:C25([Purchase_Orders_Items:12]ReqdDate:8))
Else 
	Cal_getDate(->[Purchase_Orders_Items:12]ReqdDate:8)
End if 
//
If (sDateLimitor(->[Purchase_Orders_Items:12]ReqdDate:8; 365)=0)
	If ([Purchase_Orders_Items:12]ReqdDate:8<[Purchase_Orders:11]Required:27) | ([Purchase_Orders:11]Required:27=!00-00-00!)
		[Purchase_Orders:11]Required:27:=[Purchase_Orders_Items:12]ReqdDate:8
	End if 
	If ([Purchase_Orders_Items:12]PromiseDate:9=!00-00-00!)
		[Purchase_Orders_Items:12]PromiseDate:9:=[Purchase_Orders_Items:12]ReqdDate:8
	End if 
End if 