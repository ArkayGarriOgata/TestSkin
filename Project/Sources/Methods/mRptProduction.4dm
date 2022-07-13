//%attributes = {"publishedWeb":true}
//(P) mRptProd: Produces Production Report (Daily or Weekly)

SET MENU BAR:C67(5)
Open window:C153(100; 110; 550; 340; 1)
//uCenterWindow (450;230;1;"")
DEFAULT TABLE:C46([Job_Forms_Machine_Tickets:61])
xCriterion1:=""
xCriterion2:=""
xCriterion3:=""
dDate:=!00-00-00!
dFrom:=!00-00-00!
dTo:=!00-00-00!
DIALOG:C40([Job_Forms_Machine_Tickets:61]; "Select4.2")
CLOSE WINDOW:C154
zDefFilePtr:=->[Job_Forms_Machine_Tickets:61]
MESSAGES OFF:C175

If (OK=1)
	gSrchProd
	Case of 
		: (qb1=1)
			aHdg:="DAILY"
			dFrom:=dDate
			dTo:=dDate
			aFrom:=String:C10(dFrom)
			aHdgTo:=""
			aTo:=""
		: (qb2=1)
			aHdg:="WEEKLY"
			aFrom:=String:C10(dFrom)
			aHdgTo:="to"
			aTo:=String:C10(dTo)
	End case 
	If ((dFrom=!00-00-00!) | (dTo=!00-00-00!))
		ALERT:C41("Invalid date - try again!!!")
	Else 
		QUERY SELECTION BY FORMULA:C207([Job_Forms_Machine_Tickets:61]; ([Job_Forms_Machine_Tickets:61]DateEntered:5>=dFrom) & ([Job_Forms_Machine_Tickets:61]DateEntered:5<=dTo))
		If (Records in selection:C76([Job_Forms_Machine_Tickets:61])=0)
			ALERT:C41("No records found!!!")
		Else 
			//uCenterWindow (150;39;1;"")
			Open window:C153(20; 50; 220; 89; 1; "")
			MESSAGE:C88(<>sCR+"Sorting! Please Wait...")
			ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >; [Job_Forms_Machine_Tickets:61]DateEntered:5; >; [Job_Forms_Machine_Tickets:61]JobForm:1; >; [Job_Forms_Machine_Tickets:61]Sequence:3; >)
			CLOSE WINDOW:C154
			
			If (OK=1)
				SET WINDOW TITLE:C213("PRODUCTION REPORT")
				FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "ProductionRept")
				util_PAGE_SETUP(->[Job_Forms_Machine_Tickets:61]; "ProductionRept")
				ACCUMULATE:C303([Job_Forms_Machine_Tickets:61]Good_Units:8; [Job_Forms_Machine_Tickets:61]Waste_Units:9; [Job_Forms_Machine_Tickets:61]MR_Act:6; [Job_Forms_Machine_Tickets:61]Run_Act:7; [Job_Forms_Machine_Tickets:61]MR_AdjStd:14; [Job_Forms_Machine_Tickets:61]Run_AdjStd:15; rDown_Hrs; rTot_Act; rTot_Adj)
				BREAK LEVEL:C302(2)
				PRINT SELECTION:C60([Job_Forms_Machine_Tickets:61])
				FORM SET OUTPUT:C54([Job_Forms_Machine_Tickets:61]; "List")
				gSetWindTitle
			End if 
		End if 
	End if 
End if 

MESSAGES ON:C181