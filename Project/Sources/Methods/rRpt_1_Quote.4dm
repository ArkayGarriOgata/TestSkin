//%attributes = {"publishedWeb":true}
//rRpt_1_Quote mod
//upr 1047 3/24/94
//upr 1143 7/28/94
//upr 1135 10/12/94
//upr 1302 11/8/94
//•upr 1458 040395 & 051195 
//•081595  MLB  remove text2array2
//•042696  MLB  sort on Description fails with 4Dv1.5.1
//•3/21/00  mlb  

C_LONGINT:C283(maxPixels; pixels; iPage)  //page locators
C_LONGINT:C283($i; $j; $newSize; $numComments)
C_TEXT:C284($LastDiff; $CurrDiff)
C_TEXT:C284($WhichDiffs)  //All | "" | AA AC AD
C_BOOLEAN:C305($chgStatus)
ARRAY TEXT:C222($aPspec; 0)  //used to hold all the p-specs in the target diffs
//•051195 upr 1458 Begin
C_REAL:C285($priceWnt; $priceYld)
C_TEXT:C284($item)
C_TEXT:C284($cpn)
C_LONGINT:C283($qtyWnt; $qtyYld)
C_BOOLEAN:C305($error; $break)

maxPixels:=552  // figure on landscape
iPage:=1
pixels:=0
//•.                        end
If (Records in selection:C76([Estimates:17])=1)
	If (Est_OkToQuote([Estimates:17]EstimateNo:1))  //•3/21/00  mlb   
		//*Determine which Differentials to print
		$WhichDiffs:=Request:C163("Quote which differential?"; "All")
		If (ok=1)
			util_PAGE_SETUP(->[Estimates:17]; "Est.H1")
			PRINT SETTINGS:C106
			If (ok=1)
				//*Determine whether Estimate status should be set to Quoted after printing
				$continue:=True:C214
				Case of 
					: (Position:C15("Priced"; [Estimates:17]Status:30)#0)
						CONFIRM:C162("Change the Estimate status to Quoted?"; "Change"; "Don't Change")
						If (ok=1)
							$chgStatus:=True:C214
						Else 
							$chgStatus:=False:C215
						End if 
						
					: ([Estimates:17]Status:30="Quoted")
						$chgStatus:=False:C215
						
					: (Position:C15("Hold"; [Estimates:17]Status:30)#0)
						uConfirm("This Estimate is on Hold and may not be Quoted at this time."; "OK"; "Help")
						$chgStatus:=False:C215
						$continue:=False:C215
						
					Else 
						uConfirm("Note: this printing cannot change the status to quoted at this time."; "OK"; "Help")
						$chgStatus:=False:C215
				End case 
				
				If ($continue)
					//*SET UP MAIN HEADER -----------
					t1:="Estimate Number: "+[Estimates:17]EstimateNo:1
					t2:="Arkay's Quote Detail"
					If (Substring:C12([Estimates:17]EstimateNo:1; 8; 2)="00")
						t2b:="(Original) Status is:"+[Estimates:17]Status:30
					Else 
						t2b:="(Revised) Status is:"+[Estimates:17]Status:30
					End if 
					t3:=String:C10(4D_Current_date; 2)+" "+String:C10(4d_Current_time; 2)
					t3a:="Last Update on "+String:C10([Estimates:17]ModDate:37; 1)+" by "+[Estimates:17]ModWho:38
					Print form:C5([Estimates:17]; "Est.H1")
					pixels:=pixels+30
					//*BUILD ADDRESS-----------
					QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Estimates:17]z_Bill_To_ID:5)
					Text2:=fGetAddressText
					RELATE ONE:C42([Estimates:17]Cust_ID:2)
					Print form:C5([Estimates:17]; "Quote.H2")
					pixels:=pixels+150
					//*PRINT ESTIMATE COMMENTS -----------  
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
					//sSummarizeCases 
					//*.   Get all the cartonspecs for this estimate
					RELATE MANY:C262([Estimates:17]EstimateNo:1)
					//*.   Set up a list of desired differtials
					If (($WhichDiffs="All") | ($WhichDiffs=""))
						MESSAGE:C88("Quoting all differentials...")
						$WhichDiffs:=""
						If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
							
							FIRST RECORD:C50([Estimates_Differentials:38])
							
							
						Else 
							
							// see line 95
							
							
						End if   // END 4D Professional Services : January 2019 First record
						// 4D Professional Services : after Order by , query or any query type you don't need First record  
						If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
							
							While (Not:C34(End selection:C36([Estimates_Differentials:38])))
								If ([Estimates_Differentials:38]diffNum:3#<>sQtyWorksht)
									$WhichDiffs:=$WhichDiffs+[Estimates_Differentials:38]diffNum:3+" "
								End if 
								NEXT RECORD:C51([Estimates_Differentials:38])
							End while 
							
						Else 
							
							ARRAY TEXT:C222($_diffNum; 0)
							
							SELECTION TO ARRAY:C260([Estimates_Differentials:38]diffNum:3; $_diffNum)
							For ($Iter; 1; Size of array:C274($_diffNum); 1)
								If ($_diffNum{$Iter}#<>sQtyWorksht)
									$WhichDiffs:=$WhichDiffs+$_diffNum{$Iter}+" "
								End if 
							End for 
							
						End if   // END 4D Professional Services : January 2019 
						
					Else 
						MESSAGE:C88("Quoting '"+$WhichDiffs+"' differentials...")
					End if 
					//*.   Init loop testors and accumulators            
					$LastDiff:="1"
					$iQty1:=0
					$iQty2:=0
					$iQty3:=0
					$iQty4:=0
					t5a:=""  // this is the title of the differential "AA- Differential Tag"
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
						
						ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11; >; [Estimates_Carton_Specs:19]Item:1; >)
						FIRST RECORD:C50([Estimates_Carton_Specs:19])
						
					Else 
						
						ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]diffNum:11; >; [Estimates_Carton_Specs:19]Item:1; >)
						
						
					End if   // END 4D Professional Services : January 2019 First record
					// 4D Professional Services : after Order by , query or any query type you don't need First record  
					
					//°ARRAY TEXT($aPspec;1)
					//°$aPspec{1}:=""
					//*.   Process all c-specs in the target differentials
					For ($i; 1; Records in selection:C76([Estimates_Carton_Specs:19]))
						If (Position:C15([Estimates_Carton_Specs:19]diffNum:11; $WhichDiffs)#0)  //make sure we want this case
							//*.      Keep a list of all the p-specs used in the target differentials     
							If (Find in array:C230($aPspec; [Estimates_Carton_Specs:19]ProcessSpec:3)=-1)
								$newSize:=Size of array:C274($aPspec)+1
								ARRAY TEXT:C222($aPspec; $newSize)
								$aPspec{$newSize}:=[Estimates_Carton_Specs:19]ProcessSpec:3
							End if 
							//*.      See if we are at the begining of the next diff
							$CurrDiff:=[Estimates_Carton_Specs:19]diffNum:11
							If ($CurrDiff#$LastDiff)  //first time for this case, print header
								//*.         Process Differential Break              
								If ($LastDiff#"1")  //print totals unless frist time thru
									uDiffBreakLevel($iQty1; $iQty2; $iQty3; $iQty4; $LastDiff)
								End if   //the first
								//*.         Set up for next differential
								uChk4Room(60; 30; "Est.H1")
								//*.             Init loop testors and accumulators     
								$LastDiff:=$CurrDiff
								$iQty1:=0
								$iQty2:=0
								$iQty3:=0
								$iQty4:=0
								QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=[Estimates_Carton_Specs:19]Estimate_No:2+$CurrDiff)
								t5a:=$CurrDiff+" "+[Estimates_Differentials:38]PSpec_Qty_TAG:25
								Print form:C5([Estimates:17]; "Quote.H3")
								pixels:=pixels+30
								
							End if   //the same one
							//TRACE
							//*.      Set up the carton details -----------  
							
							//*.         Load & Print detail1 varibles           
							t5:=[Estimates_Carton_Specs:19]Item:1
							t6:=[Estimates_Carton_Specs:19]ProductCode:5
							t7:=[Estimates_Carton_Specs:19]Description:14
							C_TEXT:C284($dim_A; $dim_B; $dem_ht)
							$success:=FG_getDimensions(->$dim_A; ->$dim_B; ->$dem_ht; [Estimates_Carton_Specs:19]OutLineNumber:15; [Estimates_Carton_Specs:19]ProductCode:5)
							If ($success)
								t8:=$dim_A+" * "+$dim_B+" * "+$dem_ht
							Else 
								t8:="*** dimensions unavailable ***"
							End if 
							t8a:=[Estimates_Carton_Specs:19]Style:4
							t9:=String:C10([Estimates_Carton_Specs:19]SquareInches:16)
							t10:=[Estimates_Carton_Specs:19]OutLineNumber:15
							t11:=[Estimates_Carton_Specs:19]ProcessSpec:3
							t13b:=String:C10([Estimates_Carton_Specs:19]PriceWant_Per_M:28; "$###,###,##0.00;-###,###.##; ")
							t13d:=String:C10([Estimates_Carton_Specs:19]PriceYield_PerM:30; "$###,###,##0.00;-###,###.##; ")
							//°upr1047 remove [CARTON_SPEC]PriceSqInWant_M,[CARTON_SPEC]PriceSqInYld_M        
							//*.         Load & Print Carton comment varible
							t12:=[Estimates_Carton_Specs:19]OrderType:8+" type item, "+[Estimates_Carton_Specs:19]OriginalOrRepeat:9+" order catagory; "+(Num:C11([Estimates_Carton_Specs:19]SamplesSupplied:10)*"Sample supplied  ")+" "
							t12:=t12+String:C10([Estimates_Carton_Specs:19]OverRun:47)+"% over-run, "+String:C10([Estimates_Carton_Specs:19]UnderRun:48)+"% under-run; "
							t12:=t12+fGetLeafText
							If ([Estimates_Carton_Specs:19]WindowMatl:35#"")
								t12:=t12+String:C10([Estimates_Carton_Specs:19]WindowGauge:36)+" "+[Estimates_Carton_Specs:19]WindowMatl:35+" Window "+String:C10([Estimates_Carton_Specs:19]WindowWth:37)+" Wide "+String:C10([Estimates_Carton_Specs:19]WindowHth:38)+" High;  "
							End if 
							t12:=t12+"Glued: "+[Estimates_Carton_Specs:19]GlueType:41+"; "+(" Inspected "*Num:C11([Estimates_Carton_Specs:19]GlueInspect:42))+(" Imaje "*Num:C11([Estimates_Carton_Specs:19]SecurityLabels:43))+(" UPC: "+[Estimates_Carton_Specs:19]UPC:44)
							t12:=t12+(" Strip Holes "*Num:C11([Estimates_Carton_Specs:19]StripHoles:46))
							If ([Estimates_Carton_Specs:19]QuoteComment:62#"")
								t12:=t12+Char:C90(13)+[Estimates_Carton_Specs:19]QuoteComment:62
							End if 
							If ([Estimates_Carton_Specs:19]SpecialPacking:50#"")
								t12:=t12+Char:C90(13)+[Estimates_Carton_Specs:19]SpecialPacking:50
							End if 
							//#######
							//*.            Look forward for the same item, upr 1458 4.5.95
							//.                 because each item maybe on multiple forms          
							$break:=False:C215  // in case we reach the eof
							$error:=False:C215  // in case like items have different cpn or price
							$item:=[Estimates_Carton_Specs:19]Item:1  //compare item
							$cpn:=[Estimates_Carton_Specs:19]ProductCode:5
							$qtyWnt:=[Estimates_Carton_Specs:19]Quantity_Want:27  //accum qty
							$qtyYld:=[Estimates_Carton_Specs:19]Quantity_Yield:29
							$priceWnt:=[Estimates_Carton_Specs:19]PriceWant_Per_M:28
							$priceYld:=[Estimates_Carton_Specs:19]PriceYield_PerM:30
							//TRACE
							//•.                        end
							While ((Not:C34(End selection:C36([Estimates_Carton_Specs:19]))) & (Not:C34($break)))  //not the last one
								NEXT RECORD:C51([Estimates_Carton_Specs:19])  //look forward
								If (Not:C34(End selection:C36([Estimates_Carton_Specs:19])))
									If ([Estimates_Carton_Specs:19]diffNum:11=$CurrDiff)  //make sure we don't drift into the next differential
										If ($item#[Estimates_Carton_Specs:19]Item:1)
											PREVIOUS RECORD:C110([Estimates_Carton_Specs:19])  //go back                
											$break:=True:C214
										Else   //same item, so run comparsisons and accumulate qtys
											If ($cpn=[Estimates_Carton_Specs:19]ProductCode:5)
												If ($priceWnt=[Estimates_Carton_Specs:19]PriceWant_Per_M:28)
													If ($priceYld=[Estimates_Carton_Specs:19]PriceYield_PerM:30)
														$qtyWnt:=$qtyWnt+[Estimates_Carton_Specs:19]Quantity_Want:27
														$qtyYld:=$qtyYld+[Estimates_Carton_Specs:19]Quantity_Yield:29  //•051195 UPR 1476
													Else 
														BEEP:C151
														$error:=True:C214
														$break:=True:C214
														ALERT:C41("Item "+$item+" has an inconsistent yield price. Please correct to print a quote.")
													End if 
												Else 
													BEEP:C151
													$error:=True:C214
													$break:=True:C214
													ALERT:C41("Item "+$item+" has an inconsistent want price. Please correct to print a quote.")
												End if 
											Else 
												BEEP:C151
												$error:=True:C214
												$break:=True:C214
												ALERT:C41("Item "+$item+" has in consistent CPN. Please correct to print a quote.")
											End if 
											
										End if   //item comparison
										
									Else   //into the next differential
										PREVIOUS RECORD:C110([Estimates_Carton_Specs:19])  //get back into the selection              
										$break:=True:C214
									End if   //same differential
									
								Else   //oops, too far
									LAST RECORD:C200([Estimates_Carton_Specs:19])  //get back into the selection              
									$break:=True:C214
								End if 
							End while 
							//#######
							If (Not:C34($error))
								t13a:=String:C10($qtyWnt; "###,###,##0;-###,###; ")
								t13c:=String:C10($qtyYld; "###,###,##0;-###,###; ")
								
								ARRAY TEXT:C222(axText; 0)
								uText2Array2(t12; axText; 250; "Helvetica"; 9; 0)
								t12:=""
								$numComments:=Size of array:C274(axText)
								
								uChk4Room((27+(12*$numComments)); 60; "Est.H1"; "Quote.H3")  //only print if entire thing fits on page
								Print form:C5([Estimates:17]; "Quote.D1")
								pixels:=pixels+27
								
								For ($j; 1; $numComments)
									t12:=axText{$j}
									Print form:C5([Estimates:17]; "RFQ.D2")
									pixels:=pixels+12
								End for 
								ARRAY TEXT:C222(axText; 0)
								
								//*.         Accumulate totals
								$iQty1:=$iQty1+$qtyWnt
								If ($qtyWnt#0)  //•051195
									$iQty3:=$iQty3+(($qtyWnt/1000)*[Estimates_Carton_Specs:19]PriceWant_Per_M:28)
								End if 
								
								$iQty2:=$iQty2+$qtyYld
								If ($qtyYld#0)  //•051195
									$iQty4:=$iQty4+(($qtyYld/1000)*[Estimates_Carton_Specs:19]PriceYield_PerM:30)
								End if 
								
							Else   //`break due to error
								$i:=$i+Records in selection:C76([Estimates_Carton_Specs:19])
								t12:="CONSISTANCY ERROR ON ITEM "+$item
								Print form:C5([Estimates:17]; "RFQ.D2")
								pixels:=pixels+12
								PAGE BREAK:C6
							End if   //error
							
						End if   //we want this case quoted  
						NEXT RECORD:C51([Estimates_Carton_Specs:19])
					End for 
					//*.   Print the last totals
					If (Not:C34($error))
						uDiffBreakLevel($iQty1; $iQty2; $iQty3; $iQty4; $LastDiff)
						//*PROCESS SPECIFICATION SECTION -----------       
						//°sSummarizePSpec 
						If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
							
							CREATE EMPTY SET:C140([Process_Specs:18]; "theseHereOnes")
							For ($i; 1; Size of array:C274($aPspec))
								QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=$aPspec{$i})
								ADD TO SET:C119([Process_Specs:18]; "theseHereOnes")
							End for 
							USE SET:C118("theseHereOnes")
							CLEAR SET:C117("theseHereOnes")
							
						Else 
							
							QUERY WITH ARRAY:C644([Process_Specs:18]ID:1; $aPspec)
							
						End if   // END 4D Professional Services : January 2019 
						
						If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
							
							ORDER BY:C49([Process_Specs:18]; [Process_Specs:18]ID:1; >)  //•042696  MLB  
							FIRST RECORD:C50([Process_Specs:18])
							
						Else 
							
							ORDER BY:C49([Process_Specs:18]; [Process_Specs:18]ID:1; >)  //•042696  MLB  
							
							
						End if   // END 4D Professional Services : January 2019 First record
						// 4D Professional Services : after Order by , query or any query type you don't need First record  
						
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
						//*Change the Estimate status
						If ($chgStatus)
							<>EstStatus:="Quoted"
							<>EstNo:=[Estimates:17]EstimateNo:1
							$id:=New process:C317("uChgEstStatus"; <>lMinMemPart; "Estimate Status Change")
						End if 
						
					End if   //not error after loop
				End if   //continue      
			End if   //ok print settings 
		End if   //   cases specified
	End if   //ok to qwote
	
Else 
	uConfirm("You must select ONE estimate number to print the Quote Detial."; "OK"; "Help")
End if 