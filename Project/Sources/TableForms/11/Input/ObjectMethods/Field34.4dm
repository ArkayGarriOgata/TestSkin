If ([Purchase_Orders:11]ConfirmingOrder:29)
	[Purchase_Orders:11]ConfirmingBy:23:=<>zResp
	[Purchase_Orders:11]ConfirmingDate:24:=4D_Current_date
	GOTO OBJECT:C206([Purchase_Orders:11]ConfirmingTo:22)
Else 
	[Purchase_Orders:11]ConfirmingBy:23:=""
	[Purchase_Orders:11]ConfirmingDate:24:=!00-00-00!
End if 