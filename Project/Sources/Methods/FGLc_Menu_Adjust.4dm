//%attributes = {}
//Method:  FGLc_Menu_Adjust
//Description:  This method will bring up the Adjustment for a 

Case of 
	: (Undefined:C82(<>FGLcnProcessAdujst))
		
		<>FGLcnProcessAdujst:=New process:C317("FGLc_Dialog_Adjust"; <>lMidMemPart; "Plus Minus Pairs")
		
	: (<>FGLcnProcessAdujst=0)
		
		<>FGLcnProcessAdujst:=New process:C317("FGLc_Dialog_Adjust"; <>lMidMemPart; "Plus Minus Pairs")
		
	Else 
		
		SHOW PROCESS:C325(<>FGLcnProcessAdujst)
		BRING TO FRONT:C326(<>FGLcnProcessAdujst)
		
End case 
