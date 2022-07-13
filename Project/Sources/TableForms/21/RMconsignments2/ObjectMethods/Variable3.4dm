QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=sCriterion1; *)
QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19=sCriterion2; *)
QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=sCriterion3)
If (Records in selection:C76([Raw_Materials_Locations:25])=0)
	BEEP:C151
	ALERT:C41("Invalid bin location!")
	GOTO OBJECT:C206(sCriterion3)
End if 