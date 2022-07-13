//(LOP) [MACH_ACT_JOB];"VarAnalSumRept"
Case of 
	: (Form event code:C388=On Header:K2:17)
		If (Before selection:C198)
			rBud_Hrs:=0
			rAct_Hrs:=0
			rStd_Hrs:=0
			rVol_Hrs:=0
			rFix_MHR:=0
			rVar:=0
			rStd_Act:=0
			rOOP_MHR:=0
			rEVar:=0
			rDL_MHR:=0
			rSVar:=0
			rVar_MHR:=0
			rVVar:=0
			rFull_MHR:=0
			rConvVar:=0
			//----------------
			rtBud_Hrs:=0
			rtAct_Hrs:=0
			rtStd_Hrs:=0
			rtVar:=0
			rtEVar:=0
			rtSVar:=0
			rtVVar:=0
			rtConvVar:=0
			//----------------
			rvVar:=0
			rvEVar:=0
			rvSVar:=0
			rvVVar:=0
			rvFixed:=0
			rvConvVar:=0
			rCBud_Hrs:=0
			rCFix_MHR:=0
			rCOOP_MHR:=0
			rCDL_MHR:=0
			rCVar_MHR:=0
			rCFull_MHR:=0
			rCVar:=0
			rCEVar:=0
			rCSVar:=0
			rCVVar:=0
			rCConvVar:=0
		End if 
	: (Form event code:C388=On Display Detail:K2:22)
		rAct_Hrs:=Round:C94([Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7; 1)
		rStd_Hrs:=Round:C94([Job_Forms_Machine_Tickets:61]MR_AdjStd:14+[Job_Forms_Machine_Tickets:61]Run_AdjStd:15; 1)
		//----------------    
	: (Form event code:C388=On Printing Break:K2:19)
		Case of 
			: (Level:C101=0)
				rvVar:=rtVar
				rvEVar:=rtEVar
				rvSVar:=rtSVar-raSVar
				rvVVar:=rtVVar-raVVar
				rvFixed:=rtFixed-raFixed
				rvConvVar:=rtConvVar-raConvVar
			: (Level:C101=1)
				If ([Cost_Centers:27]cc_Group:2#"")
					aSubTitle:="Total for Group "+[Cost_Centers:27]cc_Group:2
					rBud_Hrs:=rCBud_Hrs
					rFix_MHR:=rCFix_MHR
					rOOP_MHR:=rCOOP_MHR
					rDL_MHR:=rCDL_MHR
					rVar_MHR:=rCVar_MHR
					rFull_MHR:=rCFull_MHR
					rAct_Hrs:=Subtotal:C97(rAct_Hrs)
					rStd_Hrs:=Subtotal:C97(rStd_Hrs)
					rVol_Hrs:=rStd_Hrs-rBud_Hrs
					rVar:=rCVar
					rStd_Act:=rStd_Hrs-rAct_Hrs
					rEVar:=rCEVar
					rSVar:=rCSVar
					rVVar:=rCVVar
					rConvVar:=rCConvVar
					//--------------------------------- 
					//------------------------
				Else 
					aSubTitle:=""
					rBud_Hrs:=0
					rAct_Hrs:=0
					rStd_Hrs:=0
					rVol_Hrs:=0
					rFix_MHR:=0
					rVar:=0
					rStd_Act:=0
					rOOP_MHR:=0
					rEVar:=0
					rDL_MHR:=0
					rSVar:=0
					rVar_MHR:=0
					rVVar:=0
					rFull_MHR:=0
					rConvVar:=0
				End if 
				rCBud_Hrs:=0
				rCFix_MHR:=0
				rCOOP_MHR:=0
				rCDL_MHR:=0
				rCVar_MHR:=0
				rCFull_MHR:=0
				rCVar:=0
				rCEVar:=0
				rCSVar:=0
				rCVVar:=0
				rCConvVar:=0
			: (Level:C101=2)
				QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=[Job_Forms_Machine_Tickets:61]CostCenterID:2)
				aMach:=[Job_Forms_Machine_Tickets:61]CostCenterID:2
				aMachDesc:=[Cost_Centers:27]Description:3
				rBud_Hrs:=Round:C94([Cost_Centers:27]PreventMaintHrs:12*rDate; 1)
				rCBud_Hrs:=rCBud_Hrs+rBud_Hrs
				rFix_MHR:=[Cost_Centers:27]FixedOHRate:8
				rCFix_MHR:=rCFix_MHR+[Cost_Centers:27]FixedOHRate:8
				rOOP_MHR:=[Cost_Centers:27]MHRoopSales:7
				rCOOP_MHR:=rCOOP_MHR+[Cost_Centers:27]MHRoopSales:7
				rDL_MHR:=[Cost_Centers:27]MHRlaborSales:4
				rCDL_MHR:=rCDL_MHR+[Cost_Centers:27]MHRlaborSales:4
				rVar_MHR:=[Cost_Centers:27]MHRburdenSales:5
				rCVar_MHR:=rCVar_MHR+[Cost_Centers:27]MHRburdenSales:5
				rFull_MHR:=[Cost_Centers:27]FullAbsorptionRate:9
				rCFull_MHR:=rCFull_MHR+[Cost_Centers:27]FullAbsorptionRate:9
				rAct_Hrs:=Round:C94(Subtotal:C97(rAct_Hrs); 1)
				rStd_Hrs:=Round:C94(Subtotal:C97(rStd_Hrs); 1)
				rVol_Hrs:=rStd_Hrs-rBud_Hrs
				rVar:=Round:C94(rVol_Hrs*rFix_MHR; 0)
				rStd_Act:=rStd_Hrs-rAct_Hrs
				rEVar:=Round:C94(rStd_Act*rOOP_MHR; 0)
				rSVar:=Round:C94(rAct_Hrs*rDL_MHR; 0)
				rVVar:=Round:C94(rAct_Hrs*rVar_MHR; 0)
				rConvVar:=Round:C94(rStd_Hrs*rFull_MHR; 0)
				//-------------------
				rCVar:=rCVar+rVar
				rCEVar:=rCEVar+rEVar
				rCSVar:=rCSVar+rSVar
				rCVVar:=rCVVar+rVVar
				rCConvVar:=rCConvVar+rConvVar
				//---------------------------------
				rtBud_Hrs:=rtBud_Hrs+rBud_Hrs
				rtAct_Hrs:=rtAct_Hrs+rAct_Hrs
				rtStd_Hrs:=rtStd_Hrs+rStd_Hrs
				rtVar:=rtVar+rVar
				rtEVar:=rtEVar+rEVar
				rtSVar:=rtSVar+rSVar
				rtVVar:=rtVVar+rVVar
				rtConvVar:=rtConvVar+rConvVar
				//------------------------
		End case 
End case 
//EOLP