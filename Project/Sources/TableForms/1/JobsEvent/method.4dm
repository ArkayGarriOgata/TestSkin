// ----------------------------------------------------
// Form Method: [zz_control].JobsEvent
// ----------------------------------------------------
//• 12/5/97 cs added abilty to print new job bag for testing
//• 12/16/97 cs added new close out report for testing
//• 7/2/98 cs setup reports for removal
//• 7/28/98 cs new report
//• 8/4/d98 cs added Ink order form to report list
//•111798  mlb  UPR add two more
//•090199  mlb  UPR 2054
// Modified by: MelvinBohince (4/5/22) add JobSeq_Bud_v_Act

Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT SET ENABLED:C1123(bAct; False:C215)
		OBJECT SET ENABLED:C1123(ibIss; False:C215)
		OBJECT SET ENABLED:C1123(bPlan; False:C215)
		OBJECT SET ENABLED:C1123(bBill; False:C215)
		OBJECT SET ENABLED:C1123(bPrint; False:C215)
		OBJECT SET ENABLED:C1123(bPacking; False:C215)
		OBJECT SET ENABLED:C1123(bQuote; False:C215)
		OBJECT SET ENABLED:C1123(ibNewEst; False:C215)
		OBJECT SET ENABLED:C1123(ibModEst; False:C215)
		OBJECT SET ENABLED:C1123(ibRevEst; True:C214)
		OBJECT SET ENABLED:C1123(bWaste; False:C215)
		OBJECT SET ENABLED:C1123(bReverseIssue; False:C215)
		
		If (User in group:C338(Current user:C182; "RoleCostAccountant"))
			OBJECT SET ENABLED:C1123(bAct; True:C214)
			OBJECT SET ENABLED:C1123(bBill; True:C214)
			OBJECT SET ENABLED:C1123(bPrint; True:C214)
			OBJECT SET ENABLED:C1123(bReverseIssue; True:C214)
			If (Size of array:C274(<>asJobAPages)=0)
				ARRAY TEXT:C222(<>asJobAPages; 6)
				<>asJobAPages{1}:="Actual"
				<>asJobAPages{2}:="Machine"
				<>asJobAPages{3}:="Material"
				<>asJobAPages{4}:="Summary"
				<>asJobAPages{5}:="Good/Waste Units"
				<>asJobAPages{6}:="Transfers"
			End if 
		End if 
		
		If (User in group:C338(Current user:C182; "RoleQA"))
			OBJECT SET ENABLED:C1123(bWaste; True:C214)
			OBJECT SET ENABLED:C1123(ibModEst; True:C214)
		End if 
		
		If (User in group:C338(Current user:C182; "WorkInProcess"))
			OBJECT SET ENABLED:C1123(ibIss; True:C214)
			OBJECT SET ENABLED:C1123(bPlan; True:C214)
			OBJECT SET ENABLED:C1123(bPacking; True:C214)
		End if 
		
		If (User in group:C338(Current user:C182; "RoleDataEntry"))
			OBJECT SET ENABLED:C1123(ibIss; True:C214)
			OBJECT SET ENABLED:C1123(bPlan; True:C214)
		End if 
		
		If (User in group:C338(Current user:C182; "RoleOperations"))
			OBJECT SET ENABLED:C1123(bPacking; True:C214)
			OBJECT SET ENABLED:C1123(bQuote; True:C214)
		End if 
		
		If (User in group:C338(Current user:C182; "Job Review"))
			OBJECT SET ENABLED:C1123(ibNewEst; False:C215)
			OBJECT SET ENABLED:C1123(ibModEst; False:C215)
		End if 
		
		If (User in group:C338(Current user:C182; "Planners"))
			OBJECT SET ENABLED:C1123(ibNewEst; True:C214)
			OBJECT SET ENABLED:C1123(ibModEst; True:C214)
		End if 
		
		//If (User in group(Current user;"Role_Glue_Scheduling"))  // Added by: Mark Zinke (8/20/13) 
		OBJECT SET ENABLED:C1123(bGlueLineStatus; True:C214)
		//Else 
		//OBJECT SET ENABLED(bGlueLineStatus;False)
		//End if 
		//doJobRptRecords
		If (Size of array:C274(<>aJobRptPop)=0)  //• 7/2/98 cs remove these commented report (completely from AMS)
			ARRAY TEXT:C222(<>aJobRptPop; 36)  //after about 2 mmonths current date = 7/2/98
			//   ◊aJobRptPop{1}:="Daily Cost Center Summary"
			//   ◊aJobRptPop{2}:="Monthly Cost Center Sum"
			//   ◊aJobRptPop{3}:="Production Report"
			<>aJobRptPop{1}:="Prod Analysis"
			<>aJobRptPop{2}:="Variance Analysis Summary"
			<>aJobRptPop{3}:="WIP Inventory"
			<>aJobRptPop{4}:="WIP Actual Hours Summary"  //4/20/95
			<>aJobRptPop{5}:="-------------------"
			<>aJobRptPop{6}:="Job Close Out"
			<>aJobRptPop{7}:="Job Close Out Summary"  //041196 TJF
			<>aJobRptPop{8}:="PO Items by Job"  //• 7/28/98 cs new report
			<>aJobRptPop{9}:="Closeout Review"  //OLD Job Close Out"
			<>aJobRptPop{10}:="Sheeter Rate Closeout"
			<>aJobRptPop{11}:="Gluer Rate Closeout"
			<>aJobRptPop{12}:="-------------------"
			<>aJobRptPop{13}:="Monthly Hours Journal"
			<>aJobRptPop{14}:="Machine Ticket Report"
			<>aJobRptPop{15}:="Machine Efficiencies"
			<>aJobRptPop{16}:="Job Bag"
			<>aJobRptPop{17}:="-Ink Order Form"
			<>aJobRptPop{18}:="JobItem Contributions"  //•111798  mlb  UPR 
			<>aJobRptPop{19}:="Material Variances"  //•111798  mlb  UPR 
			<>aJobRptPop{20}:="Job Variances"  //•08/26/1999  Mel Bohince  
			<>aJobRptPop{21}:="Machine Variances"  //•090199  mlb  UPR 2054
			<>aJobRptPop{22}:="-------------------"  //was "Payroll vs. Production"  
			<>aJobRptPop{23}:="Daily Gluing Shortage"  //•5/30/00  mlb  was "Daily Production"
			<>aJobRptPop{24}:="Daily Item Status"  //•080302  mlb  
			<>aJobRptPop{25}:="Cost & Qty Estimate"  //•081702  mlb  
			<>aJobRptPop{26}:="Daily Press Report"  //• mlb - 8/23/01  
			<>aJobRptPop{27}:="Daily Press Output"  //• mlb - 8/24/01  12:30
			<>aJobRptPop{28}:="Just-In-Time Summary"  //• mlb - 5/24/02  12:20
			<>aJobRptPop{29}:="Material Usage"  //• mlb - 1/31/03  10:50
			<>aJobRptPop{30}:="Job_80_20"  //• mlb - 1/22/04  10:50
			<>aJobRptPop{31}:="Combo Percent"  // Modified by: Mel Bohince (11/9/16) 
			<>aJobRptPop{32}:="Score Card Data"  // Modified by: Mel Bohince (1/25/17) 
			<>aJobRptPop{33}:="Closeout-Commodities"  // Modified by: Mel Bohince (2/17/17) 
			<>aJobRptPop{34}:="Jobits without Pricing"  // Modified by: Mel Bohince (3/1/17) 
			<>aJobRptPop{35}:="Finishing Dept Rpt"  // Modified by: Mel Bohince (1/19/19) 
			<>aJobRptPop{36}:="JobSeq Bud v Act"
			
			<>aJobRptPopMenu:=<>aJobRptPop{1}
			For ($i; 2; Size of array:C274(<>aJobRptPop))
				
				If (Substring:C12(<>aJobRptPop{$i}; 1; 1)="-")
					<>aJobRptPopMenu:=<>aJobRptPopMenu+";("+<>aJobRptPop{$i}
				Else 
					If ($i=6)
						If (User in group:C338(Current user:C182; "RoleCostAccountant"))
							<>aJobRptPopMenu:=<>aJobRptPopMenu+";"+<>aJobRptPop{$i}
						Else 
							<>aJobRptPopMenu:=<>aJobRptPopMenu+";("+<>aJobRptPop{$i}
						End if 
					Else 
						<>aJobRptPopMenu:=<>aJobRptPopMenu+";"+<>aJobRptPop{$i}
					End if 
					
				End if 
			End for 
		End if 
		
		If (<>PHYSICAL_INVENORY_IN_PROGRESS)
			OBJECT SET ENABLED:C1123(bBill; False:C215)
			OBJECT SET ENABLED:C1123(bPrint; False:C215)
			OBJECT SET ENABLED:C1123(ibIss; False:C215)
			OBJECT SET ENABLED:C1123(bPlan; False:C215)
		End if 
		
		If (<>bButtons)  // Added by: Mark Zinke (2/6/13)
			FORM GOTO PAGE:C247(2)
			GET WINDOW RECT:C443($xlLeft; $xlTop; $xlRight; $xlBottom)
			SET WINDOW RECT:C444($xlLeft; $xlTop; $xlRight; $xlBottom)
		End if 
End case 