Case of 
	: ([Purchase_Orders:11]Dept:7="")
		ALERT:C41("The Approving Department Code is required.")
		GOTO OBJECT:C206([Purchase_Orders:11]Dept:7)
		REJECT:C38
	Else 
		ACCEPT:C269
End case 
