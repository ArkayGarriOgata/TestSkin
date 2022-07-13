// mlb: 01/17/06, 11:12:40
// ----------------------------------------------------
// Form Method: RM_ReverseIssue_dio
//---------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		dDate:=4D_Current_date
		sJobForm:=""
		sCriterion1:=""
		sCriterion2:=""
		sCriterion3:=""
		sCriterion4:=""
		rReal1:=0
		tText:="Enter a Jobform with issues"
		ARRAY TEXT:C222(aPOIpoiKey; 0)
		ARRAY REAL:C219(asQty; 0)
		ARRAY TEXT:C222(aComm; 0)
		ARRAY TEXT:C222(aRMcode; 0)
		ARRAY TEXT:C222(aText; 0)
		aText{0}:=""
		rb1:=0
		rb2:=1
		
		If (User in group:C338(Current user:C182; "RoleCostAccountant"))  //• 5/12/98 cs limmt acces to chnagin receipt date (AT ALL) to Cost Acct
			SetObjectProperties(""; ->dDate; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
			OBJECT SET ENABLED:C1123(rb1; True:C214)
		Else 
			SetObjectProperties(""; ->dDate; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
			OBJECT SET ENABLED:C1123(rb1; False:C215)
		End if 
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 