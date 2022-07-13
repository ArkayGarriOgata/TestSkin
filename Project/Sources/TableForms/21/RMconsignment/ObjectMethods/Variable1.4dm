QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=sCriterion1)
If (Records in selection:C76([Raw_Materials:21])=0)
	BEEP:C151
	ALERT:C41("Invalid Raw Material Code!")
	GOTO OBJECT:C206(sCriterion1)
End if 