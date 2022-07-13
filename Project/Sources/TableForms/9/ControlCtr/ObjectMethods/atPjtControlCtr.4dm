// ----------------------------------------------------
// Method: [Customers_Projects].ControlCtr.atPjtControlCtr
// Description:
// Select a project page
// ----------------------------------------------------

$pjtTitle:="Cust: "+pjtCustid+" "+pjtCustName+", Pjt: "+pjtId+" "+pjtName

If (bLarge)  //Set in ControlCtrLoadTabs
	Case of 
		: (atPjtControlCtr=1)
			zwStatusMsg("PROJECT"; $pjtTitle+" Home")
			FORM GOTO PAGE:C247(ppHome)
			
		: (atPjtControlCtr=2)
			zwStatusMsg("PROJECT"; $pjtTitle+" Request for Construction")
			ControlCtrManageLB("SSFillLB")  // Added by: Mark Zinke (3/22/13)
			iMode:=2
			FORM GOTO PAGE:C247(ppRFC)
			
		: (atPjtControlCtr=3)
			zwStatusMsg("PROJECT"; $pjtTitle+" Color Specification Masters")
			QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]projectId:4=pjtId)
			ORDER BY:C49([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecMaster:128]name:2; >)
			ControlCtrManageLB("Color")  // Added by: Mark Zinke (3/26/13)
			FORM GOTO PAGE:C247(ppColor)
			
		: (atPjtControlCtr=4)
			zwStatusMsg("PROJECT"; $pjtTitle+" Prep Services")
			ControlCtrManageLB("ArtFillLB")  // Added by: Mark Zinke (3/20/13)
			iMode:=2
			FORM GOTO PAGE:C247(ppPrep)
			
		: (atPjtControlCtr=5)
			zwStatusMsg("PROJECT"; $pjtTitle+" Estimates")
			ControlCtrManageLB("EstimatesFillLB")  // Added by: Mark Zinke (3/15/13)
			iMode:=2
			FORM GOTO PAGE:C247(ppEst)
			
		: (atPjtControlCtr=6)
			zwStatusMsg("PROJECT"; $pjtTitle+" Finished Goods")
			READ ONLY:C145([Finished_Goods:26])
			ControlCtrManageLB("F/G")  // Added by: Mark Zinke (3/21/13)
			FORM GOTO PAGE:C247(ppFG)
			
		: (atPjtControlCtr=7)
			zwStatusMsg("PROJECT"; $pjtTitle+" Orders")
			ControlCtrManageLB("OrderFillLB")  // Added by: Mark Zinke (3/21/13)
			iMode:=2
			fLoop:=False:C215
			ARRAY TEXT:C222(aBilltos; 0)
			ARRAY TEXT:C222(aShiptos; 0)
			FORM GOTO PAGE:C247(ppOrd)
			
		: (atPjtControlCtr=8)
			zwStatusMsg("PROJECT"; $pjtTitle+" Job Physical Support Items and Job Transfer Bags")
			READ ONLY:C145([JPSI_Job_Physical_Support_Items:111])
			QUERY:C277([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]PjtNumber:3=pjtId)
			ORDER BY:C49([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]ItemType:2; >; [JPSI_Job_Physical_Support_Items:111]SortDescript:9; >)
			
			READ ONLY:C145([JTB_Job_Transfer_Bags:112])
			QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]PjtNumber:2=pjtId)
			ORDER BY:C49([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]Jobform:3; >)
			ControlCtrManageLB("SuptItem")  // Added by: Mark Zinke (3/25/13)
			FORM GOTO PAGE:C247(ppJPSI)
			
		: (atPjtControlCtr=9)
			zwStatusMsg("PROJECT"; $pjtTitle+" Jobs")
			ControlCtrManageLB("JobFillLB")  // Added by: Mark Zinke (3/21/13)
			iMode:=2
			FORM GOTO PAGE:C247(ppJob)
			
		: (atPjtControlCtr=10)
			zwStatusMsg("PROJECT"; $pjtTitle+" CustomerInfo")
			QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]CustID:1=[Customers:16]ID:1)
			ORDER BY:C49([Customers_Contacts:52]; [Customers_Contacts:52]ContactID:2; >)
			FORM GOTO PAGE:C247(ppCust)
	End case 
	
Else 
	Case of 
		: (atPjtControlCtr=1)
			zwStatusMsg("PROJECT"; $pjtTitle+" Home")
			FORM GOTO PAGE:C247(ppHome)
			
		: (atPjtControlCtr=2)
			zwStatusMsg("PROJECT"; $pjtTitle+" CustomerInfo")
			QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]CustID:1=[Customers:16]ID:1)
			ORDER BY:C49([Customers_Contacts:52]; [Customers_Contacts:52]ContactID:2; >)
			FORM GOTO PAGE:C247(ppCust)
	End case 
	
End if 