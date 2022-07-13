READ WRITE:C146([Purchase_Orders_Items:12])
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sCriterion2)
If (Records in selection:C76([Purchase_Orders_Items:12])=0)
	BEEP:C151
	ALERT:C41("Invalid PO item key!")
	sCriterion2:=""
	GOTO OBJECT:C206(sCriterion2)
Else 
	If (fLockNLoad(->[Purchase_Orders_Items:12]))
		If (Not:C34([Purchase_Orders_Items:12]Consignment:49))
			CONFIRM:C162("Change PO_Item "+sCriterion2+" to a consignment item?"; "Change"; "Try Again")
			If (ok=1)
				[Purchase_Orders_Items:12]Consignment:49:=True:C214
				SAVE RECORD:C53([Purchase_Orders_Items:12])
			Else 
				sCriterion2:=""
				REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
			End if 
		End if 
	Else 
		sCriterion2:=""
		REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
	End if 
End if 