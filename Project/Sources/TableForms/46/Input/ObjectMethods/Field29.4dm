If ([Customers_ReleaseSchedules:46]RemarkLine1:25="Bill and Hold")
	READ ONLY:C145([Finished_Goods:26])  //query for inventory in bh state
	$i:=qryFinishedGood([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11)
	
	Case of 
		: ($i=0)
			uConfirm("Finished Good record not found."; "OK"; "Help")
			[Customers_ReleaseSchedules:46]RemarkLine1:25:=""
			
		: ([Finished_Goods:26]Bill_and_Hold_Qty:108<=0)
			uConfirm("This item has no Bill and Holds executed."; "OK"; "Help")
			[Customers_ReleaseSchedules:46]RemarkLine1:25:=""
			
		: ([Finished_Goods:26]Bill_and_Hold_Qty:108<[Customers_ReleaseSchedules:46]Sched_Qty:6)
			uConfirm("This item only has "+String:C10([Finished_Goods:26]Bill_and_Hold_Qty:108)+" cartons as Bill and Hold"; "OK"; "Help")
			[Customers_ReleaseSchedules:46]RemarkLine1:25:=""
			
		Else 
			Text23:="Bill and Hold"
			[Customers_ReleaseSchedules:46]RemarkLine1:25:="Bill and Hold"
			[Customers_ReleaseSchedules:46]Billto:22:="N/A"
			[Customers_ReleaseSchedules:46]Expedite:35:="B&H"
	End case 
End if 