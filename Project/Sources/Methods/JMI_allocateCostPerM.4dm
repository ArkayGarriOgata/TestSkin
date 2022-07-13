//%attributes = {"executedOnServer":true}
// _______
// Method: JMI_allocateCostPerM   (jobForm; cost; field) -> collection of jobits with cost
// By: MelvinBohince @ 05/03/22, 14:09:13
// Description
// allocate cost to specified field as a costPerM
//see also Job_CalcAllocPercent
// ----------------------------------------------------
// Modified by: MelvinBohince (5/13/22) exclude if not Qty_Want > 1

C_COLLECTION:C1488($0; $jobits_c)
C_OBJECT:C1216($jobit_o)
C_REAL:C285($costToAllocate; $2; $costAllocatedToThisItem; $perM)
C_TEXT:C284($field)
C_LONGINT:C283($basisQty)

If (Count parameters:C259>0)
	$jobForm_t:=$1
	$costToAllocate:=$2
	$field:=$3
Else 
	$jobForm_t:="18378.01"
	$costToAllocate:=1886
	$field:="Cost_Mat"
End if 

$jobits_c:=ds:C1482.Job_Forms_Items.query("JobForm = :1 and Qty_Want >1"; $jobForm_t).toCollection("Jobit, Qty_Want, Qty_Actual, Qty_Good, AllocationPercent, "+$field)

For each ($jobit_o; $jobits_c)  //see Est_FormCartonAllocation and JOB_getItemBudget
	If (Position:C15("Cost_Mat"; $field)>0)
		$costAllocatedToThisItem:=$jobit_o.AllocationPercent/100*$costToAllocate  //total cost allocated to this item
	Else   //Cost_Burd already allocated sheet operations and added item operations
		$costAllocatedToThisItem:=$costToAllocate
	End if 
	
	$productionQty:=Choose:C955($jobit_o.Qty_Good=0; $jobit_o.Qty_Actual; $jobit_o.Qty_Good)  //good not available until Closed
	$basisQty:=Choose:C955($jobit_o.Qty_Want<$productionQty; $jobit_o.Qty_Want; $productionQty)  //use the lessor of want or good
	$basisQty:=Choose:C955($basisQty=0; $jobit_o.Qty_Want; $basisQty)  //don't use 0
	
	$perM:=Round:C94($costAllocatedToThisItem/$basisQty*1000; 2)
	
	If ($basisQty>0)
		$jobit_o[$field]:=$perM
	Else 
		$jobit_o[$field]:=0
	End if 
	
End for each 

$0:=$jobits_c

If (Count parameters:C259=0)
	$backTest:=0
	For each ($jobit_o; $jobits_c)
		$backTest:=$backTest+($jobit_o.Qty_Want*$jobit_o[$field]/1000)
	End for each 
	
	If (Round:C94($backTest; 0)#Round:C94($costToAllocate; 0))
		ALERT:C41("Failed backtest")
	End if 
End if 
