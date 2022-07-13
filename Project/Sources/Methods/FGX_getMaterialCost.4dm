//%attributes = {"executedOnServer":true}
// _______
// Method: FGX_getMaterialCost   ( fgx entity selection ; invoice entity) -> total material cost
// By: MelvinBohince @ 05/03/22, 15:40:26
// Description
//calculate the actual materials cost for an invoice's shipment
//
//with that, the realized throughput can be calculate as sales less
//material without the noise of adding variable overhead and 
//estimated labor. While higher is better, it is important also to look at TP 
//on a per unit to see that smaller orders may be better per unit.
// ----------------------------------------------------
// Modified by: MelvinBohince (5/17/22) rename and refactor using FGX_extendCost

C_TEXT:C284($orderLineRelease_t; $jobForm_t)
C_OBJECT:C1216($invoice_e; $jobitCostCache_o; $fgx_es; $1)
C_COLLECTION:C1488($invoiceJobits_c; $jobits_c; $shippedJobs_c)
C_REAL:C285($0; $cogsMatl; $errorMarkerNoTransactions)

$errorMarkerNoTransactions:=0.01

$cogsMatl:=$errorMarkerNoTransactions  // this is what we are trying to find

If (Count parameters:C259>0)
	$fgx_es:=$1
	$invoice_e:=$2
	
Else   //test
	//a shipment
	$invoice_e:=ds:C1482.Customers_Invoices.query("InvoiceNumber = 380176").first()
	$orderLineRelease_t:=$invoice_e.OrderLine+"/"+String:C10($invoice_e.ReleaseNumber)
	$fgx_es:=ds:C1482.Finished_Goods_Transactions.query("OrderItem = :1"; $orderLineRelease_t)
	$assert:=1089.92
	//a return:
	//$invoice_e:=ds.Customers_Invoices.query("InvoiceNumber = 384171").first()
	//$orderLineRelease_t:=[Customers_Invoices]OrderLine+"@"
	//$rgaStringPosition:=Position("RGA#R";$invoice_e.InvComment)
	//$rga:=Substring($invoice_e.InvComment;$rgaStringPosition;9)
	//$fgx_es:=ds.Finished_Goods_Transactions.query("OrderItem = :1 and ReasonNotes = :2";$orderLineRelease_t;$rga)
	//$assert:=1392.29
End if 


If ($fgx_es.length>0)
	
	//get the FORMS in play and do the material allocation on actual issues
	$shippedJobs_c:=$fgx_es.toCollection().distinct("JobForm")  //do each form once
	
	For each ($jobForm_t; $shippedJobs_c)  //cost the jobits and cache the result
		
		//get the total material costs issued to the job 
		$materialCost:=Job_getActualMaterialCost($jobForm_t; $invoice_e.ExtendedPrice)
		
		//and allocate to items in perM
		$jobits_c:=JMI_allocateCostPerM($jobForm_t; $materialCost; "Cost_Mat")
		
		//cache that by jobit so it can be used when going thru the invoice's transactions
		$jobitCostCache_o:=JMI_buildDictionary($jobitCostCache_o; $jobits_c; "Cost_Mat")
		
	End for each 
	
	//for each jobit that shipped, find the sum of its extended material cost 
	$cogsMatl:=FGX_extendCost($fgx_es; $jobitCostCache_o)
	
End if 

$0:=$cogsMatl
