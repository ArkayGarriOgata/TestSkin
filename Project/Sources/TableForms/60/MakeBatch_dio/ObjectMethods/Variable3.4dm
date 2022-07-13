sCriterion3:=fStripSpace("A"; sCriterion3)

If (sVerifyLocation(Self:C308))
	READ WRITE:C146([Raw_Materials_Locations:25])
	QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1; *)
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=sCriterion3; *)
	QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19=sCriterion2)
	If (fLockNLoad(->[Raw_Materials_Locations:25]))
		
	Else 
		BEEP:C151
		ALERT:C41("Location is locked. Try again later.")
		sCriterion3:=""
		rReal1:=0
		GOTO OBJECT:C206(sCriterion3)
	End if 
End if 
//