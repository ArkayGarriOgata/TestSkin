//%attributes = {"publishedWeb":true}
//PM:  Job_calcAdjRunHrs  2/21/01  mlb
//based on:
//(S) [MachineTicket]MachActInclList'BudRunSpeed
//Calculate Run_AdjStd
//• 4/10/98 cs Nan Checking

If ([Job_Forms_Machine_Tickets:61]BudRunSpeed:13>0)
	If ([Job_Forms_Machine_Tickets:61]Good_Units:8#0)
		If (([Job_Forms_Machine_Tickets:61]CostCenterID:2="428") | ([Job_Forms_Machine_Tickets:61]CostCenterID:2="426") | ([Job_Forms_Machine_Tickets:61]CostCenterID:2="427"))
			[Job_Forms_Machine_Tickets:61]Run_AdjStd:15:=uNANCheck(Round:C94((([Job_Forms_Machine_Tickets:61]Good_Units:8*[Job_Forms:42]Lenth:24)/12)/[Job_Forms_Machine_Tickets:61]BudRunSpeed:13; 2))
		Else 
			[Job_Forms_Machine_Tickets:61]Run_AdjStd:15:=uNANCheck(Round:C94([Job_Forms_Machine_Tickets:61]Good_Units:8/[Job_Forms_Machine_Tickets:61]BudRunSpeed:13; 2))
		End if 
		
	Else 
		[Job_Forms_Machine_Tickets:61]Run_AdjStd:15:=0
	End if 
	
Else 
	[Job_Forms_Machine_Tickets:61]Run_AdjStd:15:=0
End if 