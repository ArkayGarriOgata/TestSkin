Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		util_alternateBackground
		If ([Estimates_Differentials:38]TotalPieces:8>0) & ([Estimates_Differentials:38]CostTTL:14>0)
			rReal1:=Round:C94([Estimates_Differentials:38]CostTTL:14/[Estimates_Differentials:38]TotalPieces:8*1000; 2)
		Else 
			rReal1:=0
		End if 
		
End case 
app_SelectIncludedRecords(->[Estimates_Differentials:38]Id:1; 0; "DIFF")