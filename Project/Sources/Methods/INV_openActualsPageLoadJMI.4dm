//%attributes = {}
// _______
// Method: INV_openActualsPageLoadJMI   ( ) ->
// By: MelvinBohince @ 05/11/22, 10:36:59
// Description
// called by INV_openActualsPage and Onclick in LB

// calculate the material costs for the jobit's form
// then allocate it to the jobit in a per thousand (perM)
// value, then show what portion this invoice's qty gets.
//IF there are multiple jobits in play they would need
// to be sum'ed
//
// this would be called in OnLoad if one jobit in play
//OTHERWISE, the jobit would need clicked in the ListBox
// ----------------------------------------------------


C_OBJECT:C1216(materials_es; $budgetAuto_es; $fgxQty_es; $1; resultsObject)
//init calculated values
materials_es:=ds:C1482.Raw_Materials_Transactions.newSelection()
machTic_es:=ds:C1482.Job_Forms_Machine_Tickets.newSelection()
resultsObject.materialCost:=0
footerMaterialCosts:=resultsObject.materialCost
resultsObject.materialWithAutoInvoice:=0
resultsObject.allocatedMaterial:=0
resultsObject.autoCostPerJobBudget:=0
resultsObject.budMaterialWithAutoInvoice:=0
resultsObject.allocatedMaterialPerM:=0
resultsObject.allocatedInvoiceMaterial:=0
resultsObject.allocatedInvoiceMachine:=0
footerMachineCosts:=resultsObject.allocatedInvoiceMachine
footerMachineHours:=0
resultsObject.basisQty:=0
resultsObject.jobitsInvoiceCoGS:=0.01

If (jmi_e#Null:C1517)  //jobit has been selected
	$allocPct:=(jmi_e.AllocationPercent/100)
	$jobForm:=Substring:C12(jmi_e.JobForm; 1; 8)
	<>jobform:=$jobForm
	//determine the basis for the jobit's perM
	$productionQty:=Choose:C955(jmi_e.Qty_Good=0; jmi_e.Qty_Actual; jmi_e.Qty_Good)  //good not available until Closed
	resultsObject.basisQty:=Choose:C955(jmi_e.Qty_Want<$productionQty; jmi_e.Qty_Want; $productionQty)  //use the lessor of want or good
	resultsObject.basisQty:=Choose:C955(resultsObject.basisQty=0; jmi_e.Qty_Want; resultsObject.basisQty)  //don't use 0
	
	//determine how many of this jobit shipped for the invoice's perM
	$fgxQty_es:=fgx_es.query("Jobit = :1"; jmi_e.Jobit)
	If ($fgxQty_es.length>0)
		$qtyOfThisJobit:=$fgxQty_es.sum("Qty")
	Else 
		$qtyOfThisJobit:=0
	End if 
	
	//get the materials issued to the job, excluding any auto issue which would have been for the entire Jobform and all its items
	materials_es:=ds:C1482.Raw_Materials_Transactions.query("JobForm = :1 and Xfer_Type =:2 and Raw_Matl_Code # :3"; $jobForm; "Issue"; "AutoIssue@")
	If (materials_es.length>0)
		resultsObject.materialCost:=Round:C94(materials_es.sum("ActExtCost")*-1; 2)
		footerMaterialCosts:=resultsObject.materialCost
		//now add it auto materials from a individual invoice basis
		resultsObject.materialWithAutoInvoice:=resultsObject.materialCost+resultsObject.autoCostPerInvoice  //material cost adjusted by invoice's selling price
		//$test:=Job_getActualMaterialCost ($jobForm;[Customers_Invoices]ExtendedPrice)
		
		//how much material cost to this jobit
		resultsObject.allocatedMaterial:=resultsObject.materialWithAutoInvoice*$allocPct  //how much of ttl matl of this job belongs to this jobit
		//calc perM for the jobit
		resultsObject.allocatedMaterialPerM:=Round:C94(resultsObject.allocatedMaterial/resultsObject.basisQty*1000; 2)
		//calc perM for the invoice
		
		resultsObject.allocatedInvoiceMaterial:=resultsObject.allocatedMaterialPerM*$qtyOfThisJobit/1000*resultsObject.setSignForShipOrReturn
		
		//just for comparison with job's selling price to obtain auto issues
		$budgetAuto_es:=ds:C1482.Raw_Materials_Transactions.query("JobForm = :1 and Xfer_Type =:2 and Raw_Matl_Code = :3"; $jobForm; "Issue"; "AutoIssue@")
		If ($budgetAuto_es.length>0)
			resultsObject.autoCostPerJobBudget:=Round:C94($budgetAuto_es.sum("ActExtCost")*-1; 2)
			resultsObject.budMaterialWithAutoInvoice:=materialCost+resultsObject.autoCostPerJobBudget
		End if 
	End if 
	
	//get the machine costs
	//[Job_Forms_Machine_Tickets]CostCenterID
	resultsObject.machineCosts:=0
	resultsObject.machineHours:=0
	$jobit:=jmi_e.Jobit
	$jobform:=Substring:C12($jobit; 1; 8)+".00"
	$sheetMT_es:=ds:C1482.Job_Forms_Machine_Tickets.query("Jobit = :1 "; $jobform)
	$itemsMT_es:=ds:C1482.Job_Forms_Machine_Tickets.query("Jobit = :1 "; $jobit)
	machTic_es:=$sheetMT_es.or($itemsMT_es).orderBy("JobFormSeq,Jobit")
	//machTic_es:=ds.Job_Forms_Machine_Tickets.query("JobForm = :1";$jobForm).orderBy("JobFormSeq,Jobit")
	If (machTic_es.length>0)
		
		C_OBJECT:C1216($machineTicket_e)
		$sheetCosts:=0
		$glueCosts:=0
		For each ($machineTicket_e; machTic_es)
			//extend its cost by multiplying its MR and Run Hours by it's standards out-of-pocket Machine hour rate
			$hrs:=$machineTicket_e.MR_Act+$machineTicket_e.Run_Act
			resultsObject.machineHours:=resultsObject.machineHours+$hrs
			$mhr:=CostCtrCurrent("oop"; $machineTicket_e.CostCenterID)
			If ($machineTicket_e.GlueMachItemNo=0)
				$sheetCosts:=$sheetCosts+($hrs*$mhr)
			Else 
				$glueCosts:=$glueCosts+($hrs*$mhr)
			End if 
		End for each 
		
		footerMachineHours:=resultsObject.machineHours
		
		resultsObject.machineCosts:=$sheetCosts+$glueCosts
		footerMachineCosts:=resultsObject.machineCosts
		
		resultsObject.allocatedMachine:=($sheetCosts*$allocPct)+$glueCosts
		
		//calc perM for the jobit
		resultsObject.allocatedMachinePerM:=Round:C94(resultsObject.allocatedMachine/resultsObject.basisQty*1000; 2)
		
		//calc perM for the invoice
		resultsObject.allocatedInvoiceMachine:=resultsObject.allocatedMachinePerM*$qtyOfThisJobit/1000*resultsObject.setSignForShipOrReturn
		
	End if 
	
	resultsObject.jobitsInvoiceCoGS:=resultsObject.allocatedInvoiceMaterial+resultsObject.allocatedInvoiceMachine
	
End if 

