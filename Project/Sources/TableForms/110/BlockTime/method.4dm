// ----------------------------------------------------
// Form Method: [ProductionSchedules].BlockTime
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		sCriterion2:="Arkay"
		sCriterion3:="Maintenance"
		sCriterion4:=String:C10(?07:00:00?; HH MM:K7:2)
		sCriterion5:="0"
		sCriterion6:="0"
		dDate:=4D_Current_date
		tTime:=4d_Current_time
		rb1:=1
		rb2:=0
		SetObjectProperties(""; ->dDate; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->tTime; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->sCriterion5; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
End case 