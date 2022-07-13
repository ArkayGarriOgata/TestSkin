//If ([RM_GROUP]ReceiptType=1)

If (sVerifyLocation(Self:C308))
	READ WRITE:C146([Raw_Materials_Locations:25])
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15; *)
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=sCriterion3; *)
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19=sCriterion2)
	If (fLockNLoad(->[Raw_Materials_Locations:25]))
		If (Records in selection:C76([Raw_Materials_Locations:25])=0)
			BEEP:C151
			ALERT:C41("Old location not on file.")
			sCriterion3:=""
			rReal1:=0
			GOTO OBJECT:C206(sCriterion3)
		Else 
			rReal1:=[Raw_Materials_Locations:25]QtyOH:9
			GOTO OBJECT:C206(rReal1)
			
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("Old location is locked. Try again later.")
		sCriterion3:=""
		rReal1:=0
		GOTO OBJECT:C206(sCriterion3)
	End if 
End if 

//End if 


//