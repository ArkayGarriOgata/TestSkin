//(S) 'bSearch
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=sCriterion)
If (Records in selection:C76([Finished_Goods:26])=0)
	uNoneFound
	REJECT:C38
Else 
	RELATE MANY:C262([Finished_Goods:26])
	If (Records in selection:C76([Finished_Goods_Locations:35])>0)
		CONFIRM:C162("Bins exist - Do you still want to Delete???")
		If (OK=1)
			REJECT:C38
		End if 
	End if 
End if 
//EOS