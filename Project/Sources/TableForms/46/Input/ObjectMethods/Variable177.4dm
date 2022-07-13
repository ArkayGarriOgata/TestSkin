READ ONLY:C145([Finished_Goods:26])  //query for inventory in bh state
$i:=qryFinishedGood([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11)

Case of 
	: ($i=0)
		uConfirm("WARNING: Finished Good record not found."; "OK"; "Help")
		
	: ([Finished_Goods:26]Bill_and_Hold_Qty:108<=0)
		uConfirm("WARNING: This item has no Bill and Holds executed."; "OK"; "Help")
		
	: ([Finished_Goods:26]Bill_and_Hold_Qty:108<[Customers_ReleaseSchedules:46]Sched_Qty:6)
		uConfirm("WARNING: This item only has "+String:C10([Finished_Goods:26]Bill_and_Hold_Qty:108)+" cartons as Bill and Hold"; "OK"; "Help")
		
	Else 
		//Text23:="Bill and Hold"
		//[Customers_ReleaseSchedules]RemarkLine1:="Bill and Hold"
		//[Customers_ReleaseSchedules]Billto:="N/A"
		//[Customers_ReleaseSchedules]Expedite:="B&H"
End case 

// Modified by: Mel Bohince (10/8/19) change the above to warnings
Text23:="Bill and Hold"
[Customers_ReleaseSchedules:46]RemarkLine1:25:="Bill and Hold"
[Customers_ReleaseSchedules:46]Billto:22:="N/A"
[Customers_ReleaseSchedules:46]Expedite:35:="B&H"