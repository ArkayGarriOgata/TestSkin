//(S) 'bSearch
QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Code:1=sCriterion)
If (Records in selection:C76([Raw_Materials_Groups:22])=0)
	uNoneFound
	REJECT:C38
End if 
//EOS