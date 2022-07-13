If (Length:C16([Raw_Materials_Transactions:23]CostCenter:19)<3)
	uConfirm("Cost Center required.")
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]CostCenter:19)
	REJECT:C38
End if 

If (Length:C16([Raw_Materials_Transactions:23]Reason:5)=0)
	uConfirm("Reason required, use popup menu.")
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]Reason:5)
	REJECT:C38
End if 

If ([Raw_Materials_Transactions:23]Qty:6<=0)
	uConfirm("Quantity must be greater than zero.")
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]Qty:6)
	REJECT:C38
End if 

If ([Raw_Materials_Transactions:23]Sequence:13<=0)
	uConfirm("Sequence number required.")
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]Sequence:13)
	REJECT:C38
End if 

If (Length:C16([Raw_Materials_Transactions:23]JobForm:12)#8)
	uConfirm("Jobform required.")
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]JobForm:12)
	REJECT:C38
End if 

