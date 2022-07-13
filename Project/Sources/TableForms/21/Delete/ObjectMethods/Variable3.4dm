//(S) 'bSearch
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=sCriterion)
If (Records in selection:C76([Raw_Materials:21])=0)
	uNoneFound
	REJECT:C38
Else 
	RELATE MANY:C262([Raw_Materials:21]Raw_Matl_Code:1)
	If (Records in selection:C76([Raw_Materials_Locations:25])>0)
		CONFIRM:C162("Bins exist - Do you still want to Delete???")
		If (OK=1)
			REJECT:C38
		End if 
	End if 
End if 
//EOS