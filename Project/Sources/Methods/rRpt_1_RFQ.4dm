//%attributes = {"publishedWeb":true}
//rRpt_1_RFQ  
//mod 4/14/94
//mod 11/18/94 chip upr 1115
//•051995  MLB  allow this to be printed from the input layout
//•052495 MLB UPR1479
//•081595  MLB  remove text2array2
//•042696  MLB  sort on Description fails with 4Dv1.5.1
C_LONGINT:C283($1)  //•051995  MLB 
C_LONGINT:C283($i; $j; $NumEst; $iEst)
C_TEXT:C284($Case; $LCase)
C_REAL:C285($Totalt8; $Totalt8a; $Totalt11; $Totalt9; $Totalt10; $Totalt13)
If (Count parameters:C259=1)  //•051995  MLB  
	$NumEst:=$1
	COPY NAMED SELECTION:C331([Estimates:17]; "before")  //•052495 MLB UPR1479
Else 
	$NumEst:=Records in selection:C76([Estimates:17])
End if 

util_PAGE_SETUP(->[Estimates:17]; "Est.H1")
PRINT SETTINGS:C106

If (ok=1)
	
	For ($iEst; 1; $NumEst)
		maxPixels:=552  // figure on landscape
		iPage:=1
		pixels:=0
		//* SET UP MAIN HEADER -----------
		t1:="Estimate Number: "+[Estimates:17]EstimateNo:1
		t2:="Request for Quotation"
		If (Substring:C12([Estimates:17]EstimateNo:1; 8; 2)="00")
			t2b:="(Original)"
		Else 
			t2b:="(Revised)"
		End if 
		t3:=String:C10(4D_Current_date; 2)+" "+String:C10(4d_Current_time; 2)
		t3a:="Last Update on "+String:C10([Estimates:17]ModDate:37; 1)+" by "+[Estimates:17]ModWho:38
		Print form:C5([Estimates:17]; "Est.H1")
		pixels:=pixels+30
		//* BUILD ADDRESS -----------
		QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Estimates:17]z_Bill_To_ID:5)
		Text2:=fGetAddressText
		RELATE ONE:C42([Estimates:17]Cust_ID:2)
		Print form:C5([Estimates:17]; "RFQ.H2")
		pixels:=pixels+150
		//* PRINT ESTIMATE COMMENTS -----------  
		ARRAY TEXT:C222(axText; 0)
		uText2Array2([Estimates:17]Comments:34; axText; 600; "Helvetica"; 9; 0)
		For ($i; 1; Size of array:C274(axText))
			If ($i>23)  //start checking for room  
				Text3:="Comments: (continued)"
				uChk4Room(12; 45; "Est.H1"; "RFQ.C1")
			End if 
			Text3:=axText{$i}
			Print form:C5([Estimates:17]; "RFQ.C1")
			pixels:=pixels+12
		End for 
		ARRAY TEXT:C222(axText; 0)
		//*CASE SCENARIO SECTION -----------  
		// sSummarizeCases 
		QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)
		QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=<>sQtyWorksht)
		$Case:=""
		$iQty:=0
		t5a:=""
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11; >; [Estimates_Carton_Specs:19]Item:1; >)
			FIRST RECORD:C50([Estimates_Carton_Specs:19])
			
			
		Else 
			
			ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11; >; [Estimates_Carton_Specs:19]Item:1; >)
			
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		For ($i; 1; Records in selection:C76([Estimates_Carton_Specs:19]))
			$LCase:=[Estimates_Carton_Specs:19]diffNum:11
			If ($LCase#$Case)  //first time for this case, print
				If ($i#1)  //print totals
					uChk4Room(20; 30; "Est.H1")
					total1:="Differential "+t5a+" Total:"
					Totalt8:=String:C10($Totalt8; "###,###,##0;-###,###")
					Totalt8a:=String:C10($Totalt8a; "###,###,##0;-###,###")
					Totalt9:=String:C10($Totalt9; "###,###,##0;-###,###")
					Totalt10:=String:C10($Totalt10; "###,###,##0;-###,###")
					Totalt11:=String:C10($Totalt11; "###,###,##0;-###,###")
					Totalt13:=String:C10($Totalt13; "###,###,##0;-###,###")
					Print form:C5([Estimates:17]; "RFQ.T1")
					$Totalt8:=0
					$Totalt8a:=0
					$Totalt9:=0
					$Totalt10:=0
					$Totalt11:=0
					$Totalt13:=0
					pixels:=pixels+20
				End if 
				uChk4Room(60; 30; "Est.H1")
				t5a:=$LCase
				Print form:C5([Estimates:17]; "RFQ.H3")
				pixels:=pixels+30
				$Case:=$LCase
				$iQty:=0
			End if   //the same one
			//*PRINT CARTON DETAIL -----------  
			t5:=[Estimates_Carton_Specs:19]Item:1
			t6:=[Estimates_Carton_Specs:19]ProductCode:5
			//SEARCH([Finished_Goods];[Finished_Goods]ProductCode=t6;*)
			//SEARCH([Finished_Goods]; & [Finished_Goods]CustID=[ESTIMATE]Cust_ID)
			t7:=[Estimates_Carton_Specs:19]Description:14
			t8:=String:C10([Estimates_Carton_Specs:19]Qty1Temp:52; "###,###,##0;-###,###")
			t8a:=String:C10([Estimates_Carton_Specs:19]Qty2Temp:53; "###,###,##0;-###,###")
			t9:=String:C10([Estimates_Carton_Specs:19]Qty3Temp:54; "###,###,##0;-###,###")
			t10:=String:C10([Estimates_Carton_Specs:19]Qty4Temp:55; "###,###,##0;-###,###")
			t11:=String:C10([Estimates_Carton_Specs:19]Qty5Temp:56; "###,###,##0;-###,###")
			t13:=String:C10([Estimates_Carton_Specs:19]Qty6Temp:57; "###,###,##0;-###,###")
			$iQty:=$iQty+[Estimates_Carton_Specs:19]Quantity_Want:27
			
			//• added for new total line  Upr1115
			$Totalt8:=[Estimates_Carton_Specs:19]Qty1Temp:52+$Totalt8
			$Totalt8a:=[Estimates_Carton_Specs:19]Qty2Temp:53+$Totalt8a
			$Totalt9:=[Estimates_Carton_Specs:19]Qty3Temp:54+$Totalt9
			$Totalt10:=[Estimates_Carton_Specs:19]Qty4Temp:55+$Totalt10
			$Totalt11:=[Estimates_Carton_Specs:19]Qty5Temp:56+$Totalt11
			$Totalt13:=[Estimates_Carton_Specs:19]Qty6Temp:57+$Totalt13
			
			t12:=""
			C_TEXT:C284($dim_A; $dim_B; $dem_ht)
			$success:=FG_getDimensions(->$dim_A; ->$dim_B; ->$dem_ht; [Estimates_Carton_Specs:19]OutLineNumber:15; [Estimates_Carton_Specs:19]ProductCode:5)
			If ($success)
				t12:=$dim_A+" * "+$dim_B+" * "+$dem_ht
			Else 
				t12:="*** dimensions unavailable ***"
			End if 
			
			//If ([Estimates_Carton_Specs]Width_Dec#0)
			//t12:=t12+String([Estimates_Carton_Specs]Width_Dec;"###0.0###")+" x "
			//End if 
			//
			//If ([Estimates_Carton_Specs]Depth_Dec#0)
			//t12:=t12+String([Estimates_Carton_Specs]Depth_Dec;"###0.0###")+" x "
			//End if 
			//If ([Estimates_Carton_Specs]Height_Dec#0)
			//t12:=t12+String([Estimates_Carton_Specs]Height_Dec;"###0.0###")
			//End if 
			
			If ([Estimates_Carton_Specs:19]SquareInches:16#0)
				t12:=t12+" - "+String:C10([Estimates_Carton_Specs:19]SquareInches:16)+" SqIn,"
			End if 
			
			
			If ([Estimates_Carton_Specs:19]Style:4#"")
				t12:=t12+"  Style: "+[Estimates_Carton_Specs:19]Style:4
			End if 
			
			If ([Estimates_Carton_Specs:19]OutLineNumber:15#"")
				t12:=t12+" Outline#: "+[Estimates_Carton_Specs:19]OutLineNumber:15
			End if 
			
			t12:=t12+"  "+[Estimates_Carton_Specs:19]OrderType:8+"  "+[Estimates_Carton_Specs:19]OriginalOrRepeat:9+"  "+String:C10([Estimates_Carton_Specs:19]OverRun:47)+"% overrun "+String:C10([Estimates_Carton_Specs:19]UnderRun:48)+"% underrun; "+(Num:C11([Estimates_Carton_Specs:19]SamplesSupplied:10)*"Sample supplied   ")
			
			t12:=t12+fGetLeafText
			
			If ([Estimates_Carton_Specs:19]WindowMatl:35#"")
				t12:=t12+String:C10([Estimates_Carton_Specs:19]WindowGauge:36)+" ga. "+[Estimates_Carton_Specs:19]WindowMatl:35+" Window "+String:C10([Estimates_Carton_Specs:19]WindowWth:37)+" Wide "+String:C10([Estimates_Carton_Specs:19]WindowHth:38)+" High.  "
			End if 
			
			If ([Estimates_Carton_Specs:19]GlueType:41="")
				t12:=t12+"No Glueing "
			Else 
				t12:=t12+"Glue: "+[Estimates_Carton_Specs:19]GlueType:41
			End if 
			
			t12:=t12+(" Inspected "*Num:C11([Estimates_Carton_Specs:19]GlueInspect:42))+(" Imaje "*Num:C11([Estimates_Carton_Specs:19]SecurityLabels:43))+(" UPC: "+[Estimates_Carton_Specs:19]UPC:44)
			t12:=t12+(" Strip Holes "*Num:C11([Estimates_Carton_Specs:19]StripHoles:46))
			If ([Estimates_Carton_Specs:19]CartonComment:12#"")
				t12:=t12+Char:C90(13)+[Estimates_Carton_Specs:19]CartonComment:12
			End if 
			If ([Estimates_Carton_Specs:19]SpecialPacking:50#"")
				t12:=t12+Char:C90(13)+[Estimates_Carton_Specs:19]SpecialPacking:50
			End if 
			
			ARRAY TEXT:C222(axText; 0)
			uText2Array2(t12; axText; 250; "Helvetica"; 9; 0)
			t12:=""
			$numComments:=Size of array:C274(axText)
			uChk4Room((15+(12*$numComments)); 60; "Est.H1"; "RFQ.H3")
			Print form:C5([Estimates:17]; "RFQ.D1")
			pixels:=pixels+15
			//* PRINT CARTON COMMENTS -----------  
			For ($j; 1; $numComments)
				t12:=axText{$j}
				Print form:C5([Estimates:17]; "RFQ.D2")
				pixels:=pixels+12
			End for 
			ARRAY TEXT:C222(axText; 0)
			NEXT RECORD:C51([Estimates_Carton_Specs:19])
		End for 
		uChk4Room(20; 30; "Est.H1")  //print last total
		total1:="Differential "+t5a+" Total:"
		Totalt8:=String:C10($Totalt8; "###,###,##0;-###,###")
		Totalt8a:=String:C10($Totalt8a; "###,###,##0;-###,###")
		Totalt9:=String:C10($Totalt9; "###,###,##0;-###,###")
		Totalt10:=String:C10($Totalt10; "###,###,##0;-###,###")
		Totalt11:=String:C10($Totalt11; "###,###,##0;-###,###")
		Totalt13:=String:C10($Totalt13; "###,###,##0;-###,###")
		Print form:C5([Estimates:17]; "RFQ.T1")
		pixels:=pixels+20
		//*PROCESS SPECIFICATION SECTION -----------
		//sSummarizePSpec 
		QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]EstimateNo:1=[Estimates:17]EstimateNo:1)
		RELATE ONE SELECTION:C349([Estimates_PSpecs:57]; [Process_Specs:18])
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			ORDER BY:C49([Process_Specs:18]; [Process_Specs:18]ID:1; >)  //•042696  MLB 
			FIRST RECORD:C50([Process_Specs:18])
			
			
		Else 
			
			ORDER BY:C49([Process_Specs:18]; [Process_Specs:18]ID:1; >)  //•042696  MLB 
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		//TRACE
		If (pixels+270>maxPixels)
			uChk4Room(270; 50; "Est.H1"; "RFQ.H4")
		Else 
			Print form:C5([Estimates:17]; "RFQ.H4")
			pixels:=pixels+20
		End if 
		
		For ($i; 1; Records in selection:C76([Process_Specs:18]))
			//uChk4Room (250;50;"Est.H1";"RFQ.H4")
			//Print form([Process_Specs];"RptPspecINCD")
			//pixels:=pixels+250
			uChk4Room(370; 50; "Est.H1"; "RFQ.H4")
			Print form:C5([Process_Specs:18]; "rptPSpecIncludeNew")
			pixels:=pixels+370
			NEXT RECORD:C51([Process_Specs:18])
		End for 
		
		PAGE BREAK:C6
		NEXT RECORD:C51([Estimates:17])
	End for 
	If (Count parameters:C259=1)  //•052495 MLB UPR1479  
		USE NAMED SELECTION:C332("before")
		CLEAR NAMED SELECTION:C333("before")
	End if 
End if   //page setup ok  
//