//(lp) [control]choosecustomer
//• 4/16/97 cs upr 1794
Case of 
	: (Form event code:C388=On Load:K2:1)
		cbCorrect:=0
		If (User in group:C338(Current user:C182; "RoleSuperUser"))  //& (Size of array(aCustId)<=2) `• 4/16/97 cs removed upr 1794
			OBJECT SET ENABLED:C1123(cbCorrect; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(cbCorrect; False:C215)
		End if 
End case 
//eop