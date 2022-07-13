//FM: bagTrack_dio() -> 
//@author mlb - 1/29/02  14:39

Case of 
	: (Form event code:C388=On Load:K2:1)
		C_LONGINT:C283(hlAssignable)
		hlAssignable:=Load list:C383("ToDoAssignable")
		FORM GOTO PAGE:C247(1)
		sCriterion1:=""
		sCriterion2:=""
		sCriterion3:=""
		sCriterion4:=""
		sCriterion5:=""
		sCriterion6:=""
		sCriterion7:=""
		tTitle:=""
		tMessage1:=""
		cb1:=1  //continuous scan
		cb2:=0  //continuous scan
		ARRAY TEXT:C222(aKey; 0)
		ARRAY TEXT:C222(axRelTemp; 0)
		OBJECT SET ENABLED:C1123(bMove; False:C215)
		OBJECT SET ENABLED:C1123(rb1; False:C215)
		OBJECT SET ENABLED:C1123(bPrint; False:C215)
		LIST TO ARRAY:C288("bagTrackLocations"; aItemTypes)
		sLocation:=JTB_setLocation
		INSERT IN ARRAY:C227(aItemTypes; 1; 1)
		aItemTypes{1}:=sLocation
		
	: (Form event code:C388=On Close Box:K2:21)
		FORM GOTO PAGE:C247(1)
		OBJECT SET ENABLED:C1123(bMove; False:C215)
		OBJECT SET ENABLED:C1123(rb1; False:C215)
		OBJECT SET ENABLED:C1123(bPrint; False:C215)
		sCriterion1:=""
		sCriterion2:=""
		sCriterion3:=""
		sCriterion4:=""
		sCriterion5:=""
		sCriterion6:=""
		sCriterion7:=""
		tTitle:=""
		tMessage1:=""
		cb2:=0  //continuous scan
		ARRAY TEXT:C222(aKey; 0)
		ARRAY TEXT:C222(axRelTemp; 0)
		REDUCE SELECTION:C351([JPSI_Job_Physical_Support_Items:111]; 0)
		REDUCE SELECTION:C351([JTB_Job_Transfer_Bags:112]; 0)
		REDUCE SELECTION:C351([JTB_Contents:113]; 0)
		REDUCE SELECTION:C351([JTB_Logs:114]; 0)
		REDUCE SELECTION:C351([JPSI_Logs:115]; 0)
		
		HIDE PROCESS:C324(Current process:C322)
End case 