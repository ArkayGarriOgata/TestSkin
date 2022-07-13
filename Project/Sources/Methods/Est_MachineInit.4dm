//%attributes = {"publishedWeb":true}
//PM:  Est_MachineInitty|cost|hrs)  091099  mlb
//set fields to zero

Case of 
	: ($1="qty")
		[Estimates_Machines:20]Qty_Gross:22:=0
		[Estimates_Machines:20]Qty_Waste:23:=0
		[Estimates_Machines:20]Qty_Net:24:=0
		
	: ($1="cost")
		[Estimates_Machines:20]CostLabor:13:=0
		[Estimates_Machines:20]CostOverhead:15:=0
		[Estimates_Machines:20]CostOOP:28:=0
		[Estimates_Machines:20]CostOvertime:41:=0
		[Estimates_Machines:20]CostScrap:12:=0
		[Estimates_Machines:20]OOP_YldAddition:45:=0
		[Estimates_Machines:20]Hrs_YldAddition:44:=0
		[Estimates_Machines:20]LaborStd:7:=0  //•071296  MLB  
		[Estimates_Machines:20]OverheadStd:8:=0  //•071296  MLB  
		[Estimates_Machines:20]OOPStd:17:=0  //•071296  MLB 
		
	: ($1="hrs")
		[Estimates_Machines:20]RunningHrs:32:=0
		[Estimates_Machines:20]MakeReadyHrs:30:=0
		
End case 