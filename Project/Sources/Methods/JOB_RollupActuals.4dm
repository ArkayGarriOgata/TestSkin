//%attributes = {"publishedWeb":true}
//PM:  JOB_RollupActuals()  2/14/00  mlb
//formerly  `(P) gCalcActual
//----------------------------------------------
//see also gRMIssCalcTot
//11/15/94 make material costs positive in wip
//•5/10/95 Change to qryCostCenter
//050596 TJF
//•112296    reset the machine jobbers so they don't over accumulate
//•112696    use latest eff date if not budgeted
//• 10/20/97 cs do not run calc if Glue Qty = 0 (Winnie request),
//  alos added optional parameter as messsage flag
//$1 (optional) string - anything flag do not post alert
//• 3/18/98 cs change restriction from Stop to confirm
//• 4/10/98 cs Nan Checking
//• 7/14/98 cs fix problem where sometimes this runs and clears actuals
//090298 mlb use latest OOP
//•090398  MLB big cs ommission
//•020800 MLB calc the net produced and save in jmi an jf
//•3/23/00  mlb  forgot to account for subforms
//• mlb - 9/21/01  if no fg transaction, don't overwrite jmi qtys
//mlb 4/13/06 use lessor of good or want for ActProducedQty
// Modified by: mel (4/14/10) can't use qryjmi, doesn't work for first item
// Modified by: Mel Bohince (7/23/15) include comkey adn sequence when rolling up materials into the budget

MESSAGES OFF:C175

C_LONGINT:C283($rec; $i)
//zwStatusMsg ("Update Actuals";"Calculating Actuals for "+[Job_Forms]JobFormID)
//utl_Logfile ("rollup.log";"Update Actuals: Calculating Actuals for "+[Job_Forms]JobFormID)
//NewWindow (270;30;6;-722;"Calculating Actuals for "+[JobForm]JobFormID)
//MESSAGE(◊sCR+" Calculating Actuals for "+[JobForm]JobFormID+◊sCR+"Please
//TRACE  `« wait...")

[Job_Forms:42]ActLabCost:37:=0
[Job_Forms:42]ActOvhdCost:38:=0
[Job_Forms:42]ActS_ECost:39:=0
C_BOOLEAN:C305($laminated)
$laminated:=False:C215
//•112296    reset the machine jobbers so they don't over accumulate in next step
CREATE SET:C116([Job_Forms_Machines:43]; "thisJob")

FIRST RECORD:C50([Job_Forms_Machines:43])
//uThermoInit (Records in selection([Job_Forms_Machines]);"Gathering actual costs")
For ($i; 1; Records in selection:C76([Job_Forms_Machines:43]))
	If (Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>LAMINATERS)>0)
		$laminated:=True:C214
	End if 
	[Job_Forms_Machines:43]Actual_Labor:22:=0
	[Job_Forms_Machines:43]Actual_OH:23:=0
	[Job_Forms_Machines:43]Planned_SE_Cost:16:=0
	[Job_Forms_Machines:43]Actual_Qty:19:=0
	[Job_Forms_Machines:43]Actual_Waste:20:=0
	[Job_Forms_Machines:43]Actual_MR_Hrs:24:=0
	[Job_Forms_Machines:43]Actual_RunHrs:40:=0
	[Job_Forms_Machines:43]Actual_RunRate:39:=0
	SAVE RECORD:C53([Job_Forms_Machines:43])
	NEXT RECORD:C51([Job_Forms_Machines:43])
End for 



FIRST RECORD:C50([Job_Forms_Machine_Tickets:61])
For ($i; 1; Records in selection:C76([Job_Forms_Machine_Tickets:61]))
	//uThermoUpdate ($i;1)
	USE SET:C118("thisJob")
	$Rec:=qryMachJob([Job_Forms_Machine_Tickets:61]JobForm:1; [Job_Forms_Machine_Tickets:61]CostCenterID:2; [Job_Forms_Machine_Tickets:61]Sequence:3; 1)  //050196 
	If (True:C214)
		qryCostCenter([Job_Forms_Machine_Tickets:61]CostCenterID:2; !00-00-00!)
	Else 
		If ($Rec#0)  //use the effectivity date on hte machine job record
			qryCostCenter([Job_Forms_Machine_Tickets:61]CostCenterID:2; [Job_Forms_Machines:43]Effectivity:3)  //•5/10/95
		Else 
			qryCostCenter([Job_Forms_Machine_Tickets:61]CostCenterID:2; [Job_Forms_Machine_Tickets:61]DateEntered:5)  //was findcc`•112296    `•112696  uselatest eff date
		End if 
	End if 
	
	[Job_Forms:42]ActLabCost:37:=uNANCheck([Job_Forms:42]ActLabCost:37+Round:C94(([Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7)*[Cost_Centers:27]MHRlaborSales:4; 2))
	[Job_Forms:42]ActOvhdCost:38:=uNANCheck([Job_Forms:42]ActOvhdCost:38+Round:C94(([Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7)*[Cost_Centers:27]MHRburdenSales:5; 2))
	[Job_Forms:42]ActS_ECost:39:=uNANCheck([Job_Forms:42]ActS_ECost:39+Round:C94(([Job_Forms_Machine_Tickets:61]MR_Act:6+[Job_Forms_Machine_Tickets:61]Run_Act:7)*[Cost_Centers:27]ScrapExcessCost:32; 2))
	gCalcActMach
	NEXT RECORD:C51([Job_Forms_Machine_Tickets:61])
End for 
//uThermoClose 
USE SET:C118("thisJob")
CLEAR SET:C117("thisJob")

RM_Issue_Auto_Ink  // Modified by: Mel Bohince (9/13/13) 
If (Not:C34($laminated))
	RM_Issue_Auto_Coating  // Modified by: Mel Bohince (6/5/15) 
End if 
RM_Issue_Auto_Corrugate  // Modified by: Mel Bohince (5/15/17) 

QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=[Job_Forms:42]JobFormID:5; *)  //• 7/14/98 cs fix problem where sometimes this runs and clears actuals
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")  //•090398  MLB 
[Job_Forms:42]ActMatlCost:40:=uNANCheck(Sum:C1([Raw_Materials_Transactions:23]ActExtCost:10)*-1)  //11/15/94

[Job_Forms:42]ActFormCost:13:=[Job_Forms:42]ActLabCost:37+[Job_Forms:42]ActOvhdCost:38+[Job_Forms:42]ActS_ECost:39+[Job_Forms:42]ActMatlCost:40

CREATE SET:C116([Job_Forms_Materials:55]; "thisJob")

FIRST RECORD:C50([Job_Forms_Materials:55])
For ($i; 1; Records in selection:C76([Job_Forms_Materials:55]))
	[Job_Forms_Materials:55]Actual_Qty:14:=0
	[Job_Forms_Materials:55]Actual_Price:15:=0
	SAVE RECORD:C53([Job_Forms_Materials:55])
	NEXT RECORD:C51([Job_Forms_Materials:55])
End for 



//this is for refer only, not budgeted fall off
For ($i; 1; Records in selection:C76([Raw_Materials_Transactions:23]))
	USE SET:C118("thisJob")
	$comCode:=Substring:C12([Raw_Materials_Transactions:23]Commodity_Key:22; 1; 2)  // Modified by: Mel Bohince (9/25/15) less strict than comkey
	QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Sequence:3=[Raw_Materials_Transactions:23]Sequence:13; *)
	QUERY SELECTION:C341([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12=$comCode+"@")  // Modified by: Mel Bohince (7/23/15)
	If (Records in selection:C76([Job_Forms_Materials:55])>0)
		[Job_Forms_Materials:55]Actual_Qty:14:=[Job_Forms_Materials:55]Actual_Qty:14+([Raw_Materials_Transactions:23]Qty:6*-1)
		[Job_Forms_Materials:55]Actual_Price:15:=[Job_Forms_Materials:55]Actual_Price:15+([Raw_Materials_Transactions:23]ActExtCost:10*-1)
		SAVE RECORD:C53([Job_Forms_Materials:55])
	End if 
	NEXT RECORD:C51([Raw_Materials_Transactions:23])
End for 

USE SET:C118("thisJob")
CLEAR SET:C117("thisJob")

//•020800 MLB calc the net produced/glued and save in jmi an jf
COPY NAMED SELECTION:C331([Job_Forms_Items:44]; "holdJMI")
//•2/23/00  mlb  apply to selection lost jf record chg
//•3/23/00  mlb  forgot to account for subforms
ARRAY TEXT:C222($aJobit; 0)
DISTINCT VALUES:C339([Job_Forms_Items:44]Jobit:4; $aJobit)
$numItems:=Size of array:C274($aJobit)
C_LONGINT:C283($glueCount)
C_LONGINT:C283($goodCount)

For ($item; 1; $numItems)
	$goodCount:=JOB_CalcNetProduced($aJobit{$item})
	$glueCount:=JOB_CalcQtyGlued($aJobit{$item})
	
	If ($glueCount#-1)  //• mlb - 9/21/01  if no fg transaction, don't overwrite jmi qtys
		// Modified by: mel (4/14/10) can't use qryjmi, doesn't work for first item
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$aJobit{$item})
		$numJMI:=Records in selection:C76([Job_Forms_Items:44])
		If ($numJMI=1)  //same as its always been, no subforms        
			[Job_Forms_Items:44]Qty_Actual:11:=$glueCount
			//mlb 4/13/06 lessor of good or want
			If ($goodCount<=[Job_Forms_Items:44]Qty_Want:24)
				[Job_Forms_Items:44]Qty_Good:10:=$goodCount
			Else 
				[Job_Forms_Items:44]Qty_Good:10:=[Job_Forms_Items:44]Qty_Want:24
			End if 
			SAVE RECORD:C53([Job_Forms_Items:44])
			
		Else   //•101398  MLB subforms
			ARRAY LONGINT:C221($aPlnQty; 0)
			ARRAY LONGINT:C221($aActQty; 0)
			ARRAY LONGINT:C221($aNetQty; 0)
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]Qty_Want:24; $aPlnQty)
			
			ARRAY LONGINT:C221($aActQty; $numJMI)
			$qty:=$glueCount  //spread this over all the subforms if present
			$i:=1
			While ($qty>0) & ($i<=$numJMI)
				If ($i=$numJMI)  //dump it all in the last one
					$aActQty{$i}:=$aActQty{$i}+$qty
					
				Else 
					$qtyOpen:=$aPlnQty{$i}-$aActQty{$i}
					Case of 
						: ($qtyOpen>=$qty)  //take it all
							$aActQty{$i}:=$aActQty{$i}+$qty
							$qty:=0
							
						: ($qtyOpen>0)  //take up to planned
							$aActQty{$i}:=$aActQty{$i}+$qtyOpen
							$qty:=$qty-$qtyOpen
					End case 
				End if 
				$i:=$i+1
			End while 
			
			ARRAY LONGINT:C221($aNetQty; $numJMI)
			$qty:=$goodCount  //spread this over all the subforms if present
			$i:=1
			While ($qty>0) & ($i<=$numJMI)
				If ($i=$numJMI)  //dump it all in the last one
					$aNetQty{$i}:=$aNetQty{$i}+$qty
					
				Else 
					$qtyOpen:=$aPlnQty{$i}-$aNetQty{$i}
					Case of 
						: ($qtyOpen>=$qty)  //take it all
							$aNetQty{$i}:=$aNetQty{$i}+$qty
							$qty:=0
							
						: ($qtyOpen>0)  //take up to planned
							$aNetQty{$i}:=$aNetQty{$i}+$qtyOpen
							$qty:=$qty-$qtyOpen
					End case 
				End if 
				$i:=$i+1
			End while 
			ARRAY TO SELECTION:C261($aNetQty; [Job_Forms_Items:44]Qty_Good:10; $aActQty; [Job_Forms_Items:44]Qty_Actual:11)
		End if   //subforms  
	End if 
End for 

USE NAMED SELECTION:C332("holdJMI")
//APPLY TO SELECTION([JobMakesItem];[JobMakesItem]Qty_Good:=JOB_CalcNetProduced )
If (Records in selection:C76([Job_Forms_Items:44])>0)
	[Job_Forms:42]QtyActProduced:35:=Sum:C1([Job_Forms_Items:44]Qty_Good:10)
Else 
	[Job_Forms:42]QtyActProduced:35:=0
End if 

USE NAMED SELECTION:C332("holdJMI")
//APPLY TO SELECTION([JobMakesItem];[JobMakesItem]Qty_Actual:=JOB_CalcQtyGlued )
If (Records in selection:C76([Job_Forms_Items:44])>0)
	[Job_Forms:42]ActualGluedQty:53:=Sum:C1([Job_Forms_Items:44]Qty_Actual:11)
Else 
	[Job_Forms:42]ActualGluedQty:53:=0
End if 

USE NAMED SELECTION:C332("holdJMI")
CLEAR NAMED SELECTION:C333("holdJMI")

If (([Job_Forms:42]QtyActProduced:35#0) & ([Job_Forms:42]ActFormCost:13#0))
	[Job_Forms:42]ActCost_M:41:=uNANCheck(Round:C94(([Job_Forms:42]ActFormCost:13/[Job_Forms:42]QtyActProduced:35)*1000; 2))
Else 
	[Job_Forms:42]ActCost_M:41:=0
End if 