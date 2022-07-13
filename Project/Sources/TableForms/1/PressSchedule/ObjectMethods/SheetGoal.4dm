// -------
// Method: [zz_control].PressSchedule.SheetGoal   ( ) ->
// By: Mel Bohince @ 10/05/16, 08:37:55
// Description
// 
// ----------------------------------------------------

CUT NAMED SELECTION:C334([ProductionSchedules:110]; "beforeGoal")

distributionList:=Email_WhoAmI
Case of 
	: (sCriterion1="All")
		PS_PrintGoal("Printing")
		
	: (sCriterion1="D/C")
		PS_PrintGoal("Blanking")
		
	Else 
		PS_PrintGoal("Stamping")
End case 


ALERT:C41("Check your email!")
USE NAMED SELECTION:C332("beforeGoal")
