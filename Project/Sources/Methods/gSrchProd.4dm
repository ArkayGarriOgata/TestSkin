//%attributes = {"publishedWeb":true}
//(P) gSrchProd: Search of [MachineTicket] records for report

zDefault:="["+Table name:C256(->[Job_Forms_Machine_Tickets:61])+"]"
Case of 
	: ((xCriterion1="") & (xCriterion2="") & (xCriterion3=""))
		ALL RECORDS:C47
	: (xCriterion1#"")
		Case of 
			: (rb1=1)
				QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=xCriterion1+"@")
			: (rb2=1)
				QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2=xCriterion1+"@")
		End case 
	Else 
		gCheckCrit
		Case of 
			: (rb1=1)
				QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1>=xLoName+"@"; *)
				QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]JobForm:1<=xHiName+"@")
			: (rb2=1)
				QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2>=xLoName+"@"; *)
				QUERY:C277([Job_Forms_Machine_Tickets:61];  & ; [Job_Forms_Machine_Tickets:61]CostCenterID:2<=xHiName+"@")
		End case 
End case 
If (Records in selection:C76([Job_Forms_Machine_Tickets:61])=0)
	uNoneFound
	REJECT:C38
End if 