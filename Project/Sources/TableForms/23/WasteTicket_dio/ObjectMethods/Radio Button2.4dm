sBudget:="sheets"
iTotalQty:=[Job_Forms:42]EstNetSheets:28
If ([Raw_Materials_Transactions:23]Qty:6>iTotalQty)
	BEEP:C151
	ALERT:C41(String:C10([Raw_Materials_Transactions:23]Qty:6)+" exceeds budgeted net "+sBudget+" of "+String:C10(iTotalQty))
	[Raw_Materials_Transactions:23]Qty:6:=0
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]Qty:6)
End if 