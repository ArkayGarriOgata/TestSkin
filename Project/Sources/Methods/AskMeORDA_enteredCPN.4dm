//%attributes = {}
// _______
// Method: AskMeORDA_enteredCPN   ( ) ->
// By: Mel Bohince @ 09/27/19, 08:59:58
// Description
// gather related records and display in list boxes
// ----------------------------------------------------

C_TEXT:C284($1; sCPN)
sCPN:=$1

C_OBJECT:C1216($productCodes; $orderLines; $releases; $inventory; $jobItems; $transactions; $form_o)
$form_o:=New object:C1471
//  [Finished_Goods]pk_id
//[Customers_Order_Lines]ProductCode
//[Customers_ReleaseSchedules]ProductCode
//[Finished_Goods_Locations]ProductCode
//[Job_Forms_Items]ProductCode
//[Finished_Goods_Transactions]ProductCode
$productCodes:=ds:C1482.Finished_Goods.query("ProductCode = :1"; sCPN)
$continue:=False:C215
Case of 
	: ($productCodes.length=0)
		uConfirm(sCPN+" was not found, please try again."; "Reset"; "Edit")
		If (ok=1)
			sCPN:=""
		Else 
			sCPN:=sCPN+"?"
		End if 
		
	: ($productCodes.length>1)  //pick which customer's to display
		//TODO
		
		//C_OBJECT($form_o)
		//$form_o:=New object
		//$form_o.productCodeChoices:=$productCodes
		
		//$winRef:=OpenFormWindow (->[Job_Forms_Items];"PickCPNFromList")
		//DIALOG([Job_Forms_Items];"PickCPNFromList";$form_o)
		//$productCodes:=ds.Finished_Goods.query("ProductCode = :1";sCPN)
		//If ($productCodes.length=1)
		//$continue:=True
		//Else 
		//uConfirm (sCPN+" was not found, please try again.";"Ok";"Help")
		//sCPN:=""
		//End if 
		
		
	Else 
		$continue:=True:C214
End case 

If ($continue)  //get the entity collections
	//TODO
	C_OBJECT:C1216($productCode)
	C_TEXT:C284($primaryKey)  //;sCustName;sBrand;sDesc)
	
	$fgKey:=sCustID+":"+sCPN
	$hit:=Find in array:C230(<>aAskMeHistory; $fgKey)
	AskMeHistory("Save"; $fgKey)  // Added by: Mark Zinke (12/12/12)
	If ($hit=-1)
		INSERT IN ARRAY:C227(<>aAskMeHistory; 1; 1)
		<>aAskMeHistory{1}:=$fgKey
	End if 
	
	$productCode:=$productCodes[0]
	$primaryKey:=$productCode.pk_id
	sCustName:=$productCode.Customer.Name
	sBrand:=$productCode.Line_Brand
	sDesc:=$productCode.CartonDesc
	//push sCPN onto history collection with its pKey
	
	//$orderLines:=ds.Job_Forms_Items.query("ProductCode = :1";sCPN).orderBy("Jobit asc")
	//$releases:=ds.Job_Forms_Items.query("ProductCode = :1";sCPN).orderBy("Jobit asc")
	//$inventory:=ds.Job_Forms_Items.query("ProductCode = :1";sCPN).orderBy("Jobit asc")
	//$jobItems:=ds.Job_Forms_Items.query("ProductCode = :1";sCPN).orderBy("Jobit asc")
	//$transactions:=ds.Job_Forms_Items.query("ProductCode = :1";sCPN).orderBy("Jobit asc")
	
	C_COLLECTION:C1488($orderLines_col; $filter; $totals_col)
	
	$filter:=New collection:C1472()
	$filter.push("Quantity")
	$filter.push("Qty_Open")
	$filter.push("Status")
	
	$totals_col:=$productCode.ORDER_LINES.toCollection($filter)
	qty_Ordered:=0
	qty_StillOpen:=0
	For each ($item; $totals_col)
		qty_Ordered:=qty_Ordered+$item.Quantity
		If (Position:C15($item.Status; " Closed Cancel")=0)
			If ($item.Qty_Open>0)
				qty_StillOpen:=qty_StillOpen+$item.Qty_Open
			End if 
		End if 
	End for each 
	$totals_col.clear()
	
	Form:C1466.orderLines:=$productCodes.ORDER_LINES.orderBy("DateOpened desc")
	
	$filter.clear()
	$filter.push("Sched_Qty")
	$filter.push("Actual_Qty")
	$filter.push("CustomerRefer")
	$totals_col:=$productCode.RELEASES.toCollection($filter)
	qty_Firm:=0
	qty_Forecast:=0
	qty_Shipped:=0
	C_OBJECT:C1216($item)
	For each ($item; $totals_col)
		If (Substring:C12($item.CustomerRefer; 1; 1)="<")  //forecast
			qty_Forecast:=qty_Forecast+$item.Sched_Qty
		Else 
			qty_Firm:=qty_Firm+$item.Sched_Qty
		End if 
		If ($item.Actual_Qty>0)
			qty_Shipped:=qty_Shipped+$item.Actual_Qty
		End if 
	End for each 
	$totals_col.clear()
	
	Form:C1466.releases:=$productCodes.RELEASES.orderBy("Sched_Date desc")
	Form:C1466.inventory:=$productCodes.LOCATIONS.orderBy("Location asc")
	Form:C1466.jobItems:=$productCodes.JOB_ITEMS.orderBy("Jobit asc")
	Form:C1466.transactions:=$productCodes.TRANSACTIONS.orderBy("transactionDateTime desc")
	//$form_o.releases:=$releases
	//$form_o.inventory:=$inventory
	//$form_o.jobItems:=$jobItems
	//$form_o.transactions:=$transactions
End if 