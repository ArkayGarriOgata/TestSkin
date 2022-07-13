//(LOP) [MachineTicket];"ProductionRept"
Case of 
	: (Form event code:C388=On Header:K2:17)
		If (Before selection:C198)
			rDown_Hrs:=0
			rTot_Act:=0
			rTot_Std:=0
			rTot_Adj:=0
			rSGoodUnits:=0
			rSWasteUnit:=0
			rSMR_Act:=0
			rSRun_Act:=0
			rSDown_Act:=0
			rSTot_Act:=0
			rSMR_Std:=0
			rSRun_Std:=0
			rSTot_Std:=0
			rSMR_Adj:=0
			rSRun_Adj:=0
			rSTot_Adj:=0
			dPrevDate:=!00-00-00!
			aPrevCC:=""
		End if 
	: (Form event code:C388=On Display Detail:K2:22)
		sJobNo:=Substring:C12([Job_Forms_Machine_Tickets:61]JobForm:1; 1; 5)
		QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=sJobNo)
		//If (([MachineTicket]DateEntered=dPrevDate) & ([MachineTicket]CostCenterID=aPrevC
		//rDown_Hrs:=0
		//Else 
		//gSumDownHrs   `rDownHrs
		//rDown_Hrs:=rDownHrs
		//dPrevDate:=[MachineTicket]DateEntered
		//aPrevCC:=[MachineTicket]CostCenterID
		//End if 
		rDownHrs:=[Job_Forms_Machine_Tickets:61]DownHrs:11
		rDown_Hrs:=rDownHrs
		rTot_Act:=[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7+rDown_Hrs
		//rTot_Std:= •[MACH_ACT_JOB]MR_Std• + •[MACH_ACT_JOB]Run_Std• 
		rTot_Adj:=[Job_Forms_Machine_Tickets:61]MR_AdjStd:14+[Job_Forms_Machine_Tickets:61]Run_AdjStd:15
	: (IForm event=On Printing Break:K2:19)
		Case of 
			: (Level:C101=0)
				aSubTitle:="Grand Total"
				rSGoodUnits:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Good_Units:8)
				rSWasteUnit:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Waste_Units:9)
				rSMR_Act:=Subtotal:C97([Job_Forms_Machine_Tickets:61]MR_Act:6)
				rSRun_Act:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Run_Act:7)
				rSDown_Act:=Subtotal:C97(rDown_Hrs)
				rSTot_Act:=Subtotal:C97(rTot_Act)
				//rSMR_Std:=Subtotal( •[MACH_ACT_JOB]MR_Std• )
				//rSRun_Std:=Subtotal( •[MACH_ACT_JOB]Run_Std• )
				//rSTot_Std:=Subtotal(rTot_Std)
				rSMR_Adj:=Subtotal:C97([Job_Forms_Machine_Tickets:61]MR_AdjStd:14)
				rSRun_Adj:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Run_AdjStd:15)
				rSTot_Adj:=Subtotal:C97(rTot_Adj)
			: (Level:C101=1)
				aSubTitle:="Total for Cost Center "+[Job_Forms_Machine_Tickets:61]CostCenterID:2
				rSGoodUnits:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Good_Units:8)
				rSWasteUnit:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Waste_Units:9)
				rSMR_Act:=Subtotal:C97([Job_Forms_Machine_Tickets:61]MR_Act:6)
				rSRun_Act:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Run_Act:7)
				rSDown_Act:=Subtotal:C97(rDown_Hrs)
				rSTot_Act:=Subtotal:C97(rTot_Act)
				//rSMR_Std:=Subtotal( •[MACH_ACT_JOB]MR_Std• )
				//rSRun_Std:=Subtotal( •[MACH_ACT_JOB]Run_Std• )
				//rSTot_Std:=Subtotal(rTot_Std)
				rSMR_Adj:=Subtotal:C97([Job_Forms_Machine_Tickets:61]MR_AdjStd:14)
				rSRun_Adj:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Run_AdjStd:15)
				rSTot_Adj:=Subtotal:C97(rTot_Adj)
			: (Level:C101=2)
				If (aHdg="WEEKLY")
					aSubTitle:="Total for "+String:C10([Job_Forms_Machine_Tickets:61]DateEntered:5)
					rSGoodUnits:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Good_Units:8)
					rSWasteUnit:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Waste_Units:9)
					rSMR_Act:=Subtotal:C97([Job_Forms_Machine_Tickets:61]MR_Act:6)
					rSRun_Act:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Run_Act:7)
					rSDown_Act:=Subtotal:C97(rDown_Hrs)
					rSTot_Act:=Subtotal:C97(rTot_Act)
					//rSMR_Std:=Subtotal( •[MACH_ACT_JOB]MR_Std• )
					//rSRun_Std:=Subtotal( •[MACH_ACT_JOB]Run_Std• )
					//rSTot_Std:=Subtotal(rTot_Std)
					rSMR_Adj:=Subtotal:C97([Job_Forms_Machine_Tickets:61]MR_AdjStd:14)
					rSRun_Adj:=Subtotal:C97([Job_Forms_Machine_Tickets:61]Run_AdjStd:15)
					rSTot_Adj:=Subtotal:C97(rTot_Adj)
				Else 
					aSubTitle:=""
					rSGoodUnits:=0
					rSWasteUnit:=0
					rSMR_Act:=0
					rSRun_Act:=0
					rSDown_Act:=0
					rSTot_Act:=0
					rSMR_Std:=0
					rSRun_Std:=0
					rSTot_Std:=0
					rSMR_Adj:=0
					rSRun_Adj:=0
					rSTot_Adj:=0
				End if 
		End case 
End case 
//EOLP