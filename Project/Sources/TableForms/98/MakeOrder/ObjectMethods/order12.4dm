//OM: aOrder() -> 
//@author mlb - 8/29/02  09:21

If (aPickList#0)
	vOrd:=Num:C11(Substring:C12(aPickList{aPickList}; 1; 5))
	If (vOrd#0)
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=vOrd)
	End if 
End if 