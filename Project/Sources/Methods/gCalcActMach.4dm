//%attributes = {"publishedWeb":true}
//(P)gCalcActMach: x_fixjmiactuals and gCalcActual
//•5.10.95
//•112796   create Machin_Job record for unbugeted items
//•121096  mBohince  don't create bud rec, messes up closeout rpt
// • mel (6/29/05, 14:29:11) try to stop unnecessary !ccc records

CUT NAMED SELECTION:C334([Job_Forms_Machines:43]; "whileLooking")  // • mel (6/29/05, 14:29:11) try to stop unnecessary !ccc records

//If (Records in selection([Machine_Job])=0)  `•112596    these were managled
//USE SET("thisJob")
If (Length:C16([Job_Forms_Machine_Tickets:61]JobForm:1)=8)  // • mel (6/29/05, 14:29:11) try to stop unnecessary !ccc records
	QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=[Job_Forms_Machine_Tickets:61]JobForm:1; *)  // • mel (6/29/05, 14:29:11) try to stop unnecessary !ccc records
	QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=[Job_Forms_Machine_Tickets:61]Sequence:3)
	//End if 
	
	If (Records in selection:C76([Job_Forms_Machines:43])=0)
		If (([Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7)>0)
			CREATE RECORD:C68([Job_Forms_Machines:43])  //• mlb - 9/25/01  11:55
			[Job_Forms_Machines:43]JobForm:1:=[Job_Forms_Machine_Tickets:61]JobForm:1
			[Job_Forms_Machines:43]CostCenterID:4:="!"+[Job_Forms_Machine_Tickets:61]CostCenterID:2
			[Job_Forms_Machines:43]Sequence:5:=[Job_Forms_Machine_Tickets:61]Sequence:3
			[Job_Forms_Machines:43]Comment:2:="Not Budgeted"
			[Job_Forms_Machines:43]ModDate:32:=4D_Current_date
			[Job_Forms_Machines:43]ModWho:33:="!ccc"  // • mel (6/29/05, 14:29:11) try to stop unnecessary !ccc records
		End if 
	End if 
	
	If (Length:C16([Job_Forms_Machines:43]JobForm:1)=8)  //(Records in selection([Machine_Job])>0)
		[Job_Forms_Machines:43]Actual_OH:23:=[Job_Forms_Machines:43]Actual_OH:23+Round:C94(([Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7)*[Cost_Centers:27]MHRburdenSales:5; 2)
		[Job_Forms_Machines:43]Actual_Labor:22:=[Job_Forms_Machines:43]Actual_Labor:22+Round:C94(([Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7)*[Cost_Centers:27]MHRlaborSales:4; 2)
		[Job_Forms_Machines:43]Actual_SE_Cost:25:=[Job_Forms_Machines:43]Actual_SE_Cost:25+Round:C94(([Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7)*[Cost_Centers:27]ScrapExcessCost:32; 2)
		[Job_Forms_Machines:43]Actual_Qty:19:=[Job_Forms_Machines:43]Actual_Qty:19+[Job_Forms_Machine_Tickets:61]Good_Units:8
		[Job_Forms_Machines:43]Actual_Waste:20:=[Job_Forms_Machines:43]Actual_Waste:20+[Job_Forms_Machine_Tickets:61]Waste_Units:9
		[Job_Forms_Machines:43]Actual_MR_Hrs:24:=[Job_Forms_Machines:43]Actual_MR_Hrs:24+[Job_Forms_Machine_Tickets:61]MR_Act:6
		[Job_Forms_Machines:43]Actual_RunHrs:40:=[Job_Forms_Machines:43]Actual_RunHrs:40+[Job_Forms_Machine_Tickets:61]Run_Act:7
		[Job_Forms_Machines:43]Actual_RunRate:39:=Round:C94(([Job_Forms_Machines:43]Actual_Qty:19+[Job_Forms_Machines:43]Actual_Waste:20)/[Job_Forms_Machines:43]Actual_RunHrs:40; 0)
		SAVE RECORD:C53([Job_Forms_Machines:43])
	End if 
End if 

USE NAMED SELECTION:C332("whileLooking")  // • mel (6/29/05, 14:29:11) try to stop unnecessary !ccc records