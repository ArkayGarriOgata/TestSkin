//Script: NeedDate()  111495  MLB
//•111495  MLB  UPR 1723
//•120998  MLB Y2K Remediation 
If (sDateLimitor(->[Customers_Orders:40]NeedDate:51; 365)=0)
	uConfirm("Apply Need date, "+String:C10([Customers_Orders:40]NeedDate:51; <>shortdate)+", to all order lines?"; "Apply to all"; "No")
	If (ok=1)
		APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]NeedDate:14:=[Customers_Orders:40]NeedDate:51)
		FIRST RECORD:C50([Customers_Order_Lines:41])
	End if 
End if 

//