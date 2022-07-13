QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sCriterion2)
If (Records in selection:C76([Purchase_Orders_Items:12])=1)
	sCriterion1:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
	READ WRITE:C146([Raw_Materials_Locations:25])
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=sCriterion2)
	
	If (Records in selection:C76([Raw_Materials_Locations:25])>0)
		READ ONLY:C145([Raw_Materials:21])
		QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=sCriterion1)
		If (Records in selection:C76([Raw_Materials:21])>0)
			sCriterion3:=[Raw_Materials_Locations:25]Location:2
			rReal1:=[Raw_Materials_Locations:25]QtyOH:9
			GOTO OBJECT:C206(rReal1)
			
		Else 
			BEEP:C151
			ALERT:C41("Invalid Raw Material Code!")
			sCriterion1:=""
			GOTO OBJECT:C206(sCriterion1)
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("Not a R/M receipt type, no bin record exists.")
		sCriterion1:=""
		sCriterion2:=""
		GOTO OBJECT:C206(sCriterion2)
	End if 
	
Else 
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=sCriterion2)
	If (Records in selection:C76([Raw_Materials_Locations:25])>0)
		sCriterion1:=[Raw_Materials_Locations:25]Raw_Matl_Code:1
		sCriterion3:=[Raw_Materials_Locations:25]Location:2
		rReal1:=[Raw_Materials_Locations:25]QtyOH:9
	Else 
		BEEP:C151
		ALERT:C41("Invalid PO item number.")
		GOTO OBJECT:C206(sCriterion2)
	End if 
End if 
//