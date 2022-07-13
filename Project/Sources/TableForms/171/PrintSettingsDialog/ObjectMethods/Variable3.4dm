QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sCriterion3)
If (Records in selection:C76([Purchase_Orders_Items:12])=1)
	tText:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
Else 
	tText:="Please try again. "+String:C10(Records in selection:C76([Purchase_Orders_Items:12]))+" records found."
	sCriterion3:=""
	GOTO OBJECT:C206(sCriterion3)
End if 