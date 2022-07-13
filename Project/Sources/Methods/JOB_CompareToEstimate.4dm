//%attributes = {"publishedWeb":true}
//PM: JOB_CompareToEstimate(budget Estimate differential) -> 
//JOB_CompareToEstimate ("2-0460.04AA")
//@author mlb - 9/11/02  10:23
//warn in the $/M of budget is more the 110% of accepted order estimate
//• mlb - 11/7/02  12:22 add planner to email
// • mel (4/22/05, 11:31:13) change to 5%

C_TEXT:C284($estimate; $1; $2; $estParent; $diffId)
C_REAL:C285($budgetCost; $orderCost; $tolerance)
C_TEXT:C284(tTitle; xText; $0)

$diffId:=$1
$estimate:=Substring:C12($1; 1; 9)
$tolerance:=1.05  //looking for greater than 5%

If (Count parameters:C259=1)  //init
	$pid:=New process:C317("JOB_CompareToEstimate"; <>lMinMemPart; "JOB_CompareToEstimate"; $diffId; "doit")
	If (False:C215)
		JOB_CompareToEstimate
	End if 
	
Else 
	READ ONLY:C145([Estimates:17])
	READ ONLY:C145([Customers_Orders:40])
	READ ONLY:C145([Estimates_Differentials:38])
	MESSAGES OFF:C175
	tTitle:="Budget Estimate, "+$estimate+", Costs Exceeds Order Cost by 10 percent"
	xText:="insufficient data"
	//*Locate the accepted order estimate
	$estParent:=Substring:C12($estimate; 1; 6)+"@"
	
	QUERY:C277([Estimates:17]; [Estimates:17]Status:30="Ordered"; *)
	QUERY:C277([Estimates:17];  | ; [Estimates:17]Status:30="Accepted Order"; *)
	QUERY:C277([Estimates:17];  & ; [Estimates:17]EstimateNo:1=$estParent)
	If (Records in selection:C76([Estimates:17])>0)
		zwStatusMsg("VARIANCE"; "Checking "+$estParent)
		ORDER BY:C49([Estimates:17]; [Estimates:17]EstimateNo:1; <)  //assume the latest one
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Estimates:17]OrderNo:51)
		If (Records in selection:C76([Customers_Orders:40])=1)
			$ordDiff:=[Customers_Orders:40]EstimateNo:3+[Customers_Orders:40]CaseScenario:4
			//*Calculate the ave $/M on order estimate
			QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=$ordDiff)
			If ([Estimates_Differentials:38]TotalPieces:8#0)
				$orderCost:=Round:C94([Estimates_Differentials:38]CostTTL:14/[Estimates_Differentials:38]TotalPieces:8*1000; 0)
				
				//*Locate the budget
				QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=$diffId)
				If (Records in selection:C76([Estimates_Differentials:38])=1)
					//*Calculate the ave $/M on the budget
					If ([Estimates_Differentials:38]TotalPieces:8#0)
						$budgetCost:=Round:C94([Estimates_Differentials:38]CostTTL:14/[Estimates_Differentials:38]TotalPieces:8*1000; 2)
					Else 
						$budgetCost:=0
					End if 
					
					//*Email if under priced
					If ($budgetCost>($orderCost*$tolerance))
						$avePrice:=0
						QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Orders:40]OrderNumber:1; *)
						QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
						If (Records in selection:C76([Customers_Order_Lines:41])>0)
							SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Quantity:6; $aQty; [Customers_Order_Lines:41]Price_Per_M:8; $aPrice)
							$totalPrice:=0
							$totalUnits:=0
							For ($i; 1; Size of array:C274($aQty))
								$totalPrice:=$totalPrice+(($aQty{$i}/1000)*$aPrice{$i})
								$totalUnits:=$totalUnits+$aQty{$i}
							End for 
							$avePrice:=Round:C94($totalPrice/$totalUnits*1000; 2)
						End if 
						QUERY:C277([Users:5]; [Users:5]Initials:1=[Estimates:17]PlannedBy:16)  //• mlb - 11/7/02  12:22
						distributionList:=Email_WhoAmI([Users:5]UserName:11)+Char:C90(9)
						
						xText:="BudgetDifferential: "+$diffId+"  budgeted: "+String:C10($budgetCost; "##,##0.00")+"  OrderDifferential: "+$ordDiff+"  was "+String:C10($orderCost; "##,##0.00")
						xText:=xText+Char:C90(13)+" the average unit price on order "+String:C10([Customers_Orders:40]OrderNumber:1)+" was "+String:C10($avePrice)
						distributionList:=distributionList+Batch_GetDistributionList("JOB_CompareToEstimate")
						QM_Sender(tTitle; ""; xText; distributionList)
					Else 
						xText:="within tolerance"
					End if   //variance   
					
					xTitle:=""
				End if   //found order cost
			End if   //budget estimate
		End if   //order       
	End if   //order estimate
	REDUCE SELECTION:C351([Estimates_Differentials:38]; 0)
	REDUCE SELECTION:C351([Estimates:17]; 0)
	REDUCE SELECTION:C351([Customers_Orders:40]; 0)
	
	$0:=xText
End if 