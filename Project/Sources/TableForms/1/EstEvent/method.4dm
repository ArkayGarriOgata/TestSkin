If (Form event code:C388=On Load:K2:1)
	FORM SET INPUT:C55([Estimates:17]; "Input")
	FORM SET INPUT:C55([Process_Specs:18]; "Input")
	If (<>fisSalesRep | <>fisCoord)
		OBJECT SET ENABLED:C1123(bPlan; False:C215)
		OBJECT SET ENABLED:C1123(bPrice; False:C215)
		OBJECT SET ENABLED:C1123(ibDelEst; False:C215)
	End if 
	
	If (Size of array:C274(<>aEstRptPop)=0)
		ARRAY TEXT:C222(<>aEstRptPop; 0)
	End if 
	
	If (<>bButtons)
		FORM GOTO PAGE:C247(2)
	End if 
End if 