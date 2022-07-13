//%attributes = {}
// _______
// Method: FGX_backFillShipment   ($rel_o;$bol_o;$inv_o ) ->
// By: Mel Bohince @ 04/21/21, 13:07:05
// Description
// reconstruct a FG transaction for Release record based on the
// data from a release and invoice
// based on method BOL_ExecuteShipment which normally creates the transaction record
// ----------------------------------------------------
C_OBJECT:C1216($rel_o; $1; $inv_o)
C_BOOLEAN:C305($0)

If (Count parameters:C259>0)
	$rel_o:=$1  //you should be looping thru a release entity selection
	
Else   //testing
	$testReleaseNumber:=4802962
	$rel_o:=ds:C1482.Customers_ReleaseSchedules.query("ReleaseNumber = :1 "; $testReleaseNumber).first()
	If ($rel_o=Null:C1517)
		ALERT:C41("Nope, release "+String:C10($testReleaseNumber)+" not found")
	End if 
End if 

If ($rel_o.CUST_INVOICES=Null:C1517)  //make sure release has an invoice
	ALERT:C41("Nope, no invoice for release "+String:C10($testReleaseNumber)+",  -1 used for CoGS_FiFo, PricePerUnit, & ExtendedPrice ")
	$inv_o:=New object:C1471("CoGS_FiFo"; -1; "PricePerUnit"; -1; "ExtendedPrice"; -1)
Else 
	$inv_o:=$rel_o.CUST_INVOICES.first()
End if 

//things that can't be gotten
C_TEXT:C284($aJobit2; $aLocation2; $aPallet2)
C_LONGINT:C283($aRecNo2)
$aJobit2:=""  //?
$aLocation2:="Reconstructed"
$aRecNo2:=-1
$aPallet2:=""

$aTransactionID:=FGX_NewFG_Transaction("Ship"; $rel_o.Actual_Date; "FiX"; ?00:00:01?)
[Finished_Goods_Transactions:33]ProductCode:1:=$rel_o.ProductCode

[Finished_Goods_Transactions:33]JobNo:4:=Substring:C12($aJobit2; 1; 5)
[Finished_Goods_Transactions:33]JobForm:5:=Substring:C12($aJobit2; 1; 8)
[Finished_Goods_Transactions:33]JobFormItem:30:=Num:C11(Substring:C12($aJobit2; 10; 2))

[Finished_Goods_Transactions:33]Location:9:="Customer"
[Finished_Goods_Transactions:33]viaLocation:11:=$aLocation2
[Finished_Goods_Transactions:33]LocationFromRecNo:23:=$aRecNo2
[Finished_Goods_Transactions:33]Qty:6:=$rel_o.Actual_Qty
[Finished_Goods_Transactions:33]Skid_number:29:=$aPallet2
[Finished_Goods_Transactions:33]ActionTaken:27:="BOL# "+String:C10($rel_o.B_O_L_number)

$orderline:=$rel_o.OrderLine
[Finished_Goods_Transactions:33]OrderNo:15:=Substring:C12($orderline; 1; 5)
[Finished_Goods_Transactions:33]OrderItem:16:=$orderline+"/"+String:C10($rel_o.ReleaseNumber)

[Finished_Goods_Transactions:33]Reason:26:=$rel_o.RemarkLine1
[Finished_Goods_Transactions:33]CustID:12:=$rel_o.CustID

If ([Customers_Bills_of_Lading:49]PayUseFlag:11=1)
	[Finished_Goods_Transactions:33]Location:9:="FG:AV"  //+FG_Get_PayUse_Bin_Prefix ([Customers_Bills_of_Lading]ShipTo)+"#"+String([Customers_Bills_of_Lading]ShippersNo)
	[Finished_Goods_Transactions:33]XactionType:2:="Move"
End if 

[Finished_Goods_Transactions:33]CoGSExtended:8:=$inv_o.CoGS_FiFo
[Finished_Goods_Transactions:33]CoGS_M:7:=[Finished_Goods_Transactions:33]CoGSExtended:8/[Finished_Goods_Transactions:33]Qty:6*1000

[Finished_Goods_Transactions:33]PricePerM:19:=$inv_o.PricePerUnit
[Finished_Goods_Transactions:33]ExtendedPrice:20:=$inv_o.ExtendedPrice
SAVE RECORD:C53([Finished_Goods_Transactions:33])