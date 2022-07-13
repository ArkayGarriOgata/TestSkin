If (Records in selection:C76([Raw_Materials_Locations:25])=1)
	If (([Raw_Materials_Locations:25]Raw_Matl_Code:1=sCriterion1) & ([Raw_Materials_Locations:25]Location:2=sCriterion3) & ([Raw_Materials_Locations:25]POItemKey:19=sCriterion2))
		If (rReal1>[Raw_Materials_Locations:25]QtyOH:9)
			BEEP:C151
			ALERT:C41("Quantity is larger than the on hand amount of  "+String:C10([Raw_Materials_Locations:25]QtyOH:9; "###,###,##0.####"))
			rReal1:=0
			GOTO OBJECT:C206(rReal1)
		End if 
		
	End if 
	
End if 