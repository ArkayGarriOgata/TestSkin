//%attributes = {}
// _______
// Method: INV_openActualsPage   ( ) ->
// By: MelvinBohince @ 05/11/22, 10:33:25
// Description
// while sitting on an invoice record, calculate actual material to be allocated
// and display the results on the input form
// ----------------------------------------------------
// Modified by: MelvinBohince (5/13/22) deal with returns
// Modified by: MelvinBohince (5/17/22) refactor

C_TEXT:C284($orderLineRelease_t)
C_REAL:C285(materialCost; autoCostPerInvoice; autoCostPerBudget)
C_OBJECT:C1216(materials_es; jmi_es; fgx_es)
C_COLLECTION:C1488($shippedJobForms_c)
//init's
//empty the list boxes
materials_es:=ds:C1482.Raw_Materials_Transactions.newSelection()
machTic_es:=ds:C1482.Job_Forms_Machine_Tickets.newSelection()
fgx_es:=ds:C1482.Finished_Goods_Transactions.newSelection()
jmi_es:=ds:C1482.Job_Forms_Items.newSelection()
resultsObject:=New object:C1471  // Modified by: MelvinBohince (5/17/22) refactor, use object to hold resulting calculations
resultsObject.materialCost:=0  //in LB footer, based on which jobform is selected in the LB, doesn't include auto issues
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
resultsObject.autoCostPerInvoice:=Abs:C99([Customers_Invoices:88]ExtendedPrice:19*(<>Auto_Ink_Percent+<>Auto_Coating_Percent+<>Auto_Corr_Percent))  //this will be static, abs so returns don't negate
If ([Customers_Invoices:88]ExtendedPrice:19>0)  //a shipment (remember =1 has been excluded from the selection
	resultsObject.setSignForShipOrReturn:=1  //transactions are always positive
Else 
	resultsObject.setSignForShipOrReturn:=-1
End if 
resultsObject.jobitsInvoiceCoGS:=0.01

//find jobits in play from the transactions

Case of 
	: ([Customers_Invoices:88]Quantity:15>1)  //shipment
		$orderLineRelease_t:=[Customers_Invoices:88]OrderLine:4+"/"+String:C10([Customers_Invoices:88]ReleaseNumber:5)
		
		fgx_es:=ds:C1482.Finished_Goods_Transactions.query("OrderItem = :1"; $orderLineRelease_t)
		
	: ([Customers_Invoices:88]Quantity:15<0)  // Modified by: MelvinBohince (5/13/22) deal with returns
		$orderLineRelease_t:=[Customers_Invoices:88]OrderLine:4+"@"
		$rgaStringPosition:=Position:C15("RGA#R"; [Customers_Invoices:88]InvComment:12)
		$rga:=Substring:C12([Customers_Invoices:88]InvComment:12; $rgaStringPosition; 9)
		fgx_es:=ds:C1482.Finished_Goods_Transactions.query("OrderItem = :1 and ReasonNotes = :2"; $orderLineRelease_t; $rga)
		
	Else   //special billing, cost is arbitrary or 0
		//pass use empty fgx_es
End case 

$shippedJobits_c:=fgx_es.toCollection().distinct("Jobit")

//load the jobits into a LB
If ($shippedJobits_c.length>0)
	jmi_es:=ds:C1482.Job_Forms_Items.query("Jobit in :1 and Qty_Want > 1"; $shippedJobits_c).orderBy("Jobit")  //wantqty of 1 are normally killed and mess up results
	If (jmi_es.length=1)  //load it up
		jmi_e:=jmi_es.first()
		<>jobform:=jmi_e.JobForm
		INV_openActualsPageLoadJMI(resultsObject)
	End if 
End if 
