//%attributes = {"publishedWeb":true}
//rRptEstimate()      `aka Cost & Qty 
// modified by JML     8/13/93
//mlb 11/9/93, 1/10/94, 2/14/94
//2/22/94 upr # 1027
//3/28/94 upr # 1045
//5/23/94 upr # 60
//7/28/94 upr # 1141
//9/30/94 split out form cartons
//11/21/94 UPR 1328 chip, change format of 2 zero values
//Cost & Qty Estimate

//UPR 1148  02/10/95 chip
//onsite 3/15/95, try to stop extra blank page from printing
//4/25/95 upr 1480 chip
//•062295  MLB try to stop extra page from printing
//•3/28/97 cs upr 1804, multiples merging
//• 4/11/97 cs above change brought back extra page problem tried to stop
//• 4/14/97 cs  stop extra page - revisited - fixed!!!
//•5/15/97 cs first page of second diferential contained only 1 item
//• 5/23/97 cs consistaent messsage regarding grain upr 1870
//• 4/13/98 cs fix problem with want vs Yeild pricing on report
//• 8/6/98 cs add % of materials - requested by Howard
//090198 mlb add effectivity date
// • mel (5/2/05, 15:53:29) add Ben's mark-ups
READ ONLY:C145([Customers:16])  //••
MESSAGES OFF:C175  //•5/15/97 cs
C_TEXT:C284(tt30)
C_REAL:C285($MRh; $Rh; $matlCost; $MatAdds; $CostAdds)  //4/25/95 upr 1480 chip
C_TEXT:C284($Dot; $Ff; $whichCase)
C_TEXT:C284($ShortGrain)
C_LONGINT:C283($numCases; $i; $j; $each)  //
If ((User in group:C338(Current user:C182; "SalesReps")) | (User in group:C338(Current user:C182; "SalesCoordinator")))
	BEEP:C151
	ALERT:C41("Access denied to the Cost and Qty Report.")
Else 
	util_PAGE_SETUP(->[Estimates:17]; "Est.H1")
	If (Count parameters:C259=0)
		PRINT SETTINGS:C106
	Else 
		ok:=1
	End if 
	
	If (ok=1)
		PDF_setUp("C&Q"+[Estimates:17]EstimateNo:1+".pdf"; False:C215)
		For ($each; 1; Records in selection:C76([Estimates:17]))
			If (Count parameters:C259=0)
				$whichCase:=Request:C163("Print which differentials of "+[Estimates:17]EstimateNo:1+"?"; "All")
			Else 
				$whichCase:="All"
				ok:=1
			End if 
			
			If ((ok=1) & ($whichCase#""))
				
				maxPixels:=552  // figure on landscape
				iPage:=1
				pixels:=0
				//----------------------- SET UP MAIN HEADER -----------
				t1:="Estimate Number: "+[Estimates:17]EstimateNo:1
				t2:="Cost & Qty Estimate"
				t3:=String:C10(4D_Current_date; 2)+" "+String:C10(4d_Current_time; 2)
				t3a:="Last Update on "+String:C10([Estimates:17]ModDate:37; 1)+" by "+[Estimates:17]ModWho:38
				Print form:C5([Estimates:17]; "Est.H1")
				pixels:=pixels+30
				//----------------------- SET UP ESTIMATE HEADER -----------
				RELATE ONE:C42([Estimates:17]Cust_ID:2)
				//RELATE MANY([ESTIMATE]EstimateNo)  `get carton spec's, case secnario
				QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)
				QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11#"00")
				
				If ($whichCase="All")
					QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1; *)
					QUERY:C277([Estimates_Differentials:38];  & ; [Estimates_Differentials:38]diffNum:3#"00")
				Else 
					QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1; *)
					QUERY:C277([Estimates_Differentials:38];  & ; [Estimates_Differentials:38]diffNum:3=$whichCase)
				End if 
				CREATE SET:C116([Estimates_Carton_Specs:19]; "theCartons")
				CREATE SET:C116([Estimates_Differentials:38]; "theScenarios")
				$numCases:=Records in selection:C76([Estimates_Differentials:38])
				If ($numCases<1)
					BEEP:C151
					ALERT:C41("No differencials where found for: '"+$whichCase+"'.")
				End if 
				$summary:=fEstOverview($numCases)
				t4:="Customer:"+Char:C90(13)+"Line:"+Char:C90(13)+"Sales Rep:"+Char:C90(13)+"Est. Team:"
				t5:=[Customers:16]Name:2+Char:C90(13)+[Estimates:17]Brand:3+Char:C90(13)+[Estimates:17]Sales_Rep:13+Char:C90(13)+[Estimates:17]PlannedBy:16+"/"+[Estimates:17]EstimatedBy:14
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
				uEstRptInitAccm
				For ($i; 1; $numCases)  //step through the case scenario file
					If ($i>1)
						Print form:C5([Estimates:17]; "Est.H1")
						pixels:=pixels+30
					End if 
					
					t7:=[Estimates_Differentials:38]diffNum:3
					t7a:=[Estimates_Differentials:38]PSpec_Qty_TAG:25
					
					//----------------------- SET UP DIFFERENTIAL & ITEM HEADER -----------
					RELATE MANY:C262([Estimates_Differentials:38]Id:1)
					t8:=String:C10(Records in selection:C76([Estimates_DifferentialsForms:47]))
					ARRAY TEXT:C222($distincPs; 0)
					DISTINCT VALUES:C339([Estimates_DifferentialsForms:47]ProcessSpec:23; $distincPs)
					t8a:=String:C10(Size of array:C274($distincPs))
					Print form:C5([Estimates:17]; "Est.H3")
					pixels:=pixels+40
					//----------------------- SET UP THE ITEM LIST -----------    
					USE SET:C118("theCartons")  //get the cartons for this form on this case
					// ******* Verified  - 4D PS - January  2019 ********
					
					QUERY SELECTION:C341([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11=t7)  //;*)  search for cartons of just this case
					
					
					// ******* Verified  - 4D PS - January 2019 (end) *********
					$numCartons:=Records in selection:C76([Estimates_Carton_Specs:19])
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
						
						ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)
						FIRST RECORD:C50([Estimates_Carton_Specs:19])
						
						
					Else 
						
						ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)
						
					End if   // END 4D Professional Services : January 2019 First record
					// 4D Professional Services : after Order by , query or any query type you don't need First record  
					RELATE ONE:C42([Estimates_Carton_Specs:19]ProcessSpec:3)  //for use later
					RELATE MANY:C262([Estimates_Differentials:38]Id:1)  //get [casrform] records for this case scenario
					C_LONGINT:C283($GrossShts; $NetShts)
					$GrossShts:=Sum:C1([Estimates_DifferentialsForms:47]SheetsQtyGross:19)
					$NetShts:=Sum:C1([Estimates_DifferentialsForms:47]NumberSheets:4)
					
					// t20:="Sheet Size: (see each form below)   Caliper: "+String([PROCESS_SPEC]Calip
					t20:="Differential Totals->      Net Sheets: "+String:C10($NetShts; "###,###,##0")+"         Gross Sheets: "+String:C10($GrossShts; "###,###,##0")
					t20:=t20+"      Waste Sheets: "+String:C10(($GrossShts-$NetShts); "###,###,##0")+"         % Waste: "+String:C10(Round:C94(((($GrossShts-$NetShts)/$NetShts)*100); 0); "#,##0%")
					i1:=0  //form counters
					i2:=0
					i3:=0
					i4:=0
					For ($j; 1; $numCartons)
						RELATE MANY:C262([Estimates_Carton_Specs:19]CartonSpecKey:7)
						t16:=String:C10(Sum:C1([Estimates_FormCartons:48]NumberUp:4))  //# up for this carton      
						//  If (Num(t16)>0)
						t10:=[Estimates_Carton_Specs:19]Item:1
						t11:=[Estimates_Carton_Specs:19]ProductCode:5
						t12:=[Estimates_Carton_Specs:19]Description:14+" OL#:"+[Estimates_Carton_Specs:19]OutLineNumber:15+" Art#:"+[Estimates_Carton_Specs:19]z_ArtReceived:60  //"-"+ the dash is a secret code which says FG record not available
						C_TEXT:C284($dim_A; $dim_B; $dem_ht)
						$success:=FG_getDimensions(->$dim_A; ->$dim_B; ->$dem_ht; [Estimates_Carton_Specs:19]OutLineNumber:15; [Estimates_Carton_Specs:19]ProductCode:5)
						If ($success)
							t13:=$dim_A+" * "+$dim_B+" * "+$dem_ht
						Else 
							t13:="*** dimensions unavailable ***"
						End if 
						//t13:=String([Estimates_Carton_Specs]Width_Dec;"#,##0.0###")+" x "+String([Estimates_Carton_Specs]Depth_Dec;"#,##0.0###")+" x "+String([Estimates_Carton_Specs]Height_Dec;"#,##0.0###")
						t14:=String:C10([Estimates_Carton_Specs:19]SquareInches:16)
						t15:=[Estimates_Carton_Specs:19]Style:4  //OutLineNumber      
						// upr 1141  t17:=String([CARTON_SPEC]Quantity_Want;"###,###,##0")
						// upr 1141  t18:=String([CARTON_SPEC]Quantity_Yield;"###,###,##0")
						t17:=String:C10(Sum:C1([Estimates_FormCartons:48]FormWantQty:9); "###,###,##0")
						t18:=String:C10(Sum:C1([Estimates_FormCartons:48]MakesQty:5); "###,###,##0")
						Print form:C5([Estimates:17]; "Est.D1")
						
						i1:=i1+Sum:C1([Estimates_FormCartons:48]NumberUp:4)
						If (Records in selection:C76([Estimates_FormCartons:48])#0)  //make sure it is on a form
							//upr 1141  i2:=i2+[CARTON_SPEC]Quantity_Want 
							i2:=i2+Num:C11(t17)
						End if 
						// upr 1141  i3:=i3+[CARTON_SPEC]Quantity_Yield
						i3:=i3+Num:C11(t18)
						pixels:=pixels+15
						uChk4Room(47; 70; "Est.H1"; "Est.H3")
						//End if   `some up
						NEXT RECORD:C51([Estimates_Carton_Specs:19])
					End for 
					
					If ([Estimates_DifferentialsForms:47]NumberUpOverrid:30#0)  //upr 60
						i1:=[Estimates_DifferentialsForms:47]NumberUpOverrid:30
					End if 
					
					i4:=((i3-i2)/i2)*100  //percent Excess on form
					iUp:=iUp+i1
					iWant:=iWant+i2
					iYield:=iYield+i3
					
					
					Print form:C5([Estimates:17]; "Est.T1")
					pixels:=pixels+17
					Print form:C5([Estimates:17]; "Est.C1")  //t20 defined above (sheet info)`•••
					pixels:=pixels+15
					Print form:C5([zz_control:1]; "BlankPix8")  //blank line
					pixels:=pixels+8
					
					//----------------------- PROCESS FORM -----------
					//RELATE MANY([CaseScenario]Id)  `may be redundant
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
						
						ORDER BY:C49([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]FormNumber:2; >)
						FIRST RECORD:C50([Estimates_DifferentialsForms:47])
						
						
					Else 
						
						ORDER BY:C49([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]FormNumber:2; >)
						
					End if   // END 4D Professional Services : January 2019 First record
					// 4D Professional Services : after Order by , query or any query type you don't need First record  
					C_LONGINT:C283($T)
					$T:=Records in selection:C76([Estimates_DifferentialsForms:47])
					$MRh:=0
					$Rh:=0
					$matlCost:=0
					t20:=""
					For ($X; 1; $T)
						If ([Estimates_DifferentialsForms:47]ProcessSpec:23#"")  //special process spec for this form
							If (([Process_Specs:18]ID:1#[Estimates_DifferentialsForms:47]ProcessSpec:23) | ([Process_Specs:18]Cust_ID:4#[Estimates:17]Cust_ID:2))
								QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Estimates_DifferentialsForms:47]ProcessSpec:23; *)
								QUERY:C277([Process_Specs:18];  & ; [Process_Specs:18]Cust_ID:4=[Estimates:17]Cust_ID:2)
							End if 
						End if 
						$GrossShts:=[Estimates_DifferentialsForms:47]SheetsQtyGross:19
						$NetShts:=[Estimates_DifferentialsForms:47]NumberSheets:4
						
						If ([Estimates_DifferentialsForms:47]ShortGrain:11)
							$ShortGrain:=" Short Grain"
						Else 
							$ShortGrain:="Normal Grain"  //• 5/23/97 cs added phrase 'normal grain'
						End if 
						
						t20:="Sheet Size: "+String:C10([Estimates_DifferentialsForms:47]Width:5; "##0.##")+" x "+String:C10([Estimates_DifferentialsForms:47]Lenth:6; "##0.##")+$ShortGrain+" Caliper: "+String:C10([Process_Specs:18]Caliper:8; "#0.000#")+" Stock Type: "+[Process_Specs:18]Stock:7
						t20:=t20+"; SHEETS -> Net: "+String:C10($NetShts; "###,###,##0")+" Gross: "+String:C10($GrossShts; "###,###,##0")
						t20:=t20+" Waste: "+String:C10(($GrossShts-$NetShts); "###,###,##0")+" = "+String:C10(Round:C94([Estimates_DifferentialsForms:47]Spoilage_Pct:28; 0); "#,##0%")
						If ([Estimates_DifferentialsForms:47]Addl_Spoilage:29>0)
							t20:=t20+" Additional Waste: "+String:C10([Estimates_DifferentialsForms:47]Addl_Spoilage:29; "#,##0%")
						End if 
						
						RELATE MANY:C262([Estimates_DifferentialsForms:47]DiffFormId:3)  //get all formcartons, machine_est, & matl_est
						$numBOMs:=Records in selection:C76([Estimates_Machines:20])
						
						$TtlPixels:=($numBOMs*20)+20+30  //tries to make room for entire chunk of operations
						If ($TtlPixels>MaxPixels)  //if that won't fit, check for room for headers and 2 CC lines
							$TtlPixels:=40+20+30
						End if 
						uChk4Room($TtlPixels; 30; "Est.H1")
						
						//----------------------- SET UP FORM # HEADER -----------
						tt30:=String:C10([Estimates_DifferentialsForms:47]FormNumber:2)
						Print form:C5([Estimates:17]; "Est.H6")  //this header needs to show [caseform]formnumber
						pixels:=pixels+32
						//9/30/94
						uPrintFormCarto
						//
						
						//----------------------- SET UP COST CENTER HEADER -----------
						Print form:C5([Estimates:17]; "Est.H4")  //this header needs to show [caseform]formnumber
						pixels:=pixels+30
						ORDER BY:C49([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5; >)
						For ($j; 1; $numBOMs)
							t10:=String:C10([Estimates_Machines:20]Sequence:5; "000")
							$Dot:=(Num:C11((([Estimates_Machines:20]WasteAdj_Percen:40#0) | ([Estimates_Machines:20]MR_Override:26#0) | ([Estimates_Machines:20]Run_Override:27#0)))*"•")
							$Ff:=(Num:C11([Estimates_Machines:20]FormChangeHere:9)*"ƒ")
							t11:=[Estimates_Machines:20]CostCtrID:4+$Dot+$Ff
							tText:=String:C10([Estimates_Machines:20]Effectivity:6; <>MIDDATE)  //090198 mlb
							RELATE ONE:C42([Estimates_Machines:20]CostCtrID:4)
							t12:="(Out Srv) "*Num:C11([Estimates_Machines:20]OutSideService:33)
							t12:=t12+[Cost_Centers:27]Description:3  //UPR 1148
							t13:=String:C10([Estimates_Machines:20]MakeReadyHrs:30; "##0.00")
							t14:=String:C10([Estimates_Machines:20]RunningRate:31)
							t15:=String:C10([Estimates_Machines:20]RunningHrs:32; "###0.00")
							t15a:=String:C10([Estimates_Machines:20]Hrs_YldAddition:44; "##0.00; ; ")
							$MRh:=$MRh+[Estimates_Machines:20]MakeReadyHrs:30
							$Rh:=$Rh+[Estimates_Machines:20]RunningHrs:32
							t16:=String:C10(([Estimates_Machines:20]CostLabor:13+[Estimates_Machines:20]CostOvertime:41); "###,###,##0")
							If ([Estimates_Machines:20]CostOvertime:41#0)
								t16:=t16+"/ot"
							End if 
							
							t17:=String:C10([Estimates_Machines:20]CostOverhead:15; "###,###,##0")
							t19:=String:C10(Round:C94([Estimates_Machines:20]CostScrap:12; 0); "###,###,##0")
							t19a:=String:C10(Round:C94([Estimates_Machines:20]OOP_YldAddition:45; 0); "###,###,##0; ; ")  //••••••••••••••••
							rLabor:=rLabor+[Estimates_Machines:20]CostLabor:13
							rOH:=rOH+[Estimates_Machines:20]CostOverhead:15
							$CostAdds:=[Estimates_Machines:20]OOP_YldAddition:45+$CostAdds  //4/25/95 upr 1480 chip
							t18:=String:C10(([Estimates_Machines:20]CostLabor:13+[Estimates_Machines:20]CostOverhead:15+[Estimates_Machines:20]CostScrap:12+[Estimates_Machines:20]CostOvertime:41); "###,###,##0;-###,###,##0;NO COST")
							t16a:=String:C10([Estimates_Machines:20]Qty_Gross:22; "###,###,##0")
							t17a:=String:C10([Estimates_Machines:20]Qty_Waste:23; "###,###,##0")
							t18a:=String:C10([Estimates_Machines:20]Qty_Net:24; "###,###,##0")
							Print form:C5([Estimates:17]; "Est.D2")
							pixels:=pixels+20
							uChk4Room(20; 60; "Est.H1"; "Est.H4")
							NEXT RECORD:C51([Estimates_Machines:20])
						End for 
						Print form:C5([zz_control:1]; "BlankPix8")  //blank line
						pixels:=pixels+8
						
						
						//----------------------- SET UP MATERIAL HEADER -----------        
						$numBOMs:=Records in selection:C76([Estimates_Materials:29])
						$TtlPixels:=($numBOMs*20)+30  //tries to make room for entire chunk of materials
						If ($TtlPixels>MaxPixels)  //if that won't fit, check for room for headers and 2  lines
							$TtlPixels:=40+30
						End if 
						uChk4Room($TtlPixels; 30; "Est.H1")
						
						Print form:C5([Estimates:17]; "Est.H5")
						pixels:=pixels+30
						
						ORDER BY:C49([Estimates_Materials:29]; [Estimates_Materials:29]Sequence:12; >)
						For ($j; 1; $numBOMs)
							// RELATE ONE([Material_Est]__)  `get machine Est record
							If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
								
								QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=[Estimates_Materials:29]Commodity_Key:6)
								FIRST RECORD:C50([Raw_Materials_Groups:22])
								
								
							Else 
								
								QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=[Estimates_Materials:29]Commodity_Key:6)
								
							End if   // END 4D Professional Services : January 2019 First record
							// 4D Professional Services : after Order by , query or any query type you don't need First record  
							t10:=String:C10([Estimates_Materials:29]Sequence:12; "000  ")+[Estimates_Materials:29]CostCtrID:2  //machine material is used upon
							t11:=[Estimates_Materials:29]Commodity_Key:6+":  "+[Estimates_Materials:29]Raw_Matl_Code:4
							tText:=""
							t12:=String:C10([Estimates_Materials:29]Cost:11; "$###,###,##0;-$0########0;NO COST")
							
							t12a:=String:C10([Estimates_Materials:29]Matl_YieldAdds:26; "$###,###,##0; ; ")
							$matlCost:=$matlCost+[Estimates_Materials:29]Cost:11
							$MatADds:=$MatAdds+[Estimates_Materials:29]Matl_YieldAdds:26  //4/25/95 upr 1480 chip
							t13:=[Estimates_Materials:29]Comments:13+" "+[Estimates_Materials:29]CalcDetails:24
							t14:=String:C10([Estimates_Materials:29]Qty:9; "###,###,##0")
							t15:=[Estimates_Materials:29]UOM:8
							Print form:C5([Estimates:17]; "Est.D3")
							pixels:=pixels+20
							uChk4Room(20; 60; "Est.H1"; "Est.H5")
							NEXT RECORD:C51([Estimates_Materials:29])
						End for 
						
						NEXT RECORD:C51([Estimates_DifferentialsForms:47])  //move on to  next form of this differential
					End for 
					
					//----------------------- DIFFERENTIAL TOTALS -----------        
					If ([Estimates_Differentials:38]BreakOutSpls:18)
						uChk4Room(465; 30; "Est.H1")
					Else 
						uChk4Room(405; 30; "Est.H1")
					End if 
					
					uEstRptTotal($MRh; $Rh; $matlCost; $CostAdds; $MatAdds)  //4/25/95 upr 1480 chip
					uEstRptInitAccm
					$MRh:=0
					$Rh:=0
					$matlCost:=0
					$MatAdds:=0
					
					If ($i=$NumCases)  //• 4/14/97 cs  stop extra page
						PAGE BREAK:C6  //print entire document
					Else 
						PAGE BREAK:C6(>)  //force forms to print together
					End if 
					Pixels:=0  //•5/15/97 cs after formfeed pixel count was not reset
					iPage:=iPage+1  //•3/28/97 cs upr 1804, multiples merging
					
					//•3/28/97 cs upr 1804, multiples merging - removed below
					//If ($i#$numCases)  `•062295  MLB try to stop extra page from
					//« printing
					//pixels:=fFillPage (maxPixels;pixels;1)  `unconditianlly pag
					//«e break between differential
					//iPage:=iPage+1
					//End if 
					//
					//end upr 1804
					NEXT RECORD:C51([Estimates_Differentials:38])
				End for 
				
			End if   //which differtials  
			
			
			NEXT RECORD:C51([Estimates:17])
			If (Record number:C243([Estimates:17])<0)
				$each:=$each+Records in selection:C76([Estimates:17])  //break
			End if 
		End for   //each estimate selected
	End if   //print settings    
	
End if   //user in group 
MESSAGES ON:C181  //•5/15/97 cs
READ WRITE:C146([Customers:16])  //••
//