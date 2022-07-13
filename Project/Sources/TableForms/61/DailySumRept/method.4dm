//(LOP) [MACH_ACT_JOB];"DailySumRept"
Case of 
	: (Form event code:C388=On Header:K2:17)
		dDate:=[Job_Forms_Machine_Tickets:61]DateEntered:5
		If (Before selection:C198)
			rMRHrs:=0
			rRunHrs:=0
			rSubTotHrs:=0
			rDownHrs:=0
			rTotHrs:=0
			dPrevDate:=!00-00-00!
			aPrevCC:=""
			dDate:=[Job_Forms_Machine_Tickets:61]DateEntered:5
		End if 
	: (Form event code:C388=On Display Detail:K2:22)
		rMRHrs:=[Job_Forms_Machine_Tickets:61]MR_Act:6
		rRunHrs:=[Job_Forms_Machine_Tickets:61]Run_Act:7
		rSubTotHrs:=[Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7
		If (([Job_Forms_Machine_Tickets:61]DateEntered:5=dPrevDate) & ([Job_Forms_Machine_Tickets:61]CostCenterID:2=aPrevCC))
			rDownHrs:=0
		Else 
			//gSumDownHrs  `rDownHrs
			dPrevDate:=[Job_Forms_Machine_Tickets:61]DateEntered:5
			aPrevCC:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
		End if 
		rDownHrs:=[Job_Forms_Machine_Tickets:61]DownHrs:11
		rTotHrs:=rSubTotHrs+rDownHrs
	: (Form event code:C388=On Printing Break:K2:19)
		Case of 
			: (Level:C101=1)
				rMRHrs:=Subtotal:C97(rMRHrs)
				rRunHrs:=Subtotal:C97(rRunHrs)
				rSubTotHrs:=Subtotal:C97(rSubTotHrs)
				rDownHrs:=Subtotal:C97(rDownHrs)
				rTotHrs:=Subtotal:C97(rTotHrs)
				dDate:=dDate+1
			: (Level:C101=2)
				aMach:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
				gFindCC([Job_Forms_Machine_Tickets:61]CostCenterID:2)
				aMachDesc:=zzDESC
				rMRHrs:=Subtotal:C97(rMRHrs)
				rRunHrs:=Subtotal:C97(rRunHrs)
				rSubTotHrs:=Subtotal:C97(rSubTotHrs)
				rDownHrs:=Subtotal:C97(rDownHrs)
				rTotHrs:=Subtotal:C97(rTotHrs)
		End case 
End case 
//EOLP