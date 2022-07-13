// ----------------------------------------------------
// User name (OS): cs
// Date: 5/12/98
// ----------------------------------------------------
// Form Method: [zz_control].RMreturn
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	sCriterion1:=""
	sCriterion2:="0"*9
	rReal1:=0
	sCriterion3:=""
	sCriterion4:=""
	t3:=""
	dDate:=4D_Current_date
	
	If (User in group:C338(Current user:C182; "CostAcctDateAccess"))  //• 5/12/98 cs limmt acces to chnagin receipt date (AT ALL) to Cost Acct
		SetObjectProperties(""; ->dDate; True:C214; ""; True:C214)
	Else 
		SetObjectProperties(""; ->dDate; True:C214; ""; False:C215)
	End if 
End if 