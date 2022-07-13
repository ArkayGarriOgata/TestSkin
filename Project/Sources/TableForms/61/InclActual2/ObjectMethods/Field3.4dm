//(S)[MachineTicket]'MachActInclList'Seq:
//• 11/24/97 cs used standard procedure to replace cost center
sCostCenter:=CostCtr_Substitution([Job_Forms_Machine_Tickets:61]CostCenterID:2)  //• 11/24/97 cs replaced below code with this
//Case of 
//: ([MachineTicket]CostCenterID="481") | ([MachineTicket]CostCenterID=
//«"482") | ([MachineTicket]CostCenterID="483") | ([MachineTicket]CostCenterID
//«="484") | ([MachineTicket]CostCenterID="485")
//sCostCenter:="481"
//: ([MachineTicket]CostCenterID="451") | ([MachineTicket]CostCenterID=
//«"452") | ([MachineTicket]CostCenterID="453") | ([MachineTicket]CostCenterID
//«="454")
//sCostCenter:="451"
//: ([MachineTicket]CostCenterID="471") | ([MachineTicket]CostCenterID=
//«"472")
//sCostCenter:="471"
//Else 
//sCostCenter:=[MachineTicket]CostCenterID
//End case 
//• 4/10/98 cs Nan Checking

If (sCostCenter#"")
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
	//Calculate Run_AdjStd
	Job_calcAdjRunHrs
End if 
//EOS