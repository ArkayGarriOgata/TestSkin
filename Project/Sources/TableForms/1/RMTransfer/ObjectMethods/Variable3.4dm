If (sVerifyLocation(Self:C308))
	READ WRITE:C146([Raw_Materials_Locations:25])
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=sCriterion1; *)
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=sCriterion3; *)
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19=sCriterion2)
	If (fLockNLoad(->[Raw_Materials_Locations:25]))
		If (Records in selection:C76([Raw_Materials_Locations:25])=1)
			rReal1:=[Raw_Materials_Locations:25]QtyOH:9
			GOTO OBJECT:C206(rReal1)
		Else 
			BEEP:C151
			ALERT:C41("Old bin location "+sCriterion3+"/"+sCriterion2+" not found.")
			sCriterion3:=""
			rReal1:=0
			GOTO OBJECT:C206(sCriterion3)
			
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("Old location record locked, try again later.")
		UNLOAD RECORD:C212([Raw_Materials_Locations:25])
		sCriterion3:=""
		rReal1:=0
		GOTO OBJECT:C206(sCriterion3)
	End if 
End if 

//