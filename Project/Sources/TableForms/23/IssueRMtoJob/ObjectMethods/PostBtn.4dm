// _______
// Method: [Raw_Materials_Transactions].IssueRMtoJob.PostBtn   ( ) ->
// By: Mel Bohince @ 06/22/21, 15:38:23
// Description
// 
// ----------------------------------------------------
C_OBJECT:C1216($transEntity; $rmEntity; $poiEntity; $status_o)

Case of 
	: (Length:C16(Form:C1466.jobFormID)=0)
		uConfirm("Enter a job form id.")
		
	: (Form:C1466.sequence=0)
		uConfirm("Select or enter a sequence number.")
		
	: (Length:C16(Form:C1466.rawMatlCode)=0)
		uConfirm("Enter a raw material code.")
		
	: (Length:C16(Form:C1466.location)=0)
		uConfirm("Select or enter an inventory location.")
		
	: (Length:C16(Form:C1466.purchaseOrder)=0)
		uConfirm("Select or enter a PO number.")
		
	: (Form:C1466.unitCost=0)
		uConfirm("Select or enter a unit cost.")
		
	: (Form:C1466.quantity=0)
		uConfirm("Enter a quantity.")
		
	Else 
		
		$transEntity:=ds:C1482.Raw_Materials_Transactions.new()
		
		$transEntity.Xfer_Type:=Form:C1466.transactionType
		$transEntity.XferDate:=Form:C1466.transactionDate
		$transEntity.JobForm:=Form:C1466.jobFormID
		$transEntity.Sequence:=Form:C1466.sequence
		$transEntity.Raw_Matl_Code:=Form:C1466.rawMatlCode
		$transEntity.viaLocation:=Form:C1466.location
		$transEntity.Location:="WIP"
		$transEntity.POItemKey:=Form:C1466.purchaseOrder
		$transEntity.ActCost:=Form:C1466.unitCost
		$transEntity.Qty:=-1*Form:C1466.quantity
		$transEntity.ActExtCost:=Round:C94(($transEntity.ActCost*$transEntity.Qty); 2)
		$transEntity.ReferenceNo:=Form:C1466.reference
		
		$transEntity.Reason:="RMX_Issue_Dialog"  //use the bin and allocation update in the trigger
		
		$rmEntity:=ds:C1482.Raw_Materials.query("Raw_Matl_Code = :1"; Form:C1466.rawMatlCode).first()
		If ($rmEntity#Null:C1517)  //how could it be?
			$transEntity.CommodityCode:=$rmEntity.CommodityCode
			$transEntity.Commodity_Key:=$rmEntity.Commodity_Key
		End if 
		
		$poiEntity:=ds:C1482.Purchase_Orders_Items.query("POItemKey = :1"; Form:C1466.purchaseOrder).first()
		If ($poiEntity#Null:C1517)  //how could it be?
			$transEntity.CompanyID:=$poiEntity.CompanyID
			$transEntity.DepartmentID:=$poiEntity.DepartmentID
			$transEntity.ExpenseCode:=$poiEntity.ExpenseCode
		End if 
		
		$status_o:=$transEntity.save()
		If (Not:C34($status_o.success))
			ALERT:C41("Your not going to believe this, but the Transaction failed to save."; "Dang")
			
		Else   //init all but the jobform
			Form:C1466.transactions_es.add($transEntity)  //keep a history of posts in this session
			
			RMX_IssueToJobReset("budget-item-select")
			RMX_IssueToJobReset("inventory-select")
			
			GOTO OBJECT:C206(*; "jobFormSearch")
			
		End if 
		
End case 

