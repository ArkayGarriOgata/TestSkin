// ----------------------------------------------------
// User name (OS): cs
// Date: 3/27/97
// ----------------------------------------------------
// Form Method: [zz_control].RMadjust
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	dDate:=4D_Current_date
	sCriterion2:=""
	sCriterion3:=""
	sCriterion4:=""
	rReal1:=0
	
	//• 3/27/ 97 cs make reason not enterable for PI
	If (fPiActive)  //set in calling procedure
		sCriterion4:="Phys Inv"
		SetObjectProperties(""; ->sCriterion4; True:C214; ""; False:C215)
	Else 
		SetObjectProperties(""; ->sCriterion4; True:C214; ""; True:C214)
	End if 
	
	If (User in group:C338(Current user:C182; "CostAcctDateAccess"))  //• 5/12/98 cs limmt acces to chnagin receipt date (AT ALL) to Cost Acct
		SetObjectProperties(""; ->dDate; True:C214; ""; True:C214)
	Else 
		SetObjectProperties(""; ->dDate; True:C214; ""; False:C215)
	End if 
End if 