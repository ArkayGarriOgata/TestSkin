
If (FORM Event:C1606.code=On Clicked:K2:4)
	
	OBJECT SET ENABLED:C1123(*; "ColdFoil_Remove"; Not:C34(OB Is empty:C1297(eRawMatlTrns)))
	
End if 

