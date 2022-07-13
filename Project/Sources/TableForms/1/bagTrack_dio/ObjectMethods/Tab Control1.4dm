//OM: Tab Control1() -> 
//@author mlb - 2/7/02  16:15

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

OBJECT SET ENABLED:C1123(bMove; False:C215)
OBJECT SET ENABLED:C1123(rb1; False:C215)
OBJECT SET ENABLED:C1123(bPrint; False:C215)

If (Selected list items:C379(iBagTabs)=3)
	JTB_WhatsHere(sLocation)
End if 

If (Selected list items:C379(iBagTabs)=4)
	ALL RECORDS:C47([JTB_Job_Transfer_Bags:112])
	ORDER BY:C49([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]Location:4; >; [JTB_Job_Transfer_Bags:112]ID:1; >)
	
	ALL RECORDS:C47([JTB_Logs:114])
	ORDER BY:C49([JTB_Logs:114]; [JTB_Logs:114]tsTimeStamp:2; <)
End if 