//(s) rReal1

//• 10/29/97 cs insure entry is positive

//TRACE

If (Self:C308->>0)
	If ([Raw_Materials_Groups:22]ReceiptType:13=1) | (Records in selection:C76([Raw_Materials_Locations:25])>0)
		If (Records in selection:C76([Raw_Materials_Locations:25])>0)
			If (([Raw_Materials_Locations:25]Location:2=sCriterion3) & ([Raw_Materials_Locations:25]POItemKey:19=sCriterion2))
				If (rReal1>[Raw_Materials_Locations:25]QtyOH:9)
					BEEP:C151
					ALERT:C41("Quantity is larger than the on hand amount of  "+String:C10([Raw_Materials_Locations:25]QtyOH:9; "###,###,##0.####"))
					rReal1:=0
					GOTO OBJECT:C206(rReal1)
				End if 
			End if 
		End if 
		
	Else 
		If (rReal1>[Purchase_Orders_Items:12]Qty_Received:14)
			BEEP:C151
			ALERT:C41("Quantity is larger than the amount rec'd of  "+String:C10([Purchase_Orders_Items:12]Qty_Received:14; "###,###,##0.####"))
			GOTO OBJECT:C206(rReal1)
		End if 
	End if 
	
Else   //neg number
	
	ALERT:C41("Please enter the return as a positive number.")
	GOTO OBJECT:C206(Self:C308->)
End if 
//