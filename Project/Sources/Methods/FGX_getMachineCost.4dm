//%attributes = {"executedOnServer":true}
// _______
// Method: FGX_getMachineCost   ( fgx entity selection) -> total machine oop cost
// By: MelvinBohince @ 05/09/22, 13:52:46
// Description
//calculate the actual machine cost for an invoice's shipment
// ----------------------------------------------------
// Modified by: MelvinBohince (5/17/22) rename and refactor using FGX_extendCost

C_TEXT:C284($orderLineRelease_t; $jobItem_t)
C_OBJECT:C1216($invoice_e; $jobitCostCache_o; $fgx_es; $1)
C_COLLECTION:C1488($invoiceJobits_c; $jobits_c; $shippedJobits_c)
C_REAL:C285($0; $cogsOOP; $errorMarkerNoTransactions)

$errorMarkerNoTransactions:=0.01
$cogsOOP:=$errorMarkerNoTransactions  // this is what we are trying to find

If (Count parameters:C259>0)
	$fgx_es:=$1
	
Else   //test
	$invoice_e:=ds:C1482.Customers_Invoices.query("InvoiceNumber = 380176").first()
	$orderLineRelease_t:=$invoice_e.OrderLine+"/"+String:C10($invoice_e.ReleaseNumber)
	$fgx_es:=ds:C1482.Finished_Goods_Transactions.query("OrderItem = :1"; $orderLineRelease_t)
End if 

If ($fgx_es.length>0)
	
	//get the jobs in play and do the machine allocation on actual hours
	//$shippedJobForms_c:=$fgx_es.toCollection().distinct("JobForm")  //do each form once
	
	//For each ($jobForm_t;$shippedJobForms_c)
	//$sheetLevelOOP:=Job_getProductionCost ($jobForm_t+".00")  //don't get item level stuff
	//$jobits_c:=JMI_allocateCostPerM ($jobForm_t;$sheetLevelOOP;"Cost_Burd")
	//$jobitCostCache_o:=JMI_buildDictionary ($jobitCostCache_o;$jobits_c;"Cost_Burd")
	//End for each 
	
	
	//now get the ITEMS in play and get their gluing/windowing costs
	$shippedJobits_c:=$fgx_es.toCollection().distinct("Jobit")  //do each form once
	
	For each ($jobItem_t; $shippedJobits_c)  //cost the jobits and cache the result
		
		//get the total item costs issued to the job 
		$allocatedMachine:=Job_getProductionCost($jobItem_t)
		
		//and allocate to items in perM
		$jobForm:=Substring:C12($jobItem_t; 1; 8)
		$jobits_c:=JMI_allocateCostPerM($jobForm; $allocatedMachine; "Cost_Burd")
		
		//cache that by jobit so it can be used when going thru the invoice's transactions
		$jobitCostCache_o:=JMI_buildDictionary($jobitCostCache_o; $jobits_c; "Cost_Burd")
		
	End for each 
	
	//for each jobit that shipped, find the sum of its extended machine hour rate cost 
	$cogsOOP:=FGX_extendCost($fgx_es; $jobitCostCache_o)
	
End if 

$0:=$cogsOOP
