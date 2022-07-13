//(S)LastRelease
//•022197  MLB  UPR 1850 make batch to do this
If ([Customers_Order_Lines:41]OrderLine:3#[Customers_ReleaseSchedules:46]OrderLine:4)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Customers_ReleaseSchedules:46]OrderLine:4)
End if 

If ([Customers_ReleaseSchedules:46]LastRelease:20)
	[Customers_ReleaseSchedules:46]Sched_Qty:6:=0  //so we don't double count it
	SAVE RECORD:C53([Customers_ReleaseSchedules:46])  //in case its a new record
	
	CUT NAMED SELECTION:C334([Customers_ReleaseSchedules:46]; "current")  //•022197  MLB  UPR 1850, was copy
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3; *)  //what hasn't shipped
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Qty:8=0)
	$openRelease:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
	
	USE NAMED SELECTION:C332("current")
	//CLEAR NAMED SELECTION("current")`•022197  MLB  UPR 1850
	[Customers_ReleaseSchedules:46]OverRunAddOn:21:=[Customers_Order_Lines:41]Quantity:6*([Customers_Order_Lines:41]OverRun:25/100)
	$netShipped:=[Customers_Order_Lines:41]Qty_Shipped:10-[Customers_Order_Lines:41]Qty_Returned:35  //•022197  MLB  UPR 1850
	[Customers_ReleaseSchedules:46]Sched_Qty:6:=([Customers_Order_Lines:41]Quantity:6+[Customers_ReleaseSchedules:46]OverRunAddOn:21)-$netShipped-$openRelease
	
	If ([Customers_ReleaseSchedules:46]OriginalRelQty:24=0)
		[Customers_ReleaseSchedules:46]OriginalRelQty:24:=[Customers_ReleaseSchedules:46]Sched_Qty:6
	End if 
	uConfirm("Allowable: "+String:C10([Customers_Order_Lines:41]Quantity:6+[Customers_ReleaseSchedules:46]OverRunAddOn:21)+" - Releases: "+String:C10($openRelease)+" - Shipped: "+String:C10($netShipped)+" = Last: "+String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6))
	If (ok=0)
		[Customers_ReleaseSchedules:46]LastRelease:20:=False:C215
		[Customers_ReleaseSchedules:46]Sched_Qty:6:=0
		[Customers_ReleaseSchedules:46]OverRunAddOn:21:=0
		[Customers_ReleaseSchedules:46]OriginalRelQty:24:=Old:C35([Customers_ReleaseSchedules:46]OriginalRelQty:24)
	End if 
	
Else 
	//$i:=[OrderLines]Quantity*([OrderLines]OverRun/100)
	//CONFIRM("Subtract "+String($i)+" from the scheduled qty?")
	//If (ok=1)
	//[Customers_ReleaseSchedules]Sched_Qty:=0  `Sched_Qty-$i
	//[Customers_ReleaseSchedules]OverRunAddOn:=0
	// End if 
End if 
[Customers_ReleaseSchedules:46]OpenQty:16:=[Customers_ReleaseSchedules:46]Sched_Qty:6-[Customers_ReleaseSchedules:46]Actual_Qty:8
//