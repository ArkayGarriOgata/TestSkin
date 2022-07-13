If (Form event code:C388=On Load:K2:1)
	rb1:=1
	rb2:=0
	OBJECT SET ENABLED:C1123(bPick; False:C215)  //the Update btn
	OBJECT SET ENABLED:C1123(rInclPrep; False:C215)  //enabled if [Estimates]_Cost_TotalPrep>0
	OBJECT SET ENABLED:C1123(*; "accounting@"; False:C215)  //OBJECT SET ENABLED(rInclFrate;False)
	OBJECT SET ENABLED:C1123(*; "addon@"; False:C215)
	
	If (User in group:C338(Current user:C182; "AccountsReceivable"))
		OBJECT SET ENABLED:C1123(*; "accounting@"; True:C214)  //OBJECT SET ENABLED(rInclFrate;True)
	End if 
End if 
//eos