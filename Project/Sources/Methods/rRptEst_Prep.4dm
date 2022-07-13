//%attributes = {"publishedWeb":true}
//rRptEst_Prep()     -JML     9/7/93
//Preparatory Estimate

//This is called Budgdet Report on the HP mainframe.

If (Records in selection:C76([Estimates:17])=1)
	util_PAGE_SETUP(->[Estimates:17]; "Est.H1")
	PRINT SETTINGS:C106
	C_LONGINT:C283($j)
	maxPixels:=552  // figure on landscape
	iPage:=1
	pixels:=0
	
	//----------------------- SET UP MAIN HEADER -----------
	t1:="Estimate Number: "+[Estimates:17]EstimateNo:1
	t2:="Preparatory Estimate"
	t3:=String:C10(4D_Current_date; 2)+" "+String:C10(Current time:C178; 2)
	t3a:="Last Update on "+String:C10([Estimates:17]ModDate:37; 1)+" by "+[Estimates:17]ModWho:38
	Print form:C5([Estimates:17]; "Est.H1")
	pixels:=pixels+30
	
	//----------------------- SET UP ESTIMATE HEADER -----------
	RELATE ONE:C42([Estimates:17]Cust_ID:2)
	t4:="Customer:"+Char:C90(13)+"Line:"
	t5:=[Customers:16]Name:2+Char:C90(13)+[Estimates:17]Brand:3
	t7:="Sales Rep:"+Char:C90(13)+"Estimator:"
	t6:=[Estimates:17]Sales_Rep:13+Char:C90(13)+[Estimates:17]EstimatedBy:14
	Print form:C5([Estimates:17]; "Est.PrepH2")
	pixels:=pixels+30
	Print form:C5([zz_control:1]; "BlankPix8")  //blank line
	pixels:=pixels+8
	
	//----------------------- Preparatory, Special Information -----------
	Print form:C5([Estimates:17]; "Est.PrepHH2")  //pixels is updated in layout script
	pixels:=pixels+14
	
	PrepEstimateLd("Machines"; "Materials"; "Specifications")
	
	//rRptEst_PrepHdr
	Print form:C5([zz_control:1]; "BlankPix8")  //blank line
	pixels:=pixels+8
	
	
	//----------------------- SET UP COST CENTER HEADER -----------
	uEstRptInitAccm
	ORDER BY:C49([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5; >)
	//PRINT LAYOUT([ESTIMATE];"Est.PrepH4")  `this header needs to show [caseform]form
	Print form:C5([Estimates:17]; "Est.H4")  //this header needs to show [caseform]formnumber
	pixels:=pixels+30
	
	$numBOMs:=Records in selection:C76([Estimates_Machines:20])
	For ($j; 1; $numBOMs)
		t10:=String:C10([Estimates_Machines:20]Sequence:5; "000")
		t11:=[Estimates_Machines:20]CostCtrID:4
		RELATE ONE:C42([Estimates_Machines:20]CostCtrID:4)
		t12:=[Cost_Centers:27]Description:3
		t13:=String:C10([Estimates_Machines:20]MakeReadyHrs:30; "##0.00")
		t14:=String:C10([Estimates_Machines:20]RunningRate:31)
		t15:=String:C10([Estimates_Machines:20]RunningHrs:32; "##0.00")
		
		t16:=String:C10([Estimates_Machines:20]CostLabor:13; "###,###,##0")
		t17:=String:C10([Estimates_Machines:20]CostOverhead:15; "###,###,##0")
		rLabor:=rLabor+[Estimates_Machines:20]CostLabor:13
		rOH:=rOH+[Estimates_Machines:20]CostOverhead:15
		t18:=String:C10(([Estimates_Machines:20]CostLabor:13+[Estimates_Machines:20]CostOverhead:15); "###,###,##0")
		t16a:=""
		t17a:=""
		t18a:=""
		
		Print form:C5([Estimates:17]; "Est.D2")
		pixels:=pixels+20
		uChk4Room(20; 60; "Est.H1"; "Est.H4")
		NEXT RECORD:C51([Estimates_Machines:20])
	End for 
	Print form:C5([zz_control:1]; "BlankPix8")  //blank line
	pixels:=pixels+8
	
	
	//----------------------- SET UP MATERIAL HEADER -----------        
	$numBOMs:=Records in selection:C76([Estimates_Materials:29])
	$j:=($numBOMs*20)+30  //how much room needed for all materials?
	If ($j>maxPixels)  //too many materials for one page
		$j:=20+30  //so we will just worry about it line by line.
	End if 
	
	uChk4Room($j; 30; "Est.H1")  //pixels needed, # of pixels in header layout, header layout #1, header#2
	Print form:C5([Estimates:17]; "Est.H5")
	pixels:=pixels+30
	rMatl:=0
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($j; 1; $numBOMs)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=[Estimates_Materials:29]Commodity_Key:6)
				FIRST RECORD:C50([Raw_Materials_Groups:22])
				
				
			Else 
				
				QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=[Estimates_Materials:29]Commodity_Key:6)
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			t10:=[Estimates_Materials:29]CostCtrID:2  //machine material is used upon
			t11:=[Estimates_Materials:29]Commodity_Key:6+":  "+[Raw_Materials_Groups:22]Description:2
			t12:=String:C10([Estimates_Materials:29]Cost:11; "$###,###,##0.00")
			rMatl:=rMatl+[Estimates_Materials:29]Cost:11
			t13:=[Estimates_Machines:20]Comment:29
			t14:=String:C10([Estimates_Materials:29]Qty:9)
			t15:=[Estimates_Materials:29]UOM:8
			Print form:C5([Estimates:17]; "Est.D3")
			pixels:=pixels+20
			NEXT RECORD:C51([Estimates_Materials:29])
		End for 
		
		
	Else 
		
		GET FIELD RELATION:C920([Estimates_Materials:29]Commodity_Key:6; $lienAller; $lienRetour)
		SET FIELD RELATION:C919([Estimates_Materials:29]Commodity_Key:6; Automatic:K51:4; Do not modify:K51:1)
		
		SELECTION TO ARRAY:C260([Estimates_Materials:29]CostCtrID:2; $_CostCtrID; \
			[Estimates_Materials:29]Commodity_Key:6; $_Commodity_Key; \
			[Estimates_Materials:29]Cost:11; $_Cost; \
			[Estimates_Machines:20]Comment:29; $_Comment; \
			[Estimates_Materials:29]Qty:9; $_Qty; \
			[Estimates_Materials:29]UOM:8; $_UOM; \
			[Raw_Materials_Groups:22]Commodity_Key:3; $_Commodity_Key1; \
			[Raw_Materials_Groups:22]Description:2; $_Description)
		
		SET FIELD RELATION:C919([Estimates_Materials:29]Commodity_Key:6; $lienAller; $lienRetour)
		
		For ($j; 1; Size of array:C274($_CostCtrID); 1)
			
			t10:=$_CostCtrID{$j}
			t11:=$_Commodity_Key{$j}+":  "+$_Description{$j}
			t12:=String:C10($_Cost{$j}; "$###,###,##0.00")
			rMatl:=rMatl+$_Cost{$j}
			t13:=$_Comment{$j}
			t14:=String:C10($_Qty{$j})
			t15:=$_UOM{$j}
			$h:=Print form:C5([Estimates:17]; "Est.D3")
			pixels:=pixels+20
			
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 
	
	//----------------------- GRAND TOTALS -----------        
	uChk4Room(109; 30; "Est.H1")
	Print form:C5([zz_control:1]; "BlankPix8")  //blank line
	pixels:=pixels+8
	
	t10:=""
	t11:="PREPARATORY TOTALS:"
	t12:=""
	t13:=""
	t14:=""
	t15:=""
	Print form:C5([Estimates:17]; "Est.D3")
	pixels:=pixels+28
	
	t11:=""
	t16:=""
	t17:=""
	t18:=""
	
	
	PrepEstimateLd("Machines")
	
	t12:="Conversion—Labor"
	rLabor:=Sum:C1([Estimates_Machines:20]CostLabor:13)
	t13:=String:C10(rLabor; "$###,###,##0.00")
	Print form:C5([Estimates:17]; "Est.D1")
	pixels:=pixels+15
	
	
	t12:="Conversion—Overhead"
	rOH:=Sum:C1([Estimates_Machines:20]CostOverhead:15)
	t13:=String:C10(rOH; "$###,###,##0.00")
	Print form:C5([Estimates:17]; "Est.D1")
	pixels:=pixels+15
	
	
	t12:="Conversion—Total"
	rSubTotal:=rLabor+rOH
	t13:=String:C10(rSubTotal; "$###,###,##0.00")
	Print form:C5([Estimates:17]; "Est.D1")
	pixels:=pixels+15
	
	Print form:C5([zz_control:1]; "BlankPix4")  //blank line
	pixels:=pixels+4
	
	PrepEstimateLd(""; "Materials")
	t12:="Material—Total"
	rMatl:=Sum:C1([Estimates_Materials:29]Cost:11)
	t13:=String:C10(rMatl; "$###,###,##0.00")
	Print form:C5([Estimates:17]; "Est.D1")
	pixels:=pixels+15
	
	Print form:C5([zz_control:1]; "BlankPix4")  //blank line
	pixels:=pixels+4
	
	t12:="Total Estimate"
	rTotal:=rSubtotal+rMatl
	t13:=String:C10(rTotal; "$###,###,##0.00")
	Print form:C5([Estimates:17]; "Est.D1")
	pixels:=pixels+15
	
	
	
	
	PAGE BREAK:C6
Else 
	BEEP:C151
	ALERT:C41("You can only report on one estimate at a time.")
End if 