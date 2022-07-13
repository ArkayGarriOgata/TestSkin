//%attributes = {}

// Method: THC_calc_one_item (cust;cpn )  -> no zero is error
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 03/20/14, 10:39:06
// ----------------------------------------------------
// Description
// update the THC on the releases of one item
// based on BatchTHCcalc, BatchFGinventor, BatchJobcalc
// ----------------------------------------------------
// Modified by: Mel Bohince (8/18/17) dont include FG: Hold, Lost, Shipped as available inventory
// Modified by: Mel Bohince (4/11/18) mistakenly using field instead of $aBin{$i} when tallying

// use same tally loop as BatchFGinventor

READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Job_Forms_Items:44])
READ WRITE:C146([Customers_ReleaseSchedules:46])
C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($fgkey)
$fgkey:=$1+":"+$2
C_LONGINT:C283($0; $error; $i; $numRecs; $cursor; $required; $thc_state; $FG_QtyOH; $FG_QtyQA; $JMI_Qty)

$error:=0

If (True:C214)  //Get the current inventory 
	$FG_QtyOH:=0
	$FG_QtyQA:=0
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]FG_Key:34=$fgkey)
	ARRAY TEXT:C222($aCust; 0)
	ARRAY TEXT:C222($aCPN; 0)
	ARRAY TEXT:C222($aBin; 0)
	ARRAY LONGINT:C221($aQtyOH; 0)
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]CustID:16; $aCust; [Finished_Goods_Locations:35]ProductCode:1; $aCPN; [Finished_Goods_Locations:35]Location:2; $aBin; [Finished_Goods_Locations:35]QtyOH:9; $aQtyOH)
	uClearSelection(->[Finished_Goods_Locations:35])
	$numBins:=Size of array:C274($aCust)
	For ($i; 1; $numBins)
		//*    Tally based on bin type  
		$binType:=Substring:C12($aBin{$i}; 1; 2)  //$aBin{$i}≤1≥+$aBin{$i}≤2≥
		Case of 
			: ($binType="FG")  // | ($binType="FX")
				// Modified by: Mel Bohince (8/18/17) 
				Case of 
					: (Position:C15("hold"; $aBin{$i})>0)  // Modified by: Mel Bohince (4/11/18) 
						$FG_QtyQA:=$FG_QtyQA+$aQtyOH{$i}
						
					: (Position:C15("ship"; $aBin{$i})>0)
						$FG_QtyQA:=$FG_QtyQA+$aQtyOH{$i}
						
					: (Position:C15("lost"; $aBin{$i})>0)  //maybe expressed as LO:VST, picked up in the else below
						$FG_QtyQA:=$FG_QtyQA+$aQtyOH{$i}
						
					Else 
						$FG_QtyOH:=$FG_QtyOH+$aQtyOH{$i}
				End case 
				
				If (Substring:C12($aBin{$i}; 4; 2)="AV")
					$FG_QtyQA:=$FG_QtyQA+$aQtyOH{$i}
				End if 
				
			: ($binType="CC")
				$FG_QtyQA:=$FG_QtyQA+$aQtyOH{$i}
				
			: ($binType="XC")
				$FG_QtyQA:=$FG_QtyQA+$aQtyOH{$i}
				
			Else   //treat as examining, LO:VST for instance
				$FG_QtyQA:=$FG_QtyQA+$aQtyOH{$i}
		End case 
	End for 
	
	//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]FG_Key=$fgkey;*)
	//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Location="FG:@")
	//If (Records in selection([Finished_Goods_Locations])>0)
	//$FG_QtyOH:=Sum([Finished_Goods_Locations]QtyOH)
	//End if 
	
	//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]FG_Key=$fgkey;*)
	//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Location#"FG:@")
	//If (Records in selection([Finished_Goods_Locations])>0)
	//$FG_QtyQA:=Sum([Finished_Goods_Locations]QtyOH)
	//End if 
	
	//REDUCE SELECTION([Finished_Goods_Locations];0)
End if   //Get the current inventory 

If (True:C214)  //Get the current open production
	$JMI_Qty:=0
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=$2; *)
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]CustId:15=$1; *)
	QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)
	SELECTION TO ARRAY:C260([Job_Forms_Items:44]Qty_Want:24; $aQty; [Job_Forms_Items:44]Qty_Actual:11; $aActQty)
	$numRecs:=Size of array:C274($aQty)
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	For ($i; 1; $numRecs)
		If ($aQty{$i}>$aActQty{$i})  // • mel (9/16/04, 14:34:14) didn't reach yield level yet
			$JMI_Qty:=$JMI_Qty+($aQty{$i}-$aActQty{$i})
		End if 
	End for 
End if   //Get the current open production

If (True:C214)  //Apply the THC to the open releases
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=$2; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustID:12=$1; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>-1)
	$numRecs:=Records in selection:C76([Customers_ReleaseSchedules:46])
	ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
	
	For ($i; 1; $numRecs)
		If (fLockNLoad(->[Customers_ReleaseSchedules:46]))
			$required:=0
			$thc_state:=9
			$hasStock:=False:C215
			
			Case of 
				: ([Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)  //recently shipped
					$thc_state:=-1
					
				: ([Customers_ReleaseSchedules:46]PayU:31#0)  //knock off the pay use
					$thc_state:=-2
					
				Else   //this is what we came for
					/////////////////////
					////////////////////
					$required:=[Customers_ReleaseSchedules:46]Sched_Qty:6
					
					//*Get the on-hand inventory.
					$required:=RM_ConsumeBin(->$FG_QtyOH; $required)
					If ($required=0)  //all
						$thc_state:=0  //all onhand
						
					Else 
						$required:=RM_ConsumeBin(->$FG_QtyQA; $required)
						If ($required=0)  //were satisfied
							$thc_state:=1  //enough in onhand + qa
							
						Else   //will need to look in wip
							If ($required#[Customers_ReleaseSchedules:46]Sched_Qty:6)
								$hasStock:=True:C214
							End if 
						End if   //enuff in qa
					End if   //enuff onhand      
					
					
					If ($required>0)  //look for wip
						If ($JMI_Qty>0)
							Case of 
								: ($JMI_Qty>=$required)
									$JMI_Qty:=$JMI_Qty-$required
									$required:=0
									If ($hasStock)
										$thc_state:=2
									Else 
										$thc_state:=3
									End if 
									
								: ($JMI_Qty>0)
									$required:=$required-$JMI_Qty
									$JMI_Qty:=0
									If ($hasStock)
										$thc_state:=4
									Else 
										$thc_state:=5
									End if 
									
								Else 
									If ($hasStock)
										$thc_state:=7
									Else 
										$thc_state:=8
									End if 
							End case 
							
						Else   //no planned production
							If ($hasStock)
								$thc_state:=7
							Else 
								$thc_state:=8
							End if 
						End if   //planned production            
					End if   //wip required
					
			End case 
			
			[Customers_ReleaseSchedules:46]THC_Qty:37:=$required
			[Customers_ReleaseSchedules:46]THC_State:39:=$thc_state
			[Customers_ReleaseSchedules:46]THC_Date:38:=Current date:C33
			SAVE RECORD:C53([Customers_ReleaseSchedules:46])
			
		Else   //break, try later
			$error:=-1
			$i:=$i+$numRecs
		End if 
		
		NEXT RECORD:C51([Customers_ReleaseSchedules:46])
	End for   //each release
	
End if   //Apply the THC to the open releases

$0:=$error
//
