
If (FORM Event:C1606.code=On Load:K2:1)
	
	OBJECT SET ENABLED:C1123(*; "Remove"; False:C215)
	
Else 
	
	RmTr_Foil_Remove(eRawMatlTrns)
	
End if 
