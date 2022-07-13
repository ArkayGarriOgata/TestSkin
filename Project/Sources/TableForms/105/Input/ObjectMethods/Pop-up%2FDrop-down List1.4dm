//(s) aCommCode [poitems]input
If (aPO#0) & (aPO<=Size of array:C274(aPO))
	[QA_Corrective_Actions:105]CustomerPO:12:=aPO{aPO}
	GOTO OBJECT:C206([QA_Corrective_Actions:105]ReasonCustomer:24)
Else 
	GOTO OBJECT:C206([QA_Corrective_Actions:105]CustomerPO:12)
End if 