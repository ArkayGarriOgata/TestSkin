//%attributes = {"executedOnServer":true}
// _______
// Method: Job_getProductionCost   ( jobit ) -> cost ∑(hrs*oop$)
// By: MelvinBohince @ 05/09/22, 14:33:24
// Description
// see Job_getProductionStats, INV_openActualsPageLoadJMI
// ----------------------------------------------------
// find the actual production hours consumed by a job and then cost it
// ----------------------------------------------------
// Modified by: MelvinBohince (5/13/22) exclude if not Qty_Want > 1

C_TEXT:C284($jobit; $1)
C_OBJECT:C1216($sheetMT_es; $itemsMT_es; $machTic_es; $machineTicket_e; $jmi_e)
C_REAL:C285($machineTicketHours; $0; $cost)

If (Count parameters:C259>0)
	$jobit:=$1
Else 
	$jobit:="18378.01.06"
	//$jobit:="18378.01.00"
End if 

$allocatedMachineCosts:=0

//need the qty and alloc% from the jmi
$jmi_e:=ds:C1482.Job_Forms_Items.query("Jobit = :1 and Qty_Want > 1"; $jobit).first()  // Modified by: MelvinBohince (5/13/22) 
If ($jmi_e#Null:C1517)  //invalid jobit because want qty was 1
	$allocPct:=$jmi_e.AllocationPercent/100
	
	//get selections of the sheet based operations and the item based operations to tally separately
	$jobform:=Substring:C12($jobit; 1; 8)+".00"
	$sheetMT_es:=ds:C1482.Job_Forms_Machine_Tickets.query("Jobit = :1 "; $jobform)  //sheet operations, excluding unwanted jobits sequences
	$itemsMT_es:=ds:C1482.Job_Forms_Machine_Tickets.query("Jobit = :1 "; $jobit)  //carton operations specific to this jobit
	//combine,  this way sibling jobits are not included
	$machTic_es:=$sheetMT_es.or($itemsMT_es).orderBy("JobFormSeq,Jobit")  //all the tickets
	
	If ($machTic_es.length>0)
		
		$machineCosts:=0
		$machineHours:=0
		$allocatedMachineCosts:=0
		$sheetCosts:=0
		$glueCosts:=0
		For each ($machineTicket_e; $machTic_es)
			//extend its cost by multiplying its MR and Run Hours by it's standards out-of-pocket Machine hour rate
			$hrs:=$machineTicket_e.MR_Act+$machineTicket_e.Run_Act
			$machineHours:=$machineHours+$hrs
			$mhr:=CostCtrCurrent("oop"; $machineTicket_e.CostCenterID)
			If ($machineTicket_e.GlueMachItemNo=0)
				$sheetCosts:=$sheetCosts+($hrs*$mhr)
			Else 
				$glueCosts:=$glueCosts+($hrs*$mhr)
			End if 
		End for each 
		
		//sheet based is allocated to this item, and all the item based are included
		$allocatedMachineCosts:=($sheetCosts*$allocPct)+$glueCosts  //all of the gluing, part of the sheet operations
		
	End if 
	
Else 
	
End if 

$0:=$allocatedMachineCosts
