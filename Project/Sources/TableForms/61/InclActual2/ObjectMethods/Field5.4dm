//(S) [MachineTicket].MachActInclList.CostCenterID
//upr 1425 2/9/95
//4/24/95 array in line 28 is not defined here 
//•062695  MLB  UPR 220 add the 487
//•092895  MLB  UPR 1720 add the 488
//•042096 TJF
//• 4/10/98 cs Nan Checking
zzDESC:=""
[Job_Forms_Machine_Tickets:61]JobForm:1:=[Job_Forms:42]JobFormID:5
gFindCC([Job_Forms_Machine_Tickets:61]CostCenterID:2)
aMachDesc:=zzDESC
If (zzDESC="")
	[Job_Forms_Machine_Tickets:61]CostCenterID:2:=""
	ALERT:C41("Invalid Cost Center - Please try again!!!")
	REJECT:C38
Else 
	
	If ([Job_Forms_Machine_Tickets:61]BudRunSpeed:13=0)
		
		sCostCenter:=CostCtr_Substitution([Job_Forms_Machine_Tickets:61]CostCenterID:2)  //•042096 TJF
		Case of 
			: (([Job_Forms_Machine_Tickets:61]CostCenterID:2="451") | ([Job_Forms_Machine_Tickets:61]CostCenterID:2="452") | ([Job_Forms_Machine_Tickets:61]CostCenterID:2="453") | ([Job_Forms_Machine_Tickets:61]CostCenterID:2="454") | ([Job_Forms_Machine_Tickets:61]CostCenterID:2="461") | ([Job_Forms_Machine_Tickets:61]CostCenterID:2="463") | ([Job_Forms_Machine_Tickets:61]CostCenterID:2="465"))
				QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=[Job_Forms_Machine_Tickets:61]JobForm:1; *)
				QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=[Job_Forms_Machine_Tickets:61]Sequence:3)
				If (Records in selection:C76([Job_Forms_Machines:43])>0)
					If ([Job_Forms_Machines:43]CostCenterID:4#[Job_Forms_Machine_Tickets:61]CostCenterID:2)
						If (([Job_Forms_Machine_Tickets:61]CostCenterID:2="451") | ([Job_Forms_Machine_Tickets:61]CostCenterID:2="452") | ([Job_Forms_Machine_Tickets:61]CostCenterID:2="453") | ([Job_Forms_Machine_Tickets:61]CostCenterID:2="454"))
							If (([Job_Forms_Machines:43]CostCenterID:4#"451") & ([Job_Forms_Machines:43]CostCenterID:4#"463"))
								// ******* Verified  - 4D PS - January  2019 ********
								
								QUERY SELECTION:C341([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4="451")
								
								
								// ******* Verified  - 4D PS - January 2019 (end) *********
							End if 
						Else 
							If ([Job_Forms_Machines:43]CostCenterID:4#"463")
								// ******* Verified  - 4D PS - January  2019 ********
								
								QUERY SELECTION:C341([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4="463")
								
								
								// ******* Verified  - 4D PS - January 2019 (end) *********
							End if 
						End if 
					End if 
				End if 
				
			: ([Job_Forms_Machine_Tickets:61]CostCenterID:2="472")
				QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=[Job_Forms_Machine_Tickets:61]JobForm:1; *)
				QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=[Job_Forms_Machine_Tickets:61]Sequence:3)
				If (Records in selection:C76([Job_Forms_Machines:43])>0)
					If (([Job_Forms_Machines:43]CostCenterID:4#"471") & ([Job_Forms_Machines:43]CostCenterID:4#"472"))
						// ******* Verified  - 4D PS - January  2019 ********
						
						QUERY SELECTION:C341([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4="471")
						
						
						// ******* Verified  - 4D PS - January 2019 (end) *********
					End if 
				End if 
				
			Else 
				QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=[Job_Forms_Machine_Tickets:61]JobForm:1; *)
				QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]CostCenterID:4=sCostCenter; *)
				QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=[Job_Forms_Machine_Tickets:61]Sequence:3)
		End case 
		
		If (Records in selection:C76([Job_Forms_Machines:43])=0)
			//gBudRunSpdChk 
		Else 
			//[MachineTicket]BudRunSpeed:=[Machine_Job]RunSpeed
			[Job_Forms_Machine_Tickets:61]BudRunSpeed:13:=[Job_Forms_Machines:43]Planned_RunRate:36
		End if 
		
	Else 
		//gBudRunSpdChk 
	End if 
End if 

//Calculate Run_AdjStd
Job_calcAdjRunHrs
//EOS