If ([Customers_ReleaseSchedules:46]LastRelease:20)
	uConfirm("Remove last release status from this release?"; "Yes"; "No")
	If (ok=1)
		[Customers_ReleaseSchedules:46]LastRelease:20:=False:C215
		[Customers_ReleaseSchedules:46]ChgQtyVersion:14:=[Customers_ReleaseSchedules:46]ChgQtyVersion:14+1
		[Customers_ReleaseSchedules:46]OverRunAddOn:21:=0
	Else 
		[Customers_ReleaseSchedules:46]Sched_Qty:6:=Old:C35([Customers_ReleaseSchedules:46]Sched_Qty:6)
	End if 
	
Else 
	If (Not:C34(Is new record:C668([Customers_ReleaseSchedules:46])))
		[Customers_ReleaseSchedules:46]ChgQtyVersion:14:=[Customers_ReleaseSchedules:46]ChgQtyVersion:14+1
	End if 
End if 

If ([Customers_ReleaseSchedules:46]OriginalRelQty:24=0)
	[Customers_ReleaseSchedules:46]OriginalRelQty:24:=[Customers_ReleaseSchedules:46]Sched_Qty:6
End if 

If ([Customers_ReleaseSchedules:46]RemarkLine1:25="Bill and Hold")
	READ ONLY:C145([Finished_Goods:26])  //query for inventory in bh state
	$i:=qryFinishedGood([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11)
	
	Case of 
		: ($i=0)
			uConfirm("Finished Good record not found."; "OK"; "Help")
			[Customers_ReleaseSchedules:46]Sched_Qty:6:=0
			
		: ([Finished_Goods:26]Bill_and_Hold_Qty:108<=0)
			uConfirm("This item has no Bill and Holds executed."; "OK"; "Help")
			[Customers_ReleaseSchedules:46]Sched_Qty:6:=0
			
		: ([Finished_Goods:26]Bill_and_Hold_Qty:108<[Customers_ReleaseSchedules:46]Sched_Qty:6)
			uConfirm("This item only has "+String:C10([Finished_Goods:26]Bill_and_Hold_Qty:108)+" cartons as Bill and Hold"; "OK"; "Help")
			[Customers_ReleaseSchedules:46]Sched_Qty:6:=0
			
	End case 
End if 

[Customers_ReleaseSchedules:46]OpenQty:16:=[Customers_ReleaseSchedules:46]Sched_Qty:6-[Customers_ReleaseSchedules:46]Actual_Qty:8

[Customers_ReleaseSchedules:46]NumberOfCases:30:=-1
$caseCount:=PK_getCaseCountByCPN([Customers_ReleaseSchedules:46]ProductCode:11)
If ($caseCount>0)
	[Customers_ReleaseSchedules:46]NumberOfCases:30:=Round:C94([Customers_ReleaseSchedules:46]Sched_Qty:6/$caseCount; 2)
Else 
	[Customers_ReleaseSchedules:46]NumberOfCases:30:=-2
End if 
