//(S) [PURCHASE_ORDER]'SelectPO'bOK
If (Size of array:C274(aText)=0) | (sCriterion1#"")
	sFindPo
End if 

If (Size of array:C274(aText)>0)
	ACCEPT:C269
Else 
	ALERT:C41("You need to Select at least one PO.")
End if 
//