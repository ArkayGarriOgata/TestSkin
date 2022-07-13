
//(LP) [PO_ITEMS]Input
//•031997  MLB  
Case of 
	: (Form event code:C388=On Load:K2:1)
		C_BOOLEAN:C305(fNwJobPoLnk; fChngComKey; fNoDelete)  //• 4/11/97 cs fChngComKey used to track a change in commodity key/subgroup
		beforePOI  //
		
	: (Form event code:C388=On Close Box:K2:21)
		bDone:=1
		CANCEL:C270
		
	: (Form event code:C388=On Validate:K2:3)
		AfterPOI
End case 
//EOLP