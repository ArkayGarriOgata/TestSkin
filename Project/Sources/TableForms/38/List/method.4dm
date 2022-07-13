app_basic_list_form_method
$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		If ([Estimates_Differentials:38]TotalPieces:8>0)
			rReal1:=Round:C94([Estimates_Differentials:38]CostTTL:14/[Estimates_Differentials:38]TotalPieces:8*1000; 2)
		Else 
			rReal1:=0
		End if 
		
End case 
