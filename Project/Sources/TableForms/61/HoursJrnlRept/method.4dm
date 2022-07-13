//(LOP) [MACH_ACT_JOB];"HoursJrnlRept"
//•092895  MLB  UPR none
Case of 
	: (Form event code:C388=On Header:K2:17)
		If (Before selection:C198)
			rPrepHrsGT:=0
			rProdHrsGT:=0
			rRDHrsGT:=0
			rTotHrsGT:=0
			rPrepDLGT:=0
			rPrepOHGT:=0
			rProdDLGT:=0
			rProdOHGT:=0
			rRDDLGT:=0
			rRDOHGT:=0
			rTotDLGT:=0
			rTotOHGT:=0
			rPrepHrs:=0
			rProdHrs:=0
			rRDHrs:=0
			rTotHrs:=0
			rPrepHrs1:=0
			rProdHrs1:=0
			rRDHrs1:=0
			rTotHrs1:=0
			rPrepHrs2:=0
			rProdHrs2:=0
			rRDHrs2:=0
			rTotHrs2:=0
			rPrepHrs3:=0
			rProdHrs3:=0
			rRDHrs3:=0
			rTotHrs3:=0
			rPrepHrs4:=0
			rProdHrs4:=0
			rRDHrs4:=0
			rTotHrs4:=0
			rPrepHrs5:=0
			rProdHrs5:=0
			rRDHrs5:=0
			rTotHrs5:=0
			rPrepHrsCnt:=0
			rProdHrsCnt:=0
			rRDHrsCnt:=0
			rTotHrsCnt:=0
			dPrevDate:=!00-00-00!
			aPrevCC:=""
			dDate:=[Job_Forms_Machine_Tickets:61]DateEntered:5
			rSundayCt:=1
			fCnt:=False:C215
		End if 
	: (Form event code:C388=On Display Detail:K2:22)
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_Forms_Machine_Tickets:61]JobForm:1)
		If (fCnt=True:C214)
			rPrepHrsCnt:=0
			rProdHrsCnt:=0
			rRDHrsCnt:=0
			rTotHrsCnt:=0
			rPrepHrs1:=0
			rProdHrs1:=0
			rRDHrs1:=0
			rTotHrs1:=0
			rPrepHrs2:=0
			rProdHrs2:=0
			rRDHrs2:=0
			rTotHrs2:=0
			rPrepHrs3:=0
			rProdHrs3:=0
			rRDHrs3:=0
			rTotHrs3:=0
			rPrepHrs4:=0
			rProdHrs4:=0
			rRDHrs4:=0
			rTotHrs4:=0
			rPrepHrs5:=0
			rProdHrs5:=0
			rRDHrs5:=0
			rTotHrs5:=0
			rPrepHrs:=0
			rProdHrs:=0
			rRDHrs:=0
			rTotHrs:=0
			fCnt:=False:C215
		End if 
		
		If (Day number:C114([Job_Forms_Machine_Tickets:61]DateEntered:5)=2)
			rPrepHrsCnt:=0
			rProdHrsCnt:=0
			rRDHrsCnt:=0
			rTotHrsCnt:=0
			//rSundayCt:=rSundayCt+1
		End if 
		Case of 
			: (Substring:C12([Job_Forms:42]JobType:33; 1; 1)="2")
				rPrepHrs:=rPrepHrs+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
				rPrepHrsCnt:=rPrepHrsCnt+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
				rTotHrs:=rTotHrs+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
			: (Substring:C12([Job_Forms:42]JobType:33; 1; 1)="3") | (Substring:C12([Job_Forms:42]JobType:33; 1; 1)="4")
				rProdHrs:=rProdHrs+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
				rProdHrsCnt:=rProdHrsCnt+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
				rTotHrs:=rTotHrs+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
			: (Substring:C12([Job_Forms:42]JobType:33; 1; 1)="6")
				rRDHrs:=rRDHrs+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
				rRDHrsCnt:=rRDHrsCnt+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
				rTotHrs:=rTotHrs+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
			Else 
				rProdHrs:=rProdHrs+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
				rProdHrsCnt:=rProdHrsCnt+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
				rTotHrs:=rTotHrs+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
		End case 
		rTotHrsCnt:=rTotHrsCnt+[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
	: (In break:C113)
		Case of 
			: (Level:C101=0)
				rPrepHrs:=Subtotal:C97(rPrepHrs)
				rProdHrs:=Subtotal:C97(rProdHrs)
				rRDHrs:=Subtotal:C97(rRDHrs)
				rTotHrs:=Subtotal:C97(rTotHrs)
				rDLDol:=Subtotal:C97(rDLDol)
				rOHDol:=Subtotal:C97(rOHDol)
				rPrepDL:=Subtotal:C97(rPrepDL)
				rPrepOH:=Subtotal:C97(rPrepOH)
				rProdDL:=Subtotal:C97(rProdDL)
				rProdOH:=Subtotal:C97(rProdOH)
				rRDDL:=Subtotal:C97(rRDDL)
				rRDOH:=Subtotal:C97(rRDOH)
				rTotDL:=Subtotal:C97(rTotDL)
				rTotOH:=Subtotal:C97(rTotOH)
			: (Level:C101=1)
				aMach:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
				gFindCC([Job_Forms_Machine_Tickets:61]CostCenterID:2)  //•092895  MLB  UPR none
				aMachDesc:=zzDESC
				//SEARCH([COST_CENTER];[COST_CENTER]ID=aMach)`°092895  MLB  UPR §
				rDLDol:=[Cost_Centers:27]MHRlaborSales:4
				rOHDol:=[Cost_Centers:27]MHRburdenSales:5
				rPrepDL:=Round:C94(rDLDol*rPrepHrs; 0)
				rPrepOH:=Round:C94(rOHDol*rPrepHrs; 0)
				rProdDL:=Round:C94(rDLDol*rProdHrs; 0)
				rProdOH:=Round:C94(rOHDol*rProdHrs; 0)
				rRDDL:=Round:C94(rDLDol*rRDHrs; 0)
				rRDOH:=Round:C94(rOHDol*rRDHrs; 0)
				rTotDL:=Round:C94(rDLDol*rTotHrs; 0)
				rTotOH:=Round:C94(rOHDol*rTotHrs; 0)
				dDate:=dDate+1
				rPrepHrsCnt:=0
				rProdHrsCnt:=0
				rRDHrsCnt:=0
				rTotHrsCnt:=0
				fCnt:=True:C214
				rSundayCnt:=1
				rPrepHrsGT:=rPrepHrsGT+rPrepHrs
				rProdHrsGT:=rProdHrsGT+rProdHrs
				rRDHrsGT:=rRDHrsGT+rRDHrs
				rTotHrsGT:=rTotHrsGT+rTotHrs
				rPrepDLGT:=rPrepDLGT+rPrepDL
				rPrepOHGT:=rPrepOHGT+rPrepOH
				rProdDLGT:=rProdDLGT+rProdDL
				rProdOHGT:=rProdOHGT+rProdOH
				rRDDLGT:=rRDDLGT+rRDDL
				rRDOHGT:=rRDOHGT+rRDOH
				rTotDLGT:=rTotDLGT+rTotDL
				rTotOHGT:=rTotOHGT+rTotOH
			: (Level:C101=2)
				aMach:=[Cost_Centers:27]ID:1
				//gFindCC( [MachineTicket]CostCenterID )
				//aMachDesc:=zzDESC
				aJobType:=[Job_Forms:42]JobType:33
		End case 
End case 
//EOLP