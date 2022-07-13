//%attributes = {"publishedWeb":true}
//Procedure: BatchAcptContra()  101597  MLB
//accept contract orders and spew forth any execptions
//based on interactive code in proc: fCOrderRules4 and fTotalOrderLine
//•112697  MLB  add DateBooked to Orderlines
//•012198  MLB  get over and underruns
//•111098  MLB  UPR add customer name or brand
// Modified by: Mel Bohince (3/31/15)  html'ize the mailing
// Modified by: Mel Bohince (4/9/15) add the problem orderlines back into the report under the line summary
// Modified by: Mel Bohince (5/28/19) ignore spl billing orderlines, these will be in EA uom
// Modified by: MelvinBohince (1/13/22) test for billto

C_BOOLEAN:C305($isBooked)
C_LONGINT:C283($i; $numContract; $j; $i; $numLines; $Denom; $numBooked; $notBooked)
C_REAL:C285($prep; $prod; $cost; $rev; $newBookings; $over; $under)
C_TEXT:C284($exception; $stats)
C_TEXT:C284($CR)
C_TEXT:C284(xTitle; xText)
C_DATE:C307($date)

READ WRITE:C146([Customers_Orders:40])
READ WRITE:C146([Customers_Order_Lines:41])
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Customers_Brand_Lines:39])
READ ONLY:C145([Customers:16])  //•012198  MLB 

MESSAGES OFF:C175

$newBookings:=0
$numBooked:=0
$notBooked:=0
$CR:=Char:C90(13)
//[Customers_Order_Lines]edi_line_status="Reviewed"
$date:=4D_Current_date  //•041996  MLB  
//*Set up for logfile dump
xTitle:="Batch Contract Order Acceptance Summary for "+String:C10($date; <>LONGDATE)+"  "+String:C10(4d_Current_time; <>HMMAM)
xText:="____________________________________________"+$CR
$prehead:="Listed are problems needing attention before contract order lines can be booked."
$tableData:=""


$r:="</td></tr>"+$CR
$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"

QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]edi_line_status:55="Reviewed")  //make sure planner has agreed
QUERY:C277([Customers_Order_Lines:41];  | ; [Customers_Order_Lines:41]edi_line_status:55="Sent")  //make sure planner has agreed
QUERY:C277([Customers_Order_Lines:41];  | ; [Customers_Order_Lines:41]edi_line_status:55="")  //make sure planner has agreed
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9="CONTRACT")
RELATE ONE SELECTION:C349([Customers_Order_Lines:41]; [Customers_Orders:40])

SELECTION TO ARRAY:C260([Customers_Order_Lines:41]CustID:4; $aCust; [Customers_Order_Lines:41]CustomerLine:42; $aLine; [Customers_Order_Lines:41]ProductCode:5; $aCPN)
MULTI SORT ARRAY:C718($aCust; >; $aLine; >; $aCPN; >)

$numElements:=Size of array:C274($aCust)
uThermoInit($numElements; "Checking prerequisits")
ARRAY TEXT:C222($CheckedLine; 0)
ARRAY TEXT:C222($CheckedFG; 0)
ARRAY TEXT:C222($ProblemLine; 0)
ARRAY TEXT:C222($ProblemFG; 0)
ARRAY INTEGER:C220($CntLines; 0)
ARRAY INTEGER:C220($CntFGs; 0)

For ($i; 1; $numElements)
	$hit:=Find in array:C230($CheckedLine; $aCust{$i}+":"+$aLine{$i})
	If ($hit=-1)  //check it out
		QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=$aCust{$i}; *)
		QUERY:C277([Customers_Brand_Lines:39];  & ; [Customers_Brand_Lines:39]LineNameOrBrand:2=$aLine{$i})
		If (Records in selection:C76([Customers_Brand_Lines:39])=1)
			$distro:=[Customers_Brand_Lines:39]ContractPctMatl:10+[Customers_Brand_Lines:39]ContractPctLab:8+[Customers_Brand_Lines:39]ContractPctOH:9+[Customers_Brand_Lines:39]ContractPctFrt:11
			Case of 
				: ([Customers_Brand_Lines:39]ContractPV:7=0)
					APPEND TO ARRAY:C911($CheckedLine; $aCust{$i}+":"+$aLine{$i})
					APPEND TO ARRAY:C911($ProblemLine; "ContractPV not set")
					APPEND TO ARRAY:C911($CntLines; 1)
					
				: ($distro<99)
					APPEND TO ARRAY:C911($CheckedLine; $aCust{$i}+":"+$aLine{$i})
					APPEND TO ARRAY:C911($ProblemLine; "Cost distrobution < 99")
					APPEND TO ARRAY:C911($CntLines; 1)
					
				: ($distro>101)
					APPEND TO ARRAY:C911($CheckedLine; $aCust{$i}+":"+$aLine{$i})
					APPEND TO ARRAY:C911($ProblemLine; "Cost distrobution >101")
					APPEND TO ARRAY:C911($CntLines; 1)
					
				Else 
					APPEND TO ARRAY:C911($CheckedLine; $aCust{$i}+":"+$aLine{$i})
					APPEND TO ARRAY:C911($ProblemLine; "GOOD")
					APPEND TO ARRAY:C911($CntLines; 1)
			End case 
			
		Else   //line missing
			APPEND TO ARRAY:C911($CheckedLine; $aCust{$i}+":"+$aLine{$i})
			APPEND TO ARRAY:C911($ProblemLine; "Line record not found")
			APPEND TO ARRAY:C911($CntLines; 1)
		End if   //line found
		
	Else 
		$CntLines{$hit}:=$CntLines{$hit}+1
	End if   //line checked
	
	$hit:=Find in array:C230($CheckedFG; $aCPN{$i})
	If ($hit=-1)  //check it out
		$numfg:=qryFinishedGood($aCust{$i}; $aCPN{$i})
		If ($numfg=1)
			Case of 
				: ([Finished_Goods:26]RKContractPrice:49=0)
					APPEND TO ARRAY:C911($CheckedFG; $aCust{$i}+":"+$aCPN{$i})
					APPEND TO ARRAY:C911($ProblemFG; "Contract price not set")
					APPEND TO ARRAY:C911($CntFGs; 1)
				Else 
					APPEND TO ARRAY:C911($CheckedFG; $aCust{$i}+":"+$aCPN{$i})
					APPEND TO ARRAY:C911($ProblemFG; "GOOD")
					APPEND TO ARRAY:C911($CntFGs; 1)
			End case 
			
		Else   //fg missing
			APPEND TO ARRAY:C911($CheckedFG; $aCust{$i}+":"+$aCPN{$i})
			APPEND TO ARRAY:C911($ProblemFG; "F/G record not found")
			APPEND TO ARRAY:C911($CntFGs; 1)
		End if   //fg found
		
	Else 
		$CntFGs{$hit}:=$CntFGs{$hit}+1
	End if   //fg checked
	
	uThermoUpdate($i)
End for 
uThermoClose

For ($i; 1; Size of array:C274($CheckedLine))
	If ($ProblemLine{$i}#"GOOD")
		$tableData:=$tableData+$b+String:C10($CntLines{$i})+$t+$CheckedLine{$i}+$t+$ProblemLine{$i}+$r
	End if 
End for 

For ($i; 1; Size of array:C274($CheckedFG))
	If ($ProblemFG{$i}#"GOOD")
		$tableData:=$tableData+$b+String:C10($CntFGs{$i})+$t+$CheckedFG{$i}+$t+$ProblemFG{$i}+$r
	End if 
End for 

$numContract:=Records in selection:C76([Customers_Orders:40])

For ($j; 1; $numContract)
	//*    For each order, check some things and recalc totals
	If ([Customers_Orders:40]CustomerLine:22#"")  //•051595  MLB  UPR 1508
		$isBooked:=True:C214  //be optimistic        
		$prep:=0
		$prod:=0
		$cost:=0
		$rev:=0
		[Customers_Orders:40]BudgetCostTotal:20:=$cost  //recalc these header values
		[Customers_Orders:40]SalePrepTotal:32:=$prep
		[Customers_Orders:40]SaleProdTotal:33:=$prod
		[Customers_Orders:40]OrderSalesTotal:19:=$rev
		[Customers_Orders:40]PV:21:=0
		
		If ([Customers_Orders:40]PONumber:11="") | ([Customers_Orders:40]PONumber:11="N/A")
			$tableData:=$tableData+$b+String:C10([Customers_Orders:40]OrderNumber:1)+$t+[Customers_Orders:40]CustomerLine:22+$t+"Needs a PO#"+$r
			[Customers_Orders:40]PONumber:11:="N/A"
		End if 
		//*       For each orderline, calc the cost, and check some thinsgs
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1)
			FIRST RECORD:C50([Customers_Order_Lines:41])
			
			
		Else 
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1)
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		$numLines:=Records in selection:C76([Customers_Order_Lines:41])
		For ($i; 1; $numLines)
			If (Not:C34([Customers_Order_Lines:41]SpecialBilling:37))  // Modified by: Mel Bohince (5/28/19) 
				$Denom:=nlGetFGDenom
				
				If ([Customers_Order_Lines:41]Status:9="CONTRACT")  //Modified by: mel (11/24/09)
					
					If (Length:C16([Customers_Order_Lines:41]Classification:29)#0) & (Length:C16([Customers_Order_Lines:41]CustomerLine:42)#0) & (Length:C16([Customers_Order_Lines:41]PONumber:21)#0)
						
						If (ADDR_isValid([Customers_Order_Lines:41]defaultBillto:23))  // Modified by: MelvinBohince (1/13/22) test for billto
							
							QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=[Customers_Order_Lines:41]CustID:4; *)
							QUERY:C277([Customers_Brand_Lines:39];  & ; [Customers_Brand_Lines:39]LineNameOrBrand:2=[Customers_Order_Lines:41]CustomerLine:42)
							If (Records in selection:C76([Customers_Brand_Lines:39])=1) & ([Customers_Brand_Lines:39]ContractPV:7#0) & (([Customers_Brand_Lines:39]ContractPctMatl:10+[Customers_Brand_Lines:39]ContractPctLab:8+[Customers_Brand_Lines:39]ContractPctOH:9+[Customers_Brand_Lines:39]ContractPctFrt:11)>99) & (([Customers_Brand_Lines:39]ContractPctMatl:10+[Customers_Brand_Lines:39]ContractPctLab:8+[Customers_Brand_Lines:39]ContractPctOH:9+[Customers_Brand_Lines:39]ContractPctFrt:11)<101)
								//then brand looks good
							End if 
							// Modified by: mel (1/25/10) recal the costs regardless otherwise price changes don't get rebooked
							//*          Get the contract price and cost
							[Customers_Order_Lines:41]Price_Per_M:8:=SetContractCost([Customers_Order_Lines:41]CustID:4; [Customers_Order_Lines:41]ProductCode:5; ->[Customers_Order_Lines:41]Cost_Per_M:7; ->[Customers_Order_Lines:41]CostMatl_Per_M:32; ->[Customers_Order_Lines:41]CostLabor_Per_M:30; ->[Customers_Order_Lines:41]CostOH_Per_M:31; ->[Customers_Order_Lines:41]CostScrap_Per_M:33; 1)
							Case of 
								: ([Customers_Order_Lines:41]Price_Per_M:8=0)
									$tableData:=$tableData+$b+[Customers_Order_Lines:41]OrderLine:3+$t+[Customers_Order_Lines:41]CustomerLine:42+$t+"Price missing, see O/L record"+$r
									$isBooked:=False:C215
									If ([Finished_Goods:26]RKContractPrice:49=0)
										$tableData:=$tableData+$b+[Customers_Order_Lines:41]OrderLine:3+$t+[Customers_Order_Lines:41]CustomerLine:42+$t+"Contract price is zero"+$r
										//$tableData:=$tableData+$b+""+$t+""+$t+"Contract price = $0.00"+$r
									End if 
									$notBooked:=$notBooked+1
								: ([Customers_Order_Lines:41]Cost_Per_M:7=0)
									$tableData:=$tableData+$b+[Customers_Order_Lines:41]OrderLine:3+$t+[Customers_Order_Lines:41]CustomerLine:42+$t+"Cost not calculated"+$r
									//$tableData:=$tableData+$b+[Customers_Order_Lines]OrderLine+$t+[Customers_Order_Lines]CustomerLine+$t+"Cost missing, see Brand/Line record"+$r
									$isBooked:=False:C215
									If ([Finished_Goods:26]RKContractPrice:49=0)
										$tableData:=$tableData+$b+[Customers_Order_Lines:41]OrderLine:3+$t+[Customers_Order_Lines:41]CustomerLine:42+$t+"Contract price is zero"+$r
										//$tableData:=$tableData+$b+""+$t+""+$t+"Contract price = $0.00"+$r
									End if 
									$notBooked:=$notBooked+1
									
								Else   //•012198  MLB 
									If ([Customers:16]ID:1#[Customers_Order_Lines:41]CustID:4)
										QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_Order_Lines:41]CustID:4)
									End if 
									
									Case of 
										: (Position:C15("reg"; [Finished_Goods:26]OrderType:59)>0)
											$over:=[Customers:16]Run_Over_Regular_Order:63
											$under:=[Customers:16]Run_Under_Regular_Order:64
										: (Position:C15("promo"; [Finished_Goods:26]OrderType:59)>0)
											$over:=[Customers:16]Run_Over_Promo_Order:65
											$under:=[Customers:16]Run_Under_Promo_Order:66
									End case 
									
									If ($over>=0)  //•012198  MLB 
										[Customers_Order_Lines:41]Qty_Booked:48:=[Customers_Order_Lines:41]Quantity:6
										[Customers_Order_Lines:41]Status:9:="accepted"
										[Customers_Order_Lines:41]DateBooked:49:=$date  //•112697  MLB 
										[Customers_Order_Lines:41]OverRun:25:=$over  //•012198  MLB 
										[Customers_Order_Lines:41]UnderRun:26:=$under  //•012198  MLB  
										SAVE RECORD:C53([Customers_Order_Lines:41])
										$newBookings:=$newBookings+(([Customers_Order_Lines:41]Qty_Booked:48/$denom)*[Customers_Order_Lines:41]Price_Per_M:8)
									Else 
										$tableData:=$tableData+$b+[Customers_Order_Lines:41]OrderLine:3+$t+[Customers_Order_Lines:41]CustomerLine:42+$t+"Over/Under Run missing, check the F/G record's order-type"+$r
										$isBooked:=False:C215
										$notBooked:=$notBooked+1
									End if 
							End case 
							
							
						Else   //billto chk
							$tableData:=$tableData+$b+[Customers_Order_Lines:41]OrderLine:3+$t+[Customers_Order_Lines:41]CustomerName:24+$t+"Needs a defaultBillto to be Accepted"+$r
							$isBooked:=False:C215
						End if   //bllto chk
						
					Else   //class line po chk
						$tableData:=$tableData+$b+[Customers_Order_Lines:41]OrderLine:3+$t+[Customers_Order_Lines:41]CustomerName:24+$t+"Needs a Class, Line, and PO to be Accepted"+$r
						$isBooked:=False:C215
					End if   //class line po chk
					
				End if   //still contract status and reviewed
				
				$extended:=[Customers_Order_Lines:41]Quantity:6/$denom*[Customers_Order_Lines:41]Price_Per_M:8
				If ([Customers_Order_Lines:41]OrderType:22="Preparatory")
					$prep:=$prep+$extended
				Else 
					$prod:=$prod+$extended
				End if 
				$cost:=$cost+(([Customers_Order_Lines:41]Quantity:6-[Customers_Order_Lines:41]ExcessQtySold:40)/$denom*[Customers_Order_Lines:41]Cost_Per_M:7)
				$rev:=$rev+$extended
			End if   //not spl billing
			NEXT RECORD:C51([Customers_Order_Lines:41])
			
		End for 
		
		If ($isBooked)  //*If all lines were booked, book the header
			[Customers_Orders:40]DateApproved:45:=$date
			[Customers_Orders:40]ApprovedBy:14:="BTCH"
			If ([Customers_Orders:40]Status:10="CONTRACT")
				[Customers_Orders:40]Status:10:="accepted"
			End if 
			$numBooked:=$numBooked+1
		End if 
		[Customers_Orders:40]ModWho:8:="BTCH"
		[Customers_Orders:40]ModDate:9:=$date
		[Customers_Orders:40]BudgetCostTotal:20:=$cost  //recalc these header values
		[Customers_Orders:40]SalePrepTotal:32:=$prep
		[Customers_Orders:40]SaleProdTotal:33:=$prod
		[Customers_Orders:40]OrderSalesTotal:19:=$rev
		[Customers_Orders:40]PV:21:=uNANCheck(Round:C94((($rev-$cost)/$rev); 3))
		
		SAVE RECORD:C53([Customers_Orders:40])
		
	Else 
		$exception:=$exception+$CR
		$exception:=$exception+"Customer: "+[Customers_Orders:40]CustomerName:39+" on order "+String:C10([Customers_Orders:40]OrderNumber:1)+" needs a Line to advance the status."+$CR
		$tableData:=$tableData+$b+String:C10([Customers_Orders:40]OrderNumber:1)+$t+[Customers_Orders:40]CustomerName:39+$t+"Needs a Line to advance the status"+$r
	End if 
	
	NEXT RECORD:C51([Customers_Orders:40])
	
End for 

ORD_ContractHeaders


REDUCE SELECTION:C351([Customers_Orders:40]; 0)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)
REDUCE SELECTION:C351([Customers_Brand_Lines:39]; 0)

If (Length:C16($tableData)>0)
	$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:700;color:#000\">"
	$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:700;color:#000\">"
	
	$summary:=$b+""+$t+String:C10($numBooked)+$t+"Orders were booked"+$r
	$summary:=$summary+$b+""+$t+String:C10($newBookings; "$###,###,##0.00")+$t+"Dollar Value"+$r
	$summary:=$summary+$b+""+$t+String:C10($notBooked)+$t+"Line items not booked"+$r
	$summary:=$summary+$b+""+$t+""+$t+""+$r
	
	$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$t:="</td><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$summary:=$summary+$b+"ORDER"+$t+"LINE"+$t+"PROBLEM"+$r
	
	
	$tableData:=$summary+$tableData
	
	// distributionList:="mel.bohince@arkay.com"
	Email_html_table(xTitle; $prehead; $tableData; 600; distributionList)
End if 
//rPrintText ("CONTRACTS_ACCEPTED_"+fYYMMDD ($date)+"_"+Replace 
//«string(String(4d_Current_time;◊HHMM);":";""))
xTitle:=""
xText:=""
$stats:=""
$exception:=""
$tableData:=""