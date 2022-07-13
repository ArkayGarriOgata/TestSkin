//%attributes = {}
// _______
// Method: _version20210502   ( ) ->
// By: Garri Ogata @ 05/02/21 @ 08:00 AM
// Description
//  Create ship record for infamous 81301 order because "OPEN FILE" dialog does not work with 4D v17
// ----------------------------------------------------

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($eFinishedGoodsTransactions)
	
	C_OBJECT:C1216($oSaveResult)
	
	C_TEXT:C284($tQuery)
	
	$tQuery:="pk_id = '80C09BE6E2084F6BAB0CCA28EE7F05B0'"
	
End if   //Done initialize

If (ds:C1482.Finished_Goods_Transactions.query($tQuery).length=0)  //Does not exist
	
	$eFinishedGoodsTransactions:=ds:C1482.Finished_Goods_Transactions.new()
	
	$eFinishedGoodsTransactions.ProductCode:="EMHG-01-0113"
	$eFinishedGoodsTransactions.XactionType:="Ship"
	$eFinishedGoodsTransactions.XactionDate:=!2021-03-18!
	$eFinishedGoodsTransactions.JobNo:="16480"
	$eFinishedGoodsTransactions.JobForm:="16480.01"
	$eFinishedGoodsTransactions.Qty:=9750
	$eFinishedGoodsTransactions.CoGS_M:=87.98666666667
	$eFinishedGoodsTransactions.CoGSExtended:=857.87
	$eFinishedGoodsTransactions.Location:="Customer"
	$eFinishedGoodsTransactions.zCount:=1
	$eFinishedGoodsTransactions.viaLocation:="FG:V_SHIPPED_3"
	$eFinishedGoodsTransactions.CustID:="01780"
	$eFinishedGoodsTransactions.XactionTime:=?16:35:59?
	$eFinishedGoodsTransactions.CostlessExcess:=False:C215
	$eFinishedGoodsTransactions.OrderNo:="81301"
	$eFinishedGoodsTransactions.OrderItem:="81301.2/4734612"
	$eFinishedGoodsTransactions.ModDate:=!2021-03-18!
	$eFinishedGoodsTransactions.ModWho:="PEG"
	$eFinishedGoodsTransactions.PricePerM:=100
	$eFinishedGoodsTransactions.ExtendedPrice:=975
	$eFinishedGoodsTransactions.LocationToRecNo:="0"
	$eFinishedGoodsTransactions.FG_Classification:=""
	$eFinishedGoodsTransactions.LocationFromRecNo:="3476"
	$eFinishedGoodsTransactions.XactionNum:="8SNN1ZI001"
	$eFinishedGoodsTransactions.TransactionFailed:=False:C215
	$eFinishedGoodsTransactions.Reason:=""
	$eFinishedGoodsTransactions.ActionTaken:="BOL#151603"
	$eFinishedGoodsTransactions.ReasonNotes:=""
	$eFinishedGoodsTransactions.Skid_number:="CASE"
	$eFinishedGoodsTransactions.JobFormItem:=2
	$eFinishedGoodsTransactions.Jobit:="16480.01.02"
	$eFinishedGoodsTransactions.CoGSextendedMatl:=589.875
	$eFinishedGoodsTransactions.CoGSextendedLabor:=190.2167647059
	$eFinishedGoodsTransactions.CoGSextendedBurden:=77.77632352941
	$eFinishedGoodsTransactions.z_SYNC_ID:=""
	$eFinishedGoodsTransactions.pk_id:="80C09BE6E2084F6BAB0CCA28EE7F05B0"
	$eFinishedGoodsTransactions.Invoiced:=!00-00-00!
	$eFinishedGoodsTransactions.Paid:=!00-00-00!
	$eFinishedGoodsTransactions.transactionDateTime:="2021-03-18 16:35:59"
	
	$oSaveResult:=$eFinishedGoodsTransactions.save()
	
	If ($oSaveResult.success)  //Success
		
		ALERT:C41("saved")
		
	End if   //Done success
	
End if   //Done does not exist
