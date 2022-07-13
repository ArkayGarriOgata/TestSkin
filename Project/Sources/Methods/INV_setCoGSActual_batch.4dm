//%attributes = {"executedOnServer":true}
// _______
// Method: INV_setCoGSActual_batch   ( 1 = init ) ->
// By: MelvinBohince @ 05/12/22, 14:42:10
// Description
//Calculate each invoice's CoGS_Actual and CoGS_Material in the current fiscal year 
//  which hasn’t previously been calculated, as the sum of:
//    gather it’s Ship transactions, get the actual cost per thousand of their related jobits
//    and extend the transaction’s qty by the per thousand cost of the jobit. 
// Assumptions:
// 1) the auto issues are recalculated based on the Invoices actual selling price, not the Job's estimated selling price
// 2) all of the sheet uom operations costs are.... included, only the specific item's carton uom is included in oop costs
// 3) the BASIS quantity used in per unit calculations is the lessor Want or Good, when Good is 0, use Actual produced is compared to Want
// 4) the BASIS quantity must be a value greater than 0, otherwise want is used (? it was Killed or auto-Completed if <10 ?)
// 5) O/S diecut, glue, etc will be issued prior to shipping, (normally the direct bill is received when the materials are received)


// ----------------------------------------------------
// Modified by: MelvinBohince (5/17/22) refactor and chg to Execute on server
ON ERR CALL:C155("e_ExeOnServerError")

C_LONGINT:C283($pid; $1; $i)
C_DATE:C307($dateBegin)
C_OBJECT:C1216($invoice_e; $invoices_es; $fgx_es; $status_o)
C_REAL:C285($machineCost; $materialCost)
C_TEXT:C284($orderLineRelease_t)

If (Count parameters:C259=0)  //testing
	$pid:=New process:C317(Current method name:C684; 0; Current method name:C684; 1; *)
	SHOW PROCESS:C325($pid)
	
Else   //init
	//put the work here
	$dateBegin:=Date:C102(FiscalYear("start"; Current date:C33))
	//only looking for invoice which havn't been previously calculated and are not Special Billing (qty=1, rarely is their cost known)
	$invoices_es:=ds:C1482.Customers_Invoices.query("Invoice_Date >= :1 and CoGS_Actual = :2 and Quantity # :3"; $dateBegin; 0; 1)  //qty = 1 on spl billings which normally havn't a cost provided
	//tests:
	//$invoices_es:=ds.Customers_Invoices.query("InvoiceNumber = 382058")
	//$invoices_es:=ds.Customers_Invoices.query("InvoiceNumber = 384171")  //a return
	
	uThermoInit($invoices_es.length; "Calc CoGS Actuals")
	$i:=0  //unused if run on server
	
	For each ($invoice_e; $invoices_es)
		$i:=$i+1  //unused if run on serve
		
		Case of 
			: ($invoice_e.Quantity>0)  //a shipment (remember =1 has been excluded from the selection
				$setSignForShipOrReturn:=1  //transactions are always positive
				//use OrderItem field to find ship transactions for this invoice
				$orderLineRelease_t:=$invoice_e.OrderLine+"/"+String:C10($invoice_e.ReleaseNumber)
				//get the ship transaction so the participating jobits can be found
				$fgx_es:=ds:C1482.Finished_Goods_Transactions.query("OrderItem = :1"; $orderLineRelease_t)
				
			: ($invoice_e.Quantity<0)  //a return, use the RGA because there's no release to key off of
				$setSignForShipOrReturn:=-1  //transactions are always positive
				$orderLineRelease_t:=[Customers_Invoices:88]OrderLine:4+"@"
				$rgaStringPosition:=Position:C15("RGA#R"; $invoice_e.InvComment)
				$rga:=Substring:C12($invoice_e.InvComment; $rgaStringPosition; 9)
				$fgx_es:=ds:C1482.Finished_Goods_Transactions.query("OrderItem = :1 and XactionType = :2  and ReasonNotes = :3"; $orderLineRelease_t; "Return"; $rga)
				
			Else   //should not happen based on starting invoice selection
				$fgx_es:=ds:C1482.Finished_Goods_Transactions.newSelection()
		End case   //qty + or -
		
		$materialCost:=FGX_getMaterialCost($fgx_es; $invoice_e)*$setSignForShipOrReturn
		
		$machineCost:=FGX_getMachineCost($fgx_es)*$setSignForShipOrReturn
		
		$invoice_e.CoGS_Material:=$materialCost
		$invoice_e.CoGS_Actual:=$materialCost+$machineCost
		$status_o:=$invoice_e.save()
		If ($status_o.success)
			utl_Logfile("cogs_actuals.log"; "Invoice#: "+String:C10($invoice_e.InvoiceNumber)+" saved SUCCESSFULLY")
		Else 
			utl_Logfile("cogs_actuals.log"; "Invoice#: "+String:C10($invoice_e.InvoiceNumber)+" FAILED")
		End if 
		
		uThermoUpdate($i)
	End for each 
	uThermoClose
	//BEEP
	
End if   //param

ON ERR CALL:C155("")
