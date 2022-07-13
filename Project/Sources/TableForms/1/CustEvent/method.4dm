If (Form event code:C388=On Load:K2:1)
	C_LONGINT:C283($xlLeft; $xlTop; $xlRight; $xlBottom)
	
	If (Size of array:C274(<>aBkRptPop)=0)
		ARRAY TEXT:C222(<>aBkRptPop; 0)
		ARRAY TEXT:C222(<>aCustRptPop; 0)
	End if 
	
	If (<>bButtons)  // Added by: Mark Zinke (2/6/13)
		FORM GOTO PAGE:C247(2)
		GET WINDOW RECT:C443($xlLeft; $xlTop; $xlRight; $xlBottom)
		SET WINDOW RECT:C444($xlLeft; $xlTop; $xlRight-40; $xlBottom-70)
	End if 
End if 