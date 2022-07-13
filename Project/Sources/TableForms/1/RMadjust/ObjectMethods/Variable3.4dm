//11/3/94
// 3/27/95
//If ([RM_GROUP]ReceiptType=1)`  3/27/95
//• 5/6/98 cs changed error message for no bin record

If (sVerifyLocation(Self:C308))
	READ WRITE:C146([Raw_Materials_Locations:25])
	
	If (Records in selection:C76([Purchase_Orders_Items:12])=1)  //  3/27/95
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15; *)
	Else 
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=sCriterion1; *)
	End if 
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=sCriterion3; *)
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19=sCriterion2)
	
	If (fLockNLoad(->[Raw_Materials_Locations:25]))
		
		If (Records in selection:C76([Raw_Materials_Locations:25])=0)
			BEEP:C151
			ALERT:C41("Warning: No Bin record found for this Po Item, Posting will create a bin record.")
			//sCriterion3:=""  `11/3/94
			rReal1:=0
			GOTO OBJECT:C206(sCriterion3)
		Else 
			rReal1:=[Raw_Materials_Locations:25]QtyOH:9
			GOTO OBJECT:C206(rReal1)
			
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("Location is locked. Try again later.")
		sCriterion3:=""
		rReal1:=0
		GOTO OBJECT:C206(sCriterion3)
	End if 
End if 
//End if 

//