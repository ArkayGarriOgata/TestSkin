//%attributes = {}
// _______
// Method: FGX_InventoryChanged   ( location_entity_before;location_entity_after) -> success
// By: Mel Bohince @ 09/29/20, 16:18:06
// Description
// create a fg transaction record to log the change that was just made to the fg location record
// Modified by: Garri Ogata (4/14/21) If reason is blank then add FGL_Mgmt
// Modified by: Garri Ogata (5/13/21) changed costlessExcess to SkipTrigger
// ----------------------------------------------------

C_OBJECT:C1216($locationEntityBefore_e; $1; $locationEntityAfter_e; $2; $fgTransaction_e; $status_o; $0)

$locationEntityBefore_e:=$1
$locationEntityAfter_e:=$2

//this is the important attribute
$adjustment:=$locationEntityAfter_e.QtyOH-$locationEntityBefore_e.QtyOH

$fgTransaction_e:=ds:C1482.Finished_Goods_Transactions.new()

//start with some housekeeping that the transaction records alway carry
$fgTransaction_e.XactionNum:=app_GetPrimaryKey  //app_AutoIncrement (->$fgTransaction_e.)
$fgTransaction_e.zCount:=1
$fgTransaction_e.ModDate:=4D_Current_date
$fgTransaction_e.XactionDate:=$fgTransaction_e.ModDate
$fgTransaction_e.XactionTime:=4d_Current_time
$fgTransaction_e.XactionType:="Adjust"
$fgTransaction_e.ModWho:=<>zResp

$fgTransaction_e.Reason:=Choose:C955(\
(Form:C1466.editEntity.Reason=CorektBlank); \
"FGL_Mgmt"; \
Form:C1466.editEntity.Reason)  // Modified by: Garri Ogata (4/14/21) 

$fgTransaction_e.ActionTaken:="was bin: "+Form:C1466.origEntity.Location+" skid: "+Form:C1466.origEntity.skid_number  //indicates specific percentages, special notes..

Case of 
	: ($adjustment=0)
		$fgTransaction_e.ReasonNotes:="Info Chg"
		
	: ($adjustment<0)
		If (Abs:C99($adjustment)=Form:C1466.origEntity.QtyOH)
			$fgTransaction_e.ReasonNotes:="Qty Zero'd"
		Else 
			$fgTransaction_e.ReasonNotes:="Qty Reduced"
		End if 
		
	: ($adjustment>0)
		$fgTransaction_e.ReasonNotes:="Qty Increased"
End case 

$fgTransaction_e.LocationFromRecNo:=No current record:K29:2
$fgTransaction_e.TransactionFailed:=False:C215  //optimistic, will set to true if records were locked
$fgTransaction_e.SkipTrigger:=False:C215  // Modified by: Garri Ogata (5/13/21) 
//some descriptive stuff
$fgTransaction_e.ProductCode:=Form:C1466.editEntity.ProductCode
$fgTransaction_e.CustID:=Form:C1466.editEntity.CustID
$fgTransaction_e.JobNo:=Num:C11(Substring:C12(Form:C1466.editEntity.JobForm; 1; 5))
$fgTransaction_e.JobForm:=Form:C1466.editEntity.JobForm
$fgTransaction_e.JobFormItem:=Form:C1466.editEntity.JobFormItem
$fgTransaction_e.Jobit:=Form:C1466.editEntity.Jobit
$fgTransaction_e.FG_Classification:=Form:C1466.editEntity.PRODUCT_CODE.ClassOrType
$fgTransaction_e.CoGS_M:=Round:C94(Form:C1466.editEntity.JOB_ITEM.PldCostTotal; 5)
$fgTransaction_e.CoGSExtended:=Round:C94(($adjustment/1000)*$fgTransaction_e.CoGS_M; 2)

//now the attributes that could have been changed
$fgTransaction_e.Qty:=$adjustment
$fgTransaction_e.Location:=Form:C1466.editEntity.Location
$fgTransaction_e.viaLocation:=Form:C1466.origEntity.Location

$fgTransaction_e.Skid_number:=Form:C1466.editEntity.skid_number

$status_o:=$fgTransaction_e.save()
If (Not:C34($status_o.success))
	ALERT:C41("Your not going to believe this, but the Transaction failed to save."; "Dang")
End if 

$0:=$status_o
