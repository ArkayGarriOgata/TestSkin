//(s) poitemkey [issueticket] input

If (Self:C308->#"")
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=Self:C308->)
	
	If (Records in selection:C76([Purchase_Orders_Items:12])=0)
		ALERT:C41("Entered PO Item was not found."+Char:C90(13)+"Please try again.")
		Self:C308->:=""
	End if 
End if 
//