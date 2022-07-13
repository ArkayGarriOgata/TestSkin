//%attributes = {"publishedWeb":true}
//Quantity Estimate
//HP calls this the "Work Order"


//THIS JUST DOESN"T WORK
//• 4/15/97 cs try to get fFillPage to print without extra page

C_LONGINT:C283($numUp)  //uRptEstimateQty
If (Records in selection:C76([Estimates:17])=1)
	util_PAGE_SETUP(->[Estimates:17]; "Est.H1")
	PRINT SETTINGS:C106
	C_LONGINT:C283($numCases; $i; $j)  //select one estimate before calling this proc
	maxPixels:=552  // figure on landscape
	iPage:=1
	pixels:=0
	//----------------------- SET UP MAIN HEADER -----------
	t1:="Estimate Number: "+[Estimates:17]EstimateNo:1
	t2:="Quantity Estimate"
	t3:=String:C10(Current date:C33; 2)+" "+String:C10(Current time:C178; 2)
	t3a:="Last Update on "+String:C10([Estimates:17]ModDate:37; 1)+" by "+[Estimates:17]ModWho:38
	Print form:C5([Estimates:17]; "Est.H1")
	pixels:=pixels+30
	//----------------------- SET UP ESTIMATE HEADER -----------
	RELATE ONE:C42([Estimates:17]Cust_ID:2)
	RELATE MANY:C262([Estimates:17]EstimateNo:1)
	CREATE SET:C116([Estimates_Carton_Specs:19]; "theCartons")
	CREATE SET:C116([Estimates_Differentials:38]; "theScenarios")
	$numCases:=Records in selection:C76([Estimates_Differentials:38])
	$summary:=fEstOverview($numCases)
	t4:="Customer:"+Char:C90(13)+"Line:"+Char:C90(13)+"Sales Rep:"+Char:C90(13)+"Estimator:"
	t5:=[Customers:16]Name:2+Char:C90(13)+[Estimates:17]Brand:3+Char:C90(13)+[Estimates:17]Sales_Rep:13+Char:C90(13)+[Estimates:17]EstimatedBy:14
	t6:=$summary
	Print form:C5([Estimates:17]; "Est.H2")
	pixels:=pixels+60
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		ORDER BY:C49([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1; >)
		FIRST RECORD:C50([Estimates_Differentials:38])
		
		
	Else 
		
		ORDER BY:C49([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1; >)
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	$lastCase:=[Estimates_Differentials:38]diffNum:3  //last case; compare to t7
	t7:=$lastCase
	$lastForm:=""  //last form; compare to t8
	For ($i; 1; $numCases)  //step through the case scenario file
		If ([Estimates_Differentials:38]diffNum:3#$lastCase)  //----------------------- PRINT CASE TOTALS -----------  
			pixels:=fFillPage(maxPixels; pixels; 1)  //• 4/15/97 cs added 3rd parameter
			iPage:=iPage+1
			Print form:C5([Estimates:17]; "Est.H1")
			pixels:=pixels+30
			$lastCase:=[Estimates_Differentials:38]diffNum:3
			t7:=$lastCase
		End if 
		t8:=String:C10([Estimates_Differentials:38]NumForms:4)
		//----------------------- SET UP THE ITEM LIST -----------    
		USE SET:C118("theCartons")  //get the cartons for this form on this case
		
		QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11=t7; *)
		QUERY SELECTION:C341([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]CartonSpecKey:7=t8)
		
		$numCartons:=Records in selection:C76([Estimates_Carton_Specs:19])
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)
			FIRST RECORD:C50([Estimates_Carton_Specs:19])
			
		Else 
			
			ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
		RELATE ONE:C42([Estimates_Carton_Specs:19]ProcessSpec:3)  //for use later
		t20:="Sheet Size: "  //+String([PROCESS_SPEC]_fut;"##0.00")+" x "+String([PROCESS_SPEC]_fut;"##0.00")+"
		t20:=t20+"      Net Sheets: "+String:C10([Estimates_Differentials:38]netSheets:6; "###,###,##0")+"         Gross Sheets: "+String:C10([Estimates_Differentials:38]grossSheets:7; "###,###,##0")
		//----------------------- SET UP ITEM HEADER -----------
		Print form:C5([Estimates:17]; "Est.H3")
		pixels:=pixels+40
		i1:=0  //form counters
		i2:=0
		i3:=0
		i4:=0
		For ($j; 1; $numCartons)
			t10:=[Estimates_Carton_Specs:19]Item:1
			t11:=[Estimates_Carton_Specs:19]ProductCode:5
			RELATE ONE:C42([Estimates_Carton_Specs:19]ProductCode:5)
			t12:=[Finished_Goods:26]CartonDesc:3
			t13:=String:C10([Finished_Goods:26]Width_Dec:10; "#,##0.0###")+" x "+String:C10([Finished_Goods:26]Depth_Dec:11; "#,##0.0###")+" x "+String:C10([Finished_Goods:26]Height_Dec:12; "#,##0.0###")
			t14:=String:C10([Finished_Goods:26]SquareInch:6)
			t15:=[Finished_Goods:26]OutLine_Num:4
			RELATE MANY:C262([Estimates_Carton_Specs:19]CartonSpecKey:7)
			$numUp:=Sum:C1([Estimates_FormCartons:48]NumberUp:4)
			//$makesQty:=Sum([FormCartons]MakesQty)
			t16:=String:C10($numUp)
			t17:=String:C10([Estimates_Carton_Specs:19]Quantity_Want:27; "###,###,##0")
			t18:=String:C10([Estimates_Carton_Specs:19]Quantity_Yield:29; "###,###,##0")
			Print form:C5([Estimates:17]; "Est.D1")
			i1:=i1+$numUp
			i2:=i2+[Estimates_Carton_Specs:19]Quantity_Want:27
			i3:=i3+[Estimates_Carton_Specs:19]Quantity_Yield:29
			pixels:=pixels+15
			uChk4Room(47; 60; "Est.H1"; "Est.H3")
			NEXT RECORD:C51([Estimates_Carton_Specs:19])
		End for 
		i4:=((i3-i2)/i2)*100  //percent Excess on form    
		Print form:C5([Estimates:17]; "Est.T1")
		pixels:=pixels+17
		Print form:C5([Estimates:17]; "Est.C1")  //t20 defined above
		pixels:=pixels+15
		Print form:C5([zz_control:1]; "BlankPix8")  //blank line
		pixels:=pixels+8
		uChk4Room(50; 30; "Est.H1")
		//----------------------- SET UP qty COST CENTER HEADER -----------
		Print form:C5([Estimates:17]; "Est.H4b")
		pixels:=pixels+30
		RELATE MANY:C262([Estimates_Differentials:38]Id:1)
		$numBOMs:=Records in selection:C76([Estimates_Machines:20])
		ORDER BY:C49([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5; >)
		$firstMatl:=True:C214
		For ($j; 1; $numBOMs)
			// If ([Machine_Est]Effectivity="Conversion")
			t10:=String:C10([Estimates_Machines:20]Sequence:5; "000")
			t11:=[Estimates_Machines:20]CostCtrID:4
			RELATE ONE:C42([Estimates_Machines:20]CostCtrID:4)
			// t12:=[COST_CENTER]EffectivityDate
			t13:=String:C10([Estimates_Machines:20]MakeReadyHrs:30; "##0.00")
			t14:=String:C10([Estimates_Machines:20]RunningRate:31)
			t15:=String:C10([Estimates_Machines:20]RunningHrs:32; "##0.00")
			t16:=String:C10([Estimates_Machines:20]Qty_Net:24; "###,###,##0")
			t17:=String:C10([Estimates_Machines:20]Qty_Waste:23; "###,###,##0")
			t18:=String:C10([Estimates_Machines:20]Qty_Gross:22; "###,###,##0")
			Print form:C5([Estimates:17]; "Est.D2")
			pixels:=pixels+20
			uChk4Room(20; 60; "Est.H1"; "Est.H4b")
			// Else 
			//----------------------- SET UP MATERIAL HEADER -----------        
			If ($firstMatl)
				$firstMatl:=False:C215
				uChk4Room(80; 30; "Est.H1")
				Print form:C5([Estimates:17]; "Est.H5b")
				pixels:=pixels+30
				rMatl:=0
			End if 
			t10:=String:C10([Estimates_Machines:20]Sequence:5; "000")
			t11:=[Estimates_Machines:20]SequenceID:3
			// t12:=String([Machine_Est]Quantity_Yield;"###,###,##0.00")+[Machine_Est]Overhead
			t13:=[Estimates_Machines:20]Comment:29
			Print form:C5([Estimates:17]; "Est.D3")
			pixels:=pixels+20
			uChk4Room(20; 60; "Est.H1"; "Est.H5b")
			// End if 
			NEXT RECORD:C51([Estimates_Machines:20])
		End for 
		If ($numBOMs=0)
			Print form:C5([zz_control:1]; "BlankPix8")  //blank line      
			Print form:C5([Estimates:17]; "Est.H5b")
			Print form:C5([zz_control:1]; "BlankPix8")  //blank line
			pixels:=pixels+36
		End if 
		NEXT RECORD:C51([Estimates_Differentials:38])
	End for 
	//----------------------- PRINT LAST SET OF TOTALS -----------  
	PAGE BREAK:C6
Else 
	BEEP:C151
	ALERT:C41("Must select '1' Estimate to run this report.")
End if 
//