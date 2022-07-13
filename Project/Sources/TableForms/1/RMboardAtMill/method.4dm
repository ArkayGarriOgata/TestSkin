//FM: RMboardAtMill() -> 
//@author mlb - 7/5/02  16:28

Case of 
	: (Form event code:C388=On Load:K2:1)
		sCriterion1:=""
		sCriterion2:="0"*9
		rReal1:=0
		sCriterion3:=""  //location
		sCriterion4:=""
		t3:=""  //uom
		dDate:=4D_Current_date
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 
//